#option solver baron;
#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';
option solver gurobi;
option gurobi_options 'lim:time=1800 tech:logfile=gurobi.log qp:nonconvex=2';
#option solver octeract;
#option octeract_options 'max_solver_time=60';

param DSP_avail = 5414;
param ON_CHIP_MEM_SIZE = 1512000;
param MAX_BUFFER_SIZE = 2048;
param CONSTRAINT_ARRAY_PARTITIONING_VALUE = 1024;
param MAX_UF = 2048;
param SLR0_mem = 504000;
param SLR0_DSP = 1804;
param SLR1_mem = 504000;
param SLR1_DSP = 1804;
param SLR2_mem = 504000;
param SLR2_DSP = 1804;
param II_S0_par = 1;
param II_S0_seq = 3;
param II_S1_par = 1;
param II_S1_seq = 3;
param II_S2_par = 1;
param II_S2_seq = 3;
param II_S3_par = 1;
param II_S3_seq = 3;
param TC0_ori = 180;
param TC1_ori = 190;
param TC2_ori = 180;
param TC3_ori = 190;
param TC4_ori = 210;
param TC5_ori = 180;
param TC6_ori = 220;
param TC7_ori = 180;
param TC8_ori = 220;
param TC9_ori = 190;
param IL_par_S0 = 1;
param IL_seq_S0 = 0;
param IL_par_S1 = 8;
param IL_seq_S1 = 7;
param IL_par_S2 = 4;
param IL_seq_S2 = 0;
param IL_par_S3 = 4;
param IL_seq_S3 = 7;
param DSP_S0 = 0;
param DSP_S1 = 8;
param DSP_S2 = 3;
param DSP_S3 = 5;

