


void gpt2_forward(float params_wte[50257][1024], float params_wpe[64][1024], float params_ln1w[1024], float params_ln1b[1024], float params_qkvw[3072][1024], float params_qkvb[3072], float params_attprojw[1024][1024], float params_attprojb[1024], float params_ln2w[1024], float params_ln2b[1024], float params_fcw[4096][1024], float params_fcb[4096], float params_fcprojw[1024][4096], float params_fcprojb[1024], float params_lnfw[1024], float params_lnfb[1024], float acts_encoded[4][64][1024], float ace_ln1[4][64][1024], float acts_ln1_mean[4][64], float acts_ln1_rstd[4][64], float acts_qkv[4][64][3072], float acts_atty[4][64][1024], float acts_preatt[4][16][64][64], float acts2_att[4][16][64][64], float acts_attproj[4][64][1024], float acts_residual2[4][64][1024], float ac_ln2[4][64][1024], float acts_ln2_mean[4][64], float acts_ln2_rstd[4][64], float acw_fch[4][64][4096], float acts_fch_gelu[4][64][4096], float acts_fcproj[4][64][1024], float acts_residual3[4][64][1024], float acr_lnf[4][64][1024], float acts_lnf_mean[4][64], float acts_lnf_rstd[4][64], float acts_logits[4][64][50257], float acts_probs[4][64][50257], float curr_residual[4][64][1024], float maxal[4][16][64], float expssum[4][16][64], float vall[4][16][64][64], float exp_val[4][16][64][64], float expsum_inv[4][16][64], float sunm[4][64], float maxival[4][64]){

    
    int b;
    int t;
    int c;
    int i;
    int o;


    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            acts_lnf_rstd[b][t] = 0.0f;
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int i = 0; i < 1024; i++) {
                acts_lnf_rstd[b][t] += (acts_residual3[b][t][i] - acts_lnf_mean[b][t]) * (acts_residual3[b][t][i] - acts_lnf_mean[b][t]);
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            acts_lnf_rstd[b][t] /= 1024;
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            acts_lnf_rstd[b][t] = 1.0f / sqrtf(acts_lnf_rstd[b][t] + 0.00001);
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int i = 0; i < 1024; i++) {
                acr_lnf[b][t][i] = acts_lnf_rstd[b][t] * (acts_residual3[b][t][i] - acts_lnf_mean[b][t]) * params_lnfw[i] + params_lnfb[i]; // Scale and shift
            }
        }
    }

    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 50304; o++) {
                acts_logits[b][t][o] = 0.0f; 
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int o = 0; o < 50304; o++) {
                for (int i = 0; i < 1024; i++) {
                    acts_logits[b][t][o] += acr_lnf[b][t][i] * params_wte[o][i];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            maxival[b][t] = -10000.0f;
        }
    }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         for (int i = 0; i < 50257; i++) {
    //             maxival[b][t] = acts_logits[b][t][i] > maxival[b][t] ? acts_logits[b][t][i] : maxival[b][t];
    //         }
    //     }
    // }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         sunm[b][t] = 0.0f;
    //     }
    // }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         for (int i = 0; i < 50257; i++) {
    //             acts_probs[b][t][i] = expf(acts_logits[b][t][i] - maxival[b][t]);
    //         }
    //     }
    // }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         for (int i = 0; i < 50257; i++) {
    //             sunm[b][t] += expf(acts_logits[b][t][i] - maxival[b][t]);
    //         }
    //     }
    // }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         for (int i = 0; i < 50257; i++) {
    //             acts_probs[b][t][i] = acts_probs[b][t][i] / sunm[b][t];
    //         }
    //     }
    // }
    // for (int b = 0; b < 4; b++) {
    //     for (int t = 0; t < 64; t++) {
    //         for (int i = 50257; i < 50304; i++) {
    //             acts_probs[b][t][i] = 0.0f;
    //         }
    //     }
    // }
}