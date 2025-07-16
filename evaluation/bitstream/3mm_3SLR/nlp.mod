#option solver baron;
#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';
option solver gurobi;
option gurobi_options 'lim:time=1800 tech:logfile=gurobi.log qp:nonconvex=2';
#option solver octeract;
#option octeract_options 'max_solver_time=60';

param DSP_avail = 5300;
param ON_CHIP_MEM_SIZE = 1360688;
param MAX_BUFFER_SIZE = 2048;
param CONSTRAINT_ARRAY_PARTITIONING_VALUE = 512;
param MAX_UF = 2048;
param SLR0_mem = 453562;
param SLR0_DSP = 1766;
param SLR1_mem = 453562;
param SLR1_DSP = 1766;
param SLR2_mem = 453562;
param SLR2_DSP = 1766;
param II_S0_par = 1;
param II_S0_seq = 3;
param II_S1_par = 1;
param II_S1_seq = 3;
param II_S2_par = 1;
param II_S2_seq = 3;
param II_S3_par = 1;
param II_S3_seq = 3;
param II_S4_par = 1;
param II_S4_seq = 3;
param II_S5_par = 1;
param II_S5_seq = 3;
param TC0_ori = 180;
param TC1_ori = 190;
param TC2_ori = 180;
param TC3_ori = 190;
param TC4_ori = 200;
param TC5_ori = 190;
param TC6_ori = 210;
param TC7_ori = 190;
param TC8_ori = 210;
param TC9_ori = 220;
param TC10_ori = 180;
param TC11_ori = 210;
param TC12_ori = 180;
param TC13_ori = 210;
param TC14_ori = 190;
param IL_par_S0 = 1;
param IL_seq_S0 = 0;
param IL_par_S1 = 4;
param IL_seq_S1 = 7;
param IL_par_S2 = 1;
param IL_seq_S2 = 0;
param IL_par_S3 = 4;
param IL_seq_S3 = 7;
param IL_par_S4 = 1;
param IL_seq_S4 = 0;
param IL_par_S5 = 4;
param IL_seq_S5 = 7;
param DSP_S0 = 0;
param DSP_S1 = 5;
param DSP_S2 = 0;
param DSP_S3 = 5;
param DSP_S4 = 0;
param DSP_S5 = 5;

