/*
This file trains the GPT-2 model.
This version is the clean, minimal, reference. As such:
- it runs on CPU.
- it does not make the code too complex; it is readable.
- it does not use any processor-specific instructions, intrinsics and such.
- it _does_ use a few OpenMP pragmas because this is a large speedup at very low cost
There will be other versions of this code that specialize it and make it fast.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#ifdef OMP
#include <omp.h>
#endif
// our own utilities
// defines: fopenCheck, freadCheck, fcloseCheck, fseekCheck, mallocCheck
#include "llmc/utils.h"
// defines: tokenizer_init, tokenizer_decode, tokenizer_free
#include "llmc/tokenizer.h"
// defines: dataloader_init, dataloader_reset, dataloader_next_batch, dataloader_free
#include "llmc/dataloader.h"

// ----------------------------------------------------------------------------
// all the individual layers' forward and backward passes
// B = batch_size, T = sequence_length, C = channels, V = vocab_size

void encoder_forward(float out[B][T][C],
                     int inp[B][T], float wte[V][C], float wpe[T][C],
                     int B, int T, int C) {
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            // Get the index of the token at inp[b][t]
            int ix = inp[b][t];
            
            // Add the token and position embeddings
            for (int i = 0; i < C; i++) {
                out[b][t][i] = wte[ix][i] + wpe[t][i];
            }
        }
    }
}


void layernorm_forward(float out[B][T][C], float mean[B][T], float rstd[B][T],
                       float inp[B][T][C], float weight[C], float bias[C],
                       int B, int T, int C) {
    const float eps = 1e-5f;

    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            // Calculate the mean
            mean[b][t] = 0.0;
            for (int i = 0; i < C; i++) {
                mean[b][t] += inp[b][t][i];
            }
            mean[b][t] /= C;

            // Calculate the variance (without any bias correction)
            rstd[b][t] = 0.0;
            for (int i = 0; i < C; i++) {
                rstd[b][t] += (inp[b][t][i] - mean[b][t]) * (inp[b][t][i] - mean[b][t]);
            }
            rstd[b][t] /= C;

            // Calculate the rstd (reciprocal standard deviation)
            rstd[b][t] = 1.0f / sqrtf(rstd[b][t] + eps);

            // Normalize and scale/shift
            for (int i = 0; i < C; i++) {
                out[b][t][i] = rstd[b][t] * (inp[b][t][i] - mean[b][t]) * weight[i] + bias[i]; // Scale and shift
            }
        }
    }
}


void matmul_forward(float out[B][T][OC],
                         const float inp[B][T][C], const float weight[OC][C], const float bias[OC],
                         int B, int T, int C, int OC) {
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            for (int o = 0; o < OC; o++) {
                out[b][t][o] = bias[o];
                for (int i = 0; i < C; i++) {
                    out[b][t][o] += inp[b][t][i] * weight[o][i];
                }
            }
        }
    }
}


void attention_forward(float out[B][T][C], float preatt[B][NH][T][T], float att[B][NH][T][T],
                       const float inp[B][T][3*C], int B, int T, int C, int NH) {

    int hs = C / NH; // Head size
    float scale = 1.0f / sqrtf(hs);
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            for (int h = 0; h < NH; h++) {
                // Calculate query dot key and maxval
                float maxval = -FLT_MAX; // Initialize with a very low value
                float expsum = 0.0f;
                for (int t2 = 0; t2 <= t; t2++) {
                    // Compute dot product for the current head
                    float val = 0.0f;
                    for (int i = 0; i < hs; i++) {
                        val += inp[b][t][h * hs + i] * inp[b][t2][h * hs + C + i];
                    }
                    val *= scale;
                    preatt[b][h][t][t2] = val;

                    if (val > maxval) {
                        maxval = val;
                    }
                }
                // Compute the exponential and normalization
                for (int t2 = 0; t2 <= t; t2++) {
                    float exp_val = expf(preatt[b][h][t][t2] - maxval);
                    att[b][h][t][t2] = exp_val;
                    expsum += exp_val;
                }
                float expsum_inv = (expsum > 0.0f) ? 1.0f / expsum : 0.0f;
                // Normalize the attention weights
                for (int t2 = 0; t2 < T; t2++) {
                    if (t2 <= t) {
                        att[b][h][t][t2] *= expsum_inv;
                    } else {
                        att[b][h][t][t2] = 0.0f; // Causal attention mask
                    }
                }
                // Accumulate weighted values into the output
                for (int i = 0; i < hs; i++) {
                    out[b][t][h * hs + i] = 0.0f;
                }
                for (int t2 = 0; t2 <= t; t2++) {
                    for (int i = 0; i < hs; i++) {
                        out[b][t][h * hs + i] += att[b][h][t][t2] * inp[b][t2][h * hs + 2 * C + i];
                    }
                }
            }
        }
    }
}



void gelu_forward(float out[B][T][4*C], const float inp[B][T][4*C], int B, int T, int C) {
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            for (int i = 0; i < 4*C; i++) {
                out[b][t][i] = 0.5f * inp[b][t][i] * (1.0f + tanhf(0.7978845608028654 * (inp[b][t][i] + 0.044715f * inp[b][t][i] * inp[b][t][i] * inp[b][t][i])));
            }
        }
    }
}



void residual_forward(float out[B][T][C], const float inp1[B][T][C], const float inp2[B][T][C]) {
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            for (int c = 0; c < C; c++) {
                out[b][t][c] = inp1[b][t][c] + inp2[b][t][c];
            }
        }
    }
}



void softmax_forward(float probs[B][T][Vp], const float logits[B][T][Vp], int B, int T, int V, int Vp) {
    for (int b = 0; b < B; b++) {
        for (int t = 0; t < T; t++) {
            // Calculate max value for numerical stability
            float maxval = -10000.0f;
            for (int i = 0; i < V; i++) {
                if (logits[b][t][i] > maxval) {
                    maxval = logits[b][t][i];
                }
            }

            // Calculate exponentials and sum
            float sum = 0.0f;
            for (int i = 0; i < V; i++) {
                float expval = expf(logits[b][t][i] - maxval);
                probs[b][t][i] = expval;
                sum += expval;
            }

            // Normalize probabilities
            for (int i = 0; i < V; i++) {
                probs[b][t][i] /= sum;
            }

            // Set padded dimensions to zero
            for (int i = V; i < Vp; i++) {
                probs[b][t][i] = 0.0f;
            }
        }
    }
}


void gpt2_forward() {
    // Parameters
    const size_t B = 4;        // Batch size
    const size_t T = 64;       // Sequence length
    const size_t V = 50257;    // Vocabulary size
    const size_t Vp = 50304;   // Padded vocabulary size
    const size_t L = 24;       // Number of layers
    const size_t NH = 16;      // Number of attention heads
    const size_t C = 1024;     // Number of channels

    // Allocate memory for parameters and activations
    float params_wte[V][C];
    float params_wpe[T][C];
    float params_ln1w[L][C];
    float params_ln1b[L][C];
    float params_qkvw[L][3*C][C];
    float params_qkvb[L][3*C];
    float params_attprojw[L][C][C];
    float params_attprojb[L][C];
    float params_ln2w[L][C];
    float params_ln2b[L][C];
    float params_fcw[L][4*C][C];
    float params_fcb[L][4*C];
    float params_fcprojw[L][C][4*C];
    float params_fcprojb[L][C];
    float params_lnfw[C];
    float params_lnfb[C];

    float acts_encoded[B][T][C];
    float acts_ln1[L][B][T][C];
    float acts_ln1_mean[L][B][T];
    float acts_ln1_rstd[L][B][T];
    float acts_qkv[L][B][T][3*C];
    float acts_atty[L][B][T][C];
    float acts_preatt[L][B][NH][T][T];
    float acts_att[L][B][NH][T][T];
    float acts_attproj[L][B][T][C];
    float acts_residual2[L][B][T][C];
    float acts_ln2[L][B][T][C];
    float acts_ln2_mean[L][B][T];
    float acts_ln2_rstd[L][B][T];
    float acts_fch[L][B][T][4*C];
    float acts_fch_gelu[L][B][T][4*C];
    float acts_fcproj[L][B][T][C];
    float acts_residual3[L][B][T][C];
    float acts_lnf[B][T][C];
    float acts_lnf_mean[B][T];
    float acts_lnf_rstd[B][T];
    float acts_logits[B][T][V];
    float acts_probs[B][T][V];

    // Forward pass
    // encoder_forward(acts_encoded, inputs, params_wte, params_wpe, B, T, C); // we suppose already done
    for (int l = 0; l < L; l++) {
        float residual[B][T][C];
        if (l == 0) {
            for (size_t b = 0; b < B; b++) {
                for (size_t t = 0; t < T; t++) {
                    for (size_t c = 0; c < C; c++) {
                        residual[b][t][c] = acts_encoded[b][t][c];
                    }
                }
            }
        } else {
            for (size_t b = 0; b < B; b++) {
                for (size_t t = 0; t < T; t++) {
                    for (size_t c = 0; c < C; c++) {
                        residual[b][t][c] = acts_residual3[l-1][b][t][c];
                    }
                }
            }
        }

        layernorm_forward(acts_ln1[l], acts_ln1_mean[l], acts_ln1_rstd[l], residual, params_ln1w[l], params_ln1b[l], B, T, C);
        matmul_forward(acts_qkv[l], acts_ln1[l], params_qkvw[l], params_qkvb[l], B, T, C, 3*C);
        attention_forward(acts_atty[l], acts_preatt[l], acts_att[l], acts_qkv[l], B, T, C, NH);
        matmul_forward(acts_attproj[l], acts_atty[l], params_attprojw[l], params_attprojb[l], B, T, C, C);
        residual_forward(acts_residual2[l], residual, acts_attproj[l], B*T*C);
        layernorm_forward(acts_ln2[l], acts_ln2_mean[l], acts_ln2_rstd[l], acts_residual2[l], params_ln2w[l], params_ln2b[l], B, T, C);
        matmul_forward(acts_fch[l], acts_ln2[l], params_fcw[l], params_fcb[l], B, T, C, 4*C);
        gelu_forward(acts_fch_gelu[l], acts_fch[l], B*T*4*C);
        matmul_forward(acts_fcproj[l], acts_fch_gelu[l], params_fcprojw[l], params_fcprojb[l], B, T, 4*C, C);
        residual_forward(acts_residual3[l], acts_residual2[l], acts_fcproj[l], B*T*C);
    }
    layernorm_forward(acts_lnf, acts_lnf_mean, acts_lnf_rstd, acts_residual3[L-1], params_lnfw, params_lnfb, B, T, C);
    matmul_forward(acts_logits, acts_lnf, params_wte, NULL, B, T, C, Vp);
    softmax_forward(acts_probs, acts_logits, B, T, V, Vp);
}