void gpt2_forward(float params_wte[50257][1024], float params_wpe[64][1024], float params_ln1w[1024], float params_ln1b[1024], float params_qkvw1[1024][1024],float params_qkvw2[1024][1024],float params_qkvw3[1024][1024], float params_qkvb1[1024],float params_qkvb2[1024],float params_qkvb3[1024], float params_attprojw[1024][1024], float params_attprojb[1024], float params_ln2w[1024], float params_ln2b[1024], float params_fcw[4096][1024], float params_fcb[4096], float params_fcprojw[1024][4096], float params_fcprojb[1024], float params_lnfw[1024], float params_lnfb[1024], float acts_encoded[4][64][1024], float ace_ln1[4][64][1024], float acts_ln1_mean[4][64], float acts_ln1_rstd[4][64], float acts_qkv1[4][64][1024],float acts_qkv2[4][64][1024],float acts_qkv3[4][64][1024], float acts_atty[4][64][1024], float acts_preatt[4][16][64][64], float acts2_att[4][16][64][64], float acts_attproj[4][64][1024], float acts_residual2[4][64][1024], float ac_ln2[4][64][1024], float acts_ln2_mean[4][64], float acts_ln2_rstd[4][64], float acw_fch[4][64][4096], float acts_fch_gelu[4][64][4096], float acts_fcproj[4][64][1024], float acts_residual3[4][64][1024], float acr_lnf[4][64][1024], float acts_lnf_mean[4][64], float acts_lnf_rstd[4][64], float acts_logits[4][64][50257], float acts_probs[4][64][50257], float curr_residual[4][64][1024], float maxal[4][16][64], float expssum[4][16][64], float vall[4][16][64][64], float exp_val[4][16][64][64], float expsum_inv[4][16][64], float sunm[4][64], float maxival[4][64]){

    
    int b;
    int t;
    int c;
    int i;
    int o;



    // begin of layers loop

    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( c = 0; c < 1024; c++) {
                curr_residual[b][t][c] = acts_encoded[b][t][c];
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            acts_ln1_mean[b][t] = 0.0f;
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( i = 0; i < 1024; i++) {
                acts_ln1_mean[b][t] += curr_residual[b][t][i];
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            acts_ln1_mean[b][t] = acts_ln1_mean[b][t] / 1024;
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            acts_ln1_rstd[b][t] = 0.0f;
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( i = 0; i < 1024; i++) {
                acts_ln1_rstd[b][t] += (curr_residual[b][t][i] - acts_ln1_mean[b][t]) * (curr_residual[b][t][i] - acts_ln1_mean[b][t]);
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            acts_ln1_rstd[b][t] = acts_ln1_rstd[b][t] / 1024;
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            acts_ln1_rstd[b][t] = 1.0f / sqrtf(acts_ln1_rstd[b][t] + 0.00001);
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( i = 0; i < 1024; i++) {
                ace_ln1[b][t][i] = acts_ln1_rstd[b][t] * (curr_residual[b][t][i] - acts_ln1_mean[b][t]) * params_ln1w[i] + params_ln1b[i]; 
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) { 
                acts_qkv1[b][t][o] = params_qkvb1[o];
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) { 
                acts_qkv2[b][t][o] = params_qkvb2[o];
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) { 
                acts_qkv3[b][t][o] = params_qkvb3[o];
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) {
                for ( i = 0; i < 1024; i++) {
                    acts_qkv1[b][t][o] += ace_ln1[b][t][i] * params_qkvw1[o][i];
                }
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) {
                for ( i = 0; i < 1024; i++) {
                    acts_qkv2[b][t][o] += ace_ln1[b][t][i] * params_qkvw2[o][i];
                }
            }
        }
    }
    for ( b = 0; b < 4; b++) {
        for ( t = 0; t < 64; t++) {
            for ( o = 0; o < 1024; o++) {
                for ( i = 0; i < 1024; i++) {
                    acts_qkv3[b][t][o] += ace_ln1[b][t][i] * params_qkvw3[o][i];
                }
            }
        }
    }

    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                maxal[b][h][t] = -3.4028234663852886e+38;
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                expssum[b][h][t] = 0.0f;
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    vall[b][h][t][t2] = 0.0f;
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    for (int i = 0; i < 64; i++) {
                        vall[b][h][t][t2] += acts_qkv1[b][t][h * 64 + i] * acts_qkv2[b][t2][h * 64 + i];
                    }
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    vall[b][h][t][t2] *= 0.125;
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    acts_preatt[b][h][t][t2] = vall[b][h][t][t2];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    maxal[b][h][t] = maxal[b][h][t] < vall[b][h][t][t2]? vall[b][h][t][t2] : maxal[b][h][t];
                }
            }
        }
    }
    for (int b = 0; b < 4; b++) {
        for (int t = 0; t < 64; t++) {
            for (int h = 0; h < 16; h++) {
                for (int t2 = 0; t2 <= t; t2++) {
                    exp_val[b][h][t][t2] = expf(acts_preatt[b][h][t][t2] - maxal[b][h][t]);
                }
            }
        }
    }
    
}