var TC0 integer >= 180 <= 192;
var TC1 integer >= 190 <= 192;
var TC2 integer >= 180 <= 192;
var TC3 integer >= 190 <= 192;
var TC4 integer >= 200 <= 208;
var TC5 integer >= 190 <= 192;
var TC6 integer >= 210 <= 224;
var TC7 integer >= 190 <= 192;
var TC8 integer >= 210 <= 224;
var TC9 integer >= 220 <= 224;
var TC10 integer >= 180 <= 192;
var TC11 integer >= 210 <= 224;
var TC12 integer >= 180 <= 192;
var TC13 integer >= 210 <= 224;
var TC14 integer >= 190 <= 192;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task0_in_SLR_1 binary;
var is_fused_task0_in_SLR_2 binary;
var is_fused_task1_in_SLR_0 binary;
var is_fused_task1_in_SLR_1 binary;
var is_fused_task1_in_SLR_2 binary;
var is_fused_task2_in_SLR_0 binary;
var is_fused_task2_in_SLR_1 binary;
var is_fused_task2_in_SLR_2 binary;
var is_slr0_used binary;
var is_slr1_used binary;
var is_slr2_used binary;
var perm0_S0 binary; # [0, 0, 0, 1, 0, 0, 0, 1, 0]
var perm1_S0 binary; # [0, 1, 0, 0, 0, 1, 0, 0, 0]
var perm0_S1 binary; # [1, 2, 0, 3, 0, 4, 0, 2, 0, 3, 0, 4, 0]
var perm1_S1 binary; # [1, 2, 0, 4, 0, 3, 0, 2, 0, 4, 0, 3, 0]
var perm2_S1 binary; # [1, 3, 0, 2, 0, 4, 0, 3, 0, 2, 0, 4, 0]
var perm3_S1 binary; # [1, 3, 0, 4, 0, 2, 0, 3, 0, 4, 0, 2, 0]
var perm4_S1 binary; # [1, 4, 0, 2, 0, 3, 0, 4, 0, 2, 0, 3, 0]
var perm5_S1 binary; # [1, 4, 0, 3, 0, 2, 0, 4, 0, 3, 0, 2, 0]
var perm0_S2 binary; # [2, 5, 0, 6, 0, 5, 0, 6, 0]
var perm1_S2 binary; # [2, 6, 0, 5, 0, 6, 0, 5, 0]
var perm0_S3 binary; # [3, 7, 0, 8, 0, 9, 0, 7, 0, 8, 0, 9, 0]
var perm1_S3 binary; # [3, 7, 0, 9, 0, 8, 0, 7, 0, 9, 0, 8, 0]
var perm2_S3 binary; # [3, 8, 0, 7, 0, 9, 0, 8, 0, 7, 0, 9, 0]
var perm3_S3 binary; # [3, 8, 0, 9, 0, 7, 0, 8, 0, 9, 0, 7, 0]
var perm4_S3 binary; # [3, 9, 0, 7, 0, 8, 0, 9, 0, 7, 0, 8, 0]
var perm5_S3 binary; # [3, 9, 0, 8, 0, 7, 0, 9, 0, 8, 0, 7, 0]
var perm0_S4 binary; # [4, 10, 0, 11, 0, 10, 0, 11, 0]
var perm1_S4 binary; # [4, 11, 0, 10, 0, 11, 0, 10, 0]
var perm0_S5 binary; # [5, 12, 0, 13, 0, 14, 0, 12, 0, 13, 0, 14, 0]
var Lat_comp_S5_for_off_chip >= 0;
var perm1_S5 binary; # [5, 12, 0, 14, 0, 13, 0, 12, 0, 14, 0, 13, 0]
var perm2_S5 binary; # [5, 13, 0, 12, 0, 14, 0, 13, 0, 12, 0, 14, 0]
var perm3_S5 binary; # [5, 13, 0, 14, 0, 12, 0, 13, 0, 14, 0, 12, 0]
var perm4_S5 binary; # [5, 14, 0, 12, 0, 13, 0, 14, 0, 12, 0, 13, 0]
var perm5_S5 binary; # [5, 14, 0, 13, 0, 12, 0, 14, 0, 13, 0, 12, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var Lat_comp_S2_intra_tile >= 0;
var Lat_comp_S3_intra_tile >= 0;
var Lat_comp_S4_intra_tile >= 0;
var Lat_comp_S5_intra_tile >= 0;
var footprint_E_S0_S1 integer >= 0;
var footprint_E_S0_S1_reuse integer >= 0;
var footprint_A_S1 integer >= 0;
var footprint_A_S1_reuse integer >= 0;
var footprint_B_S1 integer >= 0;
var footprint_B_S1_reuse integer >= 0;
var footprint_F_S2_S3 integer >= 0;
var footprint_F_S2_S3_reuse integer >= 0;
var footprint_C_S3 integer >= 0;
var footprint_C_S3_reuse integer >= 0;
var footprint_D_S3 integer >= 0;
var footprint_D_S3_reuse integer >= 0;
var footprint_E_S5 integer >= 0;
var footprint_E_S5_reuse integer >= 0;
var footprint_F_S5 integer >= 0;
var footprint_F_S5_reuse integer >= 0;
var footprint_G_S4_S5 integer >= 0;
var footprint_G_S4_S5_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_E_FT0_under0 binary;
var level_reuse_E_FT0_under0 binary;
var level_transfer_E_FT0_under1 binary;
var level_reuse_E_FT0_under1 binary;
var level_transfer_E_FT0_under2 binary;
var level_reuse_E_FT0_under2 binary;
var level_transfer_A_FT0_under0 binary;
var level_reuse_A_FT0_under0 binary;
var level_transfer_A_FT0_under1 binary;
var level_reuse_A_FT0_under1 binary;
var level_transfer_A_FT0_under2 binary;
var level_reuse_A_FT0_under2 binary;
var level_transfer_B_FT0_under0 binary;
var level_reuse_B_FT0_under0 binary;
var level_transfer_B_FT0_under1 binary;
var level_reuse_B_FT0_under1 binary;
var level_transfer_B_FT0_under2 binary;
var level_reuse_B_FT0_under2 binary;
var Lat_comp_fused_S0_S1_3 >= 0;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
var Lat_comp_fused_S2_S3 >= 0;
var level_transfer_F_FT1_under0 binary;
var level_reuse_F_FT1_under0 binary;
var level_transfer_F_FT1_under1 binary;
var level_reuse_F_FT1_under1 binary;
var level_transfer_F_FT1_under2 binary;
var level_reuse_F_FT1_under2 binary;
var level_transfer_C_FT1_under0 binary;
var level_reuse_C_FT1_under0 binary;
var level_transfer_C_FT1_under1 binary;
var level_reuse_C_FT1_under1 binary;
var level_transfer_C_FT1_under2 binary;
var level_reuse_C_FT1_under2 binary;
var level_transfer_D_FT1_under0 binary;
var level_reuse_D_FT1_under0 binary;
var level_transfer_D_FT1_under1 binary;
var level_reuse_D_FT1_under1 binary;
var level_transfer_D_FT1_under2 binary;
var level_reuse_D_FT1_under2 binary;
var Lat_comp_fused_S2_S3_3 >= 0;
var Lat_comp_fused_S2_S3_2 >= 0;
var Lat_comp_fused_S2_S3_1 >= 0;
var Lat_comp_fused_S4_S5 >= 0;
var level_transfer_G_FT2_under0 binary;
var level_reuse_G_FT2_under0 binary;
var level_transfer_G_FT2_under1 binary;
var level_reuse_G_FT2_under1 binary;
var level_transfer_G_FT2_under2 binary;
var level_reuse_G_FT2_under2 binary;
var level_transfer_E_FT2_under0 binary;
var level_reuse_E_FT2_under0 binary;
var level_transfer_E_FT2_under1 binary;
var level_reuse_E_FT2_under1 binary;
var level_transfer_E_FT2_under2 binary;
var level_reuse_E_FT2_under2 binary;
var level_transfer_F_FT2_under0 binary;
var level_reuse_F_FT2_under0 binary;
var level_transfer_F_FT2_under1 binary;
var level_reuse_F_FT2_under1 binary;
var level_transfer_F_FT2_under2 binary;
var level_reuse_F_FT2_under2 binary;
var Lat_comp_fused_S4_S5_3 >= 0;
var Lat_comp_fused_S4_S5_2 >= 0;
var Lat_comp_fused_S4_S5_1 >= 0;
var shift_0_to_2 >= 0;
var shift_1_to_2 >= 0;
var nb_dsp_used_SLR0 >= 0;
var nb_dsp_used_SLR1 >= 0;
var nb_dsp_used_SLR2 >= 0;
var TC0_0 integer >= 1;
var TC0_1 integer >= 1;
var TC1_0 integer >= 1;
var TC1_1 integer >= 1;
var TC2_0 integer >= 1;
var TC2_1 integer >= 1;
var TC3_0 integer >= 1;
var TC3_1 integer >= 1;
var TC4_0 integer >= 1;
var TC4_1 integer >= 1;
var TC5_0 integer >= 1;
var TC5_1 integer >= 1;
var TC6_0 integer >= 1;
var TC6_1 integer >= 1;
var TC7_0 integer >= 1;
var TC7_1 integer >= 1;
var TC8_0 integer >= 1;
var TC8_1 integer >= 1;
var TC9_0 integer >= 1;
var TC9_1 integer >= 1;
var TC10_0 integer >= 1;
var TC10_1 integer >= 1;
var TC11_0 integer >= 1;
var TC11_1 integer >= 1;
var TC12_0 integer >= 1;
var TC12_1 integer >= 1;
var TC13_0 integer >= 1;
var TC13_1 integer >= 1;
var TC14_0 integer >= 1;
var TC14_1 integer >= 1;
var G_is_fully_transfered_on_last_dim_FT2 binary;
var burst_G_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC11_for_G integer >= 0 <= 14;
var is_tc11_burst_witout_tiling_for_G binary;
var cte_1 integer >=0;
var cte_burst_without_tiling_TC13_for_G integer >= 0 <= 14;
var is_tc13_burst_witout_tiling_for_G binary;
var cte_2 integer >=0;
var burst_G_is_2 binary;
var cte_3 integer >=0;
var cte_4 integer >=0;
var cte_5 integer >=0;
var burst_G_is_4 binary;
var cte_6 integer >=0;
var cte_7 integer >=0;
var cte_8 integer >=0;
var burst_G_is_8 binary;
var cte_9 integer >=0;
var cte_10 integer >=0;
var cte_11 integer >=0;
var burst_G_is_16 binary;
var cte_12 integer >=0;
var cte_13 integer >=0;
var cte_14 integer >=0;
var B_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B_is_1 binary;
var cte_15 integer >=0;
var cte_burst_without_tiling_TC3_for_B integer >= 0 <= 2;
var is_tc3_burst_witout_tiling_for_B binary;
var burst_B_is_2 binary;
var cte_16 integer >=0;
var burst_B_is_4 binary;
var cte_17 integer >=0;
var burst_B_is_8 binary;
var cte_18 integer >=0;
var burst_B_is_16 binary;
var cte_19 integer >=0;
var C_is_fully_transfered_on_last_dim_FT1 binary;
var burst_C_is_1 binary;
var cte_20 integer >=0;
var cte_burst_without_tiling_TC9_for_C integer >= 0 <= 4;
var is_tc9_burst_witout_tiling_for_C binary;
var burst_C_is_2 binary;
var cte_21 integer >=0;
var burst_C_is_4 binary;
var cte_22 integer >=0;
var burst_C_is_8 binary;
var cte_23 integer >=0;
var burst_C_is_16 binary;
var cte_24 integer >=0;
var E_is_fully_transfered_on_last_dim_FT0 binary;
var E_is_fully_transfered_on_last_dim_FT2 binary;
var burst_E_is_1 binary;
var cte_25 integer >=0;
var cte_burst_without_tiling_TC1_for_E integer >= 0 <= 2;
var is_tc1_burst_witout_tiling_for_E binary;
var cte_26 integer >=0;
var cte_burst_without_tiling_TC3_for_E integer >= 0 <= 2;
var is_tc3_burst_witout_tiling_for_E binary;
var cte_27 integer >=0;
var cte_28 integer >=0;
var cte_burst_without_tiling_TC14_for_E integer >= 0 <= 2;
var is_tc14_burst_witout_tiling_for_E binary;
var burst_E_is_2 binary;
var cte_29 integer >=0;
var cte_30 integer >=0;
var cte_31 integer >=0;
var cte_32 integer >=0;
var burst_E_is_4 binary;
var cte_33 integer >=0;
var cte_34 integer >=0;
var cte_35 integer >=0;
var cte_36 integer >=0;
var burst_E_is_8 binary;
var cte_37 integer >=0;
var cte_38 integer >=0;
var cte_39 integer >=0;
var cte_40 integer >=0;
var burst_E_is_16 binary;
var cte_41 integer >=0;
var cte_42 integer >=0;
var cte_43 integer >=0;
var cte_44 integer >=0;
var A_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A_is_1 binary;
var cte_45 integer >=0;
var cte_burst_without_tiling_TC4_for_A integer >= 0 <= 8;
var is_tc4_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_46 integer >=0;
var burst_A_is_4 binary;
var cte_47 integer >=0;
var burst_A_is_8 binary;
var cte_48 integer >=0;
var burst_A_is_16 binary;
var cte_49 integer >=0;
var F_is_fully_transfered_on_last_dim_FT1 binary;
var F_is_fully_transfered_on_last_dim_FT2 binary;
var burst_F_is_1 binary;
var cte_50 integer >=0;
var cte_burst_without_tiling_TC6_for_F integer >= 0 <= 14;
var is_tc6_burst_witout_tiling_for_F binary;
var cte_51 integer >=0;
var cte_burst_without_tiling_TC8_for_F integer >= 0 <= 14;
var is_tc8_burst_witout_tiling_for_F binary;
var cte_52 integer >=0;
var cte_53 integer >=0;
var cte_burst_without_tiling_TC13_for_F integer >= 0 <= 14;
var is_tc13_burst_witout_tiling_for_F binary;
var burst_F_is_2 binary;
var cte_54 integer >=0;
var cte_55 integer >=0;
var cte_56 integer >=0;
var cte_57 integer >=0;
var burst_F_is_4 binary;
var cte_58 integer >=0;
var cte_59 integer >=0;
var cte_60 integer >=0;
var cte_61 integer >=0;
var burst_F_is_8 binary;
var cte_62 integer >=0;
var cte_63 integer >=0;
var cte_64 integer >=0;
var cte_65 integer >=0;
var burst_F_is_16 binary;
var cte_66 integer >=0;
var cte_67 integer >=0;
var cte_68 integer >=0;
var cte_69 integer >=0;
var D_is_fully_transfered_on_last_dim_FT1 binary;
var burst_D_is_1 binary;
var cte_70 integer >=0;
var cte_burst_without_tiling_TC8_for_D integer >= 0 <= 14;
var is_tc8_burst_witout_tiling_for_D binary;
var burst_D_is_2 binary;
var cte_71 integer >=0;
var burst_D_is_4 binary;
var cte_72 integer >=0;
var burst_D_is_8 binary;
var cte_73 integer >=0;
var burst_D_is_16 binary;
var cte_74 integer >=0;
var footprint_tot_G_FT2 integer >= 1;
var burst_G integer >= 0;
var footprint_tot_B_FT0 integer >= 1;
var burst_B integer >= 0;
var footprint_tot_C_FT1 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_E_FT0 integer >= 1;
var burst_E integer >= 0;
var footprint_tot_E_FT2 integer >= 1;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var footprint_tot_F_FT1 integer >= 1;
var burst_F integer >= 0;
var footprint_tot_F_FT2 integer >= 1;
var footprint_tot_D_FT1 integer >= 1;
var burst_D integer >= 0;
var Lat_comp_0_1 >= 0;
var Lat_comp_2_3 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var cte_tiling_2 integer >= 0;
var cte_tiling_3 integer >= 0;
var cte_tiling_4 integer >= 0;
var cte_tiling_5 integer >= 0;
var cte_tiling_6 integer >= 0;
var cte_tiling_7 integer >= 0;
var cte_tiling_8 integer >= 0;
var cte_tiling_9 integer >= 0;
var cte_tiling_10 integer >= 0;
var cte_tiling_11 integer >= 0;
var cte_tiling_12 integer >= 0;
var cte_tiling_13 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Fuse [2, 3]
#comment: Fuse [4, 5]
#comment: Task 3 writes F to off-chip
#comment: Task 5 writes G to off-chip
#comment: Task 1 writes E to off-chip
#comment: Statement 0: E[i][j] = 0.0;
#comment: Statement 1: E[i][j] += A[i][k] * B[k][j];
#comment: Statement 2: F[i][j] = 0.0;
#comment: Statement 3: F[i][j] += C[i][k] * D[k][j];
#comment: Statement 4: G[i][j] = 0.0;
#comment: Statement 5: G[i][j] += E[i][k] * F[k][j];
#comment: Loop_0: i
#comment: Loop_1: j
#comment: Loop_2: i
#comment: Loop_3: j
#comment: Loop_4: k
#comment: Loop_5: i
#comment: Loop_6: j
#comment: Loop_7: i
#comment: Loop_8: j
#comment: Loop_9: k
#comment: Loop_10: i
#comment: Loop_11: j
#comment: Loop_12: i
#comment: Loop_13: j
#comment: Loop_14: k
#comment: Argument 0: float E[180][190]
#comment: Argument 1: float A[180][200]
#comment: Argument 2: float B[200][190]
#comment: Argument 3: float F[190][210]
#comment: Argument 4: float C[190][220]
#comment: Argument 5: float D[220][210]
#comment: Argument 6: float G[180][210]
#comment: Task 1 gives E to Task 5
#comment: Task 5 received E from Task 1
#comment: Task 3 gives F to Task 5
#comment: Task 5 received F from Task 3
#comment:  4 is a reduction loop
#comment:  9 is a reduction loop
#comment:  14 is a reduction loop
#comment: Task 1 reads B from off-chip
#comment: Task 3 reads C from off-chip
#comment: Task 1 reads A from off-chip
#comment: Task 3 reads D from off-chip
#comment: Array G has for tc in dim 0 TC10 (ori=TC10_ori) arg0
#comment: Array G has for tc in dim 0 TC12 (ori=TC12_ori) arg0
#comment: Array G has for tc in dim 1 TC11 (ori=TC11_ori) arg0
#comment: Array G has for tc in dim 1 TC13 (ori=TC13_ori) arg0
#comment: Array G has for tc in dim 0 TC10 (ori=TC10_ori) arg0
#comment: Array G has for tc in dim 0 TC12 (ori=TC12_ori) arg0
#comment: Array G has for tc in dim 1 TC11 (ori=TC11_ori) arg0
#comment: Array G has for tc in dim 1 TC13 (ori=TC13_ori) arg0
#comment: Array B has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array B has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array C has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array C has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array E has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array E has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array E has for tc in dim 0 TC12 (ori=TC12_ori) arg0
#comment: Array E has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array E has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array E has for tc in dim 1 TC14 (ori=TC14_ori) arg0
#comment: Array E has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array E has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array E has for tc in dim 0 TC12 (ori=TC12_ori) arg0
#comment: Array E has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array E has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array E has for tc in dim 1 TC14 (ori=TC14_ori) arg0
#comment: Array E has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array E has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array E has for tc in dim 0 TC12 (ori=TC12_ori) arg0
#comment: Array E has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array E has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array E has for tc in dim 1 TC14 (ori=TC14_ori) arg0
#comment: Array A has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array F has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array F has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array F has for tc in dim 0 TC14 (ori=TC14_ori) arg0
#comment: Array F has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array F has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array F has for tc in dim 1 TC13 (ori=TC13_ori) arg0
#comment: Array F has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array F has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array F has for tc in dim 0 TC14 (ori=TC14_ori) arg0
#comment: Array F has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array F has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array F has for tc in dim 1 TC13 (ori=TC13_ori) arg0
#comment: Array F has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array F has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array F has for tc in dim 0 TC14 (ori=TC14_ori) arg0
#comment: Array F has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array F has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array F has for tc in dim 1 TC13 (ori=TC13_ori) arg0
#comment: Array D has for tc in dim 0 TC9 (ori=TC9_ori) arg0
#comment: Array D has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Sched 0 has reuse buffer E[TC0_1][TC1_1]
#comment: Sched 1 has reuse buffer E[TC2_1][TC3_1]
#comment: Sched 1 has reuse buffer A[TC2_1][TC4_1]
#comment: Sched 1 has reuse buffer B[TC4_1][TC3_1]
#comment: Sched 2 has reuse buffer F[TC5_1][TC6_1]
#comment: Sched 3 has reuse buffer F[TC7_1][TC8_1]
#comment: Sched 3 has reuse buffer C[TC7_1][TC9_1]
#comment: Sched 3 has reuse buffer D[TC9_1][TC8_1]
#comment: Sched 4 has reuse buffer G[TC10_1][TC11_1]
#comment: Sched 5 has reuse buffer G[TC12_1][TC13_1]
#comment: Sched 5 has reuse buffer E[TC12_1][TC14_1]
#comment: Sched 5 has reuse buffer F[TC14_1][TC13_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0 + is_fused_task2_in_SLR_0);
subject to con1: is_slr1_used = min(1,is_fused_task0_in_SLR_1 + is_fused_task1_in_SLR_1 + is_fused_task2_in_SLR_1);
subject to con2: is_slr2_used = min(1,is_fused_task0_in_SLR_2 + is_fused_task1_in_SLR_2 + is_fused_task2_in_SLR_2);
subject to con3: is_fused_task0_in_SLR_0 + is_fused_task0_in_SLR_1 + is_fused_task0_in_SLR_2 = 1; # only one SLR for fused task 0
subject to con4: is_fused_task1_in_SLR_0 + is_fused_task1_in_SLR_1 + is_fused_task1_in_SLR_2 = 1; # only one SLR for fused task 1
subject to con5: is_fused_task2_in_SLR_0 + is_fused_task2_in_SLR_1 + is_fused_task2_in_SLR_2 = 1; # only one SLR for fused task 2
subject to con6: perm0_S0 + perm1_S0 = 1; # only one permutation
subject to con7: TC2_1 = TC12_1; # same tiling factor
subject to con8: TC2_1 = TC12_1; # same tiling factor
subject to con9: TC2_1 = TC12_1; # same tiling factor
subject to con10: TC2_1 = TC12_1; # same tiling factor
subject to con11: TC2_1 = TC12_1; # same tiling factor
subject to con12: TC2_1 = TC12_1; # same tiling factor
subject to con13: perm0_S1 + perm1_S1 + perm2_S1 + perm3_S1 + perm4_S1 + perm5_S1 = 1; # only one permutation
subject to con14: perm0_S2 + perm1_S2 = 1; # only one permutation
subject to con15: TC8_1 = TC13_1; # same tiling factor
subject to con16: TC8_1 = TC13_1; # same tiling factor
subject to con17: TC8_1 = TC13_1; # same tiling factor
subject to con18: TC8_1 = TC13_1; # same tiling factor
subject to con19: TC8_1 = TC13_1; # same tiling factor
subject to con20: TC8_1 = TC13_1; # same tiling factor
subject to con21: perm0_S3 + perm1_S3 + perm2_S3 + perm3_S3 + perm4_S3 + perm5_S3 = 1; # only one permutation
subject to con22: perm0_S4 + perm1_S4 = 1; # only one permutation
subject to con23: perm0_S5 + perm1_S5 + perm2_S5 + perm3_S5 + perm4_S5 + perm5_S5 = 1; # only one permutation
subject to con24: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con25: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC4_1)/log(2); # latency of the intra-tile S1
subject to con26: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con27: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC9_1)/log(2); # latency of the intra-tile S3
subject to con28: Lat_comp_S4_intra_tile = IL_par_S4 + IL_seq_S4; # latency of the intra-tile S4
subject to con29: Lat_comp_S5_intra_tile = IL_par_S5 + IL_seq_S5 * log(TC14_1)/log(2); # latency of the intra-tile S5
subject to con30: perm1_S1 = 0; # because of the fused task 0
subject to con31: perm3_S1 = 0; # because of the fused task 0
subject to con32: perm4_S1 = 0; # because of the fused task 0
subject to con33: perm5_S1 = 0; # because of the fused task 0
subject to con34: perm1_S3 = 0; # because of the fused task 1
subject to con35: perm3_S3 = 0; # because of the fused task 1
subject to con36: perm4_S3 = 0; # because of the fused task 1
subject to con37: perm5_S3 = 0; # because of the fused task 1
subject to con38: perm1_S5 = 0; # because of the fused task 2
subject to con39: perm3_S5 = 0; # because of the fused task 2
subject to con40: perm4_S5 = 0; # because of the fused task 2
subject to con41: perm5_S5 = 0; # because of the fused task 2
subject to con42: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con43: perm1_S0 = perm2_S1; # same iteration of output in FT 0
subject to con44: perm0_S2 = perm0_S3; # same iteration of output in FT 1
subject to con45: perm1_S2 = perm2_S3; # same iteration of output in FT 1
subject to con46: perm0_S4 = perm0_S5; # same iteration of output in FT 2
subject to con47: perm1_S4 = perm2_S5; # same iteration of output in FT 2
subject to con48: is_fused_task0_in_SLR_0 * (footprint_E_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_F_S2_S3_reuse + footprint_C_S3_reuse + footprint_D_S3_reuse) + is_fused_task2_in_SLR_0 * (footprint_E_S5_reuse + footprint_F_S5_reuse + footprint_G_S4_S5_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con49: is_fused_task0_in_SLR_1 * (footprint_E_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_1 * (footprint_F_S2_S3_reuse + footprint_C_S3_reuse + footprint_D_S3_reuse) + is_fused_task2_in_SLR_1 * (footprint_E_S5_reuse + footprint_F_S5_reuse + footprint_G_S4_S5_reuse) <= SLR1_mem; # memory constraint per SLR
subject to con50: is_fused_task0_in_SLR_2 * (footprint_E_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_2 * (footprint_F_S2_S3_reuse + footprint_C_S3_reuse + footprint_D_S3_reuse) + is_fused_task2_in_SLR_2 * (footprint_E_S5_reuse + footprint_F_S5_reuse + footprint_G_S4_S5_reuse) <= SLR2_mem; # memory constraint per SLR
subject to con51: level_reuse_E_FT0_under0 = level_transfer_E_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con52: level_reuse_E_FT0_under2 = 1; # transfer innermost for output
subject to con53: level_reuse_E_FT0_under1 = level_transfer_E_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con54: level_reuse_E_FT0_under2 = level_transfer_E_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con55: level_transfer_E_FT0_under0 + level_transfer_E_FT0_under1 + level_transfer_E_FT0_under2 = 1; # only one level of transfer for E
subject to con56: level_reuse_E_FT0_under0 + level_reuse_E_FT0_under1 + level_reuse_E_FT0_under2 = 1; # only one level of reuse for E
subject to con57: level_reuse_E_FT0_under0 = level_transfer_E_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con58: level_reuse_E_FT0_under1 = level_transfer_E_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con59: level_reuse_E_FT0_under2 = level_transfer_E_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con60: level_reuse_A_FT0_under0 >= level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con61: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 >= level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con62: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 >= level_transfer_A_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con63: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2 = 1; # only one level of transfer for A
subject to con64: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 = 1; # only one level of reuse for A
subject to con65: level_reuse_B_FT0_under0 >= level_transfer_B_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con66: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 >= level_transfer_B_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con67: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 + level_reuse_B_FT0_under2 >= level_transfer_B_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con68: level_transfer_B_FT0_under0 + level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2 = 1; # only one level of transfer for B
subject to con69: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 + level_reuse_B_FT0_under2 = 1; # only one level of reuse for B
subject to con70: Lat_comp_fused_S0_S1_3 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC4_0)); # latency of the fused task S0_S1 level 3
subject to con71: Lat_comp_fused_S0_S1_2 = (perm0_S0 * TC1_0 + perm1_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_3, level_transfer_E_FT0_under2 * footprint_E_S0_S1 / burst_E, level_transfer_A_FT0_under2 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under2 * footprint_B_S1 / burst_B) + Lat_comp_fused_S0_S1_3 + max(level_transfer_E_FT0_under2 * footprint_E_S0_S1 / burst_E, level_transfer_A_FT0_under2 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under2 * footprint_B_S1 / burst_B  + level_transfer_E_FT0_under2 * footprint_E_S0_S1 / burst_E); # latency of the fused task S0_S1 level 2
subject to con72: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC1_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_E_FT0_under1 * footprint_E_S0_S1 / burst_E, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under1 * footprint_B_S1 / burst_B) + Lat_comp_fused_S0_S1_2 + max(level_transfer_E_FT0_under1 * footprint_E_S0_S1 / burst_E, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under1 * footprint_B_S1 / burst_B  + level_transfer_E_FT0_under1 * footprint_E_S0_S1 / burst_E); # latency of the fused task S0_S1 level 1
subject to con73: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_E_FT0_under0 * footprint_tot_E_FT0 / burst_E + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A + level_transfer_B_FT0_under0 * footprint_tot_B_FT0 / burst_B; # latency of the fused task S0_S1
subject to con74: level_reuse_F_FT1_under0 = level_transfer_F_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con75: level_reuse_F_FT1_under2 = 1; # transfer innermost for output
subject to con76: level_reuse_F_FT1_under1 = level_transfer_F_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con77: level_reuse_F_FT1_under2 = level_transfer_F_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con78: level_transfer_F_FT1_under0 + level_transfer_F_FT1_under1 + level_transfer_F_FT1_under2 = 1; # only one level of transfer for F
subject to con79: level_reuse_F_FT1_under0 + level_reuse_F_FT1_under1 + level_reuse_F_FT1_under2 = 1; # only one level of reuse for F
subject to con80: level_reuse_F_FT1_under0 = level_transfer_F_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con81: level_reuse_F_FT1_under1 = level_transfer_F_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con82: level_reuse_F_FT1_under2 = level_transfer_F_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con83: level_reuse_C_FT1_under0 >= level_transfer_C_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con84: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 >= level_transfer_C_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con85: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 >= level_transfer_C_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con86: level_transfer_C_FT1_under0 + level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2 = 1; # only one level of transfer for C
subject to con87: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 = 1; # only one level of reuse for C
subject to con88: level_reuse_D_FT1_under0 >= level_transfer_D_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con89: level_reuse_D_FT1_under0 + level_reuse_D_FT1_under1 >= level_transfer_D_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con90: level_reuse_D_FT1_under0 + level_reuse_D_FT1_under1 + level_reuse_D_FT1_under2 >= level_transfer_D_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con91: level_transfer_D_FT1_under0 + level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2 = 1; # only one level of transfer for D
subject to con92: level_reuse_D_FT1_under0 + level_reuse_D_FT1_under1 + level_reuse_D_FT1_under2 = 1; # only one level of reuse for D
subject to con93: Lat_comp_fused_S2_S3_3 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC9_0)); # latency of the fused task S2_S3 level 3
subject to con94: Lat_comp_fused_S2_S3_2 = (perm0_S2 * TC6_0 + perm1_S2 * TC5_0) * max(Lat_comp_fused_S2_S3_3, level_transfer_F_FT1_under2 * footprint_F_S2_S3 / burst_F, level_transfer_C_FT1_under2 * footprint_C_S3 / burst_C, level_transfer_D_FT1_under2 * footprint_D_S3 / burst_D) + Lat_comp_fused_S2_S3_3 + max(level_transfer_F_FT1_under2 * footprint_F_S2_S3 / burst_F, level_transfer_C_FT1_under2 * footprint_C_S3 / burst_C, level_transfer_D_FT1_under2 * footprint_D_S3 / burst_D  + level_transfer_F_FT1_under2 * footprint_F_S2_S3 / burst_F); # latency of the fused task S2_S3 level 2
subject to con95: Lat_comp_fused_S2_S3_1 = (perm0_S2 * TC5_0 + perm1_S2 * TC6_0) * max(Lat_comp_fused_S2_S3_2, level_transfer_F_FT1_under1 * footprint_F_S2_S3 / burst_F, level_transfer_C_FT1_under1 * footprint_C_S3 / burst_C, level_transfer_D_FT1_under1 * footprint_D_S3 / burst_D) + Lat_comp_fused_S2_S3_2 + max(level_transfer_F_FT1_under1 * footprint_F_S2_S3 / burst_F, level_transfer_C_FT1_under1 * footprint_C_S3 / burst_C, level_transfer_D_FT1_under1 * footprint_D_S3 / burst_D  + level_transfer_F_FT1_under1 * footprint_F_S2_S3 / burst_F); # latency of the fused task S2_S3 level 1
subject to con96: Lat_comp_fused_S2_S3 = Lat_comp_fused_S2_S3_1 + level_transfer_F_FT1_under0 * footprint_tot_F_FT1 / burst_F + level_transfer_C_FT1_under0 * footprint_tot_C_FT1 / burst_C + level_transfer_D_FT1_under0 * footprint_tot_D_FT1 / burst_D; # latency of the fused task S2_S3
subject to con97: level_reuse_G_FT2_under0 = level_transfer_G_FT2_under0; # reuse level have to be outermost or equal to transfer
subject to con98: level_reuse_G_FT2_under2 = 1; # transfer innermost for output
subject to con99: level_reuse_G_FT2_under1 = level_transfer_G_FT2_under1; # reuse level have to be outermost or equal to transfer
subject to con100: level_reuse_G_FT2_under2 = level_transfer_G_FT2_under2; # reuse level have to be outermost or equal to transfer
subject to con101: level_transfer_G_FT2_under0 + level_transfer_G_FT2_under1 + level_transfer_G_FT2_under2 = 1; # only one level of transfer for G
subject to con102: level_reuse_G_FT2_under0 + level_reuse_G_FT2_under1 + level_reuse_G_FT2_under2 = 1; # only one level of reuse for G
subject to con103: level_reuse_G_FT2_under0 = level_transfer_G_FT2_under0; # reuse level have to be outermost or equal to transfer
subject to con104: level_reuse_G_FT2_under1 = level_transfer_G_FT2_under1; # reuse level have to be outermost or equal to transfer
subject to con105: level_reuse_G_FT2_under2 = level_transfer_G_FT2_under2; # reuse level have to be outermost or equal to transfer
subject to con106: level_reuse_E_FT2_under0 >= level_transfer_E_FT2_under0; # reuse level have to be outermost or equal to transfer
subject to con107: level_reuse_E_FT2_under0 + level_reuse_E_FT2_under1 >= level_transfer_E_FT2_under1; # reuse level have to be outermost or equal to transfer
subject to con108: level_reuse_E_FT2_under0 + level_reuse_E_FT2_under1 + level_reuse_E_FT2_under2 >= level_transfer_E_FT2_under2; # reuse level have to be outermost or equal to transfer
subject to con109: level_transfer_E_FT2_under0 + level_transfer_E_FT2_under1 + level_transfer_E_FT2_under2 = 1; # only one level of transfer for E
subject to con110: level_reuse_E_FT2_under0 + level_reuse_E_FT2_under1 + level_reuse_E_FT2_under2 = 1; # only one level of reuse for E
subject to con111: level_reuse_F_FT2_under0 >= level_transfer_F_FT2_under0; # reuse level have to be outermost or equal to transfer
subject to con112: level_reuse_F_FT2_under0 + level_reuse_F_FT2_under1 >= level_transfer_F_FT2_under1; # reuse level have to be outermost or equal to transfer
subject to con113: level_reuse_F_FT2_under0 + level_reuse_F_FT2_under1 + level_reuse_F_FT2_under2 >= level_transfer_F_FT2_under2; # reuse level have to be outermost or equal to transfer
subject to con114: level_transfer_F_FT2_under0 + level_transfer_F_FT2_under1 + level_transfer_F_FT2_under2 = 1; # only one level of transfer for F
subject to con115: level_reuse_F_FT2_under0 + level_reuse_F_FT2_under1 + level_reuse_F_FT2_under2 = 1; # only one level of reuse for F
subject to con116: Lat_comp_fused_S4_S5_3 = ((Lat_comp_S4_intra_tile) + (Lat_comp_S5_intra_tile + II_S5_seq * TC14_0)); # latency of the fused task S4_S5 level 3
subject to con117: Lat_comp_fused_S4_S5_2 = (perm0_S4 * TC11_0 + perm1_S4 * TC10_0) * max(Lat_comp_fused_S4_S5_3, level_transfer_G_FT2_under2 * footprint_G_S4_S5 / burst_G, level_transfer_E_FT2_under2 * footprint_E_S5 / burst_E, level_transfer_F_FT2_under2 * footprint_F_S5 / burst_F) + Lat_comp_fused_S4_S5_3 + max(level_transfer_G_FT2_under2 * footprint_G_S4_S5 / burst_G, level_transfer_E_FT2_under2 * footprint_E_S5 / burst_E, level_transfer_F_FT2_under2 * footprint_F_S5 / burst_F  + level_transfer_G_FT2_under2 * footprint_G_S4_S5 / burst_G); # latency of the fused task S4_S5 level 2
subject to con118: Lat_comp_fused_S4_S5_1 = (perm0_S4 * TC10_0 + perm1_S4 * TC11_0) * max(Lat_comp_fused_S4_S5_2, level_transfer_G_FT2_under1 * footprint_G_S4_S5 / burst_G, level_transfer_E_FT2_under1 * footprint_E_S5 / burst_E, level_transfer_F_FT2_under1 * footprint_F_S5 / burst_F) + Lat_comp_fused_S4_S5_2 + max(level_transfer_G_FT2_under1 * footprint_G_S4_S5 / burst_G, level_transfer_E_FT2_under1 * footprint_E_S5 / burst_E, level_transfer_F_FT2_under1 * footprint_F_S5 / burst_F  + level_transfer_G_FT2_under1 * footprint_G_S4_S5 / burst_G); # latency of the fused task S4_S5 level 1
subject to con119: Lat_comp_fused_S4_S5 = Lat_comp_fused_S4_S5_1 + level_transfer_G_FT2_under0 * footprint_tot_G_FT2 / burst_G + level_transfer_E_FT2_under0 * footprint_tot_E_FT2 / burst_E + level_transfer_F_FT2_under0 * footprint_tot_F_FT2 / burst_F; # latency of the fused task S4_S5
subject to con120: footprint_E_S0_S1 = level_transfer_E_FT0_under0 * footprint_tot_E_FT0 + level_transfer_E_FT0_under1 * (perm0_S0 * footprint_tot_E_FT0/ TC0_0 + perm1_S0 * footprint_tot_E_FT0/ TC1_0) + level_transfer_E_FT0_under2 * (perm0_S0 * footprint_tot_E_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_E_FT0/ TC1_0/ TC0_0); # footprint of the array E for the fused task 0
subject to con121: footprint_E_S0_S1_reuse = level_reuse_E_FT0_under0 * footprint_tot_E_FT0 + level_reuse_E_FT0_under1 * (perm0_S0 * footprint_tot_E_FT0/ TC0_0 + perm1_S0 * footprint_tot_E_FT0/ TC1_0) + level_reuse_E_FT0_under2 * (perm0_S0 * footprint_tot_E_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_E_FT0/ TC1_0/ TC0_0); # footprint of the array E for the fused task 0
subject to con122: perm2_S1 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con123: perm2_S1 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con124: perm3_S1 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con125: perm3_S1 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con126: perm0_S1 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con127: perm0_S1 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con128: perm5_S1 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con129: perm5_S1 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con130: footprint_A_S1 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0 + perm2_S1 * footprint_tot_A_FT0 + perm3_S1 * footprint_tot_A_FT0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0) + level_transfer_A_FT0_under2 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A_FT0/ TC2_0 + perm3_S1 * footprint_tot_A_FT0/ TC4_0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0); # footprint of the array A for the fused task 0
subject to con131: footprint_A_S1_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0 + perm2_S1 * footprint_tot_A_FT0 + perm3_S1 * footprint_tot_A_FT0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0) + level_reuse_A_FT0_under2 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A_FT0/ TC2_0 + perm3_S1 * footprint_tot_A_FT0/ TC4_0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0); # footprint of the array A for the fused task 0
subject to con132: perm0_S1 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con133: perm0_S1 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con134: perm1_S1 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con135: perm1_S1 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con136: perm2_S1 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con137: perm2_S1 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con138: perm4_S1 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con139: perm4_S1 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con140: footprint_B_S1 = level_transfer_B_FT0_under0 * footprint_tot_B_FT0 + level_transfer_B_FT0_under1 * (perm0_S1 * footprint_tot_B_FT0 + perm1_S1 * footprint_tot_B_FT0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0) + level_transfer_B_FT0_under2 * (perm0_S1 * footprint_tot_B_FT0/ TC3_0 + perm1_S1 * footprint_tot_B_FT0/ TC4_0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0/ TC3_0); # footprint of the array B for the fused task 0
subject to con141: footprint_B_S1_reuse = level_reuse_B_FT0_under0 * footprint_tot_B_FT0 + level_reuse_B_FT0_under1 * (perm0_S1 * footprint_tot_B_FT0 + perm1_S1 * footprint_tot_B_FT0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0) + level_reuse_B_FT0_under2 * (perm0_S1 * footprint_tot_B_FT0/ TC3_0 + perm1_S1 * footprint_tot_B_FT0/ TC4_0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0/ TC3_0); # footprint of the array B for the fused task 0
subject to con142: footprint_F_S2_S3 = level_transfer_F_FT1_under0 * footprint_tot_F_FT1 + level_transfer_F_FT1_under1 * (perm0_S2 * footprint_tot_F_FT1/ TC5_0 + perm1_S2 * footprint_tot_F_FT1/ TC6_0) + level_transfer_F_FT1_under2 * (perm0_S2 * footprint_tot_F_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_F_FT1/ TC6_0/ TC5_0); # footprint of the array F for the fused task 1
subject to con143: footprint_F_S2_S3_reuse = level_reuse_F_FT1_under0 * footprint_tot_F_FT1 + level_reuse_F_FT1_under1 * (perm0_S2 * footprint_tot_F_FT1/ TC5_0 + perm1_S2 * footprint_tot_F_FT1/ TC6_0) + level_reuse_F_FT1_under2 * (perm0_S2 * footprint_tot_F_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_F_FT1/ TC6_0/ TC5_0); # footprint of the array F for the fused task 1
subject to con144: perm2_S3 * level_transfer_C_FT1_under1 = 0; # useless to transfer under this loop
subject to con145: perm2_S3 * level_reuse_C_FT1_under1 = 0; # useless to reuse under this loop
subject to con146: perm3_S3 * level_transfer_C_FT1_under1 = 0; # useless to transfer under this loop
subject to con147: perm3_S3 * level_reuse_C_FT1_under1 = 0; # useless to reuse under this loop
subject to con148: perm0_S3 * level_transfer_C_FT1_under2 = 0; # useless to transfer under this loop
subject to con149: perm0_S3 * level_reuse_C_FT1_under2 = 0; # useless to reuse under this loop
subject to con150: perm5_S3 * level_transfer_C_FT1_under2 = 0; # useless to transfer under this loop
subject to con151: perm5_S3 * level_reuse_C_FT1_under2 = 0; # useless to reuse under this loop
subject to con152: footprint_C_S3 = level_transfer_C_FT1_under0 * footprint_tot_C_FT1 + level_transfer_C_FT1_under1 * (perm0_S3 * footprint_tot_C_FT1/ TC7_0 + perm1_S3 * footprint_tot_C_FT1/ TC7_0 + perm2_S3 * footprint_tot_C_FT1 + perm3_S3 * footprint_tot_C_FT1 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0) + level_transfer_C_FT1_under2 * (perm0_S3 * footprint_tot_C_FT1/ TC7_0 + perm1_S3 * footprint_tot_C_FT1/ TC7_0/ TC9_0 + perm2_S3 * footprint_tot_C_FT1/ TC7_0 + perm3_S3 * footprint_tot_C_FT1/ TC9_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0/ TC7_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0); # footprint of the array C for the fused task 1
subject to con153: footprint_C_S3_reuse = level_reuse_C_FT1_under0 * footprint_tot_C_FT1 + level_reuse_C_FT1_under1 * (perm0_S3 * footprint_tot_C_FT1/ TC7_0 + perm1_S3 * footprint_tot_C_FT1/ TC7_0 + perm2_S3 * footprint_tot_C_FT1 + perm3_S3 * footprint_tot_C_FT1 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0) + level_reuse_C_FT1_under2 * (perm0_S3 * footprint_tot_C_FT1/ TC7_0 + perm1_S3 * footprint_tot_C_FT1/ TC7_0/ TC9_0 + perm2_S3 * footprint_tot_C_FT1/ TC7_0 + perm3_S3 * footprint_tot_C_FT1/ TC9_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0/ TC7_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0); # footprint of the array C for the fused task 1
subject to con154: perm0_S3 * level_transfer_D_FT1_under1 = 0; # useless to transfer under this loop
subject to con155: perm0_S3 * level_reuse_D_FT1_under1 = 0; # useless to reuse under this loop
subject to con156: perm1_S3 * level_transfer_D_FT1_under1 = 0; # useless to transfer under this loop
subject to con157: perm1_S3 * level_reuse_D_FT1_under1 = 0; # useless to reuse under this loop
subject to con158: perm2_S3 * level_transfer_D_FT1_under2 = 0; # useless to transfer under this loop
subject to con159: perm2_S3 * level_reuse_D_FT1_under2 = 0; # useless to reuse under this loop
subject to con160: perm4_S3 * level_transfer_D_FT1_under2 = 0; # useless to transfer under this loop
subject to con161: perm4_S3 * level_reuse_D_FT1_under2 = 0; # useless to reuse under this loop
subject to con162: footprint_D_S3 = level_transfer_D_FT1_under0 * footprint_tot_D_FT1 + level_transfer_D_FT1_under1 * (perm0_S3 * footprint_tot_D_FT1 + perm1_S3 * footprint_tot_D_FT1 + perm2_S3 * footprint_tot_D_FT1/ TC8_0 + perm3_S3 * footprint_tot_D_FT1/ TC8_0 + perm4_S3 * footprint_tot_D_FT1/ TC9_0 + perm5_S3 * footprint_tot_D_FT1/ TC9_0) + level_transfer_D_FT1_under2 * (perm0_S3 * footprint_tot_D_FT1/ TC8_0 + perm1_S3 * footprint_tot_D_FT1/ TC9_0 + perm2_S3 * footprint_tot_D_FT1/ TC8_0 + perm3_S3 * footprint_tot_D_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_D_FT1/ TC9_0 + perm5_S3 * footprint_tot_D_FT1/ TC9_0/ TC8_0); # footprint of the array D for the fused task 1
subject to con163: footprint_D_S3_reuse = level_reuse_D_FT1_under0 * footprint_tot_D_FT1 + level_reuse_D_FT1_under1 * (perm0_S3 * footprint_tot_D_FT1 + perm1_S3 * footprint_tot_D_FT1 + perm2_S3 * footprint_tot_D_FT1/ TC8_0 + perm3_S3 * footprint_tot_D_FT1/ TC8_0 + perm4_S3 * footprint_tot_D_FT1/ TC9_0 + perm5_S3 * footprint_tot_D_FT1/ TC9_0) + level_reuse_D_FT1_under2 * (perm0_S3 * footprint_tot_D_FT1/ TC8_0 + perm1_S3 * footprint_tot_D_FT1/ TC9_0 + perm2_S3 * footprint_tot_D_FT1/ TC8_0 + perm3_S3 * footprint_tot_D_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_D_FT1/ TC9_0 + perm5_S3 * footprint_tot_D_FT1/ TC9_0/ TC8_0); # footprint of the array D for the fused task 1
subject to con164: footprint_G_S4_S5 = level_transfer_G_FT2_under0 * footprint_tot_G_FT2 + level_transfer_G_FT2_under1 * (perm0_S4 * footprint_tot_G_FT2/ TC10_0 + perm1_S4 * footprint_tot_G_FT2/ TC11_0) + level_transfer_G_FT2_under2 * (perm0_S4 * footprint_tot_G_FT2/ TC10_0/ TC11_0 + perm1_S4 * footprint_tot_G_FT2/ TC11_0/ TC10_0); # footprint of the array G for the fused task 2
subject to con165: footprint_G_S4_S5_reuse = level_reuse_G_FT2_under0 * footprint_tot_G_FT2 + level_reuse_G_FT2_under1 * (perm0_S4 * footprint_tot_G_FT2/ TC10_0 + perm1_S4 * footprint_tot_G_FT2/ TC11_0) + level_reuse_G_FT2_under2 * (perm0_S4 * footprint_tot_G_FT2/ TC10_0/ TC11_0 + perm1_S4 * footprint_tot_G_FT2/ TC11_0/ TC10_0); # footprint of the array G for the fused task 2
subject to con166: perm2_S5 * level_transfer_E_FT2_under1 = 0; # useless to transfer under this loop
subject to con167: perm2_S5 * level_reuse_E_FT2_under1 = 0; # useless to reuse under this loop
subject to con168: perm3_S5 * level_transfer_E_FT2_under1 = 0; # useless to transfer under this loop
subject to con169: perm3_S5 * level_reuse_E_FT2_under1 = 0; # useless to reuse under this loop
subject to con170: perm0_S5 * level_transfer_E_FT2_under2 = 0; # useless to transfer under this loop
subject to con171: perm0_S5 * level_reuse_E_FT2_under2 = 0; # useless to reuse under this loop
subject to con172: perm5_S5 * level_transfer_E_FT2_under2 = 0; # useless to transfer under this loop
subject to con173: perm5_S5 * level_reuse_E_FT2_under2 = 0; # useless to reuse under this loop
subject to con174: footprint_E_S5 = level_transfer_E_FT2_under0 * footprint_tot_E_FT2 + level_transfer_E_FT2_under1 * (perm0_S5 * footprint_tot_E_FT2/ TC12_0 + perm1_S5 * footprint_tot_E_FT2/ TC12_0 + perm2_S5 * footprint_tot_E_FT2 + perm3_S5 * footprint_tot_E_FT2 + perm4_S5 * footprint_tot_E_FT2/ TC14_0 + perm5_S5 * footprint_tot_E_FT2/ TC14_0) + level_transfer_E_FT2_under2 * (perm0_S5 * footprint_tot_E_FT2/ TC12_0 + perm1_S5 * footprint_tot_E_FT2/ TC12_0/ TC14_0 + perm2_S5 * footprint_tot_E_FT2/ TC12_0 + perm3_S5 * footprint_tot_E_FT2/ TC14_0 + perm4_S5 * footprint_tot_E_FT2/ TC14_0/ TC12_0 + perm5_S5 * footprint_tot_E_FT2/ TC14_0); # footprint of the array E for the fused task 2
subject to con175: footprint_E_S5_reuse = level_reuse_E_FT2_under0 * footprint_tot_E_FT2 + level_reuse_E_FT2_under1 * (perm0_S5 * footprint_tot_E_FT2/ TC12_0 + perm1_S5 * footprint_tot_E_FT2/ TC12_0 + perm2_S5 * footprint_tot_E_FT2 + perm3_S5 * footprint_tot_E_FT2 + perm4_S5 * footprint_tot_E_FT2/ TC14_0 + perm5_S5 * footprint_tot_E_FT2/ TC14_0) + level_reuse_E_FT2_under2 * (perm0_S5 * footprint_tot_E_FT2/ TC12_0 + perm1_S5 * footprint_tot_E_FT2/ TC12_0/ TC14_0 + perm2_S5 * footprint_tot_E_FT2/ TC12_0 + perm3_S5 * footprint_tot_E_FT2/ TC14_0 + perm4_S5 * footprint_tot_E_FT2/ TC14_0/ TC12_0 + perm5_S5 * footprint_tot_E_FT2/ TC14_0); # footprint of the array E for the fused task 2
subject to con176: perm0_S5 * level_transfer_F_FT2_under1 = 0; # useless to transfer under this loop
subject to con177: perm0_S5 * level_reuse_F_FT2_under1 = 0; # useless to reuse under this loop
subject to con178: perm1_S5 * level_transfer_F_FT2_under1 = 0; # useless to transfer under this loop
subject to con179: perm1_S5 * level_reuse_F_FT2_under1 = 0; # useless to reuse under this loop
subject to con180: perm2_S5 * level_transfer_F_FT2_under2 = 0; # useless to transfer under this loop
subject to con181: perm2_S5 * level_reuse_F_FT2_under2 = 0; # useless to reuse under this loop
subject to con182: perm4_S5 * level_transfer_F_FT2_under2 = 0; # useless to transfer under this loop
subject to con183: perm4_S5 * level_reuse_F_FT2_under2 = 0; # useless to reuse under this loop
subject to con184: footprint_F_S5 = level_transfer_F_FT2_under0 * footprint_tot_F_FT2 + level_transfer_F_FT2_under1 * (perm0_S5 * footprint_tot_F_FT2 + perm1_S5 * footprint_tot_F_FT2 + perm2_S5 * footprint_tot_F_FT2/ TC13_0 + perm3_S5 * footprint_tot_F_FT2/ TC13_0 + perm4_S5 * footprint_tot_F_FT2/ TC14_0 + perm5_S5 * footprint_tot_F_FT2/ TC14_0) + level_transfer_F_FT2_under2 * (perm0_S5 * footprint_tot_F_FT2/ TC13_0 + perm1_S5 * footprint_tot_F_FT2/ TC14_0 + perm2_S5 * footprint_tot_F_FT2/ TC13_0 + perm3_S5 * footprint_tot_F_FT2/ TC13_0/ TC14_0 + perm4_S5 * footprint_tot_F_FT2/ TC14_0 + perm5_S5 * footprint_tot_F_FT2/ TC14_0/ TC13_0); # footprint of the array F for the fused task 2
subject to con185: footprint_F_S5_reuse = level_reuse_F_FT2_under0 * footprint_tot_F_FT2 + level_reuse_F_FT2_under1 * (perm0_S5 * footprint_tot_F_FT2 + perm1_S5 * footprint_tot_F_FT2 + perm2_S5 * footprint_tot_F_FT2/ TC13_0 + perm3_S5 * footprint_tot_F_FT2/ TC13_0 + perm4_S5 * footprint_tot_F_FT2/ TC14_0 + perm5_S5 * footprint_tot_F_FT2/ TC14_0) + level_reuse_F_FT2_under2 * (perm0_S5 * footprint_tot_F_FT2/ TC13_0 + perm1_S5 * footprint_tot_F_FT2/ TC14_0 + perm2_S5 * footprint_tot_F_FT2/ TC13_0 + perm3_S5 * footprint_tot_F_FT2/ TC13_0/ TC14_0 + perm4_S5 * footprint_tot_F_FT2/ TC14_0 + perm5_S5 * footprint_tot_F_FT2/ TC14_0/ TC13_0); # footprint of the array F for the fused task 2
subject to con186: shift_0_to_2 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC4_0 + footprint_E_S0_S1) * footprint_E_S5 / footprint_E_S0_S1;
subject to con187: shift_1_to_2 = ( + Lat_comp_S2_intra_tile + Lat_comp_S3_intra_tile + II_S3_seq * TC9_0 + footprint_F_S2_S3) * footprint_F_S5 / footprint_F_S2_S3;
subject to con188: TC0_1 * TC1_1 <= MAX_UF;
subject to con189: TC2_1 * TC3_1 * TC4_1 <= MAX_UF;
subject to con190: TC5_1 * TC6_1 <= MAX_UF;
subject to con191: TC7_1 * TC8_1 * TC9_1 <= MAX_UF;
subject to con192: TC10_1 * TC11_1 <= MAX_UF;
subject to con193: TC12_1 * TC13_1 * TC14_1 <= MAX_UF;
subject to con194: TC0_1 * TC1_1 * DSP_S0  + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq + TC5_1 * TC6_1 * DSP_S2  + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq + TC10_1 * TC11_1 * DSP_S4  + TC12_1 * TC13_1 * TC14_1 * DSP_S5 / II_S5_seq <= DSP_avail; # DSP constraint
subject to con195: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq) + is_fused_task2_in_SLR_0 * (TC10_1 * TC11_1 * DSP_S4 + TC12_1 * TC13_1 * TC14_1 * DSP_S5 / II_S5_seq); # DSP constraint per SLR
subject to con196: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con197: nb_dsp_used_SLR1 = is_fused_task0_in_SLR_1 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_1 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq) + is_fused_task2_in_SLR_1 * (TC10_1 * TC11_1 * DSP_S4 + TC12_1 * TC13_1 * TC14_1 * DSP_S5 / II_S5_seq); # DSP constraint per SLR
subject to con198: nb_dsp_used_SLR1 <= SLR1_DSP; # DSP constraint per SLR
subject to con199: nb_dsp_used_SLR2 = is_fused_task0_in_SLR_2 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_2 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq) + is_fused_task2_in_SLR_2 * (TC10_1 * TC11_1 * DSP_S4 + TC12_1 * TC13_1 * TC14_1 * DSP_S5 / II_S5_seq); # DSP constraint per SLR
subject to con200: nb_dsp_used_SLR2 <= SLR2_DSP; # DSP constraint per SLR
subject to con201: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array E 
subject to con202: TC0_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array E 
subject to con203: TC2_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array E 
subject to con204: TC2_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array E 
subject to con205: TC2_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con206: TC4_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con207: TC5_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array F 
subject to con208: TC5_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array F 
subject to con209: TC7_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array F 
subject to con210: TC7_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array F 
subject to con211: TC7_1 * TC9_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con212: TC9_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array D 
subject to con213: TC10_1 * TC11_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array G 
subject to con214: TC10_1 * TC13_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array G 
subject to con215: TC12_1 * TC11_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array G 
subject to con216: TC12_1 * TC13_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array G 
subject to con217: TC12_1 * TC14_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array E 
subject to con218: TC14_1 * TC13_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array F 
subject to con219: Lat_comp_S5_for_off_chip = perm0_S5 * TC14_0 * II_S5_seq + perm1_S5 * TC14_0 * TC13_0 * II_S5_par + perm2_S5 * TC14_0 * II_S5_seq + perm3_S5 * TC14_0 * TC12_0 * II_S5_par + perm4_S5 * TC14_0 * TC12_0 * TC13_0 * II_S5_par + perm5_S5 * TC14_0 * TC13_0 * TC12_0 * II_S5_par; # stall between task
subject to con220: TC0_0 <= TC0; # TC of split loop
subject to con221: TC0_1 <= TC0; # TC of split loop
subject to con222: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con223: TC1_0 <= TC1; # TC of split loop
subject to con224: TC1_1 <= TC1; # TC of split loop
subject to con225: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con226: TC2_0 <= TC2; # TC of split loop
subject to con227: TC2_1 <= TC2; # TC of split loop
subject to con228: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con229: TC3_0 <= TC3; # TC of split loop
subject to con230: TC3_1 <= TC3; # TC of split loop
subject to con231: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con232: TC4_0 <= TC4; # TC of split loop
subject to con233: TC4_1 <= TC4; # TC of split loop
subject to con234: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con235: TC5_0 <= TC5; # TC of split loop
subject to con236: TC5_1 <= TC5; # TC of split loop
subject to con237: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con238: TC6_0 <= TC6; # TC of split loop
subject to con239: TC6_1 <= TC6; # TC of split loop
subject to con240: TC6_0 * TC6_1 = TC6; # product of the TC of split loop = original TC
subject to con241: TC7_0 <= TC7; # TC of split loop
subject to con242: TC7_1 <= TC7; # TC of split loop
subject to con243: TC7_0 * TC7_1 = TC7; # product of the TC of split loop = original TC
subject to con244: TC8_0 <= TC8; # TC of split loop
subject to con245: TC8_1 <= TC8; # TC of split loop
subject to con246: TC8_0 * TC8_1 = TC8; # product of the TC of split loop = original TC
subject to con247: TC9_0 <= TC9; # TC of split loop
subject to con248: TC9_1 <= TC9; # TC of split loop
subject to con249: TC9_0 * TC9_1 = TC9; # product of the TC of split loop = original TC
subject to con250: TC10_0 <= TC10; # TC of split loop
subject to con251: TC10_1 <= TC10; # TC of split loop
subject to con252: TC10_0 * TC10_1 = TC10; # product of the TC of split loop = original TC
subject to con253: TC11_0 <= TC11; # TC of split loop
subject to con254: TC11_1 <= TC11; # TC of split loop
subject to con255: TC11_0 * TC11_1 = TC11; # product of the TC of split loop = original TC
subject to con256: TC12_0 <= TC12; # TC of split loop
subject to con257: TC12_1 <= TC12; # TC of split loop
subject to con258: TC12_0 * TC12_1 = TC12; # product of the TC of split loop = original TC
subject to con259: TC13_0 <= TC13; # TC of split loop
subject to con260: TC13_1 <= TC13; # TC of split loop
subject to con261: TC13_0 * TC13_1 = TC13; # product of the TC of split loop = original TC
subject to con262: TC14_0 <= TC14; # TC of split loop
subject to con263: TC14_1 <= TC14; # TC of split loop
subject to con264: TC14_0 * TC14_1 = TC14; # product of the TC of split loop = original TC
subject to con265: TC10_1 = TC12_1; # same intra tile for the same dimension of the array G in the fused task
subject to con266: TC11_1 = TC13_1; # same intra tile for the same dimension of the array G in the fused task
subject to con267: TC0_1 = TC2_1; # same intra tile for the same dimension of the array E in the fused task
subject to con268: TC1_1 = TC3_1; # same intra tile for the same dimension of the array E in the fused task
subject to con269: TC5_1 = TC7_1; # same intra tile for the same dimension of the array F in the fused task
subject to con270: TC6_1 = TC8_1; # same intra tile for the same dimension of the array F in the fused task
subject to con271: G_is_fully_transfered_on_last_dim_FT2 = level_transfer_G_FT2_under0 + perm0_S4 * (level_transfer_G_FT2_under1); # the array G is fully transfered on the last dimension
subject to con272: G_is_fully_transfered_on_last_dim_FT2 = level_transfer_G_FT2_under0 + perm0_S5 * (level_transfer_G_FT2_under1) + perm1_S5 * (level_transfer_G_FT2_under1 + level_transfer_G_FT2_under2) + perm4_S5 * (level_transfer_G_FT2_under1 + level_transfer_G_FT2_under2) + perm5_S5 * (level_transfer_G_FT2_under1); # the array G is fully transfered on the last dimension
subject to con273: burst_G_is_1 * cte_0 * 1 = burst_G_is_1 * ((1-is_tc11_burst_witout_tiling_for_G) * (TC11_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC11 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc11_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC11_for_G + TC11));
subject to con274: is_tc11_burst_witout_tiling_for_G =  min(1, cte_burst_without_tiling_TC11_for_G);
subject to con275: burst_G_is_1 * cte_1 * 1 = burst_G_is_1 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con276: is_tc13_burst_witout_tiling_for_G =  min(1, cte_burst_without_tiling_TC13_for_G);
subject to con277: burst_G_is_1 * cte_2 * 1 = burst_G_is_1 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con278: burst_G_is_2 * cte_3 * 2 = burst_G_is_2 * ((1-is_tc11_burst_witout_tiling_for_G) * (TC11_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC11 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc11_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC11_for_G + TC11));
subject to con279: burst_G_is_2 * cte_4 * 2 = burst_G_is_2 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con280: burst_G_is_2 * cte_5 * 2 = burst_G_is_2 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con281: burst_G_is_4 * cte_6 * 4 = burst_G_is_4 * ((1-is_tc11_burst_witout_tiling_for_G) * (TC11_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC11 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc11_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC11_for_G + TC11));
subject to con282: burst_G_is_4 * cte_7 * 4 = burst_G_is_4 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con283: burst_G_is_4 * cte_8 * 4 = burst_G_is_4 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con284: burst_G_is_8 * cte_9 * 8 = burst_G_is_8 * ((1-is_tc11_burst_witout_tiling_for_G) * (TC11_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC11 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc11_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC11_for_G + TC11));
subject to con285: burst_G_is_8 * cte_10 * 8 = burst_G_is_8 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con286: burst_G_is_8 * cte_11 * 8 = burst_G_is_8 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con287: burst_G_is_16 * cte_12 * 16 = burst_G_is_16 * ((1-is_tc11_burst_witout_tiling_for_G) * (TC11_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC11 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc11_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC11_for_G + TC11));
subject to con288: burst_G_is_16 * cte_13 * 16 = burst_G_is_16 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con289: burst_G_is_16 * cte_14 * 16 = burst_G_is_16 * ((1-is_tc13_burst_witout_tiling_for_G) * (TC13_1 * (1-G_is_fully_transfered_on_last_dim_FT2) + TC13 * (G_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_G * (cte_burst_without_tiling_TC13_for_G + TC13));
subject to con290: burst_G = burst_G_is_1 * 1 + burst_G_is_2 * 2 + burst_G_is_4 * 4 + burst_G_is_8 * 8 + burst_G_is_16 * 16; # burst size of the array G
subject to con291: burst_G_is_1 + burst_G_is_2 + burst_G_is_4 + burst_G_is_8 + burst_G_is_16 = 1; # only one burst size for the array G
subject to con292: is_tc11_burst_witout_tiling_for_G <= G_is_fully_transfered_on_last_dim_FT2;
subject to con293: is_tc13_burst_witout_tiling_for_G <= G_is_fully_transfered_on_last_dim_FT2;
subject to con294: B_is_fully_transfered_on_last_dim_FT0 = level_transfer_B_FT0_under0 + perm0_S1 * (level_transfer_B_FT0_under1) + perm1_S1 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm4_S1 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm5_S1 * (level_transfer_B_FT0_under1); # the array B is fully transfered on the last dimension
subject to con295: burst_B_is_1 * cte_15 * 1 = burst_B_is_1 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con296: is_tc3_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC3_for_B);
subject to con297: burst_B_is_2 * cte_16 * 2 = burst_B_is_2 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con298: burst_B_is_4 * cte_17 * 4 = burst_B_is_4 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con299: burst_B_is_8 * cte_18 * 8 = burst_B_is_8 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con300: burst_B_is_16 * cte_19 * 16 = burst_B_is_16 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con301: burst_B = burst_B_is_1 * 1 + burst_B_is_2 * 2 + burst_B_is_4 * 4 + burst_B_is_8 * 8 + burst_B_is_16 * 16; # burst size of the array B
subject to con302: burst_B_is_1 + burst_B_is_2 + burst_B_is_4 + burst_B_is_8 + burst_B_is_16 = 1; # only one burst size for the array B
subject to con303: is_tc3_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT0;
subject to con304: C_is_fully_transfered_on_last_dim_FT1 = level_transfer_C_FT1_under0 + perm0_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm1_S3 * (level_transfer_C_FT1_under1) + perm2_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm3_S3 * (level_transfer_C_FT1_under1); # the array C is fully transfered on the last dimension
subject to con305: burst_C_is_1 * cte_20 * 1 = burst_C_is_1 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con306: is_tc9_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC9_for_C);
subject to con307: burst_C_is_2 * cte_21 * 2 = burst_C_is_2 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con308: burst_C_is_4 * cte_22 * 4 = burst_C_is_4 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con309: burst_C_is_8 * cte_23 * 8 = burst_C_is_8 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con310: burst_C_is_16 * cte_24 * 16 = burst_C_is_16 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con311: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con312: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con313: is_tc9_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT1;
subject to con314: E_is_fully_transfered_on_last_dim_FT0 = level_transfer_E_FT0_under0 + perm0_S0 * (level_transfer_E_FT0_under1); # the array E is fully transfered on the last dimension
subject to con315: E_is_fully_transfered_on_last_dim_FT0 = level_transfer_E_FT0_under0 + perm0_S1 * (level_transfer_E_FT0_under1) + perm1_S1 * (level_transfer_E_FT0_under1 + level_transfer_E_FT0_under2) + perm4_S1 * (level_transfer_E_FT0_under1 + level_transfer_E_FT0_under2) + perm5_S1 * (level_transfer_E_FT0_under1); # the array E is fully transfered on the last dimension
subject to con316: E_is_fully_transfered_on_last_dim_FT2 = level_transfer_E_FT2_under0 + perm0_S5 * (level_transfer_E_FT2_under1 + level_transfer_E_FT2_under2) + perm1_S5 * (level_transfer_E_FT2_under1) + perm2_S5 * (level_transfer_E_FT2_under1 + level_transfer_E_FT2_under2) + perm3_S5 * (level_transfer_E_FT2_under1); # the array E is fully transfered on the last dimension
subject to con317: burst_E_is_1 * cte_25 * 1 = burst_E_is_1 * ((1-is_tc1_burst_witout_tiling_for_E) * (TC1_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC1 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC1_for_E + TC1));
subject to con318: is_tc1_burst_witout_tiling_for_E =  min(1, cte_burst_without_tiling_TC1_for_E);
subject to con319: burst_E_is_1 * cte_26 * 1 = burst_E_is_1 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con320: is_tc3_burst_witout_tiling_for_E =  min(1, cte_burst_without_tiling_TC3_for_E);
subject to con321: burst_E_is_1 * cte_27 * 1 = burst_E_is_1 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con322: burst_E_is_1 * cte_28 * 1 = burst_E_is_1 * ((1-is_tc14_burst_witout_tiling_for_E) * (TC14_1 * (1-E_is_fully_transfered_on_last_dim_FT2) + TC14 * (E_is_fully_transfered_on_last_dim_FT2)) + is_tc14_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC14_for_E + TC14));
subject to con323: is_tc14_burst_witout_tiling_for_E =  min(1, cte_burst_without_tiling_TC14_for_E);
subject to con324: burst_E_is_2 * cte_29 * 2 = burst_E_is_2 * ((1-is_tc1_burst_witout_tiling_for_E) * (TC1_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC1 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC1_for_E + TC1));
subject to con325: burst_E_is_2 * cte_30 * 2 = burst_E_is_2 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con326: burst_E_is_2 * cte_31 * 2 = burst_E_is_2 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con327: burst_E_is_2 * cte_32 * 2 = burst_E_is_2 * ((1-is_tc14_burst_witout_tiling_for_E) * (TC14_1 * (1-E_is_fully_transfered_on_last_dim_FT2) + TC14 * (E_is_fully_transfered_on_last_dim_FT2)) + is_tc14_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC14_for_E + TC14));
subject to con328: burst_E_is_4 * cte_33 * 4 = burst_E_is_4 * ((1-is_tc1_burst_witout_tiling_for_E) * (TC1_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC1 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC1_for_E + TC1));
subject to con329: burst_E_is_4 * cte_34 * 4 = burst_E_is_4 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con330: burst_E_is_4 * cte_35 * 4 = burst_E_is_4 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con331: burst_E_is_4 * cte_36 * 4 = burst_E_is_4 * ((1-is_tc14_burst_witout_tiling_for_E) * (TC14_1 * (1-E_is_fully_transfered_on_last_dim_FT2) + TC14 * (E_is_fully_transfered_on_last_dim_FT2)) + is_tc14_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC14_for_E + TC14));
subject to con332: burst_E_is_8 * cte_37 * 8 = burst_E_is_8 * ((1-is_tc1_burst_witout_tiling_for_E) * (TC1_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC1 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC1_for_E + TC1));
subject to con333: burst_E_is_8 * cte_38 * 8 = burst_E_is_8 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con334: burst_E_is_8 * cte_39 * 8 = burst_E_is_8 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con335: burst_E_is_8 * cte_40 * 8 = burst_E_is_8 * ((1-is_tc14_burst_witout_tiling_for_E) * (TC14_1 * (1-E_is_fully_transfered_on_last_dim_FT2) + TC14 * (E_is_fully_transfered_on_last_dim_FT2)) + is_tc14_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC14_for_E + TC14));
subject to con336: burst_E_is_16 * cte_41 * 16 = burst_E_is_16 * ((1-is_tc1_burst_witout_tiling_for_E) * (TC1_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC1 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC1_for_E + TC1));
subject to con337: burst_E_is_16 * cte_42 * 16 = burst_E_is_16 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con338: burst_E_is_16 * cte_43 * 16 = burst_E_is_16 * ((1-is_tc3_burst_witout_tiling_for_E) * (TC3_1 * (1-E_is_fully_transfered_on_last_dim_FT0) + TC3 * (E_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC3_for_E + TC3));
subject to con339: burst_E_is_16 * cte_44 * 16 = burst_E_is_16 * ((1-is_tc14_burst_witout_tiling_for_E) * (TC14_1 * (1-E_is_fully_transfered_on_last_dim_FT2) + TC14 * (E_is_fully_transfered_on_last_dim_FT2)) + is_tc14_burst_witout_tiling_for_E * (cte_burst_without_tiling_TC14_for_E + TC14));
subject to con340: burst_E = burst_E_is_1 * 1 + burst_E_is_2 * 2 + burst_E_is_4 * 4 + burst_E_is_8 * 8 + burst_E_is_16 * 16; # burst size of the array E
subject to con341: burst_E_is_1 + burst_E_is_2 + burst_E_is_4 + burst_E_is_8 + burst_E_is_16 = 1; # only one burst size for the array E
subject to con342: is_tc1_burst_witout_tiling_for_E <= E_is_fully_transfered_on_last_dim_FT0;
subject to con343: is_tc3_burst_witout_tiling_for_E <= E_is_fully_transfered_on_last_dim_FT0;
subject to con344: is_tc14_burst_witout_tiling_for_E <= E_is_fully_transfered_on_last_dim_FT2;
subject to con345: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm0_S1 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2) + perm1_S1 * (level_transfer_A_FT0_under1) + perm2_S1 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2) + perm3_S1 * (level_transfer_A_FT0_under1); # the array A is fully transfered on the last dimension
subject to con346: burst_A_is_1 * cte_45 * 1 = burst_A_is_1 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con347: is_tc4_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC4_for_A);
subject to con348: burst_A_is_2 * cte_46 * 2 = burst_A_is_2 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con349: burst_A_is_4 * cte_47 * 4 = burst_A_is_4 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con350: burst_A_is_8 * cte_48 * 8 = burst_A_is_8 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con351: burst_A_is_16 * cte_49 * 16 = burst_A_is_16 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con352: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con353: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con354: is_tc4_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con355: F_is_fully_transfered_on_last_dim_FT1 = level_transfer_F_FT1_under0 + perm0_S2 * (level_transfer_F_FT1_under1); # the array F is fully transfered on the last dimension
subject to con356: F_is_fully_transfered_on_last_dim_FT1 = level_transfer_F_FT1_under0 + perm0_S3 * (level_transfer_F_FT1_under1) + perm1_S3 * (level_transfer_F_FT1_under1 + level_transfer_F_FT1_under2) + perm4_S3 * (level_transfer_F_FT1_under1 + level_transfer_F_FT1_under2) + perm5_S3 * (level_transfer_F_FT1_under1); # the array F is fully transfered on the last dimension
subject to con357: F_is_fully_transfered_on_last_dim_FT2 = level_transfer_F_FT2_under0 + perm0_S5 * (level_transfer_F_FT2_under1) + perm1_S5 * (level_transfer_F_FT2_under1 + level_transfer_F_FT2_under2) + perm4_S5 * (level_transfer_F_FT2_under1 + level_transfer_F_FT2_under2) + perm5_S5 * (level_transfer_F_FT2_under1); # the array F is fully transfered on the last dimension
subject to con358: burst_F_is_1 * cte_50 * 1 = burst_F_is_1 * ((1-is_tc6_burst_witout_tiling_for_F) * (TC6_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC6 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC6_for_F + TC6));
subject to con359: is_tc6_burst_witout_tiling_for_F =  min(1, cte_burst_without_tiling_TC6_for_F);
subject to con360: burst_F_is_1 * cte_51 * 1 = burst_F_is_1 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con361: is_tc8_burst_witout_tiling_for_F =  min(1, cte_burst_without_tiling_TC8_for_F);
subject to con362: burst_F_is_1 * cte_52 * 1 = burst_F_is_1 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con363: burst_F_is_1 * cte_53 * 1 = burst_F_is_1 * ((1-is_tc13_burst_witout_tiling_for_F) * (TC13_1 * (1-F_is_fully_transfered_on_last_dim_FT2) + TC13 * (F_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC13_for_F + TC13));
subject to con364: is_tc13_burst_witout_tiling_for_F =  min(1, cte_burst_without_tiling_TC13_for_F);
subject to con365: burst_F_is_2 * cte_54 * 2 = burst_F_is_2 * ((1-is_tc6_burst_witout_tiling_for_F) * (TC6_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC6 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC6_for_F + TC6));
subject to con366: burst_F_is_2 * cte_55 * 2 = burst_F_is_2 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con367: burst_F_is_2 * cte_56 * 2 = burst_F_is_2 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con368: burst_F_is_2 * cte_57 * 2 = burst_F_is_2 * ((1-is_tc13_burst_witout_tiling_for_F) * (TC13_1 * (1-F_is_fully_transfered_on_last_dim_FT2) + TC13 * (F_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC13_for_F + TC13));
subject to con369: burst_F_is_4 * cte_58 * 4 = burst_F_is_4 * ((1-is_tc6_burst_witout_tiling_for_F) * (TC6_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC6 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC6_for_F + TC6));
subject to con370: burst_F_is_4 * cte_59 * 4 = burst_F_is_4 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con371: burst_F_is_4 * cte_60 * 4 = burst_F_is_4 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con372: burst_F_is_4 * cte_61 * 4 = burst_F_is_4 * ((1-is_tc13_burst_witout_tiling_for_F) * (TC13_1 * (1-F_is_fully_transfered_on_last_dim_FT2) + TC13 * (F_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC13_for_F + TC13));
subject to con373: burst_F_is_8 * cte_62 * 8 = burst_F_is_8 * ((1-is_tc6_burst_witout_tiling_for_F) * (TC6_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC6 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC6_for_F + TC6));
subject to con374: burst_F_is_8 * cte_63 * 8 = burst_F_is_8 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con375: burst_F_is_8 * cte_64 * 8 = burst_F_is_8 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con376: burst_F_is_8 * cte_65 * 8 = burst_F_is_8 * ((1-is_tc13_burst_witout_tiling_for_F) * (TC13_1 * (1-F_is_fully_transfered_on_last_dim_FT2) + TC13 * (F_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC13_for_F + TC13));
subject to con377: burst_F_is_16 * cte_66 * 16 = burst_F_is_16 * ((1-is_tc6_burst_witout_tiling_for_F) * (TC6_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC6 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC6_for_F + TC6));
subject to con378: burst_F_is_16 * cte_67 * 16 = burst_F_is_16 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con379: burst_F_is_16 * cte_68 * 16 = burst_F_is_16 * ((1-is_tc8_burst_witout_tiling_for_F) * (TC8_1 * (1-F_is_fully_transfered_on_last_dim_FT1) + TC8 * (F_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC8_for_F + TC8));
subject to con380: burst_F_is_16 * cte_69 * 16 = burst_F_is_16 * ((1-is_tc13_burst_witout_tiling_for_F) * (TC13_1 * (1-F_is_fully_transfered_on_last_dim_FT2) + TC13 * (F_is_fully_transfered_on_last_dim_FT2)) + is_tc13_burst_witout_tiling_for_F * (cte_burst_without_tiling_TC13_for_F + TC13));
subject to con381: burst_F = burst_F_is_1 * 1 + burst_F_is_2 * 2 + burst_F_is_4 * 4 + burst_F_is_8 * 8 + burst_F_is_16 * 16; # burst size of the array F
subject to con382: burst_F_is_1 + burst_F_is_2 + burst_F_is_4 + burst_F_is_8 + burst_F_is_16 = 1; # only one burst size for the array F
subject to con383: is_tc6_burst_witout_tiling_for_F <= F_is_fully_transfered_on_last_dim_FT1;
subject to con384: is_tc8_burst_witout_tiling_for_F <= F_is_fully_transfered_on_last_dim_FT1;
subject to con385: is_tc13_burst_witout_tiling_for_F <= F_is_fully_transfered_on_last_dim_FT2;
subject to con386: D_is_fully_transfered_on_last_dim_FT1 = level_transfer_D_FT1_under0 + perm0_S3 * (level_transfer_D_FT1_under1) + perm1_S3 * (level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2) + perm4_S3 * (level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2) + perm5_S3 * (level_transfer_D_FT1_under1); # the array D is fully transfered on the last dimension
subject to con387: burst_D_is_1 * cte_70 * 1 = burst_D_is_1 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con388: is_tc8_burst_witout_tiling_for_D =  min(1, cte_burst_without_tiling_TC8_for_D);
subject to con389: burst_D_is_2 * cte_71 * 2 = burst_D_is_2 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con390: burst_D_is_4 * cte_72 * 4 = burst_D_is_4 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con391: burst_D_is_8 * cte_73 * 8 = burst_D_is_8 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con392: burst_D_is_16 * cte_74 * 16 = burst_D_is_16 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con393: burst_D = burst_D_is_1 * 1 + burst_D_is_2 * 2 + burst_D_is_4 * 4 + burst_D_is_8 * 8 + burst_D_is_16 * 16; # burst size of the array D
subject to con394: burst_D_is_1 + burst_D_is_2 + burst_D_is_4 + burst_D_is_8 + burst_D_is_16 = 1; # only one burst size for the array D
subject to con395: is_tc8_burst_witout_tiling_for_D <= D_is_fully_transfered_on_last_dim_FT1;
subject to con396: footprint_tot_G_FT2 = TC10_ori * TC11_0 * (TC11_1 + cte_burst_without_tiling_TC11_for_G);
subject to con397: footprint_tot_G_FT2 = TC12_ori * TC13_0 * (TC13_1 + cte_burst_without_tiling_TC13_for_G);
subject to con398: footprint_tot_B_FT0 = TC4_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_B);
subject to con399: footprint_tot_C_FT1 = TC7_ori * TC9_0 * (TC9_1 + cte_burst_without_tiling_TC9_for_C);
subject to con400: footprint_tot_E_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_E);
subject to con401: footprint_tot_E_FT0 = TC2_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_E);
subject to con402: footprint_tot_E_FT2 = TC12_ori * TC14_0 * (TC14_1 + cte_burst_without_tiling_TC14_for_E);
subject to con403: footprint_tot_A_FT0 = TC2_ori * TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_A);
subject to con404: footprint_tot_F_FT1 = TC5_ori * TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_F);
subject to con405: footprint_tot_F_FT1 = TC7_ori * TC8_0 * (TC8_1 + cte_burst_without_tiling_TC8_for_F);
subject to con406: footprint_tot_F_FT2 = TC14_ori * TC13_0 * (TC13_1 + cte_burst_without_tiling_TC13_for_F);
subject to con407: footprint_tot_D_FT1 = TC9_ori * TC8_0 * (TC8_1 + cte_burst_without_tiling_TC8_for_D);
subject to con408: TC0 = TC0_ori;
subject to con409: TC2 = TC2_ori;
subject to con410: TC5 = TC5_ori;
subject to con411: TC7 = TC7_ori;
subject to con412: TC10 = TC10_ori;
subject to con413: TC12 = TC12_ori;
subject to con414: obj = max(shift_0_to_2 + Lat_comp_fused_S4_S5, Lat_comp_fused_S0_S1, shift_1_to_2 + Lat_comp_fused_S4_S5, Lat_comp_fused_S2_S3) + 1/burst_G + 1/burst_B + 1/burst_C + 1/burst_E + 1/burst_A + 1/burst_F + 1/burst_D + 1/(is_slr0_used + is_slr1_used + is_slr2_used);
subject to con415: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC2_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC2_1) * cte_tiling_0; # should divide for E in dim 0
subject to con416: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * max(TC0_1, TC12_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * min(TC0_1, TC12_1) * cte_tiling_1; # should divide for E in dim 0
subject to con417: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * max(TC2_1, TC12_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * min(TC2_1, TC12_1) * cte_tiling_2; # should divide for E in dim 0
subject to con418: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT0 * max(TC1_1, TC3_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT0 * min(TC1_1, TC3_1) * cte_tiling_3; # should divide for E in dim 1
subject to con419: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * max(TC1_1, TC14_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * min(TC1_1, TC14_1) * cte_tiling_4; # should divide for E in dim 1
subject to con420: E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * max(TC3_1, TC14_1) = E_is_fully_transfered_on_last_dim_FT0 * E_is_fully_transfered_on_last_dim_FT2 * min(TC3_1, TC14_1) * cte_tiling_5; # should divide for E in dim 1
subject to con421: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT1 * max(TC5_1, TC7_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT1 * min(TC5_1, TC7_1) * cte_tiling_6; # should divide for F in dim 0
subject to con422: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * max(TC5_1, TC14_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * min(TC5_1, TC14_1) * cte_tiling_7; # should divide for F in dim 0
subject to con423: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * max(TC7_1, TC14_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * min(TC7_1, TC14_1) * cte_tiling_8; # should divide for F in dim 0
subject to con424: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT1 * max(TC6_1, TC8_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT1 * min(TC6_1, TC8_1) * cte_tiling_9; # should divide for F in dim 1
subject to con425: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * max(TC6_1, TC13_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * min(TC6_1, TC13_1) * cte_tiling_10; # should divide for F in dim 1
subject to con426: F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * max(TC8_1, TC13_1) = F_is_fully_transfered_on_last_dim_FT1 * F_is_fully_transfered_on_last_dim_FT2 * min(TC8_1, TC13_1) * cte_tiling_11; # should divide for F in dim 1
subject to con427: G_is_fully_transfered_on_last_dim_FT2 * G_is_fully_transfered_on_last_dim_FT2 * max(TC10_1, TC12_1) = G_is_fully_transfered_on_last_dim_FT2 * G_is_fully_transfered_on_last_dim_FT2 * min(TC10_1, TC12_1) * cte_tiling_12; # should divide for G in dim 0
subject to con428: G_is_fully_transfered_on_last_dim_FT2 * G_is_fully_transfered_on_last_dim_FT2 * max(TC11_1, TC13_1) = G_is_fully_transfered_on_last_dim_FT2 * G_is_fully_transfered_on_last_dim_FT2 * min(TC11_1, TC13_1) * cte_tiling_13; # should divide for G in dim 1
subject to con429: buffer_size = footprint_E_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse + footprint_F_S2_S3_reuse + footprint_C_S3_reuse + footprint_D_S3_reuse + footprint_E_S5_reuse + footprint_F_S5_reuse + footprint_G_S4_S5_reuse; # total buffer size
subject to con430: fifo_size = 0; # total fifo size
subject to con431: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con432: perm0_S0 * perm3_S5 * level_transfer_E_FT2_under0 = perm0_S0 * perm3_S5 * 1;
subject to con433: perm0_S0 * perm4_S5 * level_transfer_E_FT2_under0 = perm0_S0 * perm4_S5 * 1;
subject to con434: perm0_S0 * perm5_S5 * level_transfer_E_FT2_under0 = perm0_S0 * perm5_S5 * 1;
subject to con435: perm1_S0 * perm0_S5 * level_transfer_E_FT2_under0 = perm1_S0 * perm0_S5 * 1;
subject to con436: perm1_S0 * perm1_S5 * level_transfer_E_FT2_under0 = perm1_S0 * perm1_S5 * 1;
subject to con437: perm1_S0 * perm2_S5 * level_transfer_E_FT2_under0 = perm1_S0 * perm2_S5 * 1;
subject to con438: perm0_S1 * perm3_S5 * level_transfer_E_FT2_under0 = perm0_S1 * perm3_S5 * 1;
subject to con439: perm0_S1 * perm4_S5 * level_transfer_E_FT2_under0 = perm0_S1 * perm4_S5 * 1;
subject to con440: perm0_S1 * perm5_S5 * level_transfer_E_FT2_under0 = perm0_S1 * perm5_S5 * 1;
subject to con441: perm1_S1 * perm3_S5 * level_transfer_E_FT2_under0 = perm1_S1 * perm3_S5 * 1;
subject to con442: perm1_S1 * perm4_S5 * level_transfer_E_FT2_under0 = perm1_S1 * perm4_S5 * 1;
subject to con443: perm1_S1 * perm5_S5 * level_transfer_E_FT2_under0 = perm1_S1 * perm5_S5 * 1;
subject to con444: perm2_S1 * perm0_S5 * level_transfer_E_FT2_under0 = perm2_S1 * perm0_S5 * 1;
subject to con445: perm2_S1 * perm1_S5 * level_transfer_E_FT2_under0 = perm2_S1 * perm1_S5 * 1;
subject to con446: perm2_S1 * perm2_S5 * level_transfer_E_FT2_under0 = perm2_S1 * perm2_S5 * 1;
subject to con447: perm3_S1 * perm0_S5 * level_transfer_E_FT2_under0 = perm3_S1 * perm0_S5 * 1;
subject to con448: perm3_S1 * perm1_S5 * level_transfer_E_FT2_under0 = perm3_S1 * perm1_S5 * 1;
subject to con449: perm3_S1 * perm2_S5 * level_transfer_E_FT2_under0 = perm3_S1 * perm2_S5 * 1;
subject to con450: perm4_S1 * perm3_S5 * level_transfer_E_FT2_under0 = perm4_S1 * perm3_S5 * 1;
subject to con451: perm4_S1 * perm4_S5 * level_transfer_E_FT2_under0 = perm4_S1 * perm4_S5 * 1;
subject to con452: perm4_S1 * perm5_S5 * level_transfer_E_FT2_under0 = perm4_S1 * perm5_S5 * 1;
subject to con453: perm5_S1 * perm0_S5 * level_transfer_E_FT2_under0 = perm5_S1 * perm0_S5 * 1;
subject to con454: perm5_S1 * perm1_S5 * level_transfer_E_FT2_under0 = perm5_S1 * perm1_S5 * 1;
subject to con455: perm5_S1 * perm2_S5 * level_transfer_E_FT2_under0 = perm5_S1 * perm2_S5 * 1;
subject to con456: perm0_S2 * perm0_S5 * level_transfer_F_FT2_under0 = perm0_S2 * perm0_S5 * 1;
subject to con457: perm0_S2 * perm2_S5 * level_transfer_F_FT2_under0 = perm0_S2 * perm2_S5 * 1;
subject to con458: perm0_S2 * perm3_S5 * level_transfer_F_FT2_under0 = perm0_S2 * perm3_S5 * 1;
subject to con459: perm1_S2 * perm1_S5 * level_transfer_F_FT2_under0 = perm1_S2 * perm1_S5 * 1;
subject to con460: perm1_S2 * perm4_S5 * level_transfer_F_FT2_under0 = perm1_S2 * perm4_S5 * 1;
subject to con461: perm1_S2 * perm5_S5 * level_transfer_F_FT2_under0 = perm1_S2 * perm5_S5 * 1;
subject to con462: perm0_S3 * perm0_S5 * level_transfer_F_FT2_under0 = perm0_S3 * perm0_S5 * 1;
subject to con463: perm0_S3 * perm2_S5 * level_transfer_F_FT2_under0 = perm0_S3 * perm2_S5 * 1;
subject to con464: perm0_S3 * perm3_S5 * level_transfer_F_FT2_under0 = perm0_S3 * perm3_S5 * 1;
subject to con465: perm1_S3 * perm0_S5 * level_transfer_F_FT2_under0 = perm1_S3 * perm0_S5 * 1;
subject to con466: perm1_S3 * perm2_S5 * level_transfer_F_FT2_under0 = perm1_S3 * perm2_S5 * 1;
subject to con467: perm1_S3 * perm3_S5 * level_transfer_F_FT2_under0 = perm1_S3 * perm3_S5 * 1;
subject to con468: perm2_S3 * perm1_S5 * level_transfer_F_FT2_under0 = perm2_S3 * perm1_S5 * 1;
subject to con469: perm2_S3 * perm4_S5 * level_transfer_F_FT2_under0 = perm2_S3 * perm4_S5 * 1;
subject to con470: perm2_S3 * perm5_S5 * level_transfer_F_FT2_under0 = perm2_S3 * perm5_S5 * 1;
subject to con471: perm3_S3 * perm1_S5 * level_transfer_F_FT2_under0 = perm3_S3 * perm1_S5 * 1;
subject to con472: perm3_S3 * perm4_S5 * level_transfer_F_FT2_under0 = perm3_S3 * perm4_S5 * 1;
subject to con473: perm3_S3 * perm5_S5 * level_transfer_F_FT2_under0 = perm3_S3 * perm5_S5 * 1;
subject to con474: perm4_S3 * perm0_S5 * level_transfer_F_FT2_under0 = perm4_S3 * perm0_S5 * 1;
subject to con475: perm4_S3 * perm2_S5 * level_transfer_F_FT2_under0 = perm4_S3 * perm2_S5 * 1;
subject to con476: perm4_S3 * perm3_S5 * level_transfer_F_FT2_under0 = perm4_S3 * perm3_S5 * 1;
subject to con477: perm5_S3 * perm1_S5 * level_transfer_F_FT2_under0 = perm5_S3 * perm1_S5 * 1;
subject to con478: perm5_S3 * perm4_S5 * level_transfer_F_FT2_under0 = perm5_S3 * perm4_S5 * 1;
subject to con479: perm5_S3 * perm5_S5 * level_transfer_F_FT2_under0 = perm5_S3 * perm5_S5 * 1;
subject to con480: perm4_S5 * level_reuse_G_FT2_under0 = perm4_S5 * 1;
subject to con481: perm5_S5 * level_reuse_G_FT2_under0 = perm5_S5 * 1;
subject to con482: perm0_S1 * level_reuse_B_FT0_under0 = perm0_S1 * 1;
subject to con483: perm1_S1 * level_reuse_B_FT0_under0 = perm1_S1 * 1;
subject to con484: perm2_S3 * level_reuse_C_FT1_under0 = perm2_S3 * 1;
subject to con485: perm3_S3 * level_reuse_C_FT1_under0 = perm3_S3 * 1;
subject to con486: perm4_S1 * level_reuse_E_FT0_under0 = perm4_S1 * 1;
subject to con487: perm5_S1 * level_reuse_E_FT0_under0 = perm5_S1 * 1;
subject to con488: perm2_S5 * level_reuse_E_FT2_under0 = perm2_S5 * 1;
subject to con489: perm3_S5 * level_reuse_E_FT2_under0 = perm3_S5 * 1;
subject to con490: perm2_S1 * level_reuse_A_FT0_under0 = perm2_S1 * 1;
subject to con491: perm3_S1 * level_reuse_A_FT0_under0 = perm3_S1 * 1;
subject to con492: perm4_S3 * level_reuse_F_FT1_under0 = perm4_S3 * 1;
subject to con493: perm5_S3 * level_reuse_F_FT1_under0 = perm5_S3 * 1;
subject to con494: perm0_S5 * level_reuse_F_FT2_under0 = perm0_S5 * 1;
subject to con495: perm1_S5 * level_reuse_F_FT2_under0 = perm1_S5 * 1;
subject to con496: perm0_S3 * level_reuse_D_FT1_under0 = perm0_S3 * 1;
subject to con497: perm1_S3 * level_reuse_D_FT1_under0 = perm1_S3 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display TC4;
display TC5;
display TC6;
display TC7;
display TC8;
display TC9;
display TC10;
display TC11;
display TC12;
display TC13;
display TC14;
display is_fused_task0_in_SLR_0;
display is_fused_task0_in_SLR_1;
display is_fused_task0_in_SLR_2;
display is_fused_task1_in_SLR_0;
display is_fused_task1_in_SLR_1;
display is_fused_task1_in_SLR_2;
display is_fused_task2_in_SLR_0;
display is_fused_task2_in_SLR_1;
display is_fused_task2_in_SLR_2;
display is_slr0_used;
display is_slr1_used;
display is_slr2_used;
display perm0_S0;
display perm1_S0;
display perm0_S1;
display perm1_S1;
display perm2_S1;
display perm3_S1;
display perm4_S1;
display perm5_S1;
display perm0_S2;
display perm1_S2;
display perm0_S3;
display perm1_S3;
display perm2_S3;
display perm3_S3;
display perm4_S3;
display perm5_S3;
display perm0_S4;
display perm1_S4;
display perm0_S5;
display Lat_comp_S5_for_off_chip;
display perm1_S5;
display perm2_S5;
display perm3_S5;
display perm4_S5;
display perm5_S5;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display Lat_comp_S2_intra_tile;
display Lat_comp_S3_intra_tile;
display Lat_comp_S4_intra_tile;
display Lat_comp_S5_intra_tile;
display footprint_E_S0_S1;
display footprint_E_S0_S1_reuse;
display footprint_A_S1;
display footprint_A_S1_reuse;
display footprint_B_S1;
display footprint_B_S1_reuse;
display footprint_F_S2_S3;
display footprint_F_S2_S3_reuse;
display footprint_C_S3;
display footprint_C_S3_reuse;
display footprint_D_S3;
display footprint_D_S3_reuse;
display footprint_E_S5;
display footprint_E_S5_reuse;
display footprint_F_S5;
display footprint_F_S5_reuse;
display footprint_G_S4_S5;
display footprint_G_S4_S5_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_E_FT0_under0;
display level_reuse_E_FT0_under0;
display level_transfer_E_FT0_under1;
display level_reuse_E_FT0_under1;
display level_transfer_E_FT0_under2;
display level_reuse_E_FT0_under2;
display level_transfer_A_FT0_under0;
display level_reuse_A_FT0_under0;
display level_transfer_A_FT0_under1;
display level_reuse_A_FT0_under1;
display level_transfer_A_FT0_under2;
display level_reuse_A_FT0_under2;
display level_transfer_B_FT0_under0;
display level_reuse_B_FT0_under0;
display level_transfer_B_FT0_under1;
display level_reuse_B_FT0_under1;
display level_transfer_B_FT0_under2;
display level_reuse_B_FT0_under2;
display Lat_comp_fused_S0_S1_3;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
display Lat_comp_fused_S2_S3;
display level_transfer_F_FT1_under0;
display level_reuse_F_FT1_under0;
display level_transfer_F_FT1_under1;
display level_reuse_F_FT1_under1;
display level_transfer_F_FT1_under2;
display level_reuse_F_FT1_under2;
display level_transfer_C_FT1_under0;
display level_reuse_C_FT1_under0;
display level_transfer_C_FT1_under1;
display level_reuse_C_FT1_under1;
display level_transfer_C_FT1_under2;
display level_reuse_C_FT1_under2;
display level_transfer_D_FT1_under0;
display level_reuse_D_FT1_under0;
display level_transfer_D_FT1_under1;
display level_reuse_D_FT1_under1;
display level_transfer_D_FT1_under2;
display level_reuse_D_FT1_under2;
display Lat_comp_fused_S2_S3_3;
display Lat_comp_fused_S2_S3_2;
display Lat_comp_fused_S2_S3_1;
display Lat_comp_fused_S4_S5;
display level_transfer_G_FT2_under0;
display level_reuse_G_FT2_under0;
display level_transfer_G_FT2_under1;
display level_reuse_G_FT2_under1;
display level_transfer_G_FT2_under2;
display level_reuse_G_FT2_under2;
display level_transfer_E_FT2_under0;
display level_reuse_E_FT2_under0;
display level_transfer_E_FT2_under1;
display level_reuse_E_FT2_under1;
display level_transfer_E_FT2_under2;
display level_reuse_E_FT2_under2;
display level_transfer_F_FT2_under0;
display level_reuse_F_FT2_under0;
display level_transfer_F_FT2_under1;
display level_reuse_F_FT2_under1;
display level_transfer_F_FT2_under2;
display level_reuse_F_FT2_under2;
display Lat_comp_fused_S4_S5_3;
display Lat_comp_fused_S4_S5_2;
display Lat_comp_fused_S4_S5_1;
display shift_0_to_2;
display shift_1_to_2;
display nb_dsp_used_SLR0;
display nb_dsp_used_SLR1;
display nb_dsp_used_SLR2;
display TC0_0;
display TC0_1;
display TC1_0;
display TC1_1;
display TC2_0;
display TC2_1;
display TC3_0;
display TC3_1;
display TC4_0;
display TC4_1;
display TC5_0;
display TC5_1;
display TC6_0;
display TC6_1;
display TC7_0;
display TC7_1;
display TC8_0;
display TC8_1;
display TC9_0;
display TC9_1;
display TC10_0;
display TC10_1;
display TC11_0;
display TC11_1;
display TC12_0;
display TC12_1;
display TC13_0;
display TC13_1;
display TC14_0;
display TC14_1;
display G_is_fully_transfered_on_last_dim_FT2;
display burst_G_is_1;
display cte_0;
display cte_burst_without_tiling_TC11_for_G;
display is_tc11_burst_witout_tiling_for_G;
display cte_1;
display cte_burst_without_tiling_TC13_for_G;
display is_tc13_burst_witout_tiling_for_G;
display cte_2;
display burst_G_is_2;
display cte_3;
display cte_4;
display cte_5;
display burst_G_is_4;
display cte_6;
display cte_7;
display cte_8;
display burst_G_is_8;
display cte_9;
display cte_10;
display cte_11;
display burst_G_is_16;
display cte_12;
display cte_13;
display cte_14;
display B_is_fully_transfered_on_last_dim_FT0;
display burst_B_is_1;
display cte_15;
display cte_burst_without_tiling_TC3_for_B;
display is_tc3_burst_witout_tiling_for_B;
display burst_B_is_2;
display cte_16;
display burst_B_is_4;
display cte_17;
display burst_B_is_8;
display cte_18;
display burst_B_is_16;
display cte_19;
display C_is_fully_transfered_on_last_dim_FT1;
display burst_C_is_1;
display cte_20;
display cte_burst_without_tiling_TC9_for_C;
display is_tc9_burst_witout_tiling_for_C;
display burst_C_is_2;
display cte_21;
display burst_C_is_4;
display cte_22;
display burst_C_is_8;
display cte_23;
display burst_C_is_16;
display cte_24;
display E_is_fully_transfered_on_last_dim_FT0;
display E_is_fully_transfered_on_last_dim_FT2;
display burst_E_is_1;
display cte_25;
display cte_burst_without_tiling_TC1_for_E;
display is_tc1_burst_witout_tiling_for_E;
display cte_26;
display cte_burst_without_tiling_TC3_for_E;
display is_tc3_burst_witout_tiling_for_E;
display cte_27;
display cte_28;
display cte_burst_without_tiling_TC14_for_E;
display is_tc14_burst_witout_tiling_for_E;
display burst_E_is_2;
display cte_29;
display cte_30;
display cte_31;
display cte_32;
display burst_E_is_4;
display cte_33;
display cte_34;
display cte_35;
display cte_36;
display burst_E_is_8;
display cte_37;
display cte_38;
display cte_39;
display cte_40;
display burst_E_is_16;
display cte_41;
display cte_42;
display cte_43;
display cte_44;
display A_is_fully_transfered_on_last_dim_FT0;
display burst_A_is_1;
display cte_45;
display cte_burst_without_tiling_TC4_for_A;
display is_tc4_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_46;
display burst_A_is_4;
display cte_47;
display burst_A_is_8;
display cte_48;
display burst_A_is_16;
display cte_49;
display F_is_fully_transfered_on_last_dim_FT1;
display F_is_fully_transfered_on_last_dim_FT2;
display burst_F_is_1;
display cte_50;
display cte_burst_without_tiling_TC6_for_F;
display is_tc6_burst_witout_tiling_for_F;
display cte_51;
display cte_burst_without_tiling_TC8_for_F;
display is_tc8_burst_witout_tiling_for_F;
display cte_52;
display cte_53;
display cte_burst_without_tiling_TC13_for_F;
display is_tc13_burst_witout_tiling_for_F;
display burst_F_is_2;
display cte_54;
display cte_55;
display cte_56;
display cte_57;
display burst_F_is_4;
display cte_58;
display cte_59;
display cte_60;
display cte_61;
display burst_F_is_8;
display cte_62;
display cte_63;
display cte_64;
display cte_65;
display burst_F_is_16;
display cte_66;
display cte_67;
display cte_68;
display cte_69;
display D_is_fully_transfered_on_last_dim_FT1;
display burst_D_is_1;
display cte_70;
display cte_burst_without_tiling_TC8_for_D;
display is_tc8_burst_witout_tiling_for_D;
display burst_D_is_2;
display cte_71;
display burst_D_is_4;
display cte_72;
display burst_D_is_8;
display cte_73;
display burst_D_is_16;
display cte_74;
display footprint_tot_G_FT2;
display burst_G;
display footprint_tot_B_FT0;
display burst_B;
display footprint_tot_C_FT1;
display burst_C;
display footprint_tot_E_FT0;
display burst_E;
display footprint_tot_E_FT2;
display footprint_tot_A_FT0;
display burst_A;
display footprint_tot_F_FT1;
display burst_F;
display footprint_tot_F_FT2;
display footprint_tot_D_FT1;
display burst_D;
display Lat_comp_0_1;
display Lat_comp_2_3;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display cte_tiling_2;
display cte_tiling_3;
display cte_tiling_4;
display cte_tiling_5;
display cte_tiling_6;
display cte_tiling_7;
display cte_tiling_8;
display cte_tiling_9;
display cte_tiling_10;
display cte_tiling_11;
display cte_tiling_12;
display cte_tiling_13;
display buffer_size;
display fifo_size;
display _total_solve_time;
