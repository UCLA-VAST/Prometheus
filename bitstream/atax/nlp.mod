#option solver baron;
#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';
option solver gurobi;
option gurobi_options 'lim:time=1800 tech:logfile=gurobi.log qp:nonconvex=2';
#option solver octeract;
#option octeract_options 'max_solver_time=60';

param DSP_avail = 5414;
param ON_CHIP_MEM_SIZE = 1360687;
param MAX_BUFFER_SIZE = 2048;
param CONSTRAINT_ARRAY_PARTITIONING_VALUE = 512;
param MAX_UF = 2048;
param SLR0_mem = 453562;
param SLR0_DSP = 1804;
param SLR1_mem = 453562;
param SLR1_DSP = 1804;
param SLR2_mem = 453562;
param SLR2_DSP = 1804;
param II_S0_par = 1;
param II_S0_seq = 3;
param II_S1_par = 1;
param II_S1_seq = 3;
param II_S2_par = 1;
param II_S2_seq = 3;
param II_S3_par = 1;
param II_S3_seq = 3;
param TC0_ori = 390;
param TC1_ori = 390;
param TC2_ori = 410;
param TC3_ori = 410;
param TC4_ori = 390;
param TC5_ori = 410;
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
var TC1 integer >= 390 <= 400;
var TC2 integer >= 410 <= 416;
var TC3 integer >= 410 <= 416;
var TC4 integer >= 390 <= 400;
var TC5 integer >= 410 <= 416;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task0_in_SLR_1 binary;
var is_fused_task0_in_SLR_2 binary;
var is_fused_task1_in_SLR_0 binary;
var is_fused_task1_in_SLR_1 binary;
var is_fused_task1_in_SLR_2 binary;
var is_slr0_used binary;
var is_slr1_used binary;
var is_slr2_used binary;
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
var footprint_tmp_S0_S1 integer >= 0;
var footprint_tmp_S0_S1_reuse integer >= 0;
var footprint_A_S1 integer >= 0;
var footprint_A_S1_reuse integer >= 0;
var footprint_x_S1 integer >= 0;
var footprint_x_S1_reuse integer >= 0;
var footprint_tmp_S3 integer >= 0;
var footprint_tmp_S3_reuse integer >= 0;
var footprint_A_S3 integer >= 0;
var footprint_A_S3_reuse integer >= 0;
var footprint_y_S2_S3 integer >= 0;
var footprint_y_S2_S3_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_tmp_FT0_under0 binary;
var level_reuse_tmp_FT0_under0 binary;
var level_transfer_tmp_FT0_under1 binary;
var level_reuse_tmp_FT0_under1 binary;
var level_transfer_A_FT0_under0 binary;
var level_reuse_A_FT0_under0 binary;
var level_transfer_A_FT0_under1 binary;
var level_reuse_A_FT0_under1 binary;
var level_transfer_x_FT0_under0 binary;
var level_reuse_x_FT0_under0 binary;
var level_transfer_x_FT0_under1 binary;
var level_reuse_x_FT0_under1 binary;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
var Lat_comp_fused_S2_S3 >= 0;
var level_transfer_y_FT1_under0 binary;
var level_reuse_y_FT1_under0 binary;
var level_transfer_y_FT1_under1 binary;
var level_reuse_y_FT1_under1 binary;
var level_transfer_A_FT1_under0 binary;
var level_reuse_A_FT1_under0 binary;
var level_transfer_A_FT1_under1 binary;
var level_reuse_A_FT1_under1 binary;
var level_transfer_tmp_FT1_under0 binary;
var level_reuse_tmp_FT1_under0 binary;
var level_transfer_tmp_FT1_under1 binary;
var level_reuse_tmp_FT1_under1 binary;
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
var A_is_fully_transfered_on_last_dim_FT0 binary;
var A_is_fully_transfered_on_last_dim_FT1 binary;
var burst_A_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC2_for_A integer >= 0 <= 6;
var is_tc2_burst_witout_tiling_for_A binary;
var cte_1 integer >=0;
var cte_burst_without_tiling_TC5_for_A integer >= 0 <= 6;
var is_tc5_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_2 integer >=0;
var cte_3 integer >=0;
var burst_A_is_4 binary;
var cte_4 integer >=0;
var cte_5 integer >=0;
var burst_A_is_8 binary;
var cte_6 integer >=0;
var cte_7 integer >=0;
var burst_A_is_16 binary;
var cte_8 integer >=0;
var cte_9 integer >=0;
var x_is_fully_transfered_on_last_dim_FT0 binary;
var burst_x_is_1 binary;
var cte_10 integer >=0;
var cte_burst_without_tiling_TC2_for_x integer >= 0 <= 6;
var is_tc2_burst_witout_tiling_for_x binary;
var burst_x_is_2 binary;
var cte_11 integer >=0;
var burst_x_is_4 binary;
var cte_12 integer >=0;
var burst_x_is_8 binary;
var cte_13 integer >=0;
var burst_x_is_16 binary;
var cte_14 integer >=0;
var y_is_fully_transfered_on_last_dim_FT1 binary;
var burst_y_is_1 binary;
var cte_15 integer >=0;
var cte_burst_without_tiling_TC3_for_y integer >= 0 <= 6;
var is_tc3_burst_witout_tiling_for_y binary;
var cte_16 integer >=0;
var cte_burst_without_tiling_TC5_for_y integer >= 0 <= 6;
var is_tc5_burst_witout_tiling_for_y binary;
var cte_17 integer >=0;
var burst_y_is_2 binary;
var cte_18 integer >=0;
var cte_19 integer >=0;
var cte_20 integer >=0;
var burst_y_is_4 binary;
var cte_21 integer >=0;
var cte_22 integer >=0;
var cte_23 integer >=0;
var burst_y_is_8 binary;
var cte_24 integer >=0;
var cte_25 integer >=0;
var cte_26 integer >=0;
var burst_y_is_16 binary;
var cte_27 integer >=0;
var cte_28 integer >=0;
var cte_29 integer >=0;
var tmp_is_fully_transfered_on_last_dim_FT0 binary;
var tmp_is_fully_transfered_on_last_dim_FT1 binary;
var burst_tmp_is_1 binary;
var cte_30 integer >=0;
var cte_burst_without_tiling_TC0_for_tmp integer >= 0 <= 10;
var is_tc0_burst_witout_tiling_for_tmp binary;
var cte_31 integer >=0;
var cte_burst_without_tiling_TC1_for_tmp integer >= 0 <= 10;
var is_tc1_burst_witout_tiling_for_tmp binary;
var cte_32 integer >=0;
var cte_33 integer >=0;
var cte_burst_without_tiling_TC4_for_tmp integer >= 0 <= 10;
var is_tc4_burst_witout_tiling_for_tmp binary;
var burst_tmp_is_2 binary;
var cte_34 integer >=0;
var cte_35 integer >=0;
var cte_36 integer >=0;
var cte_37 integer >=0;
var burst_tmp_is_4 binary;
var cte_38 integer >=0;
var cte_39 integer >=0;
var cte_40 integer >=0;
var cte_41 integer >=0;
var burst_tmp_is_8 binary;
var cte_42 integer >=0;
var cte_43 integer >=0;
var cte_44 integer >=0;
var cte_45 integer >=0;
var burst_tmp_is_16 binary;
var cte_46 integer >=0;
var cte_47 integer >=0;
var cte_48 integer >=0;
var cte_49 integer >=0;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var footprint_tot_A_FT1 integer >= 1;
var footprint_tot_x_FT0 integer >= 1;
var burst_x integer >= 0;
var footprint_tot_y_FT1 integer >= 1;
var burst_y integer >= 0;
var footprint_tot_tmp_FT0 integer >= 1;
var burst_tmp integer >= 0;
var footprint_tot_tmp_FT1 integer >= 1;
var Lat_comp_0_1 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var cte_tiling_2 integer >= 0;
var cte_tiling_3 integer >= 0;
var cte_tiling_4 integer >= 0;
var cte_tiling_5 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Fuse [2, 3]
#comment: Task 3 writes y to off-chip
#comment: Task 1 writes tmp to off-chip
#comment: Statement 0: tmp[i] = 0.0;
#comment: Statement 1: tmp[i] = tmp[i] + A[i][j] * x[j];
#comment: Statement 2: y[j] = 0.0;
#comment: Statement 3: y[j] = y[j] + A[i][j] * tmp[i];
#comment: Loop_0: i
#comment: Loop_1: i
#comment: Loop_2: j
#comment: Loop_3: j
#comment: Loop_4: i
#comment: Loop_5: j
#comment: Argument 0: float A[390][410]
#comment: Argument 1: float x[410]
#comment: Argument 2: float y[410]
#comment: Argument 3: float tmp[390]
#comment: Task 1 gives tmp to Task 3
#comment: Task 3 received tmp from Task 1
#comment:  2 is a reduction loop
#comment:  4 is a reduction loop
#comment: Task 1 reads A from off-chip
#comment: Task 3 reads A from off-chip
#comment: Task 1 reads x from off-chip
#comment: Array A has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array A has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC5 (ori=TC5_ori) arg0
#comment: Array A has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array A has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC5 (ori=TC5_ori) arg0
#comment: Array x has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array y has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array y has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array y has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array y has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Sched 0 has reuse buffer tmp[TC0_1]
#comment: Sched 1 has reuse buffer tmp[TC1_1]
#comment: Sched 1 has reuse buffer A[TC1_1][TC2_1]
#comment: Sched 1 has reuse buffer x[TC2_1]
#comment: Sched 2 has reuse buffer y[TC3_1]
#comment: Sched 3 has reuse buffer y[TC5_1]
#comment: Sched 3 has reuse buffer A[TC4_1][TC5_1]
#comment: Sched 3 has reuse buffer tmp[TC4_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_slr1_used = min(1,is_fused_task0_in_SLR_1 + is_fused_task1_in_SLR_1);
subject to con2: is_slr2_used = min(1,is_fused_task0_in_SLR_2 + is_fused_task1_in_SLR_2);
subject to con3: is_fused_task0_in_SLR_0 + is_fused_task0_in_SLR_1 + is_fused_task0_in_SLR_2 = 1; # only one SLR for fused task 0
subject to con4: is_fused_task1_in_SLR_0 + is_fused_task1_in_SLR_1 + is_fused_task1_in_SLR_2 = 1; # only one SLR for fused task 1
subject to con5: perm0_S0 = 1; # only one permutation
subject to con6: perm0_S1 + perm1_S1 = 1; # only one permutation
subject to con7: perm0_S2 = 1; # only one permutation
subject to con8: perm0_S3 + perm1_S3 = 1; # only one permutation
subject to con9: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con10: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC2_1)/log(2); # latency of the intra-tile S1
subject to con11: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con12: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC4_1)/log(2); # latency of the intra-tile S3
subject to con13: perm1_S1 = 0; # because of the fused task 0
subject to con14: perm0_S3 = 0; # because of the fused task 1
subject to con15: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con16: perm0_S2 = perm1_S3; # same iteration of output in FT 1
subject to con17: is_fused_task0_in_SLR_0 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_x_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_tmp_S3_reuse + footprint_A_S3_reuse + footprint_y_S2_S3_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con18: is_fused_task0_in_SLR_1 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_x_S1_reuse) + is_fused_task1_in_SLR_1 * (footprint_tmp_S3_reuse + footprint_A_S3_reuse + footprint_y_S2_S3_reuse) <= SLR1_mem; # memory constraint per SLR
subject to con19: is_fused_task0_in_SLR_2 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_x_S1_reuse) + is_fused_task1_in_SLR_2 * (footprint_tmp_S3_reuse + footprint_A_S3_reuse + footprint_y_S2_S3_reuse) <= SLR2_mem; # memory constraint per SLR
subject to con20: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con21: level_reuse_tmp_FT0_under1 = 1; # transfer innermost for output
subject to con22: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con23: level_transfer_tmp_FT0_under0 + level_transfer_tmp_FT0_under1 = 1; # only one level of transfer for tmp
subject to con24: level_reuse_tmp_FT0_under0 + level_reuse_tmp_FT0_under1 = 1; # only one level of reuse for tmp
subject to con25: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con26: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con27: level_reuse_A_FT0_under0 = level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con28: level_reuse_A_FT0_under1 = level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con29: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 = 1; # only one level of transfer for A
subject to con30: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 = 1; # only one level of reuse for A
subject to con31: level_reuse_x_FT0_under0 >= level_transfer_x_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con32: level_reuse_x_FT0_under0 + level_reuse_x_FT0_under1 >= level_transfer_x_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con33: level_transfer_x_FT0_under0 + level_transfer_x_FT0_under1 = 1; # only one level of transfer for x
subject to con34: level_reuse_x_FT0_under0 + level_reuse_x_FT0_under1 = 1; # only one level of reuse for x
subject to con35: Lat_comp_fused_S0_S1_2 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC2_0)); # latency of the fused task S0_S1 level 2
subject to con36: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_x_FT0_under1 * footprint_x_S1 / burst_x) + Lat_comp_fused_S0_S1_2 + max(level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_x_FT0_under1 * footprint_x_S1 / burst_x  + level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 1
subject to con37: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 / burst_tmp + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A + level_transfer_x_FT0_under0 * footprint_tot_x_FT0 / burst_x; # latency of the fused task S0_S1
subject to con38: level_reuse_y_FT1_under0 = level_transfer_y_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con39: level_reuse_y_FT1_under1 = 1; # transfer innermost for output
subject to con40: level_reuse_y_FT1_under1 = level_transfer_y_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con41: level_transfer_y_FT1_under0 + level_transfer_y_FT1_under1 = 1; # only one level of transfer for y
subject to con42: level_reuse_y_FT1_under0 + level_reuse_y_FT1_under1 = 1; # only one level of reuse for y
subject to con43: level_reuse_y_FT1_under0 >= level_transfer_y_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con44: level_reuse_y_FT1_under0 + level_reuse_y_FT1_under1 >= level_transfer_y_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con45: level_reuse_A_FT1_under0 = level_transfer_A_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con46: level_reuse_A_FT1_under1 = level_transfer_A_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con47: level_transfer_A_FT1_under0 + level_transfer_A_FT1_under1 = 1; # only one level of transfer for A
subject to con48: level_reuse_A_FT1_under0 + level_reuse_A_FT1_under1 = 1; # only one level of reuse for A
subject to con49: level_reuse_tmp_FT1_under0 = level_transfer_tmp_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con50: level_reuse_tmp_FT1_under1 = level_transfer_tmp_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con51: level_transfer_tmp_FT1_under0 + level_transfer_tmp_FT1_under1 = 1; # only one level of transfer for tmp
subject to con52: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 = 1; # only one level of reuse for tmp
subject to con53: Lat_comp_fused_S2_S3_2 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC4_0)); # latency of the fused task S2_S3 level 2
subject to con54: Lat_comp_fused_S2_S3_1 = (perm0_S2 * TC3_0) * max(Lat_comp_fused_S2_S3_2, level_transfer_y_FT1_under1 * footprint_y_S2_S3 / burst_y, level_transfer_A_FT1_under1 * footprint_A_S3 / burst_A, level_transfer_tmp_FT1_under1 * footprint_tmp_S3 / burst_tmp) + Lat_comp_fused_S2_S3_2 + max(level_transfer_y_FT1_under1 * footprint_y_S2_S3 / burst_y, level_transfer_A_FT1_under1 * footprint_A_S3 / burst_A, level_transfer_tmp_FT1_under1 * footprint_tmp_S3 / burst_tmp  + level_transfer_y_FT1_under1 * footprint_y_S2_S3 / burst_y); # latency of the fused task S2_S3 level 1
subject to con55: Lat_comp_fused_S2_S3 = Lat_comp_fused_S2_S3_1 + level_transfer_y_FT1_under0 * footprint_tot_y_FT1 / burst_y + level_transfer_A_FT1_under0 * footprint_tot_A_FT1 / burst_A + level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 / burst_tmp; # latency of the fused task S2_S3
subject to con56: footprint_tmp_S0_S1 = level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_transfer_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con57: footprint_tmp_S0_S1_reuse = level_reuse_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_reuse_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con58: footprint_A_S1 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con59: footprint_A_S1_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con60: perm0_S1 * level_transfer_x_FT0_under1 = 0; # useless to transfer under this loop
subject to con61: perm0_S1 * level_reuse_x_FT0_under1 = 0; # useless to reuse under this loop
subject to con62: footprint_x_S1 = level_transfer_x_FT0_under0 * footprint_tot_x_FT0 + level_transfer_x_FT0_under1 * (perm0_S1 * footprint_tot_x_FT0 + perm1_S1 * footprint_tot_x_FT0/ TC2_0); # footprint of the array x for the fused task 0
subject to con63: footprint_x_S1_reuse = level_reuse_x_FT0_under0 * footprint_tot_x_FT0 + level_reuse_x_FT0_under1 * (perm0_S1 * footprint_tot_x_FT0 + perm1_S1 * footprint_tot_x_FT0/ TC2_0); # footprint of the array x for the fused task 0
subject to con64: footprint_y_S2_S3 = level_transfer_y_FT1_under0 * footprint_tot_y_FT1 + level_transfer_y_FT1_under1 * (perm0_S2 * footprint_tot_y_FT1/ TC3_0); # footprint of the array y for the fused task 1
subject to con65: footprint_y_S2_S3_reuse = level_reuse_y_FT1_under0 * footprint_tot_y_FT1 + level_reuse_y_FT1_under1 * (perm0_S2 * footprint_tot_y_FT1/ TC3_0); # footprint of the array y for the fused task 1
subject to con66: perm1_S3 * level_transfer_tmp_FT1_under1 = 0; # useless to transfer under this loop
subject to con67: perm1_S3 * level_reuse_tmp_FT1_under1 = 0; # useless to reuse under this loop
subject to con68: footprint_tmp_S3 = level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_transfer_tmp_FT1_under1 * (perm0_S3 * footprint_tot_tmp_FT1/ TC4_0 + perm1_S3 * footprint_tot_tmp_FT1); # footprint of the array tmp for the fused task 1
subject to con69: footprint_tmp_S3_reuse = level_reuse_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_reuse_tmp_FT1_under1 * (perm0_S3 * footprint_tot_tmp_FT1/ TC4_0 + perm1_S3 * footprint_tot_tmp_FT1); # footprint of the array tmp for the fused task 1
subject to con70: footprint_A_S3 = level_transfer_A_FT1_under0 * footprint_tot_A_FT1 + level_transfer_A_FT1_under1 * (perm0_S3 * footprint_tot_A_FT1/ TC4_0 + perm1_S3 * footprint_tot_A_FT1/ TC5_0); # footprint of the array A for the fused task 1
subject to con71: footprint_A_S3_reuse = level_reuse_A_FT1_under0 * footprint_tot_A_FT1 + level_reuse_A_FT1_under1 * (perm0_S3 * footprint_tot_A_FT1/ TC4_0 + perm1_S3 * footprint_tot_A_FT1/ TC5_0); # footprint of the array A for the fused task 1
subject to con72: shift_0_to_1 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC2_0 + footprint_tmp_S0_S1) * footprint_tmp_S3 / footprint_tmp_S0_S1;
subject to con73: TC0_1 <= MAX_UF;
subject to con74: TC1_1 * TC2_1 <= MAX_UF;
subject to con75: TC3_1 <= MAX_UF;
subject to con76: TC4_1 * TC5_1 <= MAX_UF;
subject to con77: TC0_1 * DSP_S0  + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq + TC3_1 * DSP_S2  + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq <= DSP_avail; # DSP constraint
subject to con78: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * DSP_S0 + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC3_1 * DSP_S2 + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con79: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con80: nb_dsp_used_SLR1 = is_fused_task0_in_SLR_1 * (TC0_1 * DSP_S0 + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_1 * (TC3_1 * DSP_S2 + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con81: nb_dsp_used_SLR1 <= SLR1_DSP; # DSP constraint per SLR
subject to con82: nb_dsp_used_SLR2 = is_fused_task0_in_SLR_2 * (TC0_1 * DSP_S0 + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_2 * (TC3_1 * DSP_S2 + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con83: nb_dsp_used_SLR2 <= SLR2_DSP; # DSP constraint per SLR
subject to con84: TC0_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con85: TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con86: TC1_1 * TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con87: TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array x 
subject to con88: TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array y 
subject to con89: TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array y 
subject to con90: TC4_1 * TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con91: TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con92: Lat_comp_S3_for_off_chip = perm0_S3 * TC4_0 * TC5_0 * II_S3_par + perm1_S3 * TC4_0 * II_S3_seq; # stall between task
subject to con93: TC0_0 <= TC0; # TC of split loop
subject to con94: TC0_1 <= TC0; # TC of split loop
subject to con95: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con96: TC1_0 <= TC1; # TC of split loop
subject to con97: TC1_1 <= TC1; # TC of split loop
subject to con98: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con99: TC2_0 <= TC2; # TC of split loop
subject to con100: TC2_1 <= TC2; # TC of split loop
subject to con101: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con102: TC3_0 <= TC3; # TC of split loop
subject to con103: TC3_1 <= TC3; # TC of split loop
subject to con104: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con105: TC4_0 <= TC4; # TC of split loop
subject to con106: TC4_1 <= TC4; # TC of split loop
subject to con107: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con108: TC5_0 <= TC5; # TC of split loop
subject to con109: TC5_1 <= TC5; # TC of split loop
subject to con110: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con111: TC3_1 = TC5_1; # same intra tile for the same dimension of the array y in the fused task
subject to con112: TC0_1 = TC1_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con113: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm0_S1 * (level_transfer_A_FT0_under1); # the array A is fully transfered on the last dimension
subject to con114: A_is_fully_transfered_on_last_dim_FT1 = level_transfer_A_FT1_under0 + perm0_S3 * (level_transfer_A_FT1_under1); # the array A is fully transfered on the last dimension
subject to con115: burst_A_is_1 * cte_0 * 1 = burst_A_is_1 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con116: is_tc2_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC2_for_A);
subject to con117: burst_A_is_1 * cte_1 * 1 = burst_A_is_1 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con118: is_tc5_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC5_for_A);
subject to con119: burst_A_is_2 * cte_2 * 2 = burst_A_is_2 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con120: burst_A_is_2 * cte_3 * 2 = burst_A_is_2 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con121: burst_A_is_4 * cte_4 * 4 = burst_A_is_4 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con122: burst_A_is_4 * cte_5 * 4 = burst_A_is_4 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con123: burst_A_is_8 * cte_6 * 8 = burst_A_is_8 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con124: burst_A_is_8 * cte_7 * 8 = burst_A_is_8 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con125: burst_A_is_16 * cte_8 * 16 = burst_A_is_16 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con126: burst_A_is_16 * cte_9 * 16 = burst_A_is_16 * ((1-is_tc5_burst_witout_tiling_for_A) * (TC5_1 * (1-A_is_fully_transfered_on_last_dim_FT1) + TC5 * (A_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC5_for_A + TC5));
subject to con127: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con128: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con129: is_tc2_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con130: is_tc5_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT1;
subject to con131: x_is_fully_transfered_on_last_dim_FT0 = level_transfer_x_FT0_under0 + perm0_S1 * (level_transfer_x_FT0_under1); # the array x is fully transfered on the last dimension
subject to con132: burst_x_is_1 * cte_10 * 1 = burst_x_is_1 * ((1-is_tc2_burst_witout_tiling_for_x) * (TC2_1 * (1-x_is_fully_transfered_on_last_dim_FT0) + TC2 * (x_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_x * (cte_burst_without_tiling_TC2_for_x + TC2));
subject to con133: is_tc2_burst_witout_tiling_for_x =  min(1, cte_burst_without_tiling_TC2_for_x);
subject to con134: burst_x_is_2 * cte_11 * 2 = burst_x_is_2 * ((1-is_tc2_burst_witout_tiling_for_x) * (TC2_1 * (1-x_is_fully_transfered_on_last_dim_FT0) + TC2 * (x_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_x * (cte_burst_without_tiling_TC2_for_x + TC2));
subject to con135: burst_x_is_4 * cte_12 * 4 = burst_x_is_4 * ((1-is_tc2_burst_witout_tiling_for_x) * (TC2_1 * (1-x_is_fully_transfered_on_last_dim_FT0) + TC2 * (x_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_x * (cte_burst_without_tiling_TC2_for_x + TC2));
subject to con136: burst_x_is_8 * cte_13 * 8 = burst_x_is_8 * ((1-is_tc2_burst_witout_tiling_for_x) * (TC2_1 * (1-x_is_fully_transfered_on_last_dim_FT0) + TC2 * (x_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_x * (cte_burst_without_tiling_TC2_for_x + TC2));
subject to con137: burst_x_is_16 * cte_14 * 16 = burst_x_is_16 * ((1-is_tc2_burst_witout_tiling_for_x) * (TC2_1 * (1-x_is_fully_transfered_on_last_dim_FT0) + TC2 * (x_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_x * (cte_burst_without_tiling_TC2_for_x + TC2));
subject to con138: burst_x = burst_x_is_1 * 1 + burst_x_is_2 * 2 + burst_x_is_4 * 4 + burst_x_is_8 * 8 + burst_x_is_16 * 16; # burst size of the array x
subject to con139: burst_x_is_1 + burst_x_is_2 + burst_x_is_4 + burst_x_is_8 + burst_x_is_16 = 1; # only one burst size for the array x
subject to con140: is_tc2_burst_witout_tiling_for_x <= x_is_fully_transfered_on_last_dim_FT0;
subject to con141: y_is_fully_transfered_on_last_dim_FT1 = level_transfer_y_FT1_under0; # the array y is fully transfered on the last dimension
subject to con142: y_is_fully_transfered_on_last_dim_FT1 = level_transfer_y_FT1_under0 + perm0_S3 * (level_transfer_y_FT1_under1); # the array y is fully transfered on the last dimension
subject to con143: burst_y_is_1 * cte_15 * 1 = burst_y_is_1 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con144: is_tc3_burst_witout_tiling_for_y =  min(1, cte_burst_without_tiling_TC3_for_y);
subject to con145: burst_y_is_1 * cte_16 * 1 = burst_y_is_1 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con146: is_tc5_burst_witout_tiling_for_y =  min(1, cte_burst_without_tiling_TC5_for_y);
subject to con147: burst_y_is_1 * cte_17 * 1 = burst_y_is_1 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con148: burst_y_is_2 * cte_18 * 2 = burst_y_is_2 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con149: burst_y_is_2 * cte_19 * 2 = burst_y_is_2 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con150: burst_y_is_2 * cte_20 * 2 = burst_y_is_2 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con151: burst_y_is_4 * cte_21 * 4 = burst_y_is_4 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con152: burst_y_is_4 * cte_22 * 4 = burst_y_is_4 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con153: burst_y_is_4 * cte_23 * 4 = burst_y_is_4 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con154: burst_y_is_8 * cte_24 * 8 = burst_y_is_8 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con155: burst_y_is_8 * cte_25 * 8 = burst_y_is_8 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con156: burst_y_is_8 * cte_26 * 8 = burst_y_is_8 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con157: burst_y_is_16 * cte_27 * 16 = burst_y_is_16 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con158: burst_y_is_16 * cte_28 * 16 = burst_y_is_16 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con159: burst_y_is_16 * cte_29 * 16 = burst_y_is_16 * ((1-is_tc5_burst_witout_tiling_for_y) * (TC5_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC5 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC5_for_y + TC5));
subject to con160: burst_y = burst_y_is_1 * 1 + burst_y_is_2 * 2 + burst_y_is_4 * 4 + burst_y_is_8 * 8 + burst_y_is_16 * 16; # burst size of the array y
subject to con161: burst_y_is_1 + burst_y_is_2 + burst_y_is_4 + burst_y_is_8 + burst_y_is_16 = 1; # only one burst size for the array y
subject to con162: is_tc3_burst_witout_tiling_for_y <= y_is_fully_transfered_on_last_dim_FT1;
subject to con163: is_tc5_burst_witout_tiling_for_y <= y_is_fully_transfered_on_last_dim_FT1;
subject to con164: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0; # the array tmp is fully transfered on the last dimension
subject to con165: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm1_S1 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con166: tmp_is_fully_transfered_on_last_dim_FT1 = level_transfer_tmp_FT1_under0 + perm1_S3 * (level_transfer_tmp_FT1_under1); # the array tmp is fully transfered on the last dimension
subject to con167: burst_tmp_is_1 * cte_30 * 1 = burst_tmp_is_1 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con168: is_tc0_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC0_for_tmp);
subject to con169: burst_tmp_is_1 * cte_31 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con170: is_tc1_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC1_for_tmp);
subject to con171: burst_tmp_is_1 * cte_32 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con172: burst_tmp_is_1 * cte_33 * 1 = burst_tmp_is_1 * ((1-is_tc4_burst_witout_tiling_for_tmp) * (TC4_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC4 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC4_for_tmp + TC4));
subject to con173: is_tc4_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC4_for_tmp);
subject to con174: burst_tmp_is_2 * cte_34 * 2 = burst_tmp_is_2 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con175: burst_tmp_is_2 * cte_35 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con176: burst_tmp_is_2 * cte_36 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con177: burst_tmp_is_2 * cte_37 * 2 = burst_tmp_is_2 * ((1-is_tc4_burst_witout_tiling_for_tmp) * (TC4_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC4 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC4_for_tmp + TC4));
subject to con178: burst_tmp_is_4 * cte_38 * 4 = burst_tmp_is_4 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con179: burst_tmp_is_4 * cte_39 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con180: burst_tmp_is_4 * cte_40 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con181: burst_tmp_is_4 * cte_41 * 4 = burst_tmp_is_4 * ((1-is_tc4_burst_witout_tiling_for_tmp) * (TC4_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC4 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC4_for_tmp + TC4));
subject to con182: burst_tmp_is_8 * cte_42 * 8 = burst_tmp_is_8 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con183: burst_tmp_is_8 * cte_43 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con184: burst_tmp_is_8 * cte_44 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con185: burst_tmp_is_8 * cte_45 * 8 = burst_tmp_is_8 * ((1-is_tc4_burst_witout_tiling_for_tmp) * (TC4_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC4 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC4_for_tmp + TC4));
subject to con186: burst_tmp_is_16 * cte_46 * 16 = burst_tmp_is_16 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con187: burst_tmp_is_16 * cte_47 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con188: burst_tmp_is_16 * cte_48 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con189: burst_tmp_is_16 * cte_49 * 16 = burst_tmp_is_16 * ((1-is_tc4_burst_witout_tiling_for_tmp) * (TC4_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC4 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC4_for_tmp + TC4));
subject to con190: burst_tmp = burst_tmp_is_1 * 1 + burst_tmp_is_2 * 2 + burst_tmp_is_4 * 4 + burst_tmp_is_8 * 8 + burst_tmp_is_16 * 16; # burst size of the array tmp
subject to con191: burst_tmp_is_1 + burst_tmp_is_2 + burst_tmp_is_4 + burst_tmp_is_8 + burst_tmp_is_16 = 1; # only one burst size for the array tmp
subject to con192: is_tc0_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con193: is_tc1_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con194: is_tc4_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT1;
subject to con195: footprint_tot_A_FT0 = TC1_ori * TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_A);
subject to con196: footprint_tot_A_FT1 = TC4_ori * TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_A);
subject to con197: footprint_tot_x_FT0 = TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_x);
subject to con198: footprint_tot_y_FT1 = TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_y);
subject to con199: footprint_tot_y_FT1 = TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_y);
subject to con200: footprint_tot_tmp_FT0 = TC0_0 * (TC0_1 + cte_burst_without_tiling_TC0_for_tmp);
subject to con201: footprint_tot_tmp_FT0 = TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_tmp);
subject to con202: footprint_tot_tmp_FT1 = TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_tmp);
subject to con203: obj = max(shift_0_to_1 + Lat_comp_fused_S2_S3, Lat_comp_fused_S0_S1) + 1/burst_A + 1/burst_x + 1/burst_y + 1/burst_tmp + 1/(is_slr0_used + is_slr1_used + is_slr2_used);
subject to con204: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC1_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC1_1) * cte_tiling_0; # should divide for tmp in dim 0
subject to con205: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC0_1, TC4_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC0_1, TC4_1) * cte_tiling_1; # should divide for tmp in dim 0
subject to con206: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC4_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC4_1) * cte_tiling_2; # should divide for tmp in dim 0
subject to con207: A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC4_1) = A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC4_1) * cte_tiling_3; # should divide for A in dim 0
subject to con208: A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * max(TC2_1, TC5_1) = A_is_fully_transfered_on_last_dim_FT0 * A_is_fully_transfered_on_last_dim_FT1 * min(TC2_1, TC5_1) * cte_tiling_4; # should divide for A in dim 1
subject to con209: y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC5_1) = y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC5_1) * cte_tiling_5; # should divide for y in dim 0
subject to con210: buffer_size = footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_x_S1_reuse + footprint_tmp_S3_reuse + footprint_A_S3_reuse + footprint_y_S2_S3_reuse; # total buffer size
subject to con211: fifo_size = 0; # total fifo size
subject to con212: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con213: perm0_S1 * level_reuse_x_FT0_under0 = perm0_S1 * 1;
subject to con214: perm0_S3 * level_reuse_y_FT1_under0 = perm0_S3 * 1;
subject to con215: perm1_S1 * level_reuse_tmp_FT0_under0 = perm1_S1 * 1;
subject to con216: perm1_S3 * level_reuse_tmp_FT1_under0 = perm1_S3 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display TC4;
display TC5;
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
display footprint_tmp_S0_S1;
display footprint_tmp_S0_S1_reuse;
display footprint_A_S1;
display footprint_A_S1_reuse;
display footprint_x_S1;
display footprint_x_S1_reuse;
display footprint_tmp_S3;
display footprint_tmp_S3_reuse;
display footprint_A_S3;
display footprint_A_S3_reuse;
display footprint_y_S2_S3;
display footprint_y_S2_S3_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_tmp_FT0_under0;
display level_reuse_tmp_FT0_under0;
display level_transfer_tmp_FT0_under1;
display level_reuse_tmp_FT0_under1;
display level_transfer_A_FT0_under0;
display level_reuse_A_FT0_under0;
display level_transfer_A_FT0_under1;
display level_reuse_A_FT0_under1;
display level_transfer_x_FT0_under0;
display level_reuse_x_FT0_under0;
display level_transfer_x_FT0_under1;
display level_reuse_x_FT0_under1;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
display Lat_comp_fused_S2_S3;
display level_transfer_y_FT1_under0;
display level_reuse_y_FT1_under0;
display level_transfer_y_FT1_under1;
display level_reuse_y_FT1_under1;
display level_transfer_A_FT1_under0;
display level_reuse_A_FT1_under0;
display level_transfer_A_FT1_under1;
display level_reuse_A_FT1_under1;
display level_transfer_tmp_FT1_under0;
display level_reuse_tmp_FT1_under0;
display level_transfer_tmp_FT1_under1;
display level_reuse_tmp_FT1_under1;
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
display A_is_fully_transfered_on_last_dim_FT0;
display A_is_fully_transfered_on_last_dim_FT1;
display burst_A_is_1;
display cte_0;
display cte_burst_without_tiling_TC2_for_A;
display is_tc2_burst_witout_tiling_for_A;
display cte_1;
display cte_burst_without_tiling_TC5_for_A;
display is_tc5_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_2;
display cte_3;
display burst_A_is_4;
display cte_4;
display cte_5;
display burst_A_is_8;
display cte_6;
display cte_7;
display burst_A_is_16;
display cte_8;
display cte_9;
display x_is_fully_transfered_on_last_dim_FT0;
display burst_x_is_1;
display cte_10;
display cte_burst_without_tiling_TC2_for_x;
display is_tc2_burst_witout_tiling_for_x;
display burst_x_is_2;
display cte_11;
display burst_x_is_4;
display cte_12;
display burst_x_is_8;
display cte_13;
display burst_x_is_16;
display cte_14;
display y_is_fully_transfered_on_last_dim_FT1;
display burst_y_is_1;
display cte_15;
display cte_burst_without_tiling_TC3_for_y;
display is_tc3_burst_witout_tiling_for_y;
display cte_16;
display cte_burst_without_tiling_TC5_for_y;
display is_tc5_burst_witout_tiling_for_y;
display cte_17;
display burst_y_is_2;
display cte_18;
display cte_19;
display cte_20;
display burst_y_is_4;
display cte_21;
display cte_22;
display cte_23;
display burst_y_is_8;
display cte_24;
display cte_25;
display cte_26;
display burst_y_is_16;
display cte_27;
display cte_28;
display cte_29;
display tmp_is_fully_transfered_on_last_dim_FT0;
display tmp_is_fully_transfered_on_last_dim_FT1;
display burst_tmp_is_1;
display cte_30;
display cte_burst_without_tiling_TC0_for_tmp;
display is_tc0_burst_witout_tiling_for_tmp;
display cte_31;
display cte_burst_without_tiling_TC1_for_tmp;
display is_tc1_burst_witout_tiling_for_tmp;
display cte_32;
display cte_33;
display cte_burst_without_tiling_TC4_for_tmp;
display is_tc4_burst_witout_tiling_for_tmp;
display burst_tmp_is_2;
display cte_34;
display cte_35;
display cte_36;
display cte_37;
display burst_tmp_is_4;
display cte_38;
display cte_39;
display cte_40;
display cte_41;
display burst_tmp_is_8;
display cte_42;
display cte_43;
display cte_44;
display cte_45;
display burst_tmp_is_16;
display cte_46;
display cte_47;
display cte_48;
display cte_49;
display footprint_tot_A_FT0;
display burst_A;
display footprint_tot_A_FT1;
display footprint_tot_x_FT0;
display burst_x;
display footprint_tot_y_FT1;
display burst_y;
display footprint_tot_tmp_FT0;
display burst_tmp;
display footprint_tot_tmp_FT1;
display Lat_comp_0_1;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display cte_tiling_2;
display cte_tiling_3;
display cte_tiling_4;
display cte_tiling_5;
display buffer_size;
display fifo_size;
display _total_solve_time;
