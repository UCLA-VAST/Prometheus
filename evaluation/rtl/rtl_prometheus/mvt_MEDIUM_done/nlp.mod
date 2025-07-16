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
param TC0_ori = 400;
param TC1_ori = 400;
param TC2_ori = 400;
param TC3_ori = 400;
param IL_par_S0 = 4;
param IL_seq_S0 = 7;
param IL_par_S1 = 4;
param IL_seq_S1 = 7;
param DSP_S0 = 5;
param DSP_S1 = 5;

var TC0 integer >= 400 <= 400;
var TC1 integer >= 400 <= 400;
var TC2 integer >= 400 <= 400;
var TC3 integer >= 400 <= 400;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task1_in_SLR_0 binary;
var is_slr0_used binary;
var perm0_S0 binary; # [0, 0, 0, 1, 0, 0, 0, 1, 0]
var Lat_comp_S0_for_off_chip >= 0;
var perm1_S0 binary; # [0, 1, 0, 0, 0, 1, 0, 0, 0]
var perm0_S1 binary; # [1, 2, 0, 3, 0, 2, 0, 3, 0]
var Lat_comp_S1_for_off_chip >= 0;
var perm1_S1 binary; # [1, 3, 0, 2, 0, 3, 0, 2, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var footprint_x1_S0 integer >= 0;
var footprint_x1_S0_reuse integer >= 0;
var footprint_A1_S0 integer >= 0;
var footprint_A1_S0_reuse integer >= 0;
var footprint_B_S0 integer >= 0;
var footprint_B_S0_reuse integer >= 0;
var footprint_x2_S1 integer >= 0;
var footprint_x2_S1_reuse integer >= 0;
var footprint_A2_S1 integer >= 0;
var footprint_A2_S1_reuse integer >= 0;
var footprint_C_S1 integer >= 0;
var footprint_C_S1_reuse integer >= 0;
var Lat_comp_fused_S0 >= 0;
var level_transfer_x1_FT0_under0 binary;
var level_reuse_x1_FT0_under0 binary;
var level_transfer_x1_FT0_under1 binary;
var level_reuse_x1_FT0_under1 binary;
var level_transfer_A1_FT0_under0 binary;
var level_reuse_A1_FT0_under0 binary;
var level_transfer_A1_FT0_under1 binary;
var level_reuse_A1_FT0_under1 binary;
var level_transfer_B_FT0_under0 binary;
var level_reuse_B_FT0_under0 binary;
var level_transfer_B_FT0_under1 binary;
var level_reuse_B_FT0_under1 binary;
var Lat_comp_fused_S0_2 >= 0;
var Lat_comp_fused_S0_1 >= 0;
var Lat_comp_fused_S1 >= 0;
var level_transfer_x2_FT1_under0 binary;
var level_reuse_x2_FT1_under0 binary;
var level_transfer_x2_FT1_under1 binary;
var level_reuse_x2_FT1_under1 binary;
var level_transfer_A2_FT1_under0 binary;
var level_reuse_A2_FT1_under0 binary;
var level_transfer_A2_FT1_under1 binary;
var level_reuse_A2_FT1_under1 binary;
var level_transfer_C_FT1_under0 binary;
var level_reuse_C_FT1_under0 binary;
var level_transfer_C_FT1_under1 binary;
var level_reuse_C_FT1_under1 binary;
var Lat_comp_fused_S1_2 >= 0;
var Lat_comp_fused_S1_1 >= 0;
var nb_dsp_used_SLR0 >= 0;
var TC0_0 integer >= 1;
var TC0_1 integer >= 1;
var TC1_0 integer >= 1;
var TC1_1 integer >= 1;
var TC2_0 integer >= 1;
var TC2_1 integer >= 1;
var TC3_0 integer >= 1;
var TC3_1 integer >= 1;
var A1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A1_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC1_for_A1 integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_A1 binary;
var burst_A1_is_2 binary;
var cte_1 integer >=0;
var burst_A1_is_4 binary;
var cte_2 integer >=0;
var burst_A1_is_8 binary;
var cte_3 integer >=0;
var burst_A1_is_16 binary;
var cte_4 integer >=0;
var B_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B_is_1 binary;
var cte_5 integer >=0;
var cte_burst_without_tiling_TC1_for_B integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_B binary;
var burst_B_is_2 binary;
var cte_6 integer >=0;
var burst_B_is_4 binary;
var cte_7 integer >=0;
var burst_B_is_8 binary;
var cte_8 integer >=0;
var burst_B_is_16 binary;
var cte_9 integer >=0;
var x1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_x1_is_1 binary;
var cte_10 integer >=0;
var cte_burst_without_tiling_TC0_for_x1 integer >= 0 <= 0;
var is_tc0_burst_witout_tiling_for_x1 binary;
var cte_11 integer >=0;
var burst_x1_is_2 binary;
var cte_12 integer >=0;
var cte_13 integer >=0;
var burst_x1_is_4 binary;
var cte_14 integer >=0;
var cte_15 integer >=0;
var burst_x1_is_8 binary;
var cte_16 integer >=0;
var cte_17 integer >=0;
var burst_x1_is_16 binary;
var cte_18 integer >=0;
var cte_19 integer >=0;
var C_is_fully_transfered_on_last_dim_FT1 binary;
var burst_C_is_1 binary;
var cte_20 integer >=0;
var cte_burst_without_tiling_TC3_for_C integer >= 0 <= 0;
var is_tc3_burst_witout_tiling_for_C binary;
var burst_C_is_2 binary;
var cte_21 integer >=0;
var burst_C_is_4 binary;
var cte_22 integer >=0;
var burst_C_is_8 binary;
var cte_23 integer >=0;
var burst_C_is_16 binary;
var cte_24 integer >=0;
var x2_is_fully_transfered_on_last_dim_FT1 binary;
var burst_x2_is_1 binary;
var cte_25 integer >=0;
var cte_burst_without_tiling_TC2_for_x2 integer >= 0 <= 0;
var is_tc2_burst_witout_tiling_for_x2 binary;
var cte_26 integer >=0;
var burst_x2_is_2 binary;
var cte_27 integer >=0;
var cte_28 integer >=0;
var burst_x2_is_4 binary;
var cte_29 integer >=0;
var cte_30 integer >=0;
var burst_x2_is_8 binary;
var cte_31 integer >=0;
var cte_32 integer >=0;
var burst_x2_is_16 binary;
var cte_33 integer >=0;
var cte_34 integer >=0;
var A2_is_fully_transfered_on_last_dim_FT1 binary;
var burst_A2_is_1 binary;
var cte_35 integer >=0;
var cte_burst_without_tiling_TC2_for_A2 integer >= 0 <= 0;
var is_tc2_burst_witout_tiling_for_A2 binary;
var burst_A2_is_2 binary;
var cte_36 integer >=0;
var burst_A2_is_4 binary;
var cte_37 integer >=0;
var burst_A2_is_8 binary;
var cte_38 integer >=0;
var burst_A2_is_16 binary;
var cte_39 integer >=0;
var footprint_tot_A1_FT0 integer >= 1;
var burst_A1 integer >= 0;
var footprint_tot_B_FT0 integer >= 1;
var burst_B integer >= 0;
var footprint_tot_x1_FT0 integer >= 1;
var burst_x1 integer >= 0;
var footprint_tot_C_FT1 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_x2_FT1 integer >= 1;
var burst_x2 integer >= 0;
var footprint_tot_A2_FT1 integer >= 1;
var burst_A2 integer >= 0;
var obj >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0]
#comment: Fuse [1]
#comment: Task 1 writes x2 to off-chip
#comment: Task 0 writes x1 to off-chip
#comment: Statement 0: x1[i] += A1[i][j] * B[j];
#comment: Statement 1: x2[i] += A2[j][i] * C[j];
#comment: Loop_0: i
#comment: Loop_1: j
#comment: Loop_2: i
#comment: Loop_3: j
#comment: Argument 0: float x1[400]
#comment: Argument 1: float x2[400]
#comment: Argument 2: float B[400]
#comment: Argument 3: float C[400]
#comment: Argument 4: float A1[400][400]
#comment: Argument 5: float A2[400][400]
#comment:  1 is a reduction loop
#comment:  3 is a reduction loop
#comment: Task 0 reads A1 from off-chip
#comment: Task 0 reads B from off-chip
#comment: Task 0 reads x1 from off-chip
#comment: Task 1 reads C from off-chip
#comment: Task 1 reads x2 from off-chip
#comment: Task 1 reads A2 from off-chip
#comment: Array A1 has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array A1 has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array B has for tc in dim 0 TC1 (ori=TC1_ori) arg0
#comment: Array x1 has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array C has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array x2 has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A2 has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array A2 has for tc in dim 1 TC2 (ori=TC2_ori) arg0
#comment: Sched 0 has reuse buffer x1[TC0_1]
#comment: Sched 0 has reuse buffer A1[TC0_1][TC1_1]
#comment: Sched 0 has reuse buffer B[TC1_1]
#comment: Sched 1 has reuse buffer x2[TC2_1]
#comment: Sched 1 has reuse buffer A2[TC3_1][TC2_1]
#comment: Sched 1 has reuse buffer C[TC3_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: is_fused_task1_in_SLR_0 = 1; # only one SLR for fused task 1
subject to con3: perm0_S0 + perm1_S0 = 1; # only one permutation
subject to con4: perm0_S1 + perm1_S1 = 1; # only one permutation
subject to con5: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0 * log(TC1_1)/log(2); # latency of the intra-tile S0
subject to con6: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC3_1)/log(2); # latency of the intra-tile S1
subject to con7: perm1_S0 = 0; # because of the fused task 0
subject to con8: perm1_S1 = 0; # because of the fused task 1
subject to con9: is_fused_task0_in_SLR_0 * (footprint_x1_S0_reuse + footprint_A1_S0_reuse + footprint_B_S0_reuse) + is_fused_task1_in_SLR_0 * (footprint_x2_S1_reuse + footprint_A2_S1_reuse + footprint_C_S1_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con10: level_reuse_x1_FT0_under0 = level_transfer_x1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con11: level_reuse_x1_FT0_under1 = 1; # transfer innermost for output
subject to con12: level_reuse_x1_FT0_under1 = level_transfer_x1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con13: level_transfer_x1_FT0_under0 + level_transfer_x1_FT0_under1 = 1; # only one level of transfer for x1
subject to con14: level_reuse_x1_FT0_under0 + level_reuse_x1_FT0_under1 = 1; # only one level of reuse for x1
subject to con15: level_reuse_A1_FT0_under0 = level_transfer_A1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con16: level_reuse_A1_FT0_under1 = level_transfer_A1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con17: level_transfer_A1_FT0_under0 + level_transfer_A1_FT0_under1 = 1; # only one level of transfer for A1
subject to con18: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 = 1; # only one level of reuse for A1
subject to con19: level_reuse_B_FT0_under0 >= level_transfer_B_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con20: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 >= level_transfer_B_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con21: level_transfer_B_FT0_under0 + level_transfer_B_FT0_under1 = 1; # only one level of transfer for B
subject to con22: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 = 1; # only one level of reuse for B
subject to con23: Lat_comp_fused_S0_2 = ((Lat_comp_S0_intra_tile + II_S0_seq * TC1_0)); # latency of the fused task S0 level 2
subject to con24: Lat_comp_fused_S0_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC1_0) * max(Lat_comp_fused_S0_2, level_transfer_x1_FT0_under1 * footprint_x1_S0 / burst_x1, level_transfer_A1_FT0_under1 * footprint_A1_S0 / burst_A1, level_transfer_B_FT0_under1 * footprint_B_S0 / burst_B) + Lat_comp_fused_S0_2 + max(level_transfer_x1_FT0_under1 * footprint_x1_S0 / burst_x1, level_transfer_A1_FT0_under1 * footprint_A1_S0 / burst_A1, level_transfer_B_FT0_under1 * footprint_B_S0 / burst_B  + level_transfer_x1_FT0_under1 * footprint_x1_S0 / burst_x1); # latency of the fused task S0 level 1
subject to con25: Lat_comp_fused_S0 = Lat_comp_fused_S0_1 + level_transfer_x1_FT0_under0 * footprint_tot_x1_FT0 / burst_x1 + level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 / burst_A1 + level_transfer_B_FT0_under0 * footprint_tot_B_FT0 / burst_B; # latency of the fused task S0
subject to con26: level_reuse_x2_FT1_under0 = level_transfer_x2_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con27: level_reuse_x2_FT1_under1 = 1; # transfer innermost for output
subject to con28: level_reuse_x2_FT1_under1 = level_transfer_x2_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con29: level_transfer_x2_FT1_under0 + level_transfer_x2_FT1_under1 = 1; # only one level of transfer for x2
subject to con30: level_reuse_x2_FT1_under0 + level_reuse_x2_FT1_under1 = 1; # only one level of reuse for x2
subject to con31: level_reuse_A2_FT1_under0 = level_transfer_A2_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con32: level_reuse_A2_FT1_under1 = level_transfer_A2_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con33: level_transfer_A2_FT1_under0 + level_transfer_A2_FT1_under1 = 1; # only one level of transfer for A2
subject to con34: level_reuse_A2_FT1_under0 + level_reuse_A2_FT1_under1 = 1; # only one level of reuse for A2
subject to con35: level_reuse_C_FT1_under0 >= level_transfer_C_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con36: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 >= level_transfer_C_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con37: level_transfer_C_FT1_under0 + level_transfer_C_FT1_under1 = 1; # only one level of transfer for C
subject to con38: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 = 1; # only one level of reuse for C
subject to con39: Lat_comp_fused_S1_2 = ((Lat_comp_S1_intra_tile + II_S1_seq * TC3_0)); # latency of the fused task S1 level 2
subject to con40: Lat_comp_fused_S1_1 = (perm0_S1 * TC2_0 + perm1_S1 * TC3_0) * max(Lat_comp_fused_S1_2, level_transfer_x2_FT1_under1 * footprint_x2_S1 / burst_x2, level_transfer_A2_FT1_under1 * footprint_A2_S1 / burst_A2, level_transfer_C_FT1_under1 * footprint_C_S1 / burst_C) + Lat_comp_fused_S1_2 + max(level_transfer_x2_FT1_under1 * footprint_x2_S1 / burst_x2, level_transfer_A2_FT1_under1 * footprint_A2_S1 / burst_A2, level_transfer_C_FT1_under1 * footprint_C_S1 / burst_C  + level_transfer_x2_FT1_under1 * footprint_x2_S1 / burst_x2); # latency of the fused task S1 level 1
subject to con41: Lat_comp_fused_S1 = Lat_comp_fused_S1_1 + level_transfer_x2_FT1_under0 * footprint_tot_x2_FT1 / burst_x2 + level_transfer_A2_FT1_under0 * footprint_tot_A2_FT1 / burst_A2 + level_transfer_C_FT1_under0 * footprint_tot_C_FT1 / burst_C; # latency of the fused task S1
subject to con42: perm1_S0 * level_transfer_x1_FT0_under1 = 0; # useless to transfer under this loop
subject to con43: perm1_S0 * level_reuse_x1_FT0_under1 = 0; # useless to reuse under this loop
subject to con44: footprint_x1_S0 = level_transfer_x1_FT0_under0 * footprint_tot_x1_FT0 + level_transfer_x1_FT0_under1 * (perm0_S0 * footprint_tot_x1_FT0/ TC0_0 + perm1_S0 * footprint_tot_x1_FT0); # footprint of the array x1 for the fused task 0
subject to con45: footprint_x1_S0_reuse = level_reuse_x1_FT0_under0 * footprint_tot_x1_FT0 + level_reuse_x1_FT0_under1 * (perm0_S0 * footprint_tot_x1_FT0/ TC0_0 + perm1_S0 * footprint_tot_x1_FT0); # footprint of the array x1 for the fused task 0
subject to con46: footprint_A1_S0 = level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 + level_transfer_A1_FT0_under1 * (perm0_S0 * footprint_tot_A1_FT0/ TC0_0 + perm1_S0 * footprint_tot_A1_FT0/ TC1_0); # footprint of the array A1 for the fused task 0
subject to con47: footprint_A1_S0_reuse = level_reuse_A1_FT0_under0 * footprint_tot_A1_FT0 + level_reuse_A1_FT0_under1 * (perm0_S0 * footprint_tot_A1_FT0/ TC0_0 + perm1_S0 * footprint_tot_A1_FT0/ TC1_0); # footprint of the array A1 for the fused task 0
subject to con48: perm0_S0 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con49: perm0_S0 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con50: footprint_B_S0 = level_transfer_B_FT0_under0 * footprint_tot_B_FT0 + level_transfer_B_FT0_under1 * (perm0_S0 * footprint_tot_B_FT0 + perm1_S0 * footprint_tot_B_FT0/ TC1_0); # footprint of the array B for the fused task 0
subject to con51: footprint_B_S0_reuse = level_reuse_B_FT0_under0 * footprint_tot_B_FT0 + level_reuse_B_FT0_under1 * (perm0_S0 * footprint_tot_B_FT0 + perm1_S0 * footprint_tot_B_FT0/ TC1_0); # footprint of the array B for the fused task 0
subject to con52: perm1_S1 * level_transfer_x2_FT1_under1 = 0; # useless to transfer under this loop
subject to con53: perm1_S1 * level_reuse_x2_FT1_under1 = 0; # useless to reuse under this loop
subject to con54: footprint_x2_S1 = level_transfer_x2_FT1_under0 * footprint_tot_x2_FT1 + level_transfer_x2_FT1_under1 * (perm0_S1 * footprint_tot_x2_FT1/ TC2_0 + perm1_S1 * footprint_tot_x2_FT1); # footprint of the array x2 for the fused task 1
subject to con55: footprint_x2_S1_reuse = level_reuse_x2_FT1_under0 * footprint_tot_x2_FT1 + level_reuse_x2_FT1_under1 * (perm0_S1 * footprint_tot_x2_FT1/ TC2_0 + perm1_S1 * footprint_tot_x2_FT1); # footprint of the array x2 for the fused task 1
subject to con56: footprint_A2_S1 = level_transfer_A2_FT1_under0 * footprint_tot_A2_FT1 + level_transfer_A2_FT1_under1 * (perm0_S1 * footprint_tot_A2_FT1/ TC2_0 + perm1_S1 * footprint_tot_A2_FT1/ TC3_0); # footprint of the array A2 for the fused task 1
subject to con57: footprint_A2_S1_reuse = level_reuse_A2_FT1_under0 * footprint_tot_A2_FT1 + level_reuse_A2_FT1_under1 * (perm0_S1 * footprint_tot_A2_FT1/ TC2_0 + perm1_S1 * footprint_tot_A2_FT1/ TC3_0); # footprint of the array A2 for the fused task 1
subject to con58: perm0_S1 * level_transfer_C_FT1_under1 = 0; # useless to transfer under this loop
subject to con59: perm0_S1 * level_reuse_C_FT1_under1 = 0; # useless to reuse under this loop
subject to con60: footprint_C_S1 = level_transfer_C_FT1_under0 * footprint_tot_C_FT1 + level_transfer_C_FT1_under1 * (perm0_S1 * footprint_tot_C_FT1 + perm1_S1 * footprint_tot_C_FT1/ TC3_0); # footprint of the array C for the fused task 1
subject to con61: footprint_C_S1_reuse = level_reuse_C_FT1_under0 * footprint_tot_C_FT1 + level_reuse_C_FT1_under1 * (perm0_S1 * footprint_tot_C_FT1 + perm1_S1 * footprint_tot_C_FT1/ TC3_0); # footprint of the array C for the fused task 1
subject to con62: TC0_1 * TC1_1 <= MAX_UF;
subject to con63: TC2_1 * TC3_1 <= MAX_UF;
subject to con64: TC0_1 * TC1_1 * DSP_S0 / II_S0_seq + TC2_1 * TC3_1 * DSP_S1 / II_S1_seq <= DSP_avail; # DSP constraint
subject to con65: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * DSP_S0 / II_S0_seq) + is_fused_task1_in_SLR_0 * (TC2_1 * TC3_1 * DSP_S1 / II_S1_seq); # DSP constraint per SLR
subject to con66: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con67: TC0_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array x1 
subject to con68: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A1 
subject to con69: TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con70: TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array x2 
subject to con71: TC3_1 * TC2_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A2 
subject to con72: TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con73: Lat_comp_S0_for_off_chip = perm0_S0 * TC1_0 * II_S0_seq + perm1_S0 * TC1_0 * TC0_0 * II_S0_par; # stall between task
subject to con74: Lat_comp_S1_for_off_chip = perm0_S1 * TC3_0 * II_S1_seq + perm1_S1 * TC3_0 * TC2_0 * II_S1_par; # stall between task
subject to con75: TC0_0 <= TC0; # TC of split loop
subject to con76: TC0_1 <= TC0; # TC of split loop
subject to con77: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con78: TC1_0 <= TC1; # TC of split loop
subject to con79: TC1_1 <= TC1; # TC of split loop
subject to con80: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con81: TC2_0 <= TC2; # TC of split loop
subject to con82: TC2_1 <= TC2; # TC of split loop
subject to con83: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con84: TC3_0 <= TC3; # TC of split loop
subject to con85: TC3_1 <= TC3; # TC of split loop
subject to con86: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con87: A1_is_fully_transfered_on_last_dim_FT0 = level_transfer_A1_FT0_under0 + perm0_S0 * (level_transfer_A1_FT0_under1); # the array A1 is fully transfered on the last dimension
subject to con88: burst_A1_is_1 * cte_0 * 1 = burst_A1_is_1 * ((1-is_tc1_burst_witout_tiling_for_A1) * (TC1_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC1 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC1_for_A1 + TC1));
subject to con89: is_tc1_burst_witout_tiling_for_A1 =  min(1, cte_burst_without_tiling_TC1_for_A1);
subject to con90: burst_A1_is_2 * cte_1 * 2 = burst_A1_is_2 * ((1-is_tc1_burst_witout_tiling_for_A1) * (TC1_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC1 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC1_for_A1 + TC1));
subject to con91: burst_A1_is_4 * cte_2 * 4 = burst_A1_is_4 * ((1-is_tc1_burst_witout_tiling_for_A1) * (TC1_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC1 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC1_for_A1 + TC1));
subject to con92: burst_A1_is_8 * cte_3 * 8 = burst_A1_is_8 * ((1-is_tc1_burst_witout_tiling_for_A1) * (TC1_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC1 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC1_for_A1 + TC1));
subject to con93: burst_A1_is_16 * cte_4 * 16 = burst_A1_is_16 * ((1-is_tc1_burst_witout_tiling_for_A1) * (TC1_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC1 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC1_for_A1 + TC1));
subject to con94: burst_A1 = burst_A1_is_1 * 1 + burst_A1_is_2 * 2 + burst_A1_is_4 * 4 + burst_A1_is_8 * 8 + burst_A1_is_16 * 16; # burst size of the array A1
subject to con95: burst_A1_is_1 + burst_A1_is_2 + burst_A1_is_4 + burst_A1_is_8 + burst_A1_is_16 = 1; # only one burst size for the array A1
subject to con96: is_tc1_burst_witout_tiling_for_A1 <= A1_is_fully_transfered_on_last_dim_FT0;
subject to con97: B_is_fully_transfered_on_last_dim_FT0 = level_transfer_B_FT0_under0 + perm0_S0 * (level_transfer_B_FT0_under1); # the array B is fully transfered on the last dimension
subject to con98: burst_B_is_1 * cte_5 * 1 = burst_B_is_1 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con99: is_tc1_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC1_for_B);
subject to con100: burst_B_is_2 * cte_6 * 2 = burst_B_is_2 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con101: burst_B_is_4 * cte_7 * 4 = burst_B_is_4 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con102: burst_B_is_8 * cte_8 * 8 = burst_B_is_8 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con103: burst_B_is_16 * cte_9 * 16 = burst_B_is_16 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con104: burst_B = burst_B_is_1 * 1 + burst_B_is_2 * 2 + burst_B_is_4 * 4 + burst_B_is_8 * 8 + burst_B_is_16 * 16; # burst size of the array B
subject to con105: burst_B_is_1 + burst_B_is_2 + burst_B_is_4 + burst_B_is_8 + burst_B_is_16 = 1; # only one burst size for the array B
subject to con106: is_tc1_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT0;
subject to con107: x1_is_fully_transfered_on_last_dim_FT0 = level_transfer_x1_FT0_under0 + perm1_S0 * (level_transfer_x1_FT0_under1); # the array x1 is fully transfered on the last dimension
subject to con108: burst_x1_is_1 * cte_10 * 1 = burst_x1_is_1 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con109: is_tc0_burst_witout_tiling_for_x1 =  min(1, cte_burst_without_tiling_TC0_for_x1);
subject to con110: burst_x1_is_1 * cte_11 * 1 = burst_x1_is_1 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con111: burst_x1_is_2 * cte_12 * 2 = burst_x1_is_2 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con112: burst_x1_is_2 * cte_13 * 2 = burst_x1_is_2 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con113: burst_x1_is_4 * cte_14 * 4 = burst_x1_is_4 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con114: burst_x1_is_4 * cte_15 * 4 = burst_x1_is_4 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con115: burst_x1_is_8 * cte_16 * 8 = burst_x1_is_8 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con116: burst_x1_is_8 * cte_17 * 8 = burst_x1_is_8 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con117: burst_x1_is_16 * cte_18 * 16 = burst_x1_is_16 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con118: burst_x1_is_16 * cte_19 * 16 = burst_x1_is_16 * ((1-is_tc0_burst_witout_tiling_for_x1) * (TC0_1 * (1-x1_is_fully_transfered_on_last_dim_FT0) + TC0 * (x1_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_x1 * (cte_burst_without_tiling_TC0_for_x1 + TC0));
subject to con119: burst_x1 = burst_x1_is_1 * 1 + burst_x1_is_2 * 2 + burst_x1_is_4 * 4 + burst_x1_is_8 * 8 + burst_x1_is_16 * 16; # burst size of the array x1
subject to con120: burst_x1_is_1 + burst_x1_is_2 + burst_x1_is_4 + burst_x1_is_8 + burst_x1_is_16 = 1; # only one burst size for the array x1
subject to con121: is_tc0_burst_witout_tiling_for_x1 <= x1_is_fully_transfered_on_last_dim_FT0;
subject to con122: C_is_fully_transfered_on_last_dim_FT1 = level_transfer_C_FT1_under0 + perm0_S1 * (level_transfer_C_FT1_under1); # the array C is fully transfered on the last dimension
subject to con123: burst_C_is_1 * cte_20 * 1 = burst_C_is_1 * ((1-is_tc3_burst_witout_tiling_for_C) * (TC3_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC3 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC3_for_C + TC3));
subject to con124: is_tc3_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC3_for_C);
subject to con125: burst_C_is_2 * cte_21 * 2 = burst_C_is_2 * ((1-is_tc3_burst_witout_tiling_for_C) * (TC3_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC3 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC3_for_C + TC3));
subject to con126: burst_C_is_4 * cte_22 * 4 = burst_C_is_4 * ((1-is_tc3_burst_witout_tiling_for_C) * (TC3_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC3 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC3_for_C + TC3));
subject to con127: burst_C_is_8 * cte_23 * 8 = burst_C_is_8 * ((1-is_tc3_burst_witout_tiling_for_C) * (TC3_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC3 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC3_for_C + TC3));
subject to con128: burst_C_is_16 * cte_24 * 16 = burst_C_is_16 * ((1-is_tc3_burst_witout_tiling_for_C) * (TC3_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC3 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc3_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC3_for_C + TC3));
subject to con129: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con130: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con131: is_tc3_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT1;
subject to con132: x2_is_fully_transfered_on_last_dim_FT1 = level_transfer_x2_FT1_under0 + perm1_S1 * (level_transfer_x2_FT1_under1); # the array x2 is fully transfered on the last dimension
subject to con133: burst_x2_is_1 * cte_25 * 1 = burst_x2_is_1 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con134: is_tc2_burst_witout_tiling_for_x2 =  min(1, cte_burst_without_tiling_TC2_for_x2);
subject to con135: burst_x2_is_1 * cte_26 * 1 = burst_x2_is_1 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con136: burst_x2_is_2 * cte_27 * 2 = burst_x2_is_2 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con137: burst_x2_is_2 * cte_28 * 2 = burst_x2_is_2 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con138: burst_x2_is_4 * cte_29 * 4 = burst_x2_is_4 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con139: burst_x2_is_4 * cte_30 * 4 = burst_x2_is_4 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con140: burst_x2_is_8 * cte_31 * 8 = burst_x2_is_8 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con141: burst_x2_is_8 * cte_32 * 8 = burst_x2_is_8 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con142: burst_x2_is_16 * cte_33 * 16 = burst_x2_is_16 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con143: burst_x2_is_16 * cte_34 * 16 = burst_x2_is_16 * ((1-is_tc2_burst_witout_tiling_for_x2) * (TC2_1 * (1-x2_is_fully_transfered_on_last_dim_FT1) + TC2 * (x2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_x2 * (cte_burst_without_tiling_TC2_for_x2 + TC2));
subject to con144: burst_x2 = burst_x2_is_1 * 1 + burst_x2_is_2 * 2 + burst_x2_is_4 * 4 + burst_x2_is_8 * 8 + burst_x2_is_16 * 16; # burst size of the array x2
subject to con145: burst_x2_is_1 + burst_x2_is_2 + burst_x2_is_4 + burst_x2_is_8 + burst_x2_is_16 = 1; # only one burst size for the array x2
subject to con146: is_tc2_burst_witout_tiling_for_x2 <= x2_is_fully_transfered_on_last_dim_FT1;
subject to con147: A2_is_fully_transfered_on_last_dim_FT1 = level_transfer_A2_FT1_under0 + perm1_S1 * (level_transfer_A2_FT1_under1); # the array A2 is fully transfered on the last dimension
subject to con148: burst_A2_is_1 * cte_35 * 1 = burst_A2_is_1 * ((1-is_tc2_burst_witout_tiling_for_A2) * (TC2_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC2 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC2_for_A2 + TC2));
subject to con149: is_tc2_burst_witout_tiling_for_A2 =  min(1, cte_burst_without_tiling_TC2_for_A2);
subject to con150: burst_A2_is_2 * cte_36 * 2 = burst_A2_is_2 * ((1-is_tc2_burst_witout_tiling_for_A2) * (TC2_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC2 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC2_for_A2 + TC2));
subject to con151: burst_A2_is_4 * cte_37 * 4 = burst_A2_is_4 * ((1-is_tc2_burst_witout_tiling_for_A2) * (TC2_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC2 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC2_for_A2 + TC2));
subject to con152: burst_A2_is_8 * cte_38 * 8 = burst_A2_is_8 * ((1-is_tc2_burst_witout_tiling_for_A2) * (TC2_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC2 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC2_for_A2 + TC2));
subject to con153: burst_A2_is_16 * cte_39 * 16 = burst_A2_is_16 * ((1-is_tc2_burst_witout_tiling_for_A2) * (TC2_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC2 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc2_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC2_for_A2 + TC2));
subject to con154: burst_A2 = burst_A2_is_1 * 1 + burst_A2_is_2 * 2 + burst_A2_is_4 * 4 + burst_A2_is_8 * 8 + burst_A2_is_16 * 16; # burst size of the array A2
subject to con155: burst_A2_is_1 + burst_A2_is_2 + burst_A2_is_4 + burst_A2_is_8 + burst_A2_is_16 = 1; # only one burst size for the array A2
subject to con156: is_tc2_burst_witout_tiling_for_A2 <= A2_is_fully_transfered_on_last_dim_FT1;
subject to con157: footprint_tot_A1_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_A1);
subject to con158: footprint_tot_B_FT0 = TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_B);
subject to con159: footprint_tot_x1_FT0 = TC0_0 * (TC0_1 + cte_burst_without_tiling_TC0_for_x1);
subject to con160: footprint_tot_C_FT1 = TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_C);
subject to con161: footprint_tot_x2_FT1 = TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_x2);
subject to con162: footprint_tot_A2_FT1 = TC3_ori * TC2_0 * (TC2_1 + cte_burst_without_tiling_TC2_for_A2);
subject to con163: obj = Lat_comp_fused_S0 + Lat_comp_fused_S1 + 1/burst_A1 + 1/burst_B + 1/burst_x1 + 1/burst_C + 1/burst_x2 + 1/burst_A2 + 1/(is_slr0_used);
subject to con164: buffer_size = footprint_x1_S0_reuse + footprint_A1_S0_reuse + footprint_B_S0_reuse + footprint_x2_S1_reuse + footprint_A2_S1_reuse + footprint_C_S1_reuse; # total buffer size
subject to con165: fifo_size = 0; # total fifo size
subject to con166: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con167: perm0_S0 * level_reuse_B_FT0_under0 = perm0_S0 * 1;
subject to con168: perm1_S0 * level_reuse_x1_FT0_under0 = perm1_S0 * 1;
subject to con169: perm0_S1 * level_reuse_C_FT1_under0 = perm0_S1 * 1;
subject to con170: perm1_S1 * level_reuse_x2_FT1_under0 = perm1_S1 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display is_fused_task0_in_SLR_0;
display is_fused_task1_in_SLR_0;
display is_slr0_used;
display perm0_S0;
display Lat_comp_S0_for_off_chip;
display perm1_S0;
display perm0_S1;
display Lat_comp_S1_for_off_chip;
display perm1_S1;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display footprint_x1_S0;
display footprint_x1_S0_reuse;
display footprint_A1_S0;
display footprint_A1_S0_reuse;
display footprint_B_S0;
display footprint_B_S0_reuse;
display footprint_x2_S1;
display footprint_x2_S1_reuse;
display footprint_A2_S1;
display footprint_A2_S1_reuse;
display footprint_C_S1;
display footprint_C_S1_reuse;
display Lat_comp_fused_S0;
display level_transfer_x1_FT0_under0;
display level_reuse_x1_FT0_under0;
display level_transfer_x1_FT0_under1;
display level_reuse_x1_FT0_under1;
display level_transfer_A1_FT0_under0;
display level_reuse_A1_FT0_under0;
display level_transfer_A1_FT0_under1;
display level_reuse_A1_FT0_under1;
display level_transfer_B_FT0_under0;
display level_reuse_B_FT0_under0;
display level_transfer_B_FT0_under1;
display level_reuse_B_FT0_under1;
display Lat_comp_fused_S0_2;
display Lat_comp_fused_S0_1;
display Lat_comp_fused_S1;
display level_transfer_x2_FT1_under0;
display level_reuse_x2_FT1_under0;
display level_transfer_x2_FT1_under1;
display level_reuse_x2_FT1_under1;
display level_transfer_A2_FT1_under0;
display level_reuse_A2_FT1_under0;
display level_transfer_A2_FT1_under1;
display level_reuse_A2_FT1_under1;
display level_transfer_C_FT1_under0;
display level_reuse_C_FT1_under0;
display level_transfer_C_FT1_under1;
display level_reuse_C_FT1_under1;
display Lat_comp_fused_S1_2;
display Lat_comp_fused_S1_1;
display nb_dsp_used_SLR0;
display TC0_0;
display TC0_1;
display TC1_0;
display TC1_1;
display TC2_0;
display TC2_1;
display TC3_0;
display TC3_1;
display A1_is_fully_transfered_on_last_dim_FT0;
display burst_A1_is_1;
display cte_0;
display cte_burst_without_tiling_TC1_for_A1;
display is_tc1_burst_witout_tiling_for_A1;
display burst_A1_is_2;
display cte_1;
display burst_A1_is_4;
display cte_2;
display burst_A1_is_8;
display cte_3;
display burst_A1_is_16;
display cte_4;
display B_is_fully_transfered_on_last_dim_FT0;
display burst_B_is_1;
display cte_5;
display cte_burst_without_tiling_TC1_for_B;
display is_tc1_burst_witout_tiling_for_B;
display burst_B_is_2;
display cte_6;
display burst_B_is_4;
display cte_7;
display burst_B_is_8;
display cte_8;
display burst_B_is_16;
display cte_9;
display x1_is_fully_transfered_on_last_dim_FT0;
display burst_x1_is_1;
display cte_10;
display cte_burst_without_tiling_TC0_for_x1;
display is_tc0_burst_witout_tiling_for_x1;
display cte_11;
display burst_x1_is_2;
display cte_12;
display cte_13;
display burst_x1_is_4;
display cte_14;
display cte_15;
display burst_x1_is_8;
display cte_16;
display cte_17;
display burst_x1_is_16;
display cte_18;
display cte_19;
display C_is_fully_transfered_on_last_dim_FT1;
display burst_C_is_1;
display cte_20;
display cte_burst_without_tiling_TC3_for_C;
display is_tc3_burst_witout_tiling_for_C;
display burst_C_is_2;
display cte_21;
display burst_C_is_4;
display cte_22;
display burst_C_is_8;
display cte_23;
display burst_C_is_16;
display cte_24;
display x2_is_fully_transfered_on_last_dim_FT1;
display burst_x2_is_1;
display cte_25;
display cte_burst_without_tiling_TC2_for_x2;
display is_tc2_burst_witout_tiling_for_x2;
display cte_26;
display burst_x2_is_2;
display cte_27;
display cte_28;
display burst_x2_is_4;
display cte_29;
display cte_30;
display burst_x2_is_8;
display cte_31;
display cte_32;
display burst_x2_is_16;
display cte_33;
display cte_34;
display A2_is_fully_transfered_on_last_dim_FT1;
display burst_A2_is_1;
display cte_35;
display cte_burst_without_tiling_TC2_for_A2;
display is_tc2_burst_witout_tiling_for_A2;
display burst_A2_is_2;
display cte_36;
display burst_A2_is_4;
display cte_37;
display burst_A2_is_8;
display cte_38;
display burst_A2_is_16;
display cte_39;
display footprint_tot_A1_FT0;
display burst_A1;
display footprint_tot_B_FT0;
display burst_B;
display footprint_tot_x1_FT0;
display burst_x1;
display footprint_tot_C_FT1;
display burst_C;
display footprint_tot_x2_FT1;
display burst_x2;
display footprint_tot_A2_FT1;
display burst_A2;
display obj;
display buffer_size;
display fifo_size;
display _total_solve_time;