var TC0 integer >= 180 <= 192;
var TC1 integer >= 190 <= 192;
var TC2 integer >= 180 <= 192;
var TC3 integer >= 190 <= 192;
var TC4 integer >= 210 <= 224;
var TC5 integer >= 180 <= 192;
var TC6 integer >= 220 <= 224;
var TC7 integer >= 180 <= 192;
var TC8 integer >= 220 <= 224;
var TC9 integer >= 190 <= 192;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task0_in_SLR_1 binary;
var is_fused_task0_in_SLR_2 binary;
var is_fused_task1_in_SLR_0 binary;
var is_fused_task1_in_SLR_1 binary;
var is_fused_task1_in_SLR_2 binary;
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
var Lat_comp_S3_for_off_chip >= 0;
var perm1_S3 binary; # [3, 7, 0, 9, 0, 8, 0, 7, 0, 9, 0, 8, 0]
var perm2_S3 binary; # [3, 8, 0, 7, 0, 9, 0, 8, 0, 7, 0, 9, 0]
var perm3_S3 binary; # [3, 8, 0, 9, 0, 7, 0, 8, 0, 9, 0, 7, 0]
var perm4_S3 binary; # [3, 9, 0, 7, 0, 8, 0, 9, 0, 7, 0, 8, 0]
var perm5_S3 binary; # [3, 9, 0, 8, 0, 7, 0, 9, 0, 8, 0, 7, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var Lat_comp_S2_intra_tile >= 0;
var Lat_comp_S3_intra_tile >= 0;
var footprint_tmp_S0_S1 integer >= 0;
var footprint_tmp_S0_S1_reuse integer >= 0;
var footprint_A_S1 integer >= 0;
var footprint_A_S1_reuse integer >= 0;
var footprint_B_S1 integer >= 0;
var footprint_B_S1_reuse integer >= 0;
var footprint_tmp_S3 integer >= 0;
var footprint_tmp_S3_reuse integer >= 0;
var footprint_D_S2_S3 integer >= 0;
var footprint_D_S2_S3_reuse integer >= 0;
var footprint_C_S3 integer >= 0;
var footprint_C_S3_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_tmp_FT0_under0 binary;
var level_reuse_tmp_FT0_under0 binary;
var level_transfer_tmp_FT0_under1 binary;
var level_reuse_tmp_FT0_under1 binary;
var level_transfer_tmp_FT0_under2 binary;
var level_reuse_tmp_FT0_under2 binary;
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
var level_transfer_D_FT1_under0 binary;
var level_reuse_D_FT1_under0 binary;
var level_transfer_D_FT1_under1 binary;
var level_reuse_D_FT1_under1 binary;
var level_transfer_D_FT1_under2 binary;
var level_reuse_D_FT1_under2 binary;
var level_transfer_tmp_FT1_under0 binary;
var level_reuse_tmp_FT1_under0 binary;
var level_transfer_tmp_FT1_under1 binary;
var level_reuse_tmp_FT1_under1 binary;
var level_transfer_tmp_FT1_under2 binary;
var level_reuse_tmp_FT1_under2 binary;
var level_transfer_C_FT1_under0 binary;
var level_reuse_C_FT1_under0 binary;
var level_transfer_C_FT1_under1 binary;
var level_reuse_C_FT1_under1 binary;
var level_transfer_C_FT1_under2 binary;
var level_reuse_C_FT1_under2 binary;
var Lat_comp_fused_S2_S3_3 >= 0;
var Lat_comp_fused_S2_S3_2 >= 0;
var Lat_comp_fused_S2_S3_1 >= 0;
var shift_0_to_1 >= 0;
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
var C_is_fully_transfered_on_last_dim_FT1 binary;
var burst_C_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC8_for_C integer >= 0 <= 4;
var is_tc8_burst_witout_tiling_for_C binary;
var burst_C_is_2 binary;
var cte_1 integer >=0;
var burst_C_is_4 binary;
var cte_2 integer >=0;
var burst_C_is_8 binary;
var cte_3 integer >=0;
var burst_C_is_16 binary;
var cte_4 integer >=0;
var A_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A_is_1 binary;
var cte_5 integer >=0;
var cte_burst_without_tiling_TC4_for_A integer >= 0 <= 14;
var is_tc4_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_6 integer >=0;
var burst_A_is_4 binary;
var cte_7 integer >=0;
var burst_A_is_8 binary;
var cte_8 integer >=0;
var burst_A_is_16 binary;
var cte_9 integer >=0;
var tmp_is_fully_transfered_on_last_dim_FT0 binary;
var tmp_is_fully_transfered_on_last_dim_FT1 binary;
var burst_tmp_is_1 binary;
var cte_10 integer >=0;
var cte_burst_without_tiling_TC1_for_tmp integer >= 0 <= 2;
var is_tc1_burst_witout_tiling_for_tmp binary;
var cte_11 integer >=0;
var cte_burst_without_tiling_TC3_for_tmp integer >= 0 <= 2;
var is_tc3_burst_witout_tiling_for_tmp binary;
var cte_12 integer >=0;
var cte_13 integer >=0;
var cte_burst_without_tiling_TC9_for_tmp integer >= 0 <= 2;
var is_tc9_burst_witout_tiling_for_tmp binary;
var burst_tmp_is_2 binary;
var cte_14 integer >=0;
var cte_15 integer >=0;
var cte_16 integer >=0;
var cte_17 integer >=0;
var burst_tmp_is_4 binary;
var cte_18 integer >=0;
var cte_19 integer >=0;
var cte_20 integer >=0;
var cte_21 integer >=0;
var burst_tmp_is_8 binary;
var cte_22 integer >=0;
var cte_23 integer >=0;
var cte_24 integer >=0;
var cte_25 integer >=0;
var burst_tmp_is_16 binary;
var cte_26 integer >=0;
var cte_27 integer >=0;
var cte_28 integer >=0;
var cte_29 integer >=0;
var D_is_fully_transfered_on_last_dim_FT1 binary;
var burst_D_is_1 binary;
var cte_30 integer >=0;
var cte_burst_without_tiling_TC6_for_D integer >= 0 <= 4;
var is_tc6_burst_witout_tiling_for_D binary;
var cte_31 integer >=0;
var cte_32 integer >=0;
var cte_burst_without_tiling_TC8_for_D integer >= 0 <= 4;
var is_tc8_burst_witout_tiling_for_D binary;
var cte_33 integer >=0;
var burst_D_is_2 binary;
var cte_34 integer >=0;
var cte_35 integer >=0;
var cte_36 integer >=0;
var cte_37 integer >=0;
var burst_D_is_4 binary;
var cte_38 integer >=0;
var cte_39 integer >=0;
var cte_40 integer >=0;
var cte_41 integer >=0;
var burst_D_is_8 binary;
var cte_42 integer >=0;
var cte_43 integer >=0;
var cte_44 integer >=0;
var cte_45 integer >=0;
var burst_D_is_16 binary;
var cte_46 integer >=0;
var cte_47 integer >=0;
var cte_48 integer >=0;
var cte_49 integer >=0;
var B_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B_is_1 binary;
var cte_50 integer >=0;
var cte_burst_without_tiling_TC3_for_B integer >= 0 <= 2;
var is_tc3_burst_witout_tiling_for_B binary;
var burst_B_is_2 binary;
var cte_51 integer >=0;
var burst_B_is_4 binary;
var cte_52 integer >=0;
var burst_B_is_8 binary;
var cte_53 integer >=0;
var burst_B_is_16 binary;
var cte_54 integer >=0;
var footprint_tot_C_FT1 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var footprint_tot_tmp_FT0 integer >= 1;
var burst_tmp integer >= 0;
var footprint_tot_tmp_FT1 integer >= 1;
var footprint_tot_D_FT1 integer >= 1;
var burst_D integer >= 0;
var footprint_tot_B_FT0 integer >= 1;
var burst_B integer >= 0;
var Lat_comp_0_1 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var cte_tiling_2 integer >= 0;
var cte_tiling_3 integer >= 0;
var cte_tiling_4 integer >= 0;
var cte_tiling_5 integer >= 0;
var cte_tiling_6 integer >= 0;
var cte_tiling_7 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Fuse [2, 3]
#comment: Task 1 writes tmp to off-chip
#comment: Task 3 writes D to off-chip
#comment: Statement 0: tmp[i][j] = 0.0;
#comment: Statement 1: tmp[i][j] += alpha * A[i][k] * B[k][j];
#comment: Statement 2: D[i][j] *= beta;
#comment: Statement 3: D[i][j] += tmp[i][k] * C[k][j];
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
#comment: Argument 0: float alpha
#comment: Argument 1: float beta
#comment: Argument 2: float tmp[180][190]
#comment: Argument 3: float A[180][210]
#comment: Argument 4: float B[210][190]
#comment: Argument 5: float C[190][220]
#comment: Argument 6: float D[180][220]
#comment: Task 1 gives tmp to Task 3
#comment: Task 3 received tmp from Task 1
#comment:  4 is a reduction loop
#comment:  9 is a reduction loop
#comment: Task 3 reads C from off-chip
#comment: Task 1 reads A from off-chip
#comment: Task 2 reads D from off-chip
#comment: Task 1 reads B from off-chip
#comment: Array C has for tc in dim 0 TC9 (ori=TC9_ori) arg0
#comment: Array C has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array A has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array D has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array D has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array D has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array D has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array D has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array D has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array D has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array D has for tc in dim 1 TC8 (ori=TC8_ori) arg0
#comment: Array B has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array B has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Sched 0 has reuse buffer tmp[TC0_1][TC1_1]
#comment: Sched 1 has reuse buffer tmp[TC2_1][TC3_1]
#comment: Sched 1 has reuse buffer A[TC2_1][TC4_1]
#comment: Sched 1 has reuse buffer B[TC4_1][TC3_1]
#comment: Sched 2 has reuse buffer D[TC5_1][TC6_1]
#comment: Sched 3 has reuse buffer D[TC7_1][TC8_1]
#comment: Sched 3 has reuse buffer tmp[TC7_1][TC9_1]
#comment: Sched 3 has reuse buffer C[TC9_1][TC8_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_slr1_used = min(1,is_fused_task0_in_SLR_1 + is_fused_task1_in_SLR_1);
subject to con2: is_slr2_used = min(1,is_fused_task0_in_SLR_2 + is_fused_task1_in_SLR_2);
subject to con3: is_fused_task0_in_SLR_0 + is_fused_task0_in_SLR_1 + is_fused_task0_in_SLR_2 = 1; # only one SLR for fused task 0
subject to con4: is_fused_task1_in_SLR_0 + is_fused_task1_in_SLR_1 + is_fused_task1_in_SLR_2 = 1; # only one SLR for fused task 1
subject to con5: perm0_S0 + perm1_S0 = 1; # only one permutation
subject to con6: TC2_1 = TC7_1; # same tiling factor
subject to con7: TC2_1 = TC7_1; # same tiling factor
subject to con8: TC2_1 = TC7_1; # same tiling factor
subject to con9: TC2_1 = TC7_1; # same tiling factor
subject to con10: TC2_1 = TC7_1; # same tiling factor
subject to con11: TC2_1 = TC7_1; # same tiling factor
subject to con12: perm0_S1 + perm1_S1 + perm2_S1 + perm3_S1 + perm4_S1 + perm5_S1 = 1; # only one permutation
subject to con13: perm0_S2 + perm1_S2 = 1; # only one permutation
subject to con14: perm0_S3 + perm1_S3 + perm2_S3 + perm3_S3 + perm4_S3 + perm5_S3 = 1; # only one permutation
subject to con15: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con16: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC4_1)/log(2); # latency of the intra-tile S1
subject to con17: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con18: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC9_1)/log(2); # latency of the intra-tile S3
subject to con19: perm1_S1 = 0; # because of the fused task 0
subject to con20: perm3_S1 = 0; # because of the fused task 0
subject to con21: perm4_S1 = 0; # because of the fused task 0
subject to con22: perm5_S1 = 0; # because of the fused task 0
subject to con23: perm1_S3 = 0; # because of the fused task 1
subject to con24: perm3_S3 = 0; # because of the fused task 1
subject to con25: perm4_S3 = 0; # because of the fused task 1
subject to con26: perm5_S3 = 0; # because of the fused task 1
subject to con27: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con28: perm1_S0 = perm2_S1; # same iteration of output in FT 0
subject to con29: perm0_S2 = perm0_S3; # same iteration of output in FT 1
subject to con30: perm1_S2 = perm2_S3; # same iteration of output in FT 1
subject to con31: is_fused_task0_in_SLR_0 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_tmp_S3_reuse + footprint_D_S2_S3_reuse + footprint_C_S3_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con32: is_fused_task0_in_SLR_1 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_1 * (footprint_tmp_S3_reuse + footprint_D_S2_S3_reuse + footprint_C_S3_reuse) <= SLR1_mem; # memory constraint per SLR
subject to con33: is_fused_task0_in_SLR_2 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse) + is_fused_task1_in_SLR_2 * (footprint_tmp_S3_reuse + footprint_D_S2_S3_reuse + footprint_C_S3_reuse) <= SLR2_mem; # memory constraint per SLR
subject to con34: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con35: level_reuse_tmp_FT0_under2 = 1; # transfer innermost for output
subject to con36: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con37: level_reuse_tmp_FT0_under2 = level_transfer_tmp_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con38: level_transfer_tmp_FT0_under0 + level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2 = 1; # only one level of transfer for tmp
subject to con39: level_reuse_tmp_FT0_under0 + level_reuse_tmp_FT0_under1 + level_reuse_tmp_FT0_under2 = 1; # only one level of reuse for tmp
subject to con40: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con41: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con42: level_reuse_tmp_FT0_under2 = level_transfer_tmp_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con43: level_reuse_A_FT0_under0 >= level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con44: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 >= level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con45: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 >= level_transfer_A_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con46: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2 = 1; # only one level of transfer for A
subject to con47: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 = 1; # only one level of reuse for A
subject to con48: level_reuse_B_FT0_under0 >= level_transfer_B_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con49: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 >= level_transfer_B_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con50: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 + level_reuse_B_FT0_under2 >= level_transfer_B_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con51: level_transfer_B_FT0_under0 + level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2 = 1; # only one level of transfer for B
subject to con52: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 + level_reuse_B_FT0_under2 = 1; # only one level of reuse for B
subject to con53: Lat_comp_fused_S0_S1_3 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC4_0)); # latency of the fused task S0_S1 level 3
subject to con54: Lat_comp_fused_S0_S1_2 = (perm0_S0 * TC1_0 + perm1_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_3, level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under2 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under2 * footprint_B_S1 / burst_B) + Lat_comp_fused_S0_S1_3 + max(level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under2 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under2 * footprint_B_S1 / burst_B  + level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 2
subject to con55: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC1_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under1 * footprint_B_S1 / burst_B) + Lat_comp_fused_S0_S1_2 + max(level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_B_FT0_under1 * footprint_B_S1 / burst_B  + level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 1
subject to con56: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 / burst_tmp + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A + level_transfer_B_FT0_under0 * footprint_tot_B_FT0 / burst_B; # latency of the fused task S0_S1
subject to con57: level_reuse_D_FT1_under0 = level_transfer_D_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con58: level_reuse_D_FT1_under2 = 1; # transfer innermost for output
subject to con59: level_reuse_D_FT1_under1 = level_transfer_D_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con60: level_reuse_D_FT1_under2 = level_transfer_D_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con61: level_transfer_D_FT1_under0 + level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2 = 1; # only one level of transfer for D
subject to con62: level_reuse_D_FT1_under0 + level_reuse_D_FT1_under1 + level_reuse_D_FT1_under2 = 1; # only one level of reuse for D
subject to con63: level_reuse_D_FT1_under0 = level_transfer_D_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con64: level_reuse_D_FT1_under1 = level_transfer_D_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con65: level_reuse_D_FT1_under2 = level_transfer_D_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con66: level_reuse_tmp_FT1_under0 >= level_transfer_tmp_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con67: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 >= level_transfer_tmp_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con68: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 + level_reuse_tmp_FT1_under2 >= level_transfer_tmp_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con69: level_transfer_tmp_FT1_under0 + level_transfer_tmp_FT1_under1 + level_transfer_tmp_FT1_under2 = 1; # only one level of transfer for tmp
subject to con70: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 + level_reuse_tmp_FT1_under2 = 1; # only one level of reuse for tmp
subject to con71: level_reuse_C_FT1_under0 >= level_transfer_C_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con72: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 >= level_transfer_C_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con73: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 >= level_transfer_C_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con74: level_transfer_C_FT1_under0 + level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2 = 1; # only one level of transfer for C
subject to con75: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 = 1; # only one level of reuse for C
subject to con76: Lat_comp_fused_S2_S3_3 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC9_0)); # latency of the fused task S2_S3 level 3
subject to con77: Lat_comp_fused_S2_S3_2 = (perm0_S2 * TC6_0 + perm1_S2 * TC5_0) * max(Lat_comp_fused_S2_S3_3, level_transfer_D_FT1_under2 * footprint_D_S2_S3 / burst_D, level_transfer_tmp_FT1_under2 * footprint_tmp_S3 / burst_tmp, level_transfer_C_FT1_under2 * footprint_C_S3 / burst_C) + Lat_comp_fused_S2_S3_3 + max(level_transfer_D_FT1_under2 * footprint_D_S2_S3 / burst_D, level_transfer_tmp_FT1_under2 * footprint_tmp_S3 / burst_tmp, level_transfer_C_FT1_under2 * footprint_C_S3 / burst_C  + level_transfer_D_FT1_under2 * footprint_D_S2_S3 / burst_D); # latency of the fused task S2_S3 level 2
subject to con78: Lat_comp_fused_S2_S3_1 = (perm0_S2 * TC5_0 + perm1_S2 * TC6_0) * max(Lat_comp_fused_S2_S3_2, level_transfer_D_FT1_under1 * footprint_D_S2_S3 / burst_D, level_transfer_tmp_FT1_under1 * footprint_tmp_S3 / burst_tmp, level_transfer_C_FT1_under1 * footprint_C_S3 / burst_C) + Lat_comp_fused_S2_S3_2 + max(level_transfer_D_FT1_under1 * footprint_D_S2_S3 / burst_D, level_transfer_tmp_FT1_under1 * footprint_tmp_S3 / burst_tmp, level_transfer_C_FT1_under1 * footprint_C_S3 / burst_C  + level_transfer_D_FT1_under1 * footprint_D_S2_S3 / burst_D); # latency of the fused task S2_S3 level 1
subject to con79: Lat_comp_fused_S2_S3 = Lat_comp_fused_S2_S3_1 + level_transfer_D_FT1_under0 * footprint_tot_D_FT1 / burst_D + level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 / burst_tmp + level_transfer_C_FT1_under0 * footprint_tot_C_FT1 / burst_C; # latency of the fused task S2_S3
subject to con80: footprint_tmp_S0_S1 = level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_transfer_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0) + level_transfer_tmp_FT0_under2 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con81: footprint_tmp_S0_S1_reuse = level_reuse_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_reuse_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0) + level_reuse_tmp_FT0_under2 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con82: perm2_S1 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con83: perm2_S1 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con84: perm3_S1 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con85: perm3_S1 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con86: perm0_S1 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con87: perm0_S1 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con88: perm5_S1 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con89: perm5_S1 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con90: footprint_A_S1 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0 + perm2_S1 * footprint_tot_A_FT0 + perm3_S1 * footprint_tot_A_FT0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0) + level_transfer_A_FT0_under2 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A_FT0/ TC2_0 + perm3_S1 * footprint_tot_A_FT0/ TC4_0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0); # footprint of the array A for the fused task 0
subject to con91: footprint_A_S1_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0 + perm2_S1 * footprint_tot_A_FT0 + perm3_S1 * footprint_tot_A_FT0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0) + level_reuse_A_FT0_under2 * (perm0_S1 * footprint_tot_A_FT0/ TC2_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A_FT0/ TC2_0 + perm3_S1 * footprint_tot_A_FT0/ TC4_0 + perm4_S1 * footprint_tot_A_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A_FT0/ TC4_0); # footprint of the array A for the fused task 0
subject to con92: perm0_S1 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con93: perm0_S1 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con94: perm1_S1 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con95: perm1_S1 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con96: perm2_S1 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con97: perm2_S1 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con98: perm4_S1 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con99: perm4_S1 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con100: footprint_B_S1 = level_transfer_B_FT0_under0 * footprint_tot_B_FT0 + level_transfer_B_FT0_under1 * (perm0_S1 * footprint_tot_B_FT0 + perm1_S1 * footprint_tot_B_FT0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0) + level_transfer_B_FT0_under2 * (perm0_S1 * footprint_tot_B_FT0/ TC3_0 + perm1_S1 * footprint_tot_B_FT0/ TC4_0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0/ TC3_0); # footprint of the array B for the fused task 0
subject to con101: footprint_B_S1_reuse = level_reuse_B_FT0_under0 * footprint_tot_B_FT0 + level_reuse_B_FT0_under1 * (perm0_S1 * footprint_tot_B_FT0 + perm1_S1 * footprint_tot_B_FT0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0) + level_reuse_B_FT0_under2 * (perm0_S1 * footprint_tot_B_FT0/ TC3_0 + perm1_S1 * footprint_tot_B_FT0/ TC4_0 + perm2_S1 * footprint_tot_B_FT0/ TC3_0 + perm3_S1 * footprint_tot_B_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B_FT0/ TC4_0 + perm5_S1 * footprint_tot_B_FT0/ TC4_0/ TC3_0); # footprint of the array B for the fused task 0
subject to con102: footprint_D_S2_S3 = level_transfer_D_FT1_under0 * footprint_tot_D_FT1 + level_transfer_D_FT1_under1 * (perm0_S2 * footprint_tot_D_FT1/ TC5_0 + perm1_S2 * footprint_tot_D_FT1/ TC6_0) + level_transfer_D_FT1_under2 * (perm0_S2 * footprint_tot_D_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_D_FT1/ TC6_0/ TC5_0); # footprint of the array D for the fused task 1
subject to con103: footprint_D_S2_S3_reuse = level_reuse_D_FT1_under0 * footprint_tot_D_FT1 + level_reuse_D_FT1_under1 * (perm0_S2 * footprint_tot_D_FT1/ TC5_0 + perm1_S2 * footprint_tot_D_FT1/ TC6_0) + level_reuse_D_FT1_under2 * (perm0_S2 * footprint_tot_D_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_D_FT1/ TC6_0/ TC5_0); # footprint of the array D for the fused task 1
subject to con104: perm2_S3 * level_transfer_tmp_FT1_under1 = 0; # useless to transfer under this loop
subject to con105: perm2_S3 * level_reuse_tmp_FT1_under1 = 0; # useless to reuse under this loop
subject to con106: perm3_S3 * level_transfer_tmp_FT1_under1 = 0; # useless to transfer under this loop
subject to con107: perm3_S3 * level_reuse_tmp_FT1_under1 = 0; # useless to reuse under this loop
subject to con108: perm0_S3 * level_transfer_tmp_FT1_under2 = 0; # useless to transfer under this loop
subject to con109: perm0_S3 * level_reuse_tmp_FT1_under2 = 0; # useless to reuse under this loop
subject to con110: perm5_S3 * level_transfer_tmp_FT1_under2 = 0; # useless to transfer under this loop
subject to con111: perm5_S3 * level_reuse_tmp_FT1_under2 = 0; # useless to reuse under this loop
subject to con112: footprint_tmp_S3 = level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_transfer_tmp_FT1_under1 * (perm0_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm1_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm2_S3 * footprint_tot_tmp_FT1 + perm3_S3 * footprint_tot_tmp_FT1 + perm4_S3 * footprint_tot_tmp_FT1/ TC9_0 + perm5_S3 * footprint_tot_tmp_FT1/ TC9_0) + level_transfer_tmp_FT1_under2 * (perm0_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm1_S3 * footprint_tot_tmp_FT1/ TC7_0/ TC9_0 + perm2_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm3_S3 * footprint_tot_tmp_FT1/ TC9_0 + perm4_S3 * footprint_tot_tmp_FT1/ TC9_0/ TC7_0 + perm5_S3 * footprint_tot_tmp_FT1/ TC9_0); # footprint of the array tmp for the fused task 1
subject to con113: footprint_tmp_S3_reuse = level_reuse_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_reuse_tmp_FT1_under1 * (perm0_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm1_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm2_S3 * footprint_tot_tmp_FT1 + perm3_S3 * footprint_tot_tmp_FT1 + perm4_S3 * footprint_tot_tmp_FT1/ TC9_0 + perm5_S3 * footprint_tot_tmp_FT1/ TC9_0) + level_reuse_tmp_FT1_under2 * (perm0_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm1_S3 * footprint_tot_tmp_FT1/ TC7_0/ TC9_0 + perm2_S3 * footprint_tot_tmp_FT1/ TC7_0 + perm3_S3 * footprint_tot_tmp_FT1/ TC9_0 + perm4_S3 * footprint_tot_tmp_FT1/ TC9_0/ TC7_0 + perm5_S3 * footprint_tot_tmp_FT1/ TC9_0); # footprint of the array tmp for the fused task 1
subject to con114: perm0_S3 * level_transfer_C_FT1_under1 = 0; # useless to transfer under this loop
subject to con115: perm0_S3 * level_reuse_C_FT1_under1 = 0; # useless to reuse under this loop
subject to con116: perm1_S3 * level_transfer_C_FT1_under1 = 0; # useless to transfer under this loop
subject to con117: perm1_S3 * level_reuse_C_FT1_under1 = 0; # useless to reuse under this loop
subject to con118: perm2_S3 * level_transfer_C_FT1_under2 = 0; # useless to transfer under this loop
subject to con119: perm2_S3 * level_reuse_C_FT1_under2 = 0; # useless to reuse under this loop
subject to con120: perm4_S3 * level_transfer_C_FT1_under2 = 0; # useless to transfer under this loop
subject to con121: perm4_S3 * level_reuse_C_FT1_under2 = 0; # useless to reuse under this loop
subject to con122: footprint_C_S3 = level_transfer_C_FT1_under0 * footprint_tot_C_FT1 + level_transfer_C_FT1_under1 * (perm0_S3 * footprint_tot_C_FT1 + perm1_S3 * footprint_tot_C_FT1 + perm2_S3 * footprint_tot_C_FT1/ TC8_0 + perm3_S3 * footprint_tot_C_FT1/ TC8_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0) + level_transfer_C_FT1_under2 * (perm0_S3 * footprint_tot_C_FT1/ TC8_0 + perm1_S3 * footprint_tot_C_FT1/ TC9_0 + perm2_S3 * footprint_tot_C_FT1/ TC8_0 + perm3_S3 * footprint_tot_C_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0/ TC8_0); # footprint of the array C for the fused task 1
subject to con123: footprint_C_S3_reuse = level_reuse_C_FT1_under0 * footprint_tot_C_FT1 + level_reuse_C_FT1_under1 * (perm0_S3 * footprint_tot_C_FT1 + perm1_S3 * footprint_tot_C_FT1 + perm2_S3 * footprint_tot_C_FT1/ TC8_0 + perm3_S3 * footprint_tot_C_FT1/ TC8_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0) + level_reuse_C_FT1_under2 * (perm0_S3 * footprint_tot_C_FT1/ TC8_0 + perm1_S3 * footprint_tot_C_FT1/ TC9_0 + perm2_S3 * footprint_tot_C_FT1/ TC8_0 + perm3_S3 * footprint_tot_C_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_C_FT1/ TC9_0 + perm5_S3 * footprint_tot_C_FT1/ TC9_0/ TC8_0); # footprint of the array C for the fused task 1
subject to con124: shift_0_to_1 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC4_0 + footprint_tmp_S0_S1) * footprint_tmp_S3 / footprint_tmp_S0_S1;
subject to con125: TC0_1 * TC1_1 <= MAX_UF;
subject to con126: TC2_1 * TC3_1 * TC4_1 <= MAX_UF;
subject to con127: TC5_1 * TC6_1 <= MAX_UF;
subject to con128: TC7_1 * TC8_1 * TC9_1 <= MAX_UF;
subject to con129: TC0_1 * TC1_1 * DSP_S0  + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq + TC5_1 * TC6_1 * DSP_S2  + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq <= DSP_avail; # DSP constraint
subject to con130: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con131: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con132: nb_dsp_used_SLR1 = is_fused_task0_in_SLR_1 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_1 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con133: nb_dsp_used_SLR1 <= SLR1_DSP; # DSP constraint per SLR
subject to con134: nb_dsp_used_SLR2 = is_fused_task0_in_SLR_2 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_2 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con135: nb_dsp_used_SLR2 <= SLR2_DSP; # DSP constraint per SLR
subject to con136: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con137: TC0_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con138: TC2_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con139: TC2_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con140: TC2_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con141: TC4_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con142: TC5_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array D 
subject to con143: TC5_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array D 
subject to con144: TC7_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array D 
subject to con145: TC7_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array D 
subject to con146: TC7_1 * TC9_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con147: TC9_1 * TC8_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con148: Lat_comp_S3_for_off_chip = perm0_S3 * TC9_0 * II_S3_seq + perm1_S3 * TC9_0 * TC8_0 * II_S3_par + perm2_S3 * TC9_0 * II_S3_seq + perm3_S3 * TC9_0 * TC7_0 * II_S3_par + perm4_S3 * TC9_0 * TC7_0 * TC8_0 * II_S3_par + perm5_S3 * TC9_0 * TC8_0 * TC7_0 * II_S3_par; # stall between task
subject to con149: TC0_0 <= TC0; # TC of split loop
subject to con150: TC0_1 <= TC0; # TC of split loop
subject to con151: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con152: TC1_0 <= TC1; # TC of split loop
subject to con153: TC1_1 <= TC1; # TC of split loop
subject to con154: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con155: TC2_0 <= TC2; # TC of split loop
subject to con156: TC2_1 <= TC2; # TC of split loop
subject to con157: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con158: TC3_0 <= TC3; # TC of split loop
subject to con159: TC3_1 <= TC3; # TC of split loop
subject to con160: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con161: TC4_0 <= TC4; # TC of split loop
subject to con162: TC4_1 <= TC4; # TC of split loop
subject to con163: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con164: TC5_0 <= TC5; # TC of split loop
subject to con165: TC5_1 <= TC5; # TC of split loop
subject to con166: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con167: TC6_0 <= TC6; # TC of split loop
subject to con168: TC6_1 <= TC6; # TC of split loop
subject to con169: TC6_0 * TC6_1 = TC6; # product of the TC of split loop = original TC
subject to con170: TC7_0 <= TC7; # TC of split loop
subject to con171: TC7_1 <= TC7; # TC of split loop
subject to con172: TC7_0 * TC7_1 = TC7; # product of the TC of split loop = original TC
subject to con173: TC8_0 <= TC8; # TC of split loop
subject to con174: TC8_1 <= TC8; # TC of split loop
subject to con175: TC8_0 * TC8_1 = TC8; # product of the TC of split loop = original TC
subject to con176: TC9_0 <= TC9; # TC of split loop
subject to con177: TC9_1 <= TC9; # TC of split loop
subject to con178: TC9_0 * TC9_1 = TC9; # product of the TC of split loop = original TC
subject to con179: TC0_1 = TC2_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con180: TC1_1 = TC3_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con181: TC5_1 = TC7_1; # same intra tile for the same dimension of the array D in the fused task
subject to con182: TC6_1 = TC8_1; # same intra tile for the same dimension of the array D in the fused task
subject to con183: C_is_fully_transfered_on_last_dim_FT1 = level_transfer_C_FT1_under0 + perm0_S3 * (level_transfer_C_FT1_under1) + perm1_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm4_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm5_S3 * (level_transfer_C_FT1_under1); # the array C is fully transfered on the last dimension
subject to con184: burst_C_is_1 * cte_0 * 1 = burst_C_is_1 * ((1-is_tc8_burst_witout_tiling_for_C) * (TC8_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC8 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC8_for_C + TC8));
subject to con185: is_tc8_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC8_for_C);
subject to con186: burst_C_is_2 * cte_1 * 2 = burst_C_is_2 * ((1-is_tc8_burst_witout_tiling_for_C) * (TC8_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC8 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC8_for_C + TC8));
subject to con187: burst_C_is_4 * cte_2 * 4 = burst_C_is_4 * ((1-is_tc8_burst_witout_tiling_for_C) * (TC8_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC8 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC8_for_C + TC8));
subject to con188: burst_C_is_8 * cte_3 * 8 = burst_C_is_8 * ((1-is_tc8_burst_witout_tiling_for_C) * (TC8_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC8 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC8_for_C + TC8));
subject to con189: burst_C_is_16 * cte_4 * 16 = burst_C_is_16 * ((1-is_tc8_burst_witout_tiling_for_C) * (TC8_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC8 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC8_for_C + TC8));
subject to con190: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con191: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con192: is_tc8_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT1;
subject to con193: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm0_S1 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2) + perm1_S1 * (level_transfer_A_FT0_under1) + perm2_S1 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2) + perm3_S1 * (level_transfer_A_FT0_under1); # the array A is fully transfered on the last dimension
subject to con194: burst_A_is_1 * cte_5 * 1 = burst_A_is_1 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con195: is_tc4_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC4_for_A);
subject to con196: burst_A_is_2 * cte_6 * 2 = burst_A_is_2 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con197: burst_A_is_4 * cte_7 * 4 = burst_A_is_4 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con198: burst_A_is_8 * cte_8 * 8 = burst_A_is_8 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con199: burst_A_is_16 * cte_9 * 16 = burst_A_is_16 * ((1-is_tc4_burst_witout_tiling_for_A) * (TC4_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC4 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC4_for_A + TC4));
subject to con200: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con201: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con202: is_tc4_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con203: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm0_S0 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con204: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm0_S1 * (level_transfer_tmp_FT0_under1) + perm1_S1 * (level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2) + perm4_S1 * (level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2) + perm5_S1 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con205: tmp_is_fully_transfered_on_last_dim_FT1 = level_transfer_tmp_FT1_under0 + perm0_S3 * (level_transfer_tmp_FT1_under1 + level_transfer_tmp_FT1_under2) + perm1_S3 * (level_transfer_tmp_FT1_under1) + perm2_S3 * (level_transfer_tmp_FT1_under1 + level_transfer_tmp_FT1_under2) + perm3_S3 * (level_transfer_tmp_FT1_under1); # the array tmp is fully transfered on the last dimension
subject to con206: burst_tmp_is_1 * cte_10 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con207: is_tc1_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC1_for_tmp);
subject to con208: burst_tmp_is_1 * cte_11 * 1 = burst_tmp_is_1 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con209: is_tc3_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC3_for_tmp);
subject to con210: burst_tmp_is_1 * cte_12 * 1 = burst_tmp_is_1 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con211: burst_tmp_is_1 * cte_13 * 1 = burst_tmp_is_1 * ((1-is_tc9_burst_witout_tiling_for_tmp) * (TC9_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC9 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC9_for_tmp + TC9));
subject to con212: is_tc9_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC9_for_tmp);
subject to con213: burst_tmp_is_2 * cte_14 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con214: burst_tmp_is_2 * cte_15 * 2 = burst_tmp_is_2 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con215: burst_tmp_is_2 * cte_16 * 2 = burst_tmp_is_2 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con216: burst_tmp_is_2 * cte_17 * 2 = burst_tmp_is_2 * ((1-is_tc9_burst_witout_tiling_for_tmp) * (TC9_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC9 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC9_for_tmp + TC9));
subject to con217: burst_tmp_is_4 * cte_18 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con218: burst_tmp_is_4 * cte_19 * 4 = burst_tmp_is_4 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con219: burst_tmp_is_4 * cte_20 * 4 = burst_tmp_is_4 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con220: burst_tmp_is_4 * cte_21 * 4 = burst_tmp_is_4 * ((1-is_tc9_burst_witout_tiling_for_tmp) * (TC9_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC9 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC9_for_tmp + TC9));
subject to con221: burst_tmp_is_8 * cte_22 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con222: burst_tmp_is_8 * cte_23 * 8 = burst_tmp_is_8 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con223: burst_tmp_is_8 * cte_24 * 8 = burst_tmp_is_8 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con224: burst_tmp_is_8 * cte_25 * 8 = burst_tmp_is_8 * ((1-is_tc9_burst_witout_tiling_for_tmp) * (TC9_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC9 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC9_for_tmp + TC9));
subject to con225: burst_tmp_is_16 * cte_26 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con226: burst_tmp_is_16 * cte_27 * 16 = burst_tmp_is_16 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con227: burst_tmp_is_16 * cte_28 * 16 = burst_tmp_is_16 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con228: burst_tmp_is_16 * cte_29 * 16 = burst_tmp_is_16 * ((1-is_tc9_burst_witout_tiling_for_tmp) * (TC9_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC9 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC9_for_tmp + TC9));
subject to con229: burst_tmp = burst_tmp_is_1 * 1 + burst_tmp_is_2 * 2 + burst_tmp_is_4 * 4 + burst_tmp_is_8 * 8 + burst_tmp_is_16 * 16; # burst size of the array tmp
subject to con230: burst_tmp_is_1 + burst_tmp_is_2 + burst_tmp_is_4 + burst_tmp_is_8 + burst_tmp_is_16 = 1; # only one burst size for the array tmp
subject to con231: is_tc1_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con232: is_tc3_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con233: is_tc9_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT1;
subject to con234: D_is_fully_transfered_on_last_dim_FT1 = level_transfer_D_FT1_under0 + perm0_S2 * (level_transfer_D_FT1_under1); # the array D is fully transfered on the last dimension
subject to con235: D_is_fully_transfered_on_last_dim_FT1 = level_transfer_D_FT1_under0 + perm0_S3 * (level_transfer_D_FT1_under1) + perm1_S3 * (level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2) + perm4_S3 * (level_transfer_D_FT1_under1 + level_transfer_D_FT1_under2) + perm5_S3 * (level_transfer_D_FT1_under1); # the array D is fully transfered on the last dimension
subject to con236: burst_D_is_1 * cte_30 * 1 = burst_D_is_1 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con237: is_tc6_burst_witout_tiling_for_D =  min(1, cte_burst_without_tiling_TC6_for_D);
subject to con238: burst_D_is_1 * cte_31 * 1 = burst_D_is_1 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con239: burst_D_is_1 * cte_32 * 1 = burst_D_is_1 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con240: is_tc8_burst_witout_tiling_for_D =  min(1, cte_burst_without_tiling_TC8_for_D);
subject to con241: burst_D_is_1 * cte_33 * 1 = burst_D_is_1 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con242: burst_D_is_2 * cte_34 * 2 = burst_D_is_2 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con243: burst_D_is_2 * cte_35 * 2 = burst_D_is_2 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con244: burst_D_is_2 * cte_36 * 2 = burst_D_is_2 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con245: burst_D_is_2 * cte_37 * 2 = burst_D_is_2 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con246: burst_D_is_4 * cte_38 * 4 = burst_D_is_4 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con247: burst_D_is_4 * cte_39 * 4 = burst_D_is_4 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con248: burst_D_is_4 * cte_40 * 4 = burst_D_is_4 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con249: burst_D_is_4 * cte_41 * 4 = burst_D_is_4 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con250: burst_D_is_8 * cte_42 * 8 = burst_D_is_8 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con251: burst_D_is_8 * cte_43 * 8 = burst_D_is_8 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con252: burst_D_is_8 * cte_44 * 8 = burst_D_is_8 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con253: burst_D_is_8 * cte_45 * 8 = burst_D_is_8 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con254: burst_D_is_16 * cte_46 * 16 = burst_D_is_16 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con255: burst_D_is_16 * cte_47 * 16 = burst_D_is_16 * ((1-is_tc6_burst_witout_tiling_for_D) * (TC6_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC6 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC6_for_D + TC6));
subject to con256: burst_D_is_16 * cte_48 * 16 = burst_D_is_16 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con257: burst_D_is_16 * cte_49 * 16 = burst_D_is_16 * ((1-is_tc8_burst_witout_tiling_for_D) * (TC8_1 * (1-D_is_fully_transfered_on_last_dim_FT1) + TC8 * (D_is_fully_transfered_on_last_dim_FT1)) + is_tc8_burst_witout_tiling_for_D * (cte_burst_without_tiling_TC8_for_D + TC8));
subject to con258: burst_D = burst_D_is_1 * 1 + burst_D_is_2 * 2 + burst_D_is_4 * 4 + burst_D_is_8 * 8 + burst_D_is_16 * 16; # burst size of the array D
subject to con259: burst_D_is_1 + burst_D_is_2 + burst_D_is_4 + burst_D_is_8 + burst_D_is_16 = 1; # only one burst size for the array D
subject to con260: is_tc6_burst_witout_tiling_for_D <= D_is_fully_transfered_on_last_dim_FT1;
subject to con261: is_tc8_burst_witout_tiling_for_D <= D_is_fully_transfered_on_last_dim_FT1;
subject to con262: B_is_fully_transfered_on_last_dim_FT0 = level_transfer_B_FT0_under0 + perm0_S1 * (level_transfer_B_FT0_under1) + perm1_S1 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm4_S1 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm5_S1 * (level_transfer_B_FT0_under1); # the array B is fully transfered on the last dimension
subject to con263: burst_B_is_1 * cte_50 * 1 = burst_B_is_1 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con264: is_tc3_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC3_for_B);
subject to con265: burst_B_is_2 * cte_51 * 2 = burst_B_is_2 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con266: burst_B_is_4 * cte_52 * 4 = burst_B_is_4 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con267: burst_B_is_8 * cte_53 * 8 = burst_B_is_8 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con268: burst_B_is_16 * cte_54 * 16 = burst_B_is_16 * ((1-is_tc3_burst_witout_tiling_for_B) * (TC3_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC3 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC3_for_B + TC3));
subject to con269: burst_B = burst_B_is_1 * 1 + burst_B_is_2 * 2 + burst_B_is_4 * 4 + burst_B_is_8 * 8 + burst_B_is_16 * 16; # burst size of the array B
subject to con270: burst_B_is_1 + burst_B_is_2 + burst_B_is_4 + burst_B_is_8 + burst_B_is_16 = 1; # only one burst size for the array B
subject to con271: is_tc3_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT0;
subject to con272: footprint_tot_C_FT1 = TC9_ori * TC8_0 * (TC8_1 + cte_burst_without_tiling_TC8_for_C);
subject to con273: footprint_tot_A_FT0 = TC2_ori * TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_A);
subject to con274: footprint_tot_tmp_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_tmp);
subject to con275: footprint_tot_tmp_FT0 = TC2_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_tmp);
subject to con276: footprint_tot_tmp_FT1 = TC7_ori * TC9_0 * (TC9_1 + cte_burst_without_tiling_TC9_for_tmp);
subject to con277: footprint_tot_D_FT1 = TC5_ori * TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_D);
subject to con278: footprint_tot_D_FT1 = TC7_ori * TC8_0 * (TC8_1 + cte_burst_without_tiling_TC8_for_D);
subject to con279: footprint_tot_B_FT0 = TC4_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_B);
subject to con280: TC0 = TC0_ori;
subject to con281: TC2 = TC2_ori;
subject to con282: TC5 = TC5_ori;
subject to con283: TC7 = TC7_ori;
subject to con284: obj = max(shift_0_to_1 + Lat_comp_fused_S2_S3, Lat_comp_fused_S0_S1) + 1/burst_C + 1/burst_A + 1/burst_tmp + 1/burst_D + 1/burst_B + 1/(is_slr0_used + is_slr1_used + is_slr2_used);
subject to con285: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC2_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC2_1) * cte_tiling_0; # should divide for tmp in dim 0
subject to con286: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC0_1, TC7_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC0_1, TC7_1) * cte_tiling_1; # should divide for tmp in dim 0
subject to con287: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC2_1, TC7_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC2_1, TC7_1) * cte_tiling_2; # should divide for tmp in dim 0
subject to con288: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC1_1, TC3_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC1_1, TC3_1) * cte_tiling_3; # should divide for tmp in dim 1
subject to con289: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC9_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC9_1) * cte_tiling_4; # should divide for tmp in dim 1
subject to con290: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC9_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC9_1) * cte_tiling_5; # should divide for tmp in dim 1
subject to con291: D_is_fully_transfered_on_last_dim_FT1 * D_is_fully_transfered_on_last_dim_FT1 * max(TC5_1, TC7_1) = D_is_fully_transfered_on_last_dim_FT1 * D_is_fully_transfered_on_last_dim_FT1 * min(TC5_1, TC7_1) * cte_tiling_6; # should divide for D in dim 0
subject to con292: D_is_fully_transfered_on_last_dim_FT1 * D_is_fully_transfered_on_last_dim_FT1 * max(TC6_1, TC8_1) = D_is_fully_transfered_on_last_dim_FT1 * D_is_fully_transfered_on_last_dim_FT1 * min(TC6_1, TC8_1) * cte_tiling_7; # should divide for D in dim 1
subject to con293: buffer_size = footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_B_S1_reuse + footprint_tmp_S3_reuse + footprint_D_S2_S3_reuse + footprint_C_S3_reuse; # total buffer size
subject to con294: fifo_size = 0; # total fifo size
subject to con295: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con296: perm0_S0 * perm3_S3 * level_transfer_tmp_FT1_under0 = perm0_S0 * perm3_S3 * 1;
subject to con297: perm0_S0 * perm4_S3 * level_transfer_tmp_FT1_under0 = perm0_S0 * perm4_S3 * 1;
subject to con298: perm0_S0 * perm5_S3 * level_transfer_tmp_FT1_under0 = perm0_S0 * perm5_S3 * 1;
subject to con299: perm1_S0 * perm0_S3 * level_transfer_tmp_FT1_under0 = perm1_S0 * perm0_S3 * 1;
subject to con300: perm1_S0 * perm1_S3 * level_transfer_tmp_FT1_under0 = perm1_S0 * perm1_S3 * 1;
subject to con301: perm1_S0 * perm2_S3 * level_transfer_tmp_FT1_under0 = perm1_S0 * perm2_S3 * 1;
subject to con302: perm0_S1 * perm3_S3 * level_transfer_tmp_FT1_under0 = perm0_S1 * perm3_S3 * 1;
subject to con303: perm0_S1 * perm4_S3 * level_transfer_tmp_FT1_under0 = perm0_S1 * perm4_S3 * 1;
subject to con304: perm0_S1 * perm5_S3 * level_transfer_tmp_FT1_under0 = perm0_S1 * perm5_S3 * 1;
subject to con305: perm1_S1 * perm3_S3 * level_transfer_tmp_FT1_under0 = perm1_S1 * perm3_S3 * 1;
subject to con306: perm1_S1 * perm4_S3 * level_transfer_tmp_FT1_under0 = perm1_S1 * perm4_S3 * 1;
subject to con307: perm1_S1 * perm5_S3 * level_transfer_tmp_FT1_under0 = perm1_S1 * perm5_S3 * 1;
subject to con308: perm2_S1 * perm0_S3 * level_transfer_tmp_FT1_under0 = perm2_S1 * perm0_S3 * 1;
subject to con309: perm2_S1 * perm1_S3 * level_transfer_tmp_FT1_under0 = perm2_S1 * perm1_S3 * 1;
subject to con310: perm2_S1 * perm2_S3 * level_transfer_tmp_FT1_under0 = perm2_S1 * perm2_S3 * 1;
subject to con311: perm3_S1 * perm0_S3 * level_transfer_tmp_FT1_under0 = perm3_S1 * perm0_S3 * 1;
subject to con312: perm3_S1 * perm1_S3 * level_transfer_tmp_FT1_under0 = perm3_S1 * perm1_S3 * 1;
subject to con313: perm3_S1 * perm2_S3 * level_transfer_tmp_FT1_under0 = perm3_S1 * perm2_S3 * 1;
subject to con314: perm4_S1 * perm3_S3 * level_transfer_tmp_FT1_under0 = perm4_S1 * perm3_S3 * 1;
subject to con315: perm4_S1 * perm4_S3 * level_transfer_tmp_FT1_under0 = perm4_S1 * perm4_S3 * 1;
subject to con316: perm4_S1 * perm5_S3 * level_transfer_tmp_FT1_under0 = perm4_S1 * perm5_S3 * 1;
subject to con317: perm5_S1 * perm0_S3 * level_transfer_tmp_FT1_under0 = perm5_S1 * perm0_S3 * 1;
subject to con318: perm5_S1 * perm1_S3 * level_transfer_tmp_FT1_under0 = perm5_S1 * perm1_S3 * 1;
subject to con319: perm5_S1 * perm2_S3 * level_transfer_tmp_FT1_under0 = perm5_S1 * perm2_S3 * 1;
subject to con320: perm0_S3 * level_reuse_C_FT1_under0 = perm0_S3 * 1;
subject to con321: perm1_S3 * level_reuse_C_FT1_under0 = perm1_S3 * 1;
subject to con322: perm2_S1 * level_reuse_A_FT0_under0 = perm2_S1 * 1;
subject to con323: perm3_S1 * level_reuse_A_FT0_under0 = perm3_S1 * 1;
subject to con324: perm4_S1 * level_reuse_tmp_FT0_under0 = perm4_S1 * 1;
subject to con325: perm5_S1 * level_reuse_tmp_FT0_under0 = perm5_S1 * 1;
subject to con326: perm2_S3 * level_reuse_tmp_FT1_under0 = perm2_S3 * 1;
subject to con327: perm3_S3 * level_reuse_tmp_FT1_under0 = perm3_S3 * 1;
subject to con328: perm4_S3 * level_reuse_D_FT1_under0 = perm4_S3 * 1;
subject to con329: perm5_S3 * level_reuse_D_FT1_under0 = perm5_S3 * 1;
subject to con330: perm0_S1 * level_reuse_B_FT0_under0 = perm0_S1 * 1;
subject to con331: perm1_S1 * level_reuse_B_FT0_under0 = perm1_S1 * 1;
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
display is_fused_task0_in_SLR_0;
display is_fused_task0_in_SLR_1;
display is_fused_task0_in_SLR_2;
display is_fused_task1_in_SLR_0;
display is_fused_task1_in_SLR_1;
display is_fused_task1_in_SLR_2;
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
display Lat_comp_S3_for_off_chip;
display perm1_S3;
display perm2_S3;
display perm3_S3;
display perm4_S3;
display perm5_S3;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display Lat_comp_S2_intra_tile;
display Lat_comp_S3_intra_tile;
display footprint_tmp_S0_S1;
display footprint_tmp_S0_S1_reuse;
display footprint_A_S1;
display footprint_A_S1_reuse;
display footprint_B_S1;
display footprint_B_S1_reuse;
display footprint_tmp_S3;
display footprint_tmp_S3_reuse;
display footprint_D_S2_S3;
display footprint_D_S2_S3_reuse;
display footprint_C_S3;
display footprint_C_S3_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_tmp_FT0_under0;
display level_reuse_tmp_FT0_under0;
display level_transfer_tmp_FT0_under1;
display level_reuse_tmp_FT0_under1;
display level_transfer_tmp_FT0_under2;
display level_reuse_tmp_FT0_under2;
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
display level_transfer_D_FT1_under0;
display level_reuse_D_FT1_under0;
display level_transfer_D_FT1_under1;
display level_reuse_D_FT1_under1;
display level_transfer_D_FT1_under2;
display level_reuse_D_FT1_under2;
display level_transfer_tmp_FT1_under0;
display level_reuse_tmp_FT1_under0;
display level_transfer_tmp_FT1_under1;
display level_reuse_tmp_FT1_under1;
display level_transfer_tmp_FT1_under2;
display level_reuse_tmp_FT1_under2;
display level_transfer_C_FT1_under0;
display level_reuse_C_FT1_under0;
display level_transfer_C_FT1_under1;
display level_reuse_C_FT1_under1;
display level_transfer_C_FT1_under2;
display level_reuse_C_FT1_under2;
display Lat_comp_fused_S2_S3_3;
display Lat_comp_fused_S2_S3_2;
display Lat_comp_fused_S2_S3_1;
display shift_0_to_1;
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
display C_is_fully_transfered_on_last_dim_FT1;
display burst_C_is_1;
display cte_0;
display cte_burst_without_tiling_TC8_for_C;
display is_tc8_burst_witout_tiling_for_C;
display burst_C_is_2;
display cte_1;
display burst_C_is_4;
display cte_2;
display burst_C_is_8;
display cte_3;
display burst_C_is_16;
display cte_4;
display A_is_fully_transfered_on_last_dim_FT0;
display burst_A_is_1;
display cte_5;
display cte_burst_without_tiling_TC4_for_A;
display is_tc4_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_6;
display burst_A_is_4;
display cte_7;
display burst_A_is_8;
display cte_8;
display burst_A_is_16;
display cte_9;
display tmp_is_fully_transfered_on_last_dim_FT0;
display tmp_is_fully_transfered_on_last_dim_FT1;
display burst_tmp_is_1;
display cte_10;
display cte_burst_without_tiling_TC1_for_tmp;
display is_tc1_burst_witout_tiling_for_tmp;
display cte_11;
display cte_burst_without_tiling_TC3_for_tmp;
display is_tc3_burst_witout_tiling_for_tmp;
display cte_12;
display cte_13;
display cte_burst_without_tiling_TC9_for_tmp;
display is_tc9_burst_witout_tiling_for_tmp;
display burst_tmp_is_2;
display cte_14;
display cte_15;
display cte_16;
display cte_17;
display burst_tmp_is_4;
display cte_18;
display cte_19;
display cte_20;
display cte_21;
display burst_tmp_is_8;
display cte_22;
display cte_23;
display cte_24;
display cte_25;
display burst_tmp_is_16;
display cte_26;
display cte_27;
display cte_28;
display cte_29;
display D_is_fully_transfered_on_last_dim_FT1;
display burst_D_is_1;
display cte_30;
display cte_burst_without_tiling_TC6_for_D;
display is_tc6_burst_witout_tiling_for_D;
display cte_31;
display cte_32;
display cte_burst_without_tiling_TC8_for_D;
display is_tc8_burst_witout_tiling_for_D;
display cte_33;
display burst_D_is_2;
display cte_34;
display cte_35;
display cte_36;
display cte_37;
display burst_D_is_4;
display cte_38;
display cte_39;
display cte_40;
display cte_41;
display burst_D_is_8;
display cte_42;
display cte_43;
display cte_44;
display cte_45;
display burst_D_is_16;
display cte_46;
display cte_47;
display cte_48;
display cte_49;
display B_is_fully_transfered_on_last_dim_FT0;
display burst_B_is_1;
display cte_50;
display cte_burst_without_tiling_TC3_for_B;
display is_tc3_burst_witout_tiling_for_B;
display burst_B_is_2;
display cte_51;
display burst_B_is_4;
display cte_52;
display burst_B_is_8;
display cte_53;
display burst_B_is_16;
display cte_54;
display footprint_tot_C_FT1;
display burst_C;
display footprint_tot_A_FT0;
display burst_A;
display footprint_tot_tmp_FT0;
display burst_tmp;
display footprint_tot_tmp_FT1;
display footprint_tot_D_FT1;
display burst_D;
display footprint_tot_B_FT0;
display burst_B;
display Lat_comp_0_1;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display cte_tiling_2;
display cte_tiling_3;
display cte_tiling_4;
display cte_tiling_5;
display cte_tiling_6;
display cte_tiling_7;
display buffer_size;
display fifo_size;
display _total_solve_time;
