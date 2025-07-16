


void gpt2_forward() {
    // Parameters
    const size_t 4 = 4;        // Batch size
    const size_t 64 = 64;       // Sequence length
    const size_t 50257 = 50257;    // Vocabulary size
    const size_t 50304 = 50304;   // Padded vocabulary size
    const size_t 1 = 1;       // Number of layers
    const size_t 16 = 16;      // Number of attention heads
    const size_t 1024 = 1024;     // Number of channels

    // Allocate memory for parameters and activations
    float params_wte[50257][1024];
    float params_wpe[64][1024];
    float params_ln1w[1][1024];
    float params_ln1b[1][1024];
    float params_qkvw[1][3*1024][1024];
    float params_qkvb[1][3*1024];
    float params_attprojw[1][1024][1024];
    float params_attprojb[1][1024];
    float params_ln2w[1][1024];
    float params_ln2b[1][1024];
    float params_fcw[1][4*1024][1024];
    float params_fcb[1][4*1024];
    float params_fcprojw[1][1024][4*1024];
    float params_fcprojb[1][1024];
    float params_lnfw[1024];
    float params_lnfb[1024];

    float acts_encoded[4][64][1024];
    float acts_ln1[1][4][64][1024];
    float acts_ln1_mean[1][4][64];
    float acts_ln1_rstd[1][4][64];
    float acts_qkv[1][4][64][3*1024];
    float acts_atty[1][4][64][1024];
    float acts_preatt[1][4][16][64][64];
    float acts_att[1][4][16][64][64];
    float acts_attproj[1][4][64][1024];
    float acts_residual2[1][4][64][1024];
    float acts_ln2[1][4][64][1024];
    float acts_ln2_mean[1][4][64];
    float acts_ln2_rstd[1][4][64];
    float acts_fch[1][4][64][4*1024];
    float acts_fch_gelu[1][4][64][4*1024];
    float acts_fcproj[1][4][64][1024];
    float acts_residual3[1][4][64][1024];
    float acts_lnf[4][64][1024];
    float acts_lnf_mean[4][64];
    float acts_lnf_rstd[4][64];
    float acts_logits[4][64][50257];
    float acts_probs[4][64][50257];


    float residual[4][64][1024];

    for (size_t b = 0; b < 4; b++) {
        for (size_t t = 0; t < 64; t++) {
            for (size_t c = 0; c < 1024; c++) {
                residual[b][t][c] = acts_encoded[b][t][c];
            }
        }
    }


    const float eps = 1e-5f;

    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            // Calculate the mean
            acts_ln1_mean[l][b][t] = 0.0f;
            for (int i = 0; i < 1024; i++) {
                acts_ln1_mean[l][b][t] += residual[b][t][i];
            }
            acts_ln1_mean[l][b][t] /= 1024;

            // Calculate the variance (without any bias correction)
            acts_ln1_rstd[l][b][t] = 0.0f;
            for (int i = 0; i < 1024; i++) {
                float diff = residual[b][t][i] - acts_ln1_mean[l][b][t];
                acts_ln1_rstd[l][b][t] += diff * diff;
            }
            acts_ln1_rstd[l][b][t] /= 1024;

            // Calculate the rstd (reciprocal standard deviation)
            acts_ln1_rstd[l][b][t] = 1.0f / sqrtf(acts_ln1_rstd[l][b][t] + eps);

            // Normalize and scale/shift
            for (int i = 0; i < 1024; i++) {
                acts_ln1[l][b][t][i] = acts_ln1_rstd[l][b][t] * (residual[b][t][i] - acts_ln1_mean[l][b][t]) * params_ln1w[l][i] + params_ln1b[l][i]; // Scale and shift
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 3*1024; o++) { // OC is 3*1024
                acts_qkv[l][b][t][o] = params_qkvb[l][o];
                for (int i = 0; i < 1024; i++) {
                    acts_qkv[l][b][t][o] += acts_ln1[l][b][t][i] * params_qkvw[l][o][i];
                }
            }
        }
    }
    int hs = 1024 / 16; // Head size
    float scale = 1.0f / sqrtf(hs);

    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                // Calculate query dot key and maxval
                float maxval = -FLT_MAX; // Initialize with a very low value
                float expsum = 0.0f;

                for (int t2 = 0; t2 <= t; t2++) {
                    // Compute dot product for the current head
                    float val = 0.0f;
                    for (int i = 0; i < hs; i++) {
                        val += acts_qkv[l][b][t][h * hs + i] * acts_qkv[l][b][t2][h * hs + 1024 + i];
                    }
                    val *= scale;
                    acts_preatt[l][b][h][t][t2] = val;

                    if (val > maxval) {
                        maxval = val;
                    }
                }

                // Compute the exponential and normalization
                for (int t2 = 0; t2 <= t; t2++) {
                    float exp_val = expf(acts_preatt[l][b][h][t][t2] - maxval);
                    acts_att[l][b][h][t][t2] = exp_val;
                    expsum += exp_val;
                }

                float expsum_inv = (expsum > 0.0f) ? 1.0f / expsum : 0.0f;

                // Normalize the attention weights
                for (int t2 = 0; t2 < 64; t2++) {
                    if (t2 <= t) {
                        acts_att[l][b][h][t][t2] *= expsum_inv;
                    } else {
                        acts_att[l][b][h][t][t2] = 0.0f; // Causal attention mask
                    }
                }

                // Accumulate weighted values into the output
                for (int i = 0; i < hs; i++) {
                    acts_atty[l][b][t][h * hs + i] = 0.0f;
                }

                for (int t2 = 0; t2 <= t; t2++) {
                    for (int i = 0; i < hs; i++) {
                        acts_atty[l][b][t][h * hs + i] += acts_att[l][b][h][t][t2] * acts_qkv[l][b][t2][h * hs + 2 * 1024 + i];
                    }
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 1024; o++) {  // OC is replaced with 1024 in the call
                acts_attproj[l][b][t][o] = params_attprojb[l][o];  // bias
                for (int i = 0; i < 1024; i++) {  // 1024 is the same for inp and weight
                    acts_attproj[l][b][t][o] += acts_atty[l][b][t][i] * params_attprojw[l][o][i];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int c = 0; c < 1024; c++) {
                acts_residual2[l][b][t][c] = residual[b][t][c] + acts_attproj[l][b][t][c];
            }
        }
    }
    const float eps = 1e-5f;

    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            // Calculate the mean
            acts_ln2_mean[l][b][t] = 0.0f;
            for (int i = 0; i < 1024; i++) {
                acts_ln2_mean[l][b][t] += acts_residual2[l][b][t][i];
            }
            acts_ln2_mean[l][b][t] /= 1024;

            // Calculate the variance (without any bias correction)
            acts_ln2_rstd[l][b][t] = 0.0f;
            for (int i = 0; i < 1024; i++) {
                float diff = acts_residual2[l][b][t][i] - acts_ln2_mean[l][b][t];
                acts_ln2_rstd[l][b][t] += diff * diff;
            }
            acts_ln2_rstd[l][b][t] /= 1024;

            // Calculate the rstd (reciprocal standard deviation)
            acts_ln2_rstd[l][b][t] = 1.0f / sqrtf(acts_ln2_rstd[l][b][t] + eps);

            // Normalize and scale/shift
            for (int i = 0; i < 1024; i++) {
                acts_ln2[l][b][t][i] = acts_ln2_rstd[l][b][t] * (acts_residual2[l][b][t][i] - acts_ln2_mean[l][b][t]) * params_ln2w[l][i] + params_ln2b[l][i];
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 4*1024; o++) {
                acts_fch[l][b][t][o] = params_fcb[l][o]; // Initialize with bias
                for (int i = 0; i < 1024; i++) {
                    acts_fch[l][b][t][o] += acts_ln2[l][b][t][i] * params_fcw[l][o][i];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int i = 0; i < 4*1024; i++) {
                float x = acts_fch[l][b][t][i];
                float x3 = x * x * x; // x^3
                acts_fch_gelu[l][b][t][i] = 0.5f * x * (1.0f + tanhf(0.7978845608028654f * (x + 0.044715f * x3)));
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 1024; o++) {
                acts_fcproj[l][b][t][o] = params_fcprojb[l][o];
                for (int i = 0; i < 4*1024; i++) {
                    acts_fcproj[l][b][t][o] += acts_fch_gelu[l][b][t][i] * params_fcprojw[l][o][i];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int c = 0; c < 1024; c++) {
                acts_residual3[l][b][t][c] = acts_residual2[l][b][t][c] + acts_fcproj[l][b][t][c];
            }
        }
    }
}