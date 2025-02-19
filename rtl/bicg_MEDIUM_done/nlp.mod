#option solver baron;
#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';
option solver gurobi;
option gurobi_options 'lim:time=1800 tech:logfile=gurobi.log qp:nonconvex=2';
#option solver octeract;
#option octeract_options 'max_solver_time=60';

param DSP_avail = 9024;
param ON_CHIP_MEM_SIZE = 1512000;
param MAX_BUFFER_SIZE = 2048;
param CONSTRAINT_ARRAY_PARTITIONING_VALUE = 1024;
param MAX_UF = 2048;
param SLR0_mem = 1512000;
param SLR0_DSP = 9024;
param II_S0_par = 1;
param II_S0_seq = 3;
param II_S1_par = 1;
param II_S1_seq = 3;
param II_S2_par = 1;
param II_S2_seq = 3;
param II_S3_par = 1;
param II_S3_seq = 3;
param TC0_ori = 390;
param TC1_ori = 410;
param TC2_ori = 390;
param TC3_ori = 410;
param TC4_ori = 410;
param TC5_ori = 390;
param IL_par_S0 = 1;
param IL_seq_S0 = 0;
param IL_par_S1 = 4;
param IL_seq_S1 = 7;
param IL_par_S2 = 1;
param IL_seq_S2 = 0;
param IL_par_S3 = 4;
param IL_seq_S3 = 7;
param DSP_S0 = 0;
param DSP_S1 = 5;
param DSP_S2 = 0;
param DSP_S3 = 5;

