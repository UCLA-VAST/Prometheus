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
param II_S4_par = 1;
param II_S4_seq = 3;
param TC0_ori = 250;
param TC1_ori = 250;
param TC2_ori = 250;
param TC3_ori = 250;
param TC4_ori = 250;
param TC5_ori = 250;
param TC6_ori = 250;
param IL_par_S0 = 1;
param IL_seq_S0 = 0;
param IL_par_S1 = 4;
param IL_seq_S1 = 7;
param IL_par_S2 = 1;
param IL_seq_S2 = 0;
param IL_par_S3 = 4;
param IL_seq_S3 = 7;
param IL_par_S4 = 15;
param IL_seq_S4 = 0;
param DSP_S0 = 0;
param DSP_S1 = 5;
param DSP_S2 = 0;
param DSP_S3 = 5;
param DSP_S4 = 8;

var TC0 integer >= 250 <= 256;
var TC1 integer >= 250 <= 256;
var TC2 integer >= 250 <= 256;
var TC3 integer >= 250 <= 256;
var TC4 integer >= 250 <= 256;
var TC5 integer >= 250 <= 256;
var TC6 integer >= 250 <= 256;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task1_in_SLR_0 binary;
var is_slr0_used binary;
var perm0_S0 binary; # [0, 0, 0, 0, 0]
var perm0_S1 binary; # [1, 1, 0, 2, 0, 1, 0, 2, 0]
var perm1_S1 binary; # [1, 2, 0, 1, 0, 2, 0, 1, 0]
var perm0_S2 binary; # [2, 3, 0, 3, 0]
var perm0_S3 binary; # [3, 4, 0, 5, 0, 4, 0, 5, 0]
var perm1_S3 binary; # [3, 5, 0, 4, 0, 5, 0, 4, 0]
var perm0_S4 binary; # [4, 6, 0, 6, 0]
var Lat_comp_S4_for_off_chip >= 0;
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var Lat_comp_S2_intra_tile >= 0;
var Lat_comp_S3_intra_tile >= 0;
var Lat_comp_S4_intra_tile >= 0;
var footprint_tmp_S0_S1 integer >= 0;
var footprint_tmp_S0_S1_reuse integer >= 0;
var footprint_A_S1 integer >= 0;
var footprint_A_S1_reuse integer >= 0;
var footprint_w_S1 integer >= 0;
var footprint_w_S1_reuse integer >= 0;
var footprint_tmp_S4 integer >= 0;
var footprint_tmp_S4_reuse integer >= 0;
var footprint_y_S2_S3_S4 integer >= 0;
var footprint_y_S2_S3_S4_reuse integer >= 0;
var footprint_B_S3 integer >= 0;
var footprint_B_S3_reuse integer >= 0;
var footprint_r_S3 integer >= 0;
var footprint_r_S3_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_tmp_FT0_under0 binary;
var level_reuse_tmp_FT0_under0 binary;
var level_transfer_tmp_FT0_under1 binary;
var level_reuse_tmp_FT0_under1 binary;
var level_transfer_A_FT0_under0 binary;
var level_reuse_A_FT0_under0 binary;
var level_transfer_A_FT0_under1 binary;
var level_reuse_A_FT0_under1 binary;
var level_transfer_w_FT0_under0 binary;
var level_reuse_w_FT0_under0 binary;
var level_transfer_w_FT0_under1 binary;
var level_reuse_w_FT0_under1 binary;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
var Lat_comp_fused_S2_S3_S4 >= 0;
var level_transfer_y_FT1_under0 binary;
var level_reuse_y_FT1_under0 binary;
var level_transfer_y_FT1_under1 binary;
var level_reuse_y_FT1_under1 binary;
var level_transfer_B_FT1_under0 binary;
var level_reuse_B_FT1_under0 binary;
var level_transfer_B_FT1_under1 binary;
var level_reuse_B_FT1_under1 binary;
var level_transfer_r_FT1_under0 binary;
var level_reuse_r_FT1_under0 binary;
var level_transfer_r_FT1_under1 binary;
var level_reuse_r_FT1_under1 binary;
var level_transfer_tmp_FT1_under0 binary;
var level_reuse_tmp_FT1_under0 binary;
var level_transfer_tmp_FT1_under1 binary;
var level_reuse_tmp_FT1_under1 binary;
var Lat_comp_fused_S2_S3_S4_2 >= 0;
var Lat_comp_fused_S2_S3_S4_1 >= 0;
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
var TC6_0 integer >= 1;
var TC6_1 integer >= 1;
var B_is_fully_transfered_on_last_dim_FT1 binary;
var burst_B_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC5_for_B integer >= 0 <= 6;
var is_tc5_burst_witout_tiling_for_B binary;
var burst_B_is_2 binary;
var cte_1 integer >=0;
var burst_B_is_4 binary;
var cte_2 integer >=0;
var burst_B_is_8 binary;
var cte_3 integer >=0;
var burst_B_is_16 binary;
var cte_4 integer >=0;
var tmp_is_fully_transfered_on_last_dim_FT0 binary;
var tmp_is_fully_transfered_on_last_dim_FT1 binary;
var burst_tmp_is_1 binary;
var cte_5 integer >=0;
var cte_burst_without_tiling_TC0_for_tmp integer >= 0 <= 6;
var is_tc0_burst_witout_tiling_for_tmp binary;
var cte_6 integer >=0;
var cte_burst_without_tiling_TC1_for_tmp integer >= 0 <= 6;
var is_tc1_burst_witout_tiling_for_tmp binary;
var cte_7 integer >=0;
var cte_8 integer >=0;
var cte_burst_without_tiling_TC6_for_tmp integer >= 0 <= 6;
var is_tc6_burst_witout_tiling_for_tmp binary;
var burst_tmp_is_2 binary;
var cte_9 integer >=0;
var cte_10 integer >=0;
var cte_11 integer >=0;
var cte_12 integer >=0;
var burst_tmp_is_4 binary;
var cte_13 integer >=0;
var cte_14 integer >=0;
var cte_15 integer >=0;
var cte_16 integer >=0;
var burst_tmp_is_8 binary;
var cte_17 integer >=0;
var cte_18 integer >=0;
var cte_19 integer >=0;
var cte_20 integer >=0;
var burst_tmp_is_16 binary;
var cte_21 integer >=0;
var cte_22 integer >=0;
var cte_23 integer >=0;
var cte_24 integer >=0;
var r_is_fully_transfered_on_last_dim_FT1 binary;
var burst_r_is_1 binary;
var cte_25 integer >=0;
var cte_burst_without_tiling_TC5_for_r integer >= 0 <= 6;
var is_tc5_burst_witout_tiling_for_r binary;
var burst_r_is_2 binary;
var cte_26 integer >=0;
var burst_r_is_4 binary;
var cte_27 integer >=0;
var burst_r_is_8 binary;
var cte_28 integer >=0;
var burst_r_is_16 binary;
var cte_29 integer >=0;
var y_is_fully_transfered_on_last_dim_FT1 binary;
var burst_y_is_1 binary;
var cte_30 integer >=0;
var cte_burst_without_tiling_TC3_for_y integer >= 0 <= 6;
var is_tc3_burst_witout_tiling_for_y binary;
var cte_31 integer >=0;
var cte_burst_without_tiling_TC4_for_y integer >= 0 <= 6;
var is_tc4_burst_witout_tiling_for_y binary;
var cte_32 integer >=0;
var cte_33 integer >=0;
var cte_burst_without_tiling_TC6_for_y integer >= 0 <= 6;
var is_tc6_burst_witout_tiling_for_y binary;
var cte_34 integer >=0;
var burst_y_is_2 binary;
var cte_35 integer >=0;
var cte_36 integer >=0;
var cte_37 integer >=0;
var cte_38 integer >=0;
var cte_39 integer >=0;
var burst_y_is_4 binary;
var cte_40 integer >=0;
var cte_41 integer >=0;
var cte_42 integer >=0;
var cte_43 integer >=0;
var cte_44 integer >=0;
var burst_y_is_8 binary;
var cte_45 integer >=0;
var cte_46 integer >=0;
var cte_47 integer >=0;
var cte_48 integer >=0;
var cte_49 integer >=0;
var burst_y_is_16 binary;
var cte_50 integer >=0;
var cte_51 integer >=0;
var cte_52 integer >=0;
var cte_53 integer >=0;
var cte_54 integer >=0;
var w_is_fully_transfered_on_last_dim_FT0 binary;
var burst_w_is_1 binary;
var cte_55 integer >=0;
var cte_burst_without_tiling_TC2_for_w integer >= 0 <= 6;
var is_tc2_burst_witout_tiling_for_w binary;
var burst_w_is_2 binary;
var cte_56 integer >=0;
var burst_w_is_4 binary;
var cte_57 integer >=0;
var burst_w_is_8 binary;
var cte_58 integer >=0;
var burst_w_is_16 binary;
var cte_59 integer >=0;
var A_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A_is_1 binary;
var cte_60 integer >=0;
var cte_burst_without_tiling_TC2_for_A integer >= 0 <= 6;
var is_tc2_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_61 integer >=0;
var burst_A_is_4 binary;
var cte_62 integer >=0;
var burst_A_is_8 binary;
var cte_63 integer >=0;
var burst_A_is_16 binary;
var cte_64 integer >=0;
var footprint_tot_B_FT1 integer >= 1;
var burst_B integer >= 0;
var footprint_tot_tmp_FT0 integer >= 1;
var burst_tmp integer >= 0;
var footprint_tot_tmp_FT1 integer >= 1;
var footprint_tot_r_FT1 integer >= 1;
var burst_r integer >= 0;
var footprint_tot_y_FT1 integer >= 1;
var burst_y integer >= 0;
var footprint_tot_w_FT0 integer >= 1;
var burst_w integer >= 0;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var Lat_comp_0_1 >= 0;
var Lat_comp_2_3 >= 0;
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
#comment: Fuse [2, 3, 4]
#comment: Task 1 writes tmp to off-chip
#comment: Task 4 writes y to off-chip
#comment: Statement 0: tmp[i] = 0.0;
#comment: Statement 1: tmp[i] += A[i][j] * w[j];
#comment: Statement 2: y[i] = 0.0;
#comment: Statement 3: y[i] += B[i][j] * r[j];
#comment: Statement 4: y[i] = y[i] * beta + alpha * tmp[i];
#comment: Loop_0: i
#comment: Loop_1: i
#comment: Loop_2: j
#comment: Loop_3: i
#comment: Loop_4: i
#comment: Loop_5: j
#comment: Loop_6: i
#comment: Argument 0: float alpha
#comment: Argument 1: float beta
#comment: Argument 2: float A[250][250]
#comment: Argument 3: float B[250][250]
#comment: Argument 4: float tmp[250]
#comment: Argument 5: float w[250]
#comment: Argument 6: float r[250]
#comment: Argument 7: float y[250]
#comment: Task 1 gives tmp to Task 4
#comment: Task 4 received tmp from Task 1
#comment:  2 is a reduction loop
#comment:  5 is a reduction loop
#comment: Task 3 reads B from off-chip
#comment: Task 3 reads r from off-chip
#comment: Task 1 reads w from off-chip
#comment: Task 1 reads A from off-chip
#comment: Array B has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array B has for tc in dim 1 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array r has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array y has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array y has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array y has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array y has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array y has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array y has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array y has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array y has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array y has for tc in dim 0 TC6 (ori=TC6_ori) arg0
#comment: Array w has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Sched 0 has reuse buffer tmp[TC0_1]
#comment: Sched 1 has reuse buffer tmp[TC1_1]
#comment: Sched 1 has reuse buffer A[TC1_1][TC2_1]
#comment: Sched 1 has reuse buffer w[TC2_1]
#comment: Sched 2 has reuse buffer y[TC3_1]
#comment: Sched 3 has reuse buffer y[TC4_1]
#comment: Sched 3 has reuse buffer B[TC4_1][TC5_1]
#comment: Sched 3 has reuse buffer r[TC5_1]
#comment: Sched 4 has reuse buffer y[TC6_1]
#comment: Sched 4 has reuse buffer tmp[TC6_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: is_fused_task1_in_SLR_0 = 1; # only one SLR for fused task 1
subject to con3: perm0_S0 = 1; # only one permutation
subject to con4: TC1_1 = TC6_1; # same tiling factor
subject to con5: TC1_1 = TC6_1; # same tiling factor
subject to con6: perm0_S1 + perm1_S1 = 1; # only one permutation
subject to con7: perm0_S2 = 1; # only one permutation
subject to con8: perm0_S3 + perm1_S3 = 1; # only one permutation
subject to con9: perm0_S4 = 1; # only one permutation
subject to con10: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con11: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC2_1)/log(2); # latency of the intra-tile S1
subject to con12: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con13: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC5_1)/log(2); # latency of the intra-tile S3
subject to con14: Lat_comp_S4_intra_tile = IL_par_S4 + IL_seq_S4; # latency of the intra-tile S4
subject to con15: perm1_S1 = 0; # because of the fused task 0
subject to con16: perm1_S3 = 0; # because of the fused task 1
subject to con17: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con18: perm0_S2 = perm0_S3; # same iteration of output in FT 1
subject to con19: perm0_S2 = perm0_S4; # same iteration of output in FT 1
subject to con20: perm0_S3 = perm0_S4; # same iteration of output in FT 1
subject to con21: is_fused_task0_in_SLR_0 * (footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_w_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_tmp_S4_reuse + footprint_y_S2_S3_S4_reuse + footprint_B_S3_reuse + footprint_r_S3_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con22: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con23: level_reuse_tmp_FT0_under1 = 1; # transfer innermost for output
subject to con24: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con25: level_transfer_tmp_FT0_under0 + level_transfer_tmp_FT0_under1 = 1; # only one level of transfer for tmp
subject to con26: level_reuse_tmp_FT0_under0 + level_reuse_tmp_FT0_under1 = 1; # only one level of reuse for tmp
subject to con27: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con28: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con29: level_reuse_A_FT0_under0 = level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con30: level_reuse_A_FT0_under1 = level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con31: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 = 1; # only one level of transfer for A
subject to con32: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 = 1; # only one level of reuse for A
subject to con33: level_reuse_w_FT0_under0 >= level_transfer_w_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con34: level_reuse_w_FT0_under0 + level_reuse_w_FT0_under1 >= level_transfer_w_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con35: level_transfer_w_FT0_under0 + level_transfer_w_FT0_under1 = 1; # only one level of transfer for w
subject to con36: level_reuse_w_FT0_under0 + level_reuse_w_FT0_under1 = 1; # only one level of reuse for w
subject to con37: Lat_comp_fused_S0_S1_2 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC2_0)); # latency of the fused task S0_S1 level 2
subject to con38: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_w_FT0_under1 * footprint_w_S1 / burst_w) + Lat_comp_fused_S0_S1_2 + max(level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_A_FT0_under1 * footprint_A_S1 / burst_A, level_transfer_w_FT0_under1 * footprint_w_S1 / burst_w  + level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 1
subject to con39: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 / burst_tmp + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A + level_transfer_w_FT0_under0 * footprint_tot_w_FT0 / burst_w; # latency of the fused task S0_S1
subject to con40: level_reuse_y_FT1_under0 = level_transfer_y_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con41: level_reuse_y_FT1_under1 = 1; # transfer innermost for output
subject to con42: level_reuse_y_FT1_under1 = level_transfer_y_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con43: level_transfer_y_FT1_under0 + level_transfer_y_FT1_under1 = 1; # only one level of transfer for y
subject to con44: level_reuse_y_FT1_under0 + level_reuse_y_FT1_under1 = 1; # only one level of reuse for y
subject to con45: level_reuse_y_FT1_under0 = level_transfer_y_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con46: level_reuse_y_FT1_under1 = level_transfer_y_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con47: level_reuse_B_FT1_under0 = level_transfer_B_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con48: level_reuse_B_FT1_under1 = level_transfer_B_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con49: level_transfer_B_FT1_under0 + level_transfer_B_FT1_under1 = 1; # only one level of transfer for B
subject to con50: level_reuse_B_FT1_under0 + level_reuse_B_FT1_under1 = 1; # only one level of reuse for B
subject to con51: level_reuse_r_FT1_under0 >= level_transfer_r_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con52: level_reuse_r_FT1_under0 + level_reuse_r_FT1_under1 >= level_transfer_r_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con53: level_transfer_r_FT1_under0 + level_transfer_r_FT1_under1 = 1; # only one level of transfer for r
subject to con54: level_reuse_r_FT1_under0 + level_reuse_r_FT1_under1 = 1; # only one level of reuse for r
subject to con55: level_reuse_y_FT1_under0 = level_transfer_y_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con56: level_reuse_y_FT1_under1 = level_transfer_y_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con57: level_reuse_tmp_FT1_under0 = level_transfer_tmp_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con58: level_reuse_tmp_FT1_under1 = level_transfer_tmp_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con59: level_transfer_tmp_FT1_under0 + level_transfer_tmp_FT1_under1 = 1; # only one level of transfer for tmp
subject to con60: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 = 1; # only one level of reuse for tmp
subject to con61: Lat_comp_fused_S2_S3_S4_2 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC5_0) + (Lat_comp_S4_intra_tile)); # latency of the fused task S2_S3_S4 level 2
subject to con62: Lat_comp_fused_S2_S3_S4_1 = (perm0_S2 * TC3_0) * max(Lat_comp_fused_S2_S3_S4_2, level_transfer_y_FT1_under1 * footprint_y_S2_S3_S4 / burst_y, level_transfer_B_FT1_under1 * footprint_B_S3 / burst_B, level_transfer_r_FT1_under1 * footprint_r_S3 / burst_r, level_transfer_tmp_FT1_under1 * footprint_tmp_S4 / burst_tmp) + Lat_comp_fused_S2_S3_S4_2 + max(level_transfer_y_FT1_under1 * footprint_y_S2_S3_S4 / burst_y, level_transfer_B_FT1_under1 * footprint_B_S3 / burst_B, level_transfer_r_FT1_under1 * footprint_r_S3 / burst_r, level_transfer_tmp_FT1_under1 * footprint_tmp_S4 / burst_tmp  + level_transfer_y_FT1_under1 * footprint_y_S2_S3_S4 / burst_y); # latency of the fused task S2_S3_S4 level 1
subject to con63: Lat_comp_fused_S2_S3_S4 = Lat_comp_fused_S2_S3_S4_1 + level_transfer_y_FT1_under0 * footprint_tot_y_FT1 / burst_y + level_transfer_B_FT1_under0 * footprint_tot_B_FT1 / burst_B + level_transfer_r_FT1_under0 * footprint_tot_r_FT1 / burst_r + level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 / burst_tmp; # latency of the fused task S2_S3_S4
subject to con64: footprint_tmp_S0_S1 = level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_transfer_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con65: footprint_tmp_S0_S1_reuse = level_reuse_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_reuse_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con66: footprint_A_S1 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con67: footprint_A_S1_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S1 * footprint_tot_A_FT0/ TC1_0 + perm1_S1 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con68: perm0_S1 * level_transfer_w_FT0_under1 = 0; # useless to transfer under this loop
subject to con69: perm0_S1 * level_reuse_w_FT0_under1 = 0; # useless to reuse under this loop
subject to con70: footprint_w_S1 = level_transfer_w_FT0_under0 * footprint_tot_w_FT0 + level_transfer_w_FT0_under1 * (perm0_S1 * footprint_tot_w_FT0 + perm1_S1 * footprint_tot_w_FT0/ TC2_0); # footprint of the array w for the fused task 0
subject to con71: footprint_w_S1_reuse = level_reuse_w_FT0_under0 * footprint_tot_w_FT0 + level_reuse_w_FT0_under1 * (perm0_S1 * footprint_tot_w_FT0 + perm1_S1 * footprint_tot_w_FT0/ TC2_0); # footprint of the array w for the fused task 0
subject to con72: footprint_y_S2_S3_S4 = level_transfer_y_FT1_under0 * footprint_tot_y_FT1 + level_transfer_y_FT1_under1 * (perm0_S2 * footprint_tot_y_FT1/ TC3_0); # footprint of the array y for the fused task 1
subject to con73: footprint_y_S2_S3_S4_reuse = level_reuse_y_FT1_under0 * footprint_tot_y_FT1 + level_reuse_y_FT1_under1 * (perm0_S2 * footprint_tot_y_FT1/ TC3_0); # footprint of the array y for the fused task 1
subject to con74: footprint_B_S3 = level_transfer_B_FT1_under0 * footprint_tot_B_FT1 + level_transfer_B_FT1_under1 * (perm0_S3 * footprint_tot_B_FT1/ TC4_0 + perm1_S3 * footprint_tot_B_FT1/ TC5_0); # footprint of the array B for the fused task 1
subject to con75: footprint_B_S3_reuse = level_reuse_B_FT1_under0 * footprint_tot_B_FT1 + level_reuse_B_FT1_under1 * (perm0_S3 * footprint_tot_B_FT1/ TC4_0 + perm1_S3 * footprint_tot_B_FT1/ TC5_0); # footprint of the array B for the fused task 1
subject to con76: perm0_S3 * level_transfer_r_FT1_under1 = 0; # useless to transfer under this loop
subject to con77: perm0_S3 * level_reuse_r_FT1_under1 = 0; # useless to reuse under this loop
subject to con78: footprint_r_S3 = level_transfer_r_FT1_under0 * footprint_tot_r_FT1 + level_transfer_r_FT1_under1 * (perm0_S3 * footprint_tot_r_FT1 + perm1_S3 * footprint_tot_r_FT1/ TC5_0); # footprint of the array r for the fused task 1
subject to con79: footprint_r_S3_reuse = level_reuse_r_FT1_under0 * footprint_tot_r_FT1 + level_reuse_r_FT1_under1 * (perm0_S3 * footprint_tot_r_FT1 + perm1_S3 * footprint_tot_r_FT1/ TC5_0); # footprint of the array r for the fused task 1
subject to con80: footprint_tmp_S4 = level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_transfer_tmp_FT1_under1 * (perm0_S4 * footprint_tot_tmp_FT1/ TC6_0); # footprint of the array tmp for the fused task 1
subject to con81: footprint_tmp_S4_reuse = level_reuse_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_reuse_tmp_FT1_under1 * (perm0_S4 * footprint_tot_tmp_FT1/ TC6_0); # footprint of the array tmp for the fused task 1
subject to con82: shift_0_to_1 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC2_0 + footprint_tmp_S0_S1) * footprint_tmp_S4 / footprint_tmp_S0_S1;
subject to con83: TC0_1 <= MAX_UF;
subject to con84: TC1_1 * TC2_1 <= MAX_UF;
subject to con85: TC3_1 <= MAX_UF;
subject to con86: TC4_1 * TC5_1 <= MAX_UF;
subject to con87: TC6_1 <= MAX_UF;
subject to con88: TC0_1 * DSP_S0  + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq + TC3_1 * DSP_S2  + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq + TC6_1 * DSP_S4  <= DSP_avail; # DSP constraint
subject to con89: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * DSP_S0 + TC1_1 * TC2_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC3_1 * DSP_S2 + TC4_1 * TC5_1 * DSP_S3 / II_S3_seq + TC6_1 * DSP_S4); # DSP constraint per SLR
subject to con90: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con91: TC0_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con92: TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con93: TC1_1 * TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con94: TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array w 
subject to con95: TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array y 
subject to con96: TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array y 
subject to con97: TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array y 
subject to con98: TC4_1 * TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con99: TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array r 
subject to con100: TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con101: Lat_comp_S4_for_off_chip = perm0_S4 * II_S4_par; # stall between task
subject to con102: TC0_0 <= TC0; # TC of split loop
subject to con103: TC0_1 <= TC0; # TC of split loop
subject to con104: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con105: TC1_0 <= TC1; # TC of split loop
subject to con106: TC1_1 <= TC1; # TC of split loop
subject to con107: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con108: TC2_0 <= TC2; # TC of split loop
subject to con109: TC2_1 <= TC2; # TC of split loop
subject to con110: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con111: TC3_0 <= TC3; # TC of split loop
subject to con112: TC3_1 <= TC3; # TC of split loop
subject to con113: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con114: TC4_0 <= TC4; # TC of split loop
subject to con115: TC4_1 <= TC4; # TC of split loop
subject to con116: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con117: TC5_0 <= TC5; # TC of split loop
subject to con118: TC5_1 <= TC5; # TC of split loop
subject to con119: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con120: TC6_0 <= TC6; # TC of split loop
subject to con121: TC6_1 <= TC6; # TC of split loop
subject to con122: TC6_0 * TC6_1 = TC6; # product of the TC of split loop = original TC
subject to con123: TC0_1 = TC1_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con124: TC3_1 = TC4_1; # same intra tile for the same dimension of the array y in the fused task
subject to con125: TC3_1 = TC6_1; # same intra tile for the same dimension of the array y in the fused task
subject to con126: TC4_1 = TC6_1; # same intra tile for the same dimension of the array y in the fused task
subject to con127: B_is_fully_transfered_on_last_dim_FT1 = level_transfer_B_FT1_under0 + perm0_S3 * (level_transfer_B_FT1_under1); # the array B is fully transfered on the last dimension
subject to con128: burst_B_is_1 * cte_0 * 1 = burst_B_is_1 * ((1-is_tc5_burst_witout_tiling_for_B) * (TC5_1 * (1-B_is_fully_transfered_on_last_dim_FT1) + TC5 * (B_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC5_for_B + TC5));
subject to con129: is_tc5_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC5_for_B);
subject to con130: burst_B_is_2 * cte_1 * 2 = burst_B_is_2 * ((1-is_tc5_burst_witout_tiling_for_B) * (TC5_1 * (1-B_is_fully_transfered_on_last_dim_FT1) + TC5 * (B_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC5_for_B + TC5));
subject to con131: burst_B_is_4 * cte_2 * 4 = burst_B_is_4 * ((1-is_tc5_burst_witout_tiling_for_B) * (TC5_1 * (1-B_is_fully_transfered_on_last_dim_FT1) + TC5 * (B_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC5_for_B + TC5));
subject to con132: burst_B_is_8 * cte_3 * 8 = burst_B_is_8 * ((1-is_tc5_burst_witout_tiling_for_B) * (TC5_1 * (1-B_is_fully_transfered_on_last_dim_FT1) + TC5 * (B_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC5_for_B + TC5));
subject to con133: burst_B_is_16 * cte_4 * 16 = burst_B_is_16 * ((1-is_tc5_burst_witout_tiling_for_B) * (TC5_1 * (1-B_is_fully_transfered_on_last_dim_FT1) + TC5 * (B_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC5_for_B + TC5));
subject to con134: burst_B = burst_B_is_1 * 1 + burst_B_is_2 * 2 + burst_B_is_4 * 4 + burst_B_is_8 * 8 + burst_B_is_16 * 16; # burst size of the array B
subject to con135: burst_B_is_1 + burst_B_is_2 + burst_B_is_4 + burst_B_is_8 + burst_B_is_16 = 1; # only one burst size for the array B
subject to con136: is_tc5_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT1;
subject to con137: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0; # the array tmp is fully transfered on the last dimension
subject to con138: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm1_S1 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con139: tmp_is_fully_transfered_on_last_dim_FT1 = level_transfer_tmp_FT1_under0; # the array tmp is fully transfered on the last dimension
subject to con140: burst_tmp_is_1 * cte_5 * 1 = burst_tmp_is_1 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con141: is_tc0_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC0_for_tmp);
subject to con142: burst_tmp_is_1 * cte_6 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con143: is_tc1_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC1_for_tmp);
subject to con144: burst_tmp_is_1 * cte_7 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con145: burst_tmp_is_1 * cte_8 * 1 = burst_tmp_is_1 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con146: is_tc6_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC6_for_tmp);
subject to con147: burst_tmp_is_2 * cte_9 * 2 = burst_tmp_is_2 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con148: burst_tmp_is_2 * cte_10 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con149: burst_tmp_is_2 * cte_11 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con150: burst_tmp_is_2 * cte_12 * 2 = burst_tmp_is_2 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con151: burst_tmp_is_4 * cte_13 * 4 = burst_tmp_is_4 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con152: burst_tmp_is_4 * cte_14 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con153: burst_tmp_is_4 * cte_15 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con154: burst_tmp_is_4 * cte_16 * 4 = burst_tmp_is_4 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con155: burst_tmp_is_8 * cte_17 * 8 = burst_tmp_is_8 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con156: burst_tmp_is_8 * cte_18 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con157: burst_tmp_is_8 * cte_19 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con158: burst_tmp_is_8 * cte_20 * 8 = burst_tmp_is_8 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con159: burst_tmp_is_16 * cte_21 * 16 = burst_tmp_is_16 * ((1-is_tc0_burst_witout_tiling_for_tmp) * (TC0_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC0 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC0_for_tmp + TC0));
subject to con160: burst_tmp_is_16 * cte_22 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con161: burst_tmp_is_16 * cte_23 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con162: burst_tmp_is_16 * cte_24 * 16 = burst_tmp_is_16 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con163: burst_tmp = burst_tmp_is_1 * 1 + burst_tmp_is_2 * 2 + burst_tmp_is_4 * 4 + burst_tmp_is_8 * 8 + burst_tmp_is_16 * 16; # burst size of the array tmp
subject to con164: burst_tmp_is_1 + burst_tmp_is_2 + burst_tmp_is_4 + burst_tmp_is_8 + burst_tmp_is_16 = 1; # only one burst size for the array tmp
subject to con165: is_tc0_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con166: is_tc1_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con167: is_tc6_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT1;
subject to con168: r_is_fully_transfered_on_last_dim_FT1 = level_transfer_r_FT1_under0 + perm0_S3 * (level_transfer_r_FT1_under1); # the array r is fully transfered on the last dimension
subject to con169: burst_r_is_1 * cte_25 * 1 = burst_r_is_1 * ((1-is_tc5_burst_witout_tiling_for_r) * (TC5_1 * (1-r_is_fully_transfered_on_last_dim_FT1) + TC5 * (r_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC5_for_r + TC5));
subject to con170: is_tc5_burst_witout_tiling_for_r =  min(1, cte_burst_without_tiling_TC5_for_r);
subject to con171: burst_r_is_2 * cte_26 * 2 = burst_r_is_2 * ((1-is_tc5_burst_witout_tiling_for_r) * (TC5_1 * (1-r_is_fully_transfered_on_last_dim_FT1) + TC5 * (r_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC5_for_r + TC5));
subject to con172: burst_r_is_4 * cte_27 * 4 = burst_r_is_4 * ((1-is_tc5_burst_witout_tiling_for_r) * (TC5_1 * (1-r_is_fully_transfered_on_last_dim_FT1) + TC5 * (r_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC5_for_r + TC5));
subject to con173: burst_r_is_8 * cte_28 * 8 = burst_r_is_8 * ((1-is_tc5_burst_witout_tiling_for_r) * (TC5_1 * (1-r_is_fully_transfered_on_last_dim_FT1) + TC5 * (r_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC5_for_r + TC5));
subject to con174: burst_r_is_16 * cte_29 * 16 = burst_r_is_16 * ((1-is_tc5_burst_witout_tiling_for_r) * (TC5_1 * (1-r_is_fully_transfered_on_last_dim_FT1) + TC5 * (r_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_r * (cte_burst_without_tiling_TC5_for_r + TC5));
subject to con175: burst_r = burst_r_is_1 * 1 + burst_r_is_2 * 2 + burst_r_is_4 * 4 + burst_r_is_8 * 8 + burst_r_is_16 * 16; # burst size of the array r
subject to con176: burst_r_is_1 + burst_r_is_2 + burst_r_is_4 + burst_r_is_8 + burst_r_is_16 = 1; # only one burst size for the array r
subject to con177: is_tc5_burst_witout_tiling_for_r <= r_is_fully_transfered_on_last_dim_FT1;
subject to con178: y_is_fully_transfered_on_last_dim_FT1 = level_transfer_y_FT1_under0; # the array y is fully transfered on the last dimension
subject to con179: y_is_fully_transfered_on_last_dim_FT1 = level_transfer_y_FT1_under0 + perm1_S3 * (level_transfer_y_FT1_under1); # the array y is fully transfered on the last dimension
subject to con180: y_is_fully_transfered_on_last_dim_FT1 = level_transfer_y_FT1_under0; # the array y is fully transfered on the last dimension
subject to con181: burst_y_is_1 * cte_30 * 1 = burst_y_is_1 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con182: is_tc3_burst_witout_tiling_for_y =  min(1, cte_burst_without_tiling_TC3_for_y);
subject to con183: burst_y_is_1 * cte_31 * 1 = burst_y_is_1 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con184: is_tc4_burst_witout_tiling_for_y =  min(1, cte_burst_without_tiling_TC4_for_y);
subject to con185: burst_y_is_1 * cte_32 * 1 = burst_y_is_1 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con186: burst_y_is_1 * cte_33 * 1 = burst_y_is_1 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con187: is_tc6_burst_witout_tiling_for_y =  min(1, cte_burst_without_tiling_TC6_for_y);
subject to con188: burst_y_is_1 * cte_34 * 1 = burst_y_is_1 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con189: burst_y_is_2 * cte_35 * 2 = burst_y_is_2 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con190: burst_y_is_2 * cte_36 * 2 = burst_y_is_2 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con191: burst_y_is_2 * cte_37 * 2 = burst_y_is_2 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con192: burst_y_is_2 * cte_38 * 2 = burst_y_is_2 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con193: burst_y_is_2 * cte_39 * 2 = burst_y_is_2 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con194: burst_y_is_4 * cte_40 * 4 = burst_y_is_4 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con195: burst_y_is_4 * cte_41 * 4 = burst_y_is_4 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con196: burst_y_is_4 * cte_42 * 4 = burst_y_is_4 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con197: burst_y_is_4 * cte_43 * 4 = burst_y_is_4 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con198: burst_y_is_4 * cte_44 * 4 = burst_y_is_4 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con199: burst_y_is_8 * cte_45 * 8 = burst_y_is_8 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con200: burst_y_is_8 * cte_46 * 8 = burst_y_is_8 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con201: burst_y_is_8 * cte_47 * 8 = burst_y_is_8 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con202: burst_y_is_8 * cte_48 * 8 = burst_y_is_8 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con203: burst_y_is_8 * cte_49 * 8 = burst_y_is_8 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con204: burst_y_is_16 * cte_50 * 16 = burst_y_is_16 * ((1-is_tc3_burst_witout_tiling_for_y) * (TC3_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC3 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC3_for_y + TC3));
subject to con205: burst_y_is_16 * cte_51 * 16 = burst_y_is_16 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con206: burst_y_is_16 * cte_52 * 16 = burst_y_is_16 * ((1-is_tc4_burst_witout_tiling_for_y) * (TC4_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC4 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc4_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC4_for_y + TC4));
subject to con207: burst_y_is_16 * cte_53 * 16 = burst_y_is_16 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con208: burst_y_is_16 * cte_54 * 16 = burst_y_is_16 * ((1-is_tc6_burst_witout_tiling_for_y) * (TC6_1 * (1-y_is_fully_transfered_on_last_dim_FT1) + TC6 * (y_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_y * (cte_burst_without_tiling_TC6_for_y + TC6));
subject to con209: burst_y = burst_y_is_1 * 1 + burst_y_is_2 * 2 + burst_y_is_4 * 4 + burst_y_is_8 * 8 + burst_y_is_16 * 16; # burst size of the array y
subject to con210: burst_y_is_1 + burst_y_is_2 + burst_y_is_4 + burst_y_is_8 + burst_y_is_16 = 1; # only one burst size for the array y
subject to con211: is_tc3_burst_witout_tiling_for_y <= y_is_fully_transfered_on_last_dim_FT1;
subject to con212: is_tc4_burst_witout_tiling_for_y <= y_is_fully_transfered_on_last_dim_FT1;
subject to con213: is_tc6_burst_witout_tiling_for_y <= y_is_fully_transfered_on_last_dim_FT1;
subject to con214: w_is_fully_transfered_on_last_dim_FT0 = level_transfer_w_FT0_under0 + perm0_S1 * (level_transfer_w_FT0_under1); # the array w is fully transfered on the last dimension
subject to con215: burst_w_is_1 * cte_55 * 1 = burst_w_is_1 * ((1-is_tc2_burst_witout_tiling_for_w) * (TC2_1 * (1-w_is_fully_transfered_on_last_dim_FT0) + TC2 * (w_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_w * (cte_burst_without_tiling_TC2_for_w + TC2));
subject to con216: is_tc2_burst_witout_tiling_for_w =  min(1, cte_burst_without_tiling_TC2_for_w);
subject to con217: burst_w_is_2 * cte_56 * 2 = burst_w_is_2 * ((1-is_tc2_burst_witout_tiling_for_w) * (TC2_1 * (1-w_is_fully_transfered_on_last_dim_FT0) + TC2 * (w_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_w * (cte_burst_without_tiling_TC2_for_w + TC2));
subject to con218: burst_w_is_4 * cte_57 * 4 = burst_w_is_4 * ((1-is_tc2_burst_witout_tiling_for_w) * (TC2_1 * (1-w_is_fully_transfered_on_last_dim_FT0) + TC2 * (w_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_w * (cte_burst_without_tiling_TC2_for_w + TC2));
subject to con219: burst_w_is_8 * cte_58 * 8 = burst_w_is_8 * ((1-is_tc2_burst_witout_tiling_for_w) * (TC2_1 * (1-w_is_fully_transfered_on_last_dim_FT0) + TC2 * (w_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_w * (cte_burst_without_tiling_TC2_for_w + TC2));
subject to con220: burst_w_is_16 * cte_59 * 16 = burst_w_is_16 * ((1-is_tc2_burst_witout_tiling_for_w) * (TC2_1 * (1-w_is_fully_transfered_on_last_dim_FT0) + TC2 * (w_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_w * (cte_burst_without_tiling_TC2_for_w + TC2));
subject to con221: burst_w = burst_w_is_1 * 1 + burst_w_is_2 * 2 + burst_w_is_4 * 4 + burst_w_is_8 * 8 + burst_w_is_16 * 16; # burst size of the array w
subject to con222: burst_w_is_1 + burst_w_is_2 + burst_w_is_4 + burst_w_is_8 + burst_w_is_16 = 1; # only one burst size for the array w
subject to con223: is_tc2_burst_witout_tiling_for_w <= w_is_fully_transfered_on_last_dim_FT0;
subject to con224: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm0_S1 * (level_transfer_A_FT0_under1); # the array A is fully transfered on the last dimension
subject to con225: burst_A_is_1 * cte_60 * 1 = burst_A_is_1 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con226: is_tc2_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC2_for_A);
subject to con227: burst_A_is_2 * cte_61 * 2 = burst_A_is_2 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con228: burst_A_is_4 * cte_62 * 4 = burst_A_is_4 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con229: burst_A_is_8 * cte_63 * 8 = burst_A_is_8 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con230: burst_A_is_16 * cte_64 * 16 = burst_A_is_16 * ((1-is_tc2_burst_witout_tiling_for_A) * (TC2_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC2 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc2_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC2_for_A + TC2));
subject to con231: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con232: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con233: is_tc2_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con234: footprint_tot_B_FT1 = TC4_ori * TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_B);
subject to con235: footprint_tot_tmp_FT0 = TC0_0 * (TC0_1 + cte_burst_without_tiling_TC0_for_tmp);
subject to con236: footprint_tot_tmp_FT0 = TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_tmp);
subject to con237: footprint_tot_tmp_FT1 = TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_tmp);
subject to con238: footprint_tot_r_FT1 = TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_r);
subject to con239: footprint_tot_y_FT1 = TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_y);
subject to con240: footprint_tot_y_FT1 = TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_y);
subject to con241: footprint_tot_y_FT1 = TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_y);
subject to con242: footprint_tot_w_FT0 = TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_w);
subject to con243: footprint_tot_A_FT0 = TC1_ori * TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_A);
subject to con244: obj = max(shift_0_to_1 + Lat_comp_fused_S2_S3_S4, Lat_comp_fused_S0_S1) + 1/burst_B + 1/burst_tmp + 1/burst_r + 1/burst_y + 1/burst_w + 1/burst_A + 1/(is_slr0_used);
subject to con245: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC1_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC1_1) * cte_tiling_0; # should divide for tmp in dim 0
subject to con246: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC0_1, TC6_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC0_1, TC6_1) * cte_tiling_1; # should divide for tmp in dim 0
subject to con247: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC6_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC6_1) * cte_tiling_2; # should divide for tmp in dim 0
subject to con248: y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC4_1) = y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC4_1) * cte_tiling_3; # should divide for y in dim 0
subject to con249: y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC6_1) = y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC6_1) * cte_tiling_4; # should divide for y in dim 0
subject to con250: y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * max(TC4_1, TC6_1) = y_is_fully_transfered_on_last_dim_FT1 * y_is_fully_transfered_on_last_dim_FT1 * min(TC4_1, TC6_1) * cte_tiling_5; # should divide for y in dim 0
subject to con251: buffer_size = footprint_tmp_S0_S1_reuse + footprint_A_S1_reuse + footprint_w_S1_reuse + footprint_tmp_S4_reuse + footprint_y_S2_S3_S4_reuse + footprint_B_S3_reuse + footprint_r_S3_reuse; # total buffer size
subject to con252: fifo_size = 0; # total fifo size
subject to con253: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con254: perm1_S1 * level_reuse_tmp_FT0_under0 = perm1_S1 * 1;
subject to con255: perm0_S3 * level_reuse_r_FT1_under0 = perm0_S3 * 1;
subject to con256: perm1_S3 * level_reuse_y_FT1_under0 = perm1_S3 * 1;
subject to con257: perm0_S1 * level_reuse_w_FT0_under0 = perm0_S1 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display TC4;
display TC5;
display TC6;
display is_fused_task0_in_SLR_0;
display is_fused_task1_in_SLR_0;
display is_slr0_used;
display perm0_S0;
display perm0_S1;
display perm1_S1;
display perm0_S2;
display perm0_S3;
display perm1_S3;
display perm0_S4;
display Lat_comp_S4_for_off_chip;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display Lat_comp_S2_intra_tile;
display Lat_comp_S3_intra_tile;
display Lat_comp_S4_intra_tile;
display footprint_tmp_S0_S1;
display footprint_tmp_S0_S1_reuse;
display footprint_A_S1;
display footprint_A_S1_reuse;
display footprint_w_S1;
display footprint_w_S1_reuse;
display footprint_tmp_S4;
display footprint_tmp_S4_reuse;
display footprint_y_S2_S3_S4;
display footprint_y_S2_S3_S4_reuse;
display footprint_B_S3;
display footprint_B_S3_reuse;
display footprint_r_S3;
display footprint_r_S3_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_tmp_FT0_under0;
display level_reuse_tmp_FT0_under0;
display level_transfer_tmp_FT0_under1;
display level_reuse_tmp_FT0_under1;
display level_transfer_A_FT0_under0;
display level_reuse_A_FT0_under0;
display level_transfer_A_FT0_under1;
display level_reuse_A_FT0_under1;
display level_transfer_w_FT0_under0;
display level_reuse_w_FT0_under0;
display level_transfer_w_FT0_under1;
display level_reuse_w_FT0_under1;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
display Lat_comp_fused_S2_S3_S4;
display level_transfer_y_FT1_under0;
display level_reuse_y_FT1_under0;
display level_transfer_y_FT1_under1;
display level_reuse_y_FT1_under1;
display level_transfer_B_FT1_under0;
display level_reuse_B_FT1_under0;
display level_transfer_B_FT1_under1;
display level_reuse_B_FT1_under1;
display level_transfer_r_FT1_under0;
display level_reuse_r_FT1_under0;
display level_transfer_r_FT1_under1;
display level_reuse_r_FT1_under1;
display level_transfer_tmp_FT1_under0;
display level_reuse_tmp_FT1_under0;
display level_transfer_tmp_FT1_under1;
display level_reuse_tmp_FT1_under1;
display Lat_comp_fused_S2_S3_S4_2;
display Lat_comp_fused_S2_S3_S4_1;
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
display TC6_0;
display TC6_1;
display B_is_fully_transfered_on_last_dim_FT1;
display burst_B_is_1;
display cte_0;
display cte_burst_without_tiling_TC5_for_B;
display is_tc5_burst_witout_tiling_for_B;
display burst_B_is_2;
display cte_1;
display burst_B_is_4;
display cte_2;
display burst_B_is_8;
display cte_3;
display burst_B_is_16;
display cte_4;
display tmp_is_fully_transfered_on_last_dim_FT0;
display tmp_is_fully_transfered_on_last_dim_FT1;
display burst_tmp_is_1;
display cte_5;
display cte_burst_without_tiling_TC0_for_tmp;
display is_tc0_burst_witout_tiling_for_tmp;
display cte_6;
display cte_burst_without_tiling_TC1_for_tmp;
display is_tc1_burst_witout_tiling_for_tmp;
display cte_7;
display cte_8;
display cte_burst_without_tiling_TC6_for_tmp;
display is_tc6_burst_witout_tiling_for_tmp;
display burst_tmp_is_2;
display cte_9;
display cte_10;
display cte_11;
display cte_12;
display burst_tmp_is_4;
display cte_13;
display cte_14;
display cte_15;
display cte_16;
display burst_tmp_is_8;
display cte_17;
display cte_18;
display cte_19;
display cte_20;
display burst_tmp_is_16;
display cte_21;
display cte_22;
display cte_23;
display cte_24;
display r_is_fully_transfered_on_last_dim_FT1;
display burst_r_is_1;
display cte_25;
display cte_burst_without_tiling_TC5_for_r;
display is_tc5_burst_witout_tiling_for_r;
display burst_r_is_2;
display cte_26;
display burst_r_is_4;
display cte_27;
display burst_r_is_8;
display cte_28;
display burst_r_is_16;
display cte_29;
display y_is_fully_transfered_on_last_dim_FT1;
display burst_y_is_1;
display cte_30;
display cte_burst_without_tiling_TC3_for_y;
display is_tc3_burst_witout_tiling_for_y;
display cte_31;
display cte_burst_without_tiling_TC4_for_y;
display is_tc4_burst_witout_tiling_for_y;
display cte_32;
display cte_33;
display cte_burst_without_tiling_TC6_for_y;
display is_tc6_burst_witout_tiling_for_y;
display cte_34;
display burst_y_is_2;
display cte_35;
display cte_36;
display cte_37;
display cte_38;
display cte_39;
display burst_y_is_4;
display cte_40;
display cte_41;
display cte_42;
display cte_43;
display cte_44;
display burst_y_is_8;
display cte_45;
display cte_46;
display cte_47;
display cte_48;
display cte_49;
display burst_y_is_16;
display cte_50;
display cte_51;
display cte_52;
display cte_53;
display cte_54;
display w_is_fully_transfered_on_last_dim_FT0;
display burst_w_is_1;
display cte_55;
display cte_burst_without_tiling_TC2_for_w;
display is_tc2_burst_witout_tiling_for_w;
display burst_w_is_2;
display cte_56;
display burst_w_is_4;
display cte_57;
display burst_w_is_8;
display cte_58;
display burst_w_is_16;
display cte_59;
display A_is_fully_transfered_on_last_dim_FT0;
display burst_A_is_1;
display cte_60;
display cte_burst_without_tiling_TC2_for_A;
display is_tc2_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_61;
display burst_A_is_4;
display cte_62;
display burst_A_is_8;
display cte_63;
display burst_A_is_16;
display cte_64;
display footprint_tot_B_FT1;
display burst_B;
display footprint_tot_tmp_FT0;
display burst_tmp;
display footprint_tot_tmp_FT1;
display footprint_tot_r_FT1;
display burst_r;
display footprint_tot_y_FT1;
display burst_y;
display footprint_tot_w_FT0;
display burst_w;
display footprint_tot_A_FT0;
display burst_A;
display Lat_comp_0_1;
display Lat_comp_2_3;
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