var TC0 integer >= 390 <= 400;
var TC1 integer >= 410 <= 416;
var TC2 integer >= 390 <= 400;
var TC3 integer >= 410 <= 416;
var TC4 integer >= 410 <= 416;
var TC5 integer >= 390 <= 400;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task1_in_SLR_0 binary;
var is_slr0_used binary;
var perm0_S0 binary; # [0, 0, 0, 0, 0]
var perm0_S1 binary; # [1, 1, 0, 2, 0, 1, 0, 2, 0]
var perm1_S1 binary; # [1, 2, 0, 1, 0, 2, 0, 1, 0]
var perm0_S2 binary; # [2, 3, 0, 3, 0]
var perm0_S3 binary; # [3, 4, 0, 5, 0, 4, 0, 5, 0]
var Lat_comp_S3_for_off_chip >= 0;
var perm1_S3 binary; # [3, 5, 0, 4, 0, 5, 0, 4, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var Lat_comp_S2_intra_tile >= 0;
var Lat_comp_S3_intra_tile >= 0;
var footprint_s_S0_S1 integer >= 0;
var footprint_s_S0_S1_reuse integer >= 0;
var footprint_r_S1 integer >= 0;
var footprint_r_S1_reuse integer >= 0;
var footprint_A_S1 integer >= 0;
var footprint_A_S1_reuse integer >= 0;
var footprint_A_S3 integer >= 0;
var footprint_A_S3_reuse integer >= 0;
var footprint_q_S2_S3 integer >= 0;
var footprint_q_S2_S3_reuse integer >= 0;
var footprint_p_S3 integer >= 0;
var footprint_p_S3_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_s_FT0_under0 binary;
var level_reuse_s_FT0_under0 binary;
var level_transfer_s_FT0_under1 binary;
var level_reuse_s_FT0_under1 binary;
var level_transfer_r_FT0_under0 binary;
var level_reuse_r_FT0_under0 binary;
var level_transfer_r_FT0_under1 binary;
var level_reuse_r_FT0_under1 binary;
var level_transfer_A_FT0_under0 binary;
var level_reuse_A_FT0_under0 binary;
var level_transfer_A_FT0_under1 binary;
var level_reuse_A_FT0_under1 binary;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
var Lat_comp_fused_S2_S3 >= 0;
var level_transfer_q_FT1_under0 binary;
var level_reuse_q_FT1_under0 binary;
var level_transfer_q_FT1_under1 binary;
var level_reuse_q_FT1_under1 binary;
var level_transfer_A_FT1_under0 binary;
var level_reuse_A_FT1_under0 binary;
var level_transfer_A_FT1_under1 binary;
var level_reuse_A_FT1_under1 binary;
var level_transfer_p_FT1_under0 binary;
var level_reuse_p_FT1_under0 binary;
var level_transfer_p_FT1_under1 binary;
var level_reuse_p_FT1_under1 binary;
var Lat_comp_fused_S2_S3_2 >= 0;
var Lat_comp_fused_S2_S3_1 >= 0;
var shift_0_to_1 >= 0;
var nb_dsp_used_SLR0 >= 0;
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
var q_is_fully_transfered_on_last_dim_FT1 binary;
var burst_q_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC3_for_q integer >= 0 <= 6;
var is_tc3_burst_witout_tiling_for_q binary;
var cte_1 integer >=0;
var cte_burst_without_tiling_TC4_for_q integer >= 0 <= 6;
var is_tc4_burst_witout_tiling_for_q binary;
var cte_2 integer >=0;
var burst_q_is_2 binary;
var cte_3 integer >=0;
var cte_4 integer >=0;
var cte_5 integer >=0;
var burst_q_is_4 binary;
var cte_6 integer >=0;
var cte_7 integer >=0;
var cte_8 integer >=0;
var burst_q_is_8 binary;
var cte_9 integer >=0;
var cte_10 integer >=0;
var cte_11 integer >=0;
var burst_q_is_16 binary;
var cte_12 integer >=0;
var cte_13 integer >=0;
var cte_14 integer >=0;
var s_is_fully_transfered_on_last_dim_FT0 binary;
var burst_s_is_1 binary;
var cte_15 integer >=0;
var cte_burst_without_tiling_TC0_for_s integer >= 0 <= 10;
var is_tc0_burst_witout_tiling_for_s binary;
var cte_16 integer >=0;
var cte_burst_without_tiling_TC2_for_s integer >= 0 <= 10;
var is_tc2_burst_witout_tiling_for_s binary;
var cte_17 integer >=0;
var burst_s_is_2 binary;
var cte_18 integer >=0;
var cte_19 integer >=0;
var cte_20 integer >=0;
var burst_s_is_4 binary;
var cte_21 integer >=0;
var cte_22 integer >=0;
var cte_23 integer >=0;
var burst_s_is_8 binary;
var cte_24 integer >=0;
var cte_25 integer >=0;
var cte_26 integer >=0;
var burst_s_is_16 binary;
var cte_27 integer >=0;
var cte_28 integer >=0;
var cte_29 integer >=0;
var r_is_fully_transfered_on_last_dim_FT0 binary;
var burst_r_is_1 binary;
var cte_30 integer >=0;
var cte_burst_without_tiling_TC1_for_r integer >= 0 <= 6;
var is_tc1_burst_witout_tiling_for_r binary;
var burst_r_is_2 binary;
var cte_31 integer >=0;
var burst_r_is_4 binary;
var cte_32 integer >=0;
var burst_r_is_8 binary;
var cte_33 integer >=0;
var burst_r_is_16 binary;
var cte_34 integer >=0;
var p_is_fully_transfered_on_last_dim_FT1 binary;
var burst_p_is_1 binary;
var cte_35 integer >=0;
var cte_burst_without_tiling_TC5_for_p integer >= 0 <= 10;
var is_tc5_burst_witout_tiling_for_p binary;
var burst_p_is_2 binary;
var cte_36 integer >=0;
var burst_p_is_4 binary;
var cte_37 integer >=0;
var burst_p_is_8 binary;
var cte_38 integer >=0;
var burst_p_is_16 binary;
var cte_39 integer >=0;
var A_is_fully_transfered_on_last_dim_FT0 binary;
var A_is_fully_transfered_on_last_dim_FT1 binary;
var burst_A_is_1 binary;
var cte_40 integer >=0;
var cte_burst_without_tiling_TC2_for_A integer >= 0 <= 10;
var is_tc2_burst_witout_tiling_for_A binary;
var cte_41 integer >=0;
var cte_burst_without_tiling_TC5_for_A integer >= 0 <= 10;
var is_tc5_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_42 integer >=0;
var cte_43 integer >=0;
var burst_A_is_4 binary;
var cte_44 integer >=0;
var cte_45 integer >=0;
var burst_A_is_8 binary;
var cte_46 integer >=0;
var cte_47 integer >=0;
var burst_A_is_16 binary;
var cte_48 integer >=0;
var cte_49 integer >=0;
var footprint_tot_q_FT1 integer >= 1;
var burst_q integer >= 0;
var footprint_tot_s_FT0 integer >= 1;
var burst_s integer >= 0;
var footprint_tot_r_FT0 integer >= 1;
var burst_r integer >= 0;
var footprint_tot_p_FT1 integer >= 1;
var burst_p integer >= 0;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var footprint_tot_A_FT1 integer >= 1;
var Lat_comp_0_1 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var cte_tiling_2 integer >= 0;
var cte_tiling_3 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Fuse [2, 3]
#comment: Task 1 writes s to off-chip
#comment: Task 3 writes q to off-chip
#comment: Statement 0: s[j] = 0.0;
#comment: Statement 1: s[j] = s[j] + r[i] * A[i][j];
#comment: Statement 2: q[i] = 0.0;
#comment: Statement 3: q[i] = q[i] + A[i][j] * p[j];
#comment: Loop_0: j
#comment: Loop_1: i
#comment: Loop_2: j
#comment: Loop_3: i
#comment: Loop_4: i
#comment: Loop_5: j
#comment: Argument 0: float A[410][390]
#comment: Argument 1: float s[390]
#comment: Argument 2: float q[410]
#comment: Argument 3: float p[390]
#comment: Argument 4: float r[410]
#comment:  1 is a reduction loop
#comment:  5 is a reduction loop
#comment: Task 1 reads r from off-chip
#comment: Task 3 reads p from off-chip
#comment: Task 1 reads A from off-chip
#comment: Task 3 reads A from off-chip
#comment: Array q has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array q has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array q has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array q has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array s has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array s has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array s has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array s has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array r has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array p has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array A has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array A has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC5 (ori=TC5_ori) arg0
#comment: Array A has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array A has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC5 (ori=TC5_ori) arg0
#comment: Sched 0 has reuse buffer s[TC0_1]
#comment: Sched 1 has reuse buffer s[TC2_1]
#comment: Sched 1 has reuse buffer r[TC1_1]
#comment: Sched 1 has reuse buffer A[TC1_1][TC2_1]
#comment: Sched 2 has reuse buffer q[TC3_1]
#comment: Sched 3 has reuse buffer q[TC4_1]
#comment: Sched 3 has reuse buffer A[TC4_1][TC5_1]
#comment: Sched 3 has reuse buffer p[TC5_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: is_fused_task1_in_SLR_0 = 1; # only one SLR for fused task 1
subject to con3: perm0_S0 = 1; # only one permutation
subject to con4: perm0_S1 + perm1_S1 = 1; # only one permutation
subject to con5: perm0_S2 = 1; # only one permutation
subject to con6: perm0_S3 + perm1_S3 = 1; # only one permutation
subject to con7: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con8: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC1_1)/log(2); # latency of the intra-tile S1
subject to con9: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con10: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC5_1)/log(2); # latency of the intra-tile S3
subject to con11: perm0_S1 = 0; # because of the fused task 0
subject to con12: perm1_S3 = 0; # because of the fused task 1
subject to con13: perm0_S0 = perm1_S1; # same iteration of output in FT 0
subject to con14: perm0_S2 = perm0_S3; # same iteration of output in FT 1
subject to con15: is_fused_task0_in_SLR_0 * (footprint_s_S0_S1_reuse + footprint_r_S1_reuse + footprint_A_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_A_S3_reuse + footprint_q_S2_S3_reuse + footprint_p_S3_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con16: level_reuse_s_FT0_under0 = level_transfer_s_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con17: level_reuse_s_FT0_under1 = 1; # transfer innermost for output
subject to con18: level_reuse_s_FT0_under1 = level_transfer_s_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con19: level_transfer_s_FT0_under0 + level_transfer_s_FT0_under1 = 1; # only one level of transfer for s
subject to con20: level_reuse_s_FT0_under0 + level_reuse_s_FT0_under1 = 1; # only one level of reuse for s
subject to con21: level_reuse_s_FT0_under0 >= level_transfer_s_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con22: level_reuse_s_FT0_under0 + level_reuse_s_FT0_under1 >= level_transfer_s_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con23: level_reuse_r_FT0_under0 = level_transfer_r_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con24: level_reuse_r_FT0_under1 = level_transfer_r_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con25: level_transfer_r_FT0_under0 + level_transfer_r_FT0_under1 = 1; # only one level of transfer for r
subject to con26: level_reuse_r_FT0_under0 + level_reuse_r_FT0_under1 = 1; # only one level of reuse for r
subject to con27: level_reuse_A_FT0_under0 = level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con28: level_reuse_A_FT0_under1 = level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con29: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 = 1; # only one level of transfer for A
subject to con30: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 = 1; # only one level of reuse for A
subject to con31: Lat_comp_fused_S0_S1_2 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC1_0)); # latency of the fused task S0_S1 level 2
subject to con32: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_s_FT0_under1 * footprint_s_S0_S1 / burst_s, level_transfer_r_FT0_under1 * footprint_r_S1 / burst_r, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A) + Lat_comp_fused_S0_S1_2 + max(level_transfer_s_FT0_under1 * footprint_s_S0_S1 / burst_s, level_transfer_r_FT0_under1 * footprint_r_S1 / burst_r, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A  + level_transfer_s_FT0_under1 * footprint_s_S0_S1 / burst_s); # latency of the fused task S0_S1 level 1
subject to con33: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_s_FT0_under0 * footprint_tot_s_FT0 / burst_s + level_transfer_r_FT0_under0 * footprint_tot_r_FT0 / burst_r + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A; # latency of the fused task S0_S1
subject to con34: level_reuse_q_FT1_under0 = level_transfer_q_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con35: level_reuse_q_FT1_under1 = 1; # transfer innermost for output
subject to con36: level_reuse_q_FT1_under1 = level_transfer_q_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con37: level_transfer_q_FT1_under0 + level_transfer_q_FT1_under1 = 1; # only one level of transfer for q
subject to con38: level_reuse_q_FT1_under0 + level_reuse_q_FT1_under1 = 1; # only one level of reuse for q
subject to con39: level_reuse_q_FT1_under0 = level_transfer_q_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con40: level_reuse_q_FT1_under1 = level_transfer_q_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con41: level_reuse_A_FT1_under0 = level_transfer_A_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con42: level_reuse_A_FT1_under1 = level_transfer_A_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con43: level_transfer_A_FT1_under0 + level_transfer_A_FT1_under1 = 1; # only one level of transfer for A
subject to con44: level_reuse_A_FT1_under0 + level_reuse_A_FT1_under1 = 1; # only one level of reuse for A
subject to con45: level_reuse_p_FT1_under0 >= level_transfer_p_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con46: level_reuse_p_FT1_under0 + level_reuse_p_FT1_under1 >= level_transfer_p_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con47: level_transfer_p_FT1_under0 + level_transfer_p_FT1_under1 = 1; # only one level of transfer for p
subject to con48: level_reuse_p_FT1_under0 + level_reuse_p_FT1_under1 = 1; # only one level of reuse for p
subject to con49: Lat_comp_fused_S2_S3_2 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC5_0)); # latency of the fused task S2_S3 level 2
subject to con50: Lat_comp_fused_S2_S3_1 = (perm0_S2 * TC3_0) * max(Lat_comp_fused_S2_S3_2, level_transfer_q_FT1_under1 * footprint_q_S2_S3 / burst_q, level_transfer_A_FT1_under1 * footprint_A_S3 / burst_A, level_transfer_p_FT1_under1 * footprint_p_S3 / burst_p) + Lat_comp_fused_S2_S3_2 + max(level_transfer_q_FT1_under1 * footprint_q_S2_S3 / burst_q, level_transfer_A_FT1_under1 * footprint_A_S3 / burst_A, level_transfer_p_FT1_under1 * footprint_p_S3 / burst_p  + level_transfer_q_FT1_under1 * footprint_q_S2_S3 / burst_q); # latency of the fused task S2_S3 level 1
subject to con51: Lat_comp_fused_S2_S3 = Lat_comp_fused_S2_S3_1 + level_transfer_q_FT1_under0 * footprint_tot_q_FT1 / burst_q + level_transfer_A_FT1_under0 * footprint_tot_A_FT1 / burst_A + level_transfer_p_FT1_under0 * footprint_tot_p_FT1 / burst_p; # latency of the fused task S2_S3
subject to con52: footprint_s_S0_S1 = level_transfer_s_FT0_under0 * footprint_tot_s_FT0 + level_transfer_s_FT0_under1 * (perm0_S0 * footprint_tot_s_FT0/ TC0_0); # footprint of the array s for the fused task 0
subject to con53: footprint_s_S0_S1_reuse = level_reuse_s_FT0_under0 * footprint_tot_s_FT0 + level_reuse_s_FT0_under1 * (perm0_S0 * footprint_tot_s_FT0/ TC0_0); # footprint of the array s for the fused task 0
subject to con54: perm1_S1 * level_transfer_r_FT0_under1 = 0; # useless to transfer under this loop
subject to con55: perm1_S1 * level_reuse_r_FT0_under1 = 0; # useless to reuse under this loop
subject to con56: footprint_r_S1 = level_transfer_r_FT0_under0 * footprint_tot_r_FT0 + level_transfer_r_FT0_under1 * (perm0_S1 * footprint_tot_r_FT0/ TC1_0 + perm1_S1 * footprint_tot_r_FT0); # footprint of the array r for the fused task 0
subject to con57: footprint_r_S1_reuse = level_reuse_r_FT0_under0 * footprint_tot_r_FT0 + level_reuse_r_FT0_under1 * (perm0_S1 * footprint_tot_r_FT0/ TC1_0 + perm1_S1 * footprint_tot_r_FT0); # footprint of the array r for the fused task 0
subject to con58: footprint_A_S1 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con59: footprint_A_S1_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con60: footprint_q_S2_S3 = level_transfer_q_FT1_under0 * footprint_tot_q_FT1 + level_transfer_q_FT1_under1 * (perm0_S2 * footprint_tot_q_FT1/ TC3_0); # footprint of the array q for the fused task 1
subject to con61: footprint_q_S2_S3_reuse = level_reuse_q_FT1_under0 * footprint_tot_q_FT1 + level_reuse_q_FT1_under1 * (perm0_S2 * footprint_tot_q_FT1/ TC3_0); # footprint of the array q for the fused task 1
subject to con62: footprint_A_S3 = level_transfer_A_FT1_under0 * footprint_tot_A_FT1 + level_transfer_A_FT1_under1 * (perm0_S3 * footprint_tot_A_FT1/ TC4_0 + perm1_S3 * footprint_tot_A_FT1/ TC5_0); # footprint of the array A for the fused task 1
subject to con63: footprint_A_S3_reuse = level_reuse_A_FT1_under0 * footprint_tot_A_FT1 + level_reuse_A_FT1_under1 * (perm0_S3 * footprint_tot_A_FT1/ TC4_0 + perm1_S3 * footprint_tot_A_FT1/ TC5_0); # footprint of the array A for the fused task 1
subject to con64: perm0_S3 * level_transfer_p_FT1_under1 = 0; # useless to transfer under this loop
subject to con65: perm0_S3 * level_reuse_p_FT1_under1 = 0; # useless to reuse under this loop
subject to con66: footprint_p_S3 = level_transfer_p_FT1_under0 * footprint_tot_p_FT1 + level_transfer_p_FT1_under1 * (perm0_S3 * footprint_tot_p_FT1 + perm1_S3 * footprint_tot_p_FT1/ TC5_0); # footprint of the array p for the fused task 1
subject to con67: footprint_p_S3_reuse = level_reuse_p_FT1_under0 * footprint_tot_p_FT1 + level_reuse_p_FT1_under1 * (perm0_S3 * footprint_tot_p_FT1 + perm1_S3 * footprint_tot_p_FT1/ TC5_0); # footprint of the array p for the fused task 1
subject to con68: shift_0_to_1 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC1_0 + footprint_s_S0_S1) * 1;
subject to con69: TC0_1 <= MAX_UF;
subject to con70: TC1_1 * TC2_1 <= MAX_UF;
subject to con71: TC3_1 <= MAX_UF;
subject to con72: TC4_1 * TC5_1 <= MAX_UF;
subject to con73: TC0_1 * DSP_S0  + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq + TC3_1 * DSP_S2  + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq <= DSP_avail; # DSP constraint
subject to con74: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * DSP_S0 + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC3_1 * DSP_S2 + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con75: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con76: TC0_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array s 
subject to con77: TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array s 
subject to con78: TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array r 
subject to con79: TC1_1 * TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con80: TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array q 
subject to con81: TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array q 
subject to con82: TC4_1 * TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con83: TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array p 
subject to con84: Lat_comp_S3_for_off_chip = perm0_S3 * TC5_0 * II_S3_seq + perm1_S3 * TC5_0 * TC4_0 * II_S3_par; # stall between task
subject to con85: TC0_0 <= TC0; # TC of split loop
subject to con86: TC0_1 <= TC0; # TC of split loop
subject to con87: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con88: TC1_0 <= TC1; # TC of split loop
subject to con89: TC1_1 <= TC1; # TC of split loop
subject to con90: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con91: TC2_0 <= TC2; # TC of split loop
subject to con92: TC2_1 <= TC2; # TC of split loop
subject to con93: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con94: TC3_0 <= TC3; # TC of split loop
subject to con95: TC3_1 <= TC3; # TC of split loop
subject to con96: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con97: TC4_0 <= TC4; # TC of split loop
subject to con98: TC4_1 <= TC4; # TC of split loop
subject to con99: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con100: TC5_0 <= TC5; # TC of split loop
subject to con101: TC5_1 <= TC5; # TC of split loop
subject to con102: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con103: TC3_1 = TC4_1; # same intra tile for the same dimension of the array q in the fused task
subject to con104: TC0_1 = TC2_1; # same intra tile for the same dimension of the array s in the fused task
subject to con105: q_is_fully_transfered_on_last_dim_FT1 = level_transfer_q_FT1_under0; # the array q is fully transfered on the last dimension
subject to con106: q_is_fully_transfered_on_last_dim_FT1 = level_transfer_q_FT1_under0 + perm1_S3 * (level_transfer_q_FT1_under1); # the array q is fully transfered on the last dimension
subject to con107: burst_q_is_1 * cte_0 * 1 = burst_q_is_1 * ((1-is_tc3_burst_witout_tiling_for_q) * (TC3_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC3 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC3_for_q + TC3));
subject to con108: is_tc3_burst_witout_tiling_for_q =  min(1, cte_burst_without_tiling_TC3_for_q);
subject to con109: burst_q_is_1 * cte_1 * 1 = burst_q_is_1 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con110: is_tc4_burst_witout_tiling_for_q =  min(1, cte_burst_without_tiling_TC4_for_q);
subject to con111: burst_q_is_1 * cte_2 * 1 = burst_q_is_1 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con112: burst_q_is_2 * cte_3 * 2 = burst_q_is_2 * ((1-is_tc3_burst_witout_tiling_for_q) * (TC3_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC3 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC3_for_q + TC3));
subject to con113: burst_q_is_2 * cte_4 * 2 = burst_q_is_2 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con114: burst_q_is_2 * cte_5 * 2 = burst_q_is_2 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con115: burst_q_is_4 * cte_6 * 4 = burst_q_is_4 * ((1-is_tc3_burst_witout_tiling_for_q) * (TC3_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC3 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC3_for_q + TC3));
subject to con116: burst_q_is_4 * cte_7 * 4 = burst_q_is_4 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con117: burst_q_is_4 * cte_8 * 4 = burst_q_is_4 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con118: burst_q_is_8 * cte_9 * 8 = burst_q_is_8 * ((1-is_tc3_burst_witout_tiling_for_q) * (TC3_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC3 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC3_for_q + TC3));
subject to con119: burst_q_is_8 * cte_10 * 8 = burst_q_is_8 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con120: burst_q_is_8 * cte_11 * 8 = burst_q_is_8 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con121: burst_q_is_16 * cte_12 * 16 = burst_q_is_16 * ((1-is_tc3_burst_witout_tiling_for_q) * (TC3_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC3 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC3_for_q + TC3));
subject to con122: burst_q_is_16 * cte_13 * 16 = burst_q_is_16 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con123: burst_q_is_16 * cte_14 * 16 = burst_q_is_16 * ((1-is_tc4_burst_witout_tiling_for_q) * (TC4_1 * (1-q_is_fully_transfered_on_last_dim_FT1) + TC4 * (q_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_q * (cte_burst_without_tiling_TC4_for_q + TC4));
subject to con124: burst_q = burst_q_is_1 * 1 + burst_q_is_2 * 2 + burst_q_is_4 * 4 + burst_q_is_8 * 8 + burst_q_is_16 * 16; # burst size of the array q
subject to con125: burst_q_is_1 + burst_q_is_2 + burst_q_is_4 + burst_q_is_8 + burst_q_is_16 = 1; # only one burst size for the array q
subject to con126: is_tc3_burst_witout_tiling_for_q <= q_is_fully_transfered_on_last_dim_FT1;
subject to con127: is_tc4_burst_witout_tiling_for_q <= q_is_fully_transfered_on_last_dim_FT1;
subject to con128: s_is_fully_transfered_on_last_dim_FT0 = level_transfer_s_FT0_under0; # the array s is fully transfered on the last dimension
subject to con129: s_is_fully_transfered_on_last_dim_FT0 = level_transfer_s_FT0_under0 + perm0_S1 * (level_transfer_s_FT0_under1); # the array s is fully transfered on the last dimension
subject to con130: burst_s_is_1 * cte_15 * 1 = burst_s_is_1 * ((1-is_tc0_burst_witout_tiling_for_s) * (TC0_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC0 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC0_for_s + TC0));
subject to con131: is_tc0_burst_witout_tiling_for_s =  min(1, cte_burst_without_tiling_TC0_for_s);
subject to con132: burst_s_is_1 * cte_16 * 1 = burst_s_is_1 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con133: is_tc2_burst_witout_tiling_for_s =  min(1, cte_burst_without_tiling_TC2_for_s);
subject to con134: burst_s_is_1 * cte_17 * 1 = burst_s_is_1 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con135: burst_s_is_2 * cte_18 * 2 = burst_s_is_2 * ((1-is_tc0_burst_witout_tiling_for_s) * (TC0_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC0 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC0_for_s + TC0));
subject to con136: burst_s_is_2 * cte_19 * 2 = burst_s_is_2 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con137: burst_s_is_2 * cte_20 * 2 = burst_s_is_2 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con138: burst_s_is_4 * cte_21 * 4 = burst_s_is_4 * ((1-is_tc0_burst_witout_tiling_for_s) * (TC0_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC0 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC0_for_s + TC0));
subject to con139: burst_s_is_4 * cte_22 * 4 = burst_s_is_4 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con140: burst_s_is_4 * cte_23 * 4 = burst_s_is_4 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con141: burst_s_is_8 * cte_24 * 8 = burst_s_is_8 * ((1-is_tc0_burst_witout_tiling_for_s) * (TC0_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC0 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC0_for_s + TC0));
subject to con142: burst_s_is_8 * cte_25 * 8 = burst_s_is_8 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con143: burst_s_is_8 * cte_26 * 8 = burst_s_is_8 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con144: burst_s_is_16 * cte_27 * 16 = burst_s_is_16 * ((1-is_tc0_burst_witout_tiling_for_s) * (TC0_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC0 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC0_for_s + TC0));
subject to con145: burst_s_is_16 * cte_28 * 16 = burst_s_is_16 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con146: burst_s_is_16 * cte_29 * 16 = burst_s_is_16 * ((1-is_tc2_burst_witout_tiling_for_s) * (TC2_1 * (1-s_is_fully_transfered_on_last_dim_FT0) + TC2 * (s_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_s * (cte_burst_without_tiling_TC2_for_s + TC2));
subject to con147: burst_s = burst_s_is_1 * 1 + burst_s_is_2 * 2 + burst_s_is_4 * 4 + burst_s_is_8 * 8 + burst_s_is_16 * 16; # burst size of the array s
subject to con148: burst_s_is_1 + burst_s_is_2 + burst_s_is_4 + burst_s_is_8 + burst_s_is_16 = 1; # only one burst size for the array s
subject to con149: is_tc0_burst_witout_tiling_for_s <= s_is_fully_transfered_on_last_dim_FT0;
subject to con150: is_tc2_burst_witout_tiling_for_s <= s_is_fully_transfered_on_last_dim_FT0;
subject to con151: r_is_fully_transfered_on_last_dim_FT0 = level_transfer_r_FT0_under0 + perm1_S1 * (level_transfer_r_FT0_under1); # the array r is fully transfered on the last dimension
subject to con152: burst_r_is_1 * cte_30 * 1 = burst_r_is_1 * ((1-is_tc1_burst_witout_tiling_for_r) * (TC1_1 * (1-r_is_fully_transfered_on_last_dim_FT0) + TC1 * (r_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC1_for_r + TC1));
subject to con153: is_tc1_burst_witout_tiling_for_r =  min(1, cte_burst_without_tiling_TC1_for_r);
subject to con154: burst_r_is_2 * cte_31 * 2 = burst_r_is_2 * ((1-is_tc1_burst_witout_tiling_for_r) * (TC1_1 * (1-r_is_fully_transfered_on_last_dim_FT0) + TC1 * (r_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC1_for_r + TC1));
subject to con155: burst_r_is_4 * cte_32 * 4 = burst_r_is_4 * ((1-is_tc1_burst_witout_tiling_for_r) * (TC1_1 * (1-r_is_fully_transfered_on_last_dim_FT0) + TC1 * (r_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC1_for_r + TC1));
subject to con156: burst_r_is_8 * cte_33 * 8 = burst_r_is_8 * ((1-is_tc1_burst_witout_tiling_for_r) * (TC1_1 * (1-r_is_fully_transfered_on_last_dim_FT0) + TC1 * (r_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC1_for_r + TC1));
subject to con157: burst_r_is_16 * cte_34 * 16 = burst_r_is_16 * ((1-is_tc1_burst_witout_tiling_for_r) * (TC1_1 * (1-r_is_fully_transfered_on_last_dim_FT0) + TC1 * (r_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC1_for_r + TC1));
subject to con158: burst_r = burst_r_is_1 * 1 + burst_r_is_2 * 2 + burst_r_is_4 * 4 + burst_r_is_8 * 8 + burst_r_is_16 * 16; # burst size of the array r
subject to con159: burst_r_is_1 + burst_r_is_2 + burst_r_is_4 + burst_r_is_8 + burst_r_is_16 = 1; # only one burst size for the array r
subject to con160: is_tc1_burst_witout_tiling_for_r <= r_is_fully_transfered_on_last_dim_FT0;
subject to con161: p_is_fully_transfered_on_last_dim_FT1 = level_transfer_p_FT1_under0 + perm0_S3 * (level_transfer_p_FT1_under1); # the array p is fully transfered on the last dimension
subject to con162: burst_p_is_1 * cte_35 * 1 = burst_p_is_1 * ((1-is_tc5_burst_witout_tiling_for_p) * (TC5_1 * (1-p_is_fully_transfered_on_last_dim_FT1) + TC5 * (p_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_p * (cte_burst_without_tiling_TC5_for_p + TC5));
subject to con163: is_tc5_burst_witout_tiling_for_p =  min(1, cte_burst_without_tiling_TC5_for_p);
subject to con164: burst_p_is_2 * cte_36 * 2 = burst_p_is_2 * ((1-is_tc5_burst_witout_tiling_for_p) * (TC5_1 * (1-p_is_fully_transfered_on_last_dim_FT1) + TC5 * (p_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_p * (cte_burst_without_tiling_TC5_for_p + TC5));
subject to con165: burst_p_is_4 * cte_37 * 4 = burst_p_is_4 * ((1-is_tc5_burst_witout_tiling_for_p) * (TC5_1 * (1-p_is_fully_transfered_on_last_dim_FT1) + TC5 * (p_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_p * (cte_burst_without_tiling_TC5_for_p + TC5));
subject to con166: burst_p_is_8 * cte_38 * 8 = burst_p_is_8 * ((1-is_tc5_burst_witout_tiling_for_p) * (TC5_1 * (1-p_is_fully_transfered_on_last_dim_FT1) + TC5 * (p_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_p * (cte_burst_without_tiling_TC5_for_p + TC5));
subject to con167: burst_p_is_16 * cte_39 * 16 = burst_p_is_16 * ((1-is_tc5_burst_witout_tiling_for_p) * (TC5_1 * (1-p_is_fully_transfered_on_last_dim_FT1) + TC5 * (p_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_p * (cte_burst_without_tiling_TC5_for_p + TC5));
subject to con168: burst_p = burst_p_is_1 * 1 + burst_p_is_2 * 2 + burst_p_is_4 * 4 + burst_p_is_8 * 8 + burst_p_is_16 * 16; # burst size of the array p
subject to con169: burst_p_is_1 + burst_p_is_2 + burst_p_is_4 + burst_p_is_8 + burst_p_is_16 = 1; # only one burst size for the array p
subject to con170: is_tc5_burst_witout_tiling_for_p <= p_is_fully_transfered_on_last_dim_FT1;
subject to con171: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm0_S1 * (level_transfer_A_FT0_under1); # the array A is fully transfered on the last dimension
subject to con172: A_is_fully_transfered_on_last_dim_FT1 = level_transfer_A_FT1_under0 + perm0_S3 * (level_transfer_A_FT1_under1); # the array A is fully transfered on the last dimension
subject to con173: burst_A_is_1 * cte_40 * 1 = burst_A_is_1 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con174: is_tc2_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC2_for_A);
subject to con175: burst_A_is_1 * cte_41 * 1 = burst_A_is_1 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con176: is_tc5_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC5_for_A);
subject to con177: burst_A_is_2 * cte_42 * 2 = burst_A_is_2 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con178: burst_A_is_2 * cte_43 * 2 = burst_A_is_2 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con179: burst_A_is_4 * cte_44 * 4 = burst_A_is_4 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con180: burst_A_is_4 * cte_45 * 4 = burst_A_is_4 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con181: burst_A_is_8 * cte_46 * 8 = burst_A_is_8 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con182: burst_A_is_8 * cte_47 * 8 = burst_A_is_8 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con183: burst_A_is_16 * cte_48 * 16 = burst_A_is_16 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con184: burst_A_is_16 * cte_49 * 16 = burst_A_is_16 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con185: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con186: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con187: is_tc2_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con188: is_tc5_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT1;
subject to con189: footprint_tot_q_FT1 = TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_q);
subject to con190: footprint_tot_q_FT1 = TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_q);
subject to con191: footprint_tot_s_FT0 = TC0_0 * (TC0_1 + cte_burst_without_tiling_TC0_for_s);
subject to con192: footprint_tot_s_FT0 = TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_s);
subject to con193: footprint_tot_r_FT0 = TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_r);
subject to con194: footprint_tot_p_FT1 = TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_p);
subject to con195: footprint_tot_A_FT0 = TC1_ori * TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_A);
subject to con196: footprint_tot_A_FT1 = TC4_ori * TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_A);
subject to con197: obj = max(shift_0_to_1 + Lat_comp_fused_S2_S3, Lat_comp_fused_S0_S1) + 1/burst_q + 1/burst_s + 1/burst_r + 1/burst_p + 1/burst_A + 1/(is_slr0_used);
subject to con198: s_is_fully_transfered_on_last_dim_FT0 * s_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC2_1) = s_is_fully_transfered_on_last_dim_FT0 * s_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC2_1) * cte_tiling_0; # should divide for s in dim 0
subject to con199: A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC4_1) = A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC4_1) * cte_tiling_1; # should divide for A in dim 0
subject to con200: A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * max(TC2_1, TC5_1) = A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * min(TC2_1, TC5_1) * cte_tiling_2; # should divide for A in dim 1
subject to con201: q_is_fully_transfered_on_last_dim_FT1 * q_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC4_1) = q_is_fully_transfered_on_last_dim_FT1 * q_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC4_1) * cte_tiling_3; # should divide for q in dim 0
subject to con202: buffer_size = footprint_s_S0_S1_reuse + footprint_r_S1_reuse + footprint_A_S1_reuse + footprint_A_S3_reuse + footprint_q_S2_S3_reuse + footprint_p_S3_reuse; # total buffer size
subject to con203: fifo_size = 0; # total fifo size
subject to con204: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con205: perm1_S3 * level_reuse_q_FT1_under0 = perm1_S3 * 1;
subject to con206: perm0_S1 * level_reuse_s_FT0_under0 = perm0_S1 * 1;
subject to con207: perm1_S1 * level_reuse_r_FT0_under0 = perm1_S1 * 1;
subject to con208: perm0_S3 * level_reuse_p_FT1_under0 = perm0_S3 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display TC4;
display TC5;
display is_fused_task0_in_SLR_0;
display is_fused_task1_in_SLR_0;
display is_slr0_used;
display perm0_S0;
display perm0_S1;
display perm1_S1;
display perm0_S2;
display perm0_S3;
display Lat_comp_S3_for_off_chip;
display perm1_S3;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display Lat_comp_S2_intra_tile;
display Lat_comp_S3_intra_tile;
display footprint_s_S0_S1;
display footprint_s_S0_S1_reuse;
display footprint_r_S1;
display footprint_r_S1_reuse;
display footprint_A_S1;
display footprint_A_S1_reuse;
display footprint_A_S3;
display footprint_A_S3_reuse;
display footprint_q_S2_S3;
display footprint_q_S2_S3_reuse;
display footprint_p_S3;
display footprint_p_S3_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_s_FT0_under0;
display level_reuse_s_FT0_under0;
display level_transfer_s_FT0_under1;
display level_reuse_s_FT0_under1;
display level_transfer_r_FT0_under0;
display level_reuse_r_FT0_under0;
display level_transfer_r_FT0_under1;
display level_reuse_r_FT0_under1;
display level_transfer_A_FT0_under0;
display level_reuse_A_FT0_under0;
display level_transfer_A_FT0_under1;
display level_reuse_A_FT0_under1;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
display Lat_comp_fused_S2_S3;
display level_transfer_q_FT1_under0;
display level_reuse_q_FT1_under0;
display level_transfer_q_FT1_under1;
display level_reuse_q_FT1_under1;
display level_transfer_A_FT1_under0;
display level_reuse_A_FT1_under0;
display level_transfer_A_FT1_under1;
display level_reuse_A_FT1_under1;
display level_transfer_p_FT1_under0;
display level_reuse_p_FT1_under0;
display level_transfer_p_FT1_under1;
display level_reuse_p_FT1_under1;
display Lat_comp_fused_S2_S3_2;
display Lat_comp_fused_S2_S3_1;
display shift_0_to_1;
display nb_dsp_used_SLR0;
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
display q_is_fully_transfered_on_last_dim_FT1;
display burst_q_is_1;
display cte_0;
display cte_burst_without_tiling_TC3_for_q;
display is_tc3_burst_witout_tiling_for_q;
display cte_1;
display cte_burst_without_tiling_TC4_for_q;
display is_tc4_burst_witout_tiling_for_q;
display cte_2;
display burst_q_is_2;
display cte_3;
display cte_4;
display cte_5;
display burst_q_is_4;
display cte_6;
display cte_7;
display cte_8;
display burst_q_is_8;
display cte_9;
display cte_10;
display cte_11;
display burst_q_is_16;
display cte_12;
display cte_13;
display cte_14;
display s_is_fully_transfered_on_last_dim_FT0;
display burst_s_is_1;
display cte_15;
display cte_burst_without_tiling_TC0_for_s;
display is_tc0_burst_witout_tiling_for_s;
display cte_16;
display cte_burst_without_tiling_TC2_for_s;
display is_tc2_burst_witout_tiling_for_s;
display cte_17;
display burst_s_is_2;
display cte_18;
display cte_19;
display cte_20;
display burst_s_is_4;
display cte_21;
display cte_22;
display cte_23;
display burst_s_is_8;
display cte_24;
display cte_25;
display cte_26;
display burst_s_is_16;
display cte_27;
display cte_28;
display cte_29;
display r_is_fully_transfered_on_last_dim_FT0;
display burst_r_is_1;
display cte_30;
display cte_burst_without_tiling_TC1_for_r;
display is_tc1_burst_witout_tiling_for_r;
display burst_r_is_2;
display cte_31;
display burst_r_is_4;
display cte_32;
display burst_r_is_8;
display cte_33;
display burst_r_is_16;
display cte_34;
display p_is_fully_transfered_on_last_dim_FT1;
display burst_p_is_1;
display cte_35;
display cte_burst_without_tiling_TC5_for_p;
display is_tc5_burst_witout_tiling_for_p;
display burst_p_is_2;
display cte_36;
display burst_p_is_4;
display cte_37;
display burst_p_is_8;
display cte_38;
display burst_p_is_16;
display cte_39;
display A_is_fully_transfered_on_last_dim_FT0;
display A_is_fully_transfered_on_last_dim_FT1;
display burst_A_is_1;
display cte_40;
display cte_burst_without_tiling_TC2_for_A;
display is_tc2_burst_witout_tiling_for_A;
display cte_41;
display cte_burst_without_tiling_TC5_for_A;
display is_tc5_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_42;
display cte_43;
display burst_A_is_4;
display cte_44;
display cte_45;
display burst_A_is_8;
display cte_46;
display cte_47;
display burst_A_is_16;
display cte_48;
display cte_49;
display footprint_tot_q_FT1;
display burst_q;
display footprint_tot_s_FT0;
display burst_s;
display footprint_tot_r_FT0;
display burst_r;
display footprint_tot_p_FT1;
display burst_p;
display footprint_tot_A_FT0;
display burst_A;
display footprint_tot_A_FT1;
display Lat_comp_0_1;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display cte_tiling_2;
display cte_tiling_3;
display buffer_size;
display fifo_size;
display _total_solve_time;
