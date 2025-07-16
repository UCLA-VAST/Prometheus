#option solver baron;
#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';
option solver gurobi;
option gurobi_options 'lim:time=1800 tech:logfile=gurobi.log qp:nonconvex=2';
#option solver octeract;
#option octeract_options 'max_solver_time=60';

param DSP_avail = 12000;
param ON_CHIP_MEM_SIZE = 1512000;
param MAX_BUFFER_SIZE = 44096;
param CONSTRAINT_ARRAY_PARTITIONING_VALUE = 1024;
param MAX_UF = 4096;
param SLR0_mem = 1512000;
param SLR0_DSP = 12000;
param II_S0_par = 1;
param II_S0_seq = 3;
param II_S1_par = 1;
param II_S1_seq = 3;
param TC0_ori = 200;
param TC1_ori = 240;
param TC2_ori = 200;
param TC3_ori = 200;
param TC4_ori = 240;
param IL_par_S0 = 4;
param IL_seq_S0 = 7;
param IL_par_S1 = 4;
param IL_seq_S1 = 0;
param DSP_S0 = 5;
param DSP_S1 = 3;

var TC0 integer >= 200 <= 208;
var TC1 integer >= 240 <= 240;
var TC2 integer >= 200 <= 208;
var TC3 integer >= 200 <= 208;
var TC4 integer >= 240 <= 240;
var is_fused_task0_in_SLR_0 binary;
var is_slr0_used binary;
var perm0_S0 binary; # [0, 0, 0, 1, 0, 2, 0, 0, 0, 1, 0, 2, 0]
var perm1_S0 binary; # [0, 0, 0, 2, 0, 1, 0, 0, 0, 2, 0, 1, 0]
var perm2_S0 binary; # [0, 1, 0, 0, 0, 2, 0, 1, 0, 0, 0, 2, 0]
var perm3_S0 binary; # [0, 1, 0, 2, 0, 0, 0, 1, 0, 2, 0, 0, 0]
var perm4_S0 binary; # [0, 2, 0, 0, 0, 1, 0, 2, 0, 0, 0, 1, 0]
var perm5_S0 binary; # [0, 2, 0, 1, 0, 0, 0, 2, 0, 1, 0, 0, 0]
var perm0_S1 binary; # [1, 3, 0, 4, 0, 3, 0, 4, 0]
var Lat_comp_S1_for_off_chip >= 0;
var perm1_S1 binary; # [1, 4, 0, 3, 0, 4, 0, 3, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var footprint_B_S0_S1 integer >= 0;
var footprint_B_S0_S1_reuse integer >= 0;
var footprint_A_S0 integer >= 0;
var footprint_A_S0_reuse integer >= 0;
var footprint_C_S0 integer >= 0;
var footprint_C_S0_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_B_FT0_under0 binary;
var level_reuse_B_FT0_under0 binary;
var level_transfer_B_FT0_under1 binary;
var level_reuse_B_FT0_under1 binary;
var level_transfer_B_FT0_under2 binary;
var level_reuse_B_FT0_under2 binary;
var level_transfer_A_FT0_under0 binary;
var level_reuse_A_FT0_under0 binary;
var level_transfer_A_FT0_under1 binary;
var level_reuse_A_FT0_under1 binary;
var level_transfer_A_FT0_under2 binary;
var level_reuse_A_FT0_under2 binary;
var level_transfer_C_FT0_under0 binary;
var level_reuse_C_FT0_under0 binary;
var level_transfer_C_FT0_under1 binary;
var level_reuse_C_FT0_under1 binary;
var level_transfer_C_FT0_under2 binary;
var level_reuse_C_FT0_under2 binary;
var Lat_comp_fused_S0_S1_3 >= 0;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
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
var B_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC1_for_B integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_B binary;
var cte_1 integer >=0;
var cte_2 integer >=0;
var cte_burst_without_tiling_TC4_for_B integer >= 0 <= 0;
var is_tc4_burst_witout_tiling_for_B binary;
var cte_3 integer >=0;
var burst_B_is_2 binary;
var cte_4 integer >=0;
var cte_5 integer >=0;
var cte_6 integer >=0;
var cte_7 integer >=0;
var burst_B_is_4 binary;
var cte_8 integer >=0;
var cte_9 integer >=0;
var cte_10 integer >=0;
var cte_11 integer >=0;
var burst_B_is_8 binary;
var cte_12 integer >=0;
var cte_13 integer >=0;
var cte_14 integer >=0;
var cte_15 integer >=0;
var burst_B_is_16 binary;
var cte_16 integer >=0;
var cte_17 integer >=0;
var cte_18 integer >=0;
var cte_19 integer >=0;
var C_is_fully_transfered_on_last_dim_FT0 binary;
var burst_C_is_1 binary;
var cte_20 integer >=0;
var cte_burst_without_tiling_TC1_for_C integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_C binary;
var burst_C_is_2 binary;
var cte_21 integer >=0;
var burst_C_is_4 binary;
var cte_22 integer >=0;
var burst_C_is_8 binary;
var cte_23 integer >=0;
var burst_C_is_16 binary;
var cte_24 integer >=0;
var A_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A_is_1 binary;
var cte_25 integer >=0;
var cte_burst_without_tiling_TC0_for_A integer >= 0 <= 8;
var is_tc0_burst_witout_tiling_for_A binary;
var burst_A_is_2 binary;
var cte_26 integer >=0;
var burst_A_is_4 binary;
var cte_27 integer >=0;
var burst_A_is_8 binary;
var cte_28 integer >=0;
var burst_A_is_16 binary;
var cte_29 integer >=0;
var footprint_tot_B_FT0 integer >= 1;
var burst_B integer >= 0;
var footprint_tot_C_FT0 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_A_FT0 integer >= 1;
var burst_A integer >= 0;
var Lat_comp_0_1 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Task 1 writes B to off-chip
#comment: Statement 0: B[i][j] += A[k][i] * C[k][j];
#comment: Statement 1: B[i][j] *= alpha;
#comment: Loop_0: i
#comment: Loop_1: j
#comment: Loop_2: k
#comment: Loop_3: i
#comment: Loop_4: j
#comment: Argument 0: float alpha
#comment: Argument 1: float A[200][200]
#comment: Argument 2: float B[200][240]
#comment: Argument 3: float C[200][240]
#comment:  2 is a reduction loop
#comment: Task 0 reads B from off-chip
#comment: Task 0 reads C from off-chip
#comment: Task 0 reads A from off-chip
#comment: Array B has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array B has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array B has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array B has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array B has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array B has for tc in dim 0 TC3 (ori=TC3_ori) arg0
#comment: Array B has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array B has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array C has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array C has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array A has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A has for tc in dim 1 TC0 (ori=TC0_ori) arg0
#comment: Sched 0 has reuse buffer B[TC0_1][TC1_1]
#comment: Sched 0 has reuse buffer A[TC2_1][TC0_1]
#comment: Sched 0 has reuse buffer C[TC2_1][TC1_1]
#comment: Sched 1 has reuse buffer B[TC3_1][TC4_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: perm0_S0 + perm1_S0 + perm2_S0 + perm3_S0 + perm4_S0 + perm5_S0 = 1; # only one permutation
subject to con3: perm0_S1 + perm1_S1 = 1; # only one permutation
subject to con4: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0 * log(TC2_1)/log(2); # latency of the intra-tile S0
subject to con5: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1; # latency of the intra-tile S1
subject to con6: perm1_S0 = 0; # because of the fused task 0
subject to con7: perm3_S0 = 0; # because of the fused task 0
subject to con8: perm4_S0 = 0; # because of the fused task 0
subject to con9: perm5_S0 = 0; # because of the fused task 0
subject to con10: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con11: perm2_S0 = perm1_S1; # same iteration of output in FT 0
subject to con12: is_fused_task0_in_SLR_0 * (footprint_B_S0_S1_reuse + footprint_A_S0_reuse + footprint_C_S0_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con13: level_reuse_B_FT0_under0 = level_transfer_B_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con14: level_reuse_B_FT0_under2 = 1; # transfer innermost for output
subject to con15: level_reuse_B_FT0_under1 = level_transfer_B_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con16: level_reuse_B_FT0_under2 = level_transfer_B_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con17: level_transfer_B_FT0_under0 + level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2 = 1; # only one level of transfer for B
subject to con18: level_reuse_B_FT0_under0 + level_reuse_B_FT0_under1 + level_reuse_B_FT0_under2 = 1; # only one level of reuse for B
subject to con19: level_reuse_A_FT0_under0 >= level_transfer_A_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con20: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 >= level_transfer_A_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con21: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 >= level_transfer_A_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con22: level_transfer_A_FT0_under0 + level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2 = 1; # only one level of transfer for A
subject to con23: level_reuse_A_FT0_under0 + level_reuse_A_FT0_under1 + level_reuse_A_FT0_under2 = 1; # only one level of reuse for A
subject to con24: level_reuse_C_FT0_under0 >= level_transfer_C_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con25: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 >= level_transfer_C_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con26: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 + level_reuse_C_FT0_under2 >= level_transfer_C_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con27: level_transfer_C_FT0_under0 + level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2 = 1; # only one level of transfer for C
subject to con28: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 + level_reuse_C_FT0_under2 = 1; # only one level of reuse for C
subject to con29: level_reuse_B_FT0_under0 = level_transfer_B_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con30: level_reuse_B_FT0_under1 = level_transfer_B_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con31: level_reuse_B_FT0_under2 = level_transfer_B_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con32: Lat_comp_fused_S0_S1_3 = ((Lat_comp_S0_intra_tile + II_S0_seq * TC2_0) + (Lat_comp_S1_intra_tile)); # latency of the fused task S0_S1 level 3
subject to con33: Lat_comp_fused_S0_S1_2 = (perm0_S0 * TC1_0 + perm1_S0 * TC2_0 + perm2_S0 * TC0_0 + perm3_S0 * TC2_0 + perm4_S0 * TC0_0 + perm5_S0 * TC1_0) * max(Lat_comp_fused_S0_S1_3, level_transfer_B_FT0_under2 * footprint_B_S0_S1 / burst_B, level_transfer_A_FT0_under2 * footprint_A_S0 / burst_A, level_transfer_C_FT0_under2 * footprint_C_S0 / burst_C) + Lat_comp_fused_S0_S1_3 + max(level_transfer_B_FT0_under2 * footprint_B_S0_S1 / burst_B, level_transfer_A_FT0_under2 * footprint_A_S0 / burst_A, level_transfer_C_FT0_under2 * footprint_C_S0 / burst_C  + level_transfer_B_FT0_under2 * footprint_B_S0_S1 / burst_B); # latency of the fused task S0_S1 level 2
subject to con34: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC0_0 + perm2_S0 * TC1_0 + perm3_S0 * TC1_0 + perm4_S0 * TC2_0 + perm5_S0 * TC2_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_B_FT0_under1 * footprint_B_S0_S1 / burst_B, level_transfer_A_FT0_under1 * footprint_A_S0 / burst_A, level_transfer_C_FT0_under1 * footprint_C_S0 / burst_C) + Lat_comp_fused_S0_S1_2 + max(level_transfer_B_FT0_under1 * footprint_B_S0_S1 / burst_B, level_transfer_A_FT0_under1 * footprint_A_S0 / burst_A, level_transfer_C_FT0_under1 * footprint_C_S0 / burst_C  + level_transfer_B_FT0_under1 * footprint_B_S0_S1 / burst_B); # latency of the fused task S0_S1 level 1
subject to con35: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_B_FT0_under0 * footprint_tot_B_FT0 / burst_B + level_transfer_A_FT0_under0 * footprint_tot_A_FT0 / burst_A + level_transfer_C_FT0_under0 * footprint_tot_C_FT0 / burst_C; # latency of the fused task S0_S1
subject to con36: perm4_S0 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con37: perm4_S0 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con38: perm5_S0 * level_transfer_B_FT0_under1 = 0; # useless to transfer under this loop
subject to con39: perm5_S0 * level_reuse_B_FT0_under1 = 0; # useless to reuse under this loop
subject to con40: perm1_S0 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con41: perm1_S0 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con42: perm3_S0 * level_transfer_B_FT0_under2 = 0; # useless to transfer under this loop
subject to con43: perm3_S0 * level_reuse_B_FT0_under2 = 0; # useless to reuse under this loop
subject to con44: footprint_B_S0_S1 = level_transfer_B_FT0_under0 * footprint_tot_B_FT0 + level_transfer_B_FT0_under1 * (perm0_S0 * footprint_tot_B_FT0/ TC0_0 + perm1_S0 * footprint_tot_B_FT0/ TC0_0 + perm2_S0 * footprint_tot_B_FT0/ TC1_0 + perm3_S0 * footprint_tot_B_FT0/ TC1_0 + perm4_S0 * footprint_tot_B_FT0 + perm5_S0 * footprint_tot_B_FT0) + level_transfer_B_FT0_under2 * (perm0_S0 * footprint_tot_B_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_B_FT0/ TC0_0 + perm2_S0 * footprint_tot_B_FT0/ TC1_0/ TC0_0 + perm3_S0 * footprint_tot_B_FT0/ TC1_0 + perm4_S0 * footprint_tot_B_FT0/ TC0_0 + perm5_S0 * footprint_tot_B_FT0/ TC1_0); # footprint of the array B for the fused task 0
subject to con45: footprint_B_S0_S1_reuse = level_reuse_B_FT0_under0 * footprint_tot_B_FT0 + level_reuse_B_FT0_under1 * (perm0_S0 * footprint_tot_B_FT0/ TC0_0 + perm1_S0 * footprint_tot_B_FT0/ TC0_0 + perm2_S0 * footprint_tot_B_FT0/ TC1_0 + perm3_S0 * footprint_tot_B_FT0/ TC1_0 + perm4_S0 * footprint_tot_B_FT0 + perm5_S0 * footprint_tot_B_FT0) + level_reuse_B_FT0_under2 * (perm0_S0 * footprint_tot_B_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_B_FT0/ TC0_0 + perm2_S0 * footprint_tot_B_FT0/ TC1_0/ TC0_0 + perm3_S0 * footprint_tot_B_FT0/ TC1_0 + perm4_S0 * footprint_tot_B_FT0/ TC0_0 + perm5_S0 * footprint_tot_B_FT0/ TC1_0); # footprint of the array B for the fused task 0
subject to con46: perm2_S0 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con47: perm2_S0 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con48: perm3_S0 * level_transfer_A_FT0_under1 = 0; # useless to transfer under this loop
subject to con49: perm3_S0 * level_reuse_A_FT0_under1 = 0; # useless to reuse under this loop
subject to con50: perm0_S0 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con51: perm0_S0 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con52: perm5_S0 * level_transfer_A_FT0_under2 = 0; # useless to transfer under this loop
subject to con53: perm5_S0 * level_reuse_A_FT0_under2 = 0; # useless to reuse under this loop
subject to con54: footprint_A_S0 = level_transfer_A_FT0_under0 * footprint_tot_A_FT0 + level_transfer_A_FT0_under1 * (perm0_S0 * footprint_tot_A_FT0/ TC0_0 + perm1_S0 * footprint_tot_A_FT0/ TC0_0 + perm2_S0 * footprint_tot_A_FT0 + perm3_S0 * footprint_tot_A_FT0 + perm4_S0 * footprint_tot_A_FT0/ TC2_0 + perm5_S0 * footprint_tot_A_FT0/ TC2_0) + level_transfer_A_FT0_under2 * (perm0_S0 * footprint_tot_A_FT0/ TC0_0 + perm1_S0 * footprint_tot_A_FT0/ TC0_0/ TC2_0 + perm2_S0 * footprint_tot_A_FT0/ TC0_0 + perm3_S0 * footprint_tot_A_FT0/ TC2_0 + perm4_S0 * footprint_tot_A_FT0/ TC2_0/ TC0_0 + perm5_S0 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con55: footprint_A_S0_reuse = level_reuse_A_FT0_under0 * footprint_tot_A_FT0 + level_reuse_A_FT0_under1 * (perm0_S0 * footprint_tot_A_FT0/ TC0_0 + perm1_S0 * footprint_tot_A_FT0/ TC0_0 + perm2_S0 * footprint_tot_A_FT0 + perm3_S0 * footprint_tot_A_FT0 + perm4_S0 * footprint_tot_A_FT0/ TC2_0 + perm5_S0 * footprint_tot_A_FT0/ TC2_0) + level_reuse_A_FT0_under2 * (perm0_S0 * footprint_tot_A_FT0/ TC0_0 + perm1_S0 * footprint_tot_A_FT0/ TC0_0/ TC2_0 + perm2_S0 * footprint_tot_A_FT0/ TC0_0 + perm3_S0 * footprint_tot_A_FT0/ TC2_0 + perm4_S0 * footprint_tot_A_FT0/ TC2_0/ TC0_0 + perm5_S0 * footprint_tot_A_FT0/ TC2_0); # footprint of the array A for the fused task 0
subject to con56: perm0_S0 * level_transfer_C_FT0_under1 = 0; # useless to transfer under this loop
subject to con57: perm0_S0 * level_reuse_C_FT0_under1 = 0; # useless to reuse under this loop
subject to con58: perm1_S0 * level_transfer_C_FT0_under1 = 0; # useless to transfer under this loop
subject to con59: perm1_S0 * level_reuse_C_FT0_under1 = 0; # useless to reuse under this loop
subject to con60: perm2_S0 * level_transfer_C_FT0_under2 = 0; # useless to transfer under this loop
subject to con61: perm2_S0 * level_reuse_C_FT0_under2 = 0; # useless to reuse under this loop
subject to con62: perm4_S0 * level_transfer_C_FT0_under2 = 0; # useless to transfer under this loop
subject to con63: perm4_S0 * level_reuse_C_FT0_under2 = 0; # useless to reuse under this loop
subject to con64: footprint_C_S0 = level_transfer_C_FT0_under0 * footprint_tot_C_FT0 + level_transfer_C_FT0_under1 * (perm0_S0 * footprint_tot_C_FT0 + perm1_S0 * footprint_tot_C_FT0 + perm2_S0 * footprint_tot_C_FT0/ TC1_0 + perm3_S0 * footprint_tot_C_FT0/ TC1_0 + perm4_S0 * footprint_tot_C_FT0/ TC2_0 + perm5_S0 * footprint_tot_C_FT0/ TC2_0) + level_transfer_C_FT0_under2 * (perm0_S0 * footprint_tot_C_FT0/ TC1_0 + perm1_S0 * footprint_tot_C_FT0/ TC2_0 + perm2_S0 * footprint_tot_C_FT0/ TC1_0 + perm3_S0 * footprint_tot_C_FT0/ TC1_0/ TC2_0 + perm4_S0 * footprint_tot_C_FT0/ TC2_0 + perm5_S0 * footprint_tot_C_FT0/ TC2_0/ TC1_0); # footprint of the array C for the fused task 0
subject to con65: footprint_C_S0_reuse = level_reuse_C_FT0_under0 * footprint_tot_C_FT0 + level_reuse_C_FT0_under1 * (perm0_S0 * footprint_tot_C_FT0 + perm1_S0 * footprint_tot_C_FT0 + perm2_S0 * footprint_tot_C_FT0/ TC1_0 + perm3_S0 * footprint_tot_C_FT0/ TC1_0 + perm4_S0 * footprint_tot_C_FT0/ TC2_0 + perm5_S0 * footprint_tot_C_FT0/ TC2_0) + level_reuse_C_FT0_under2 * (perm0_S0 * footprint_tot_C_FT0/ TC1_0 + perm1_S0 * footprint_tot_C_FT0/ TC2_0 + perm2_S0 * footprint_tot_C_FT0/ TC1_0 + perm3_S0 * footprint_tot_C_FT0/ TC1_0/ TC2_0 + perm4_S0 * footprint_tot_C_FT0/ TC2_0 + perm5_S0 * footprint_tot_C_FT0/ TC2_0/ TC1_0); # footprint of the array C for the fused task 0
subject to con66: TC0_1 * TC1_1 * TC2_1 <= MAX_UF;
subject to con67: TC3_1 * TC4_1 <= MAX_UF;
subject to con68: TC0_1 * TC1_1 * TC2_1 * DSP_S0 / II_S0_seq + TC3_1 * TC4_1 * DSP_S1  <= DSP_avail; # DSP constraint
subject to con69: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * TC2_1 * DSP_S0 / II_S0_seq + TC3_1 * TC4_1 * DSP_S1); # DSP constraint per SLR
subject to con70: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con71: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con72: TC0_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con73: TC3_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con74: TC3_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B 
subject to con75: TC2_1 * TC0_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A 
subject to con76: TC2_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con77: Lat_comp_S1_for_off_chip = perm0_S1 * II_S1_par + perm1_S1 * II_S1_par; # stall between task
subject to con78: TC0_0 <= TC0; # TC of split loop
subject to con79: TC0_1 <= TC0; # TC of split loop
subject to con80: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con81: TC1_0 <= TC1; # TC of split loop
subject to con82: TC1_1 <= TC1; # TC of split loop
subject to con83: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con84: TC2_0 <= TC2; # TC of split loop
subject to con85: TC2_1 <= TC2; # TC of split loop
subject to con86: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con87: TC3_0 <= TC3; # TC of split loop
subject to con88: TC3_1 <= TC3; # TC of split loop
subject to con89: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con90: TC4_0 <= TC4; # TC of split loop
subject to con91: TC4_1 <= TC4; # TC of split loop
subject to con92: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con93: TC0_1 = TC3_1; # same intra tile for the same dimension of the array B in the fused task
subject to con94: TC1_1 = TC4_1; # same intra tile for the same dimension of the array B in the fused task
subject to con95: B_is_fully_transfered_on_last_dim_FT0 = level_transfer_B_FT0_under0 + perm0_S0 * (level_transfer_B_FT0_under1) + perm1_S0 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm4_S0 * (level_transfer_B_FT0_under1 + level_transfer_B_FT0_under2) + perm5_S0 * (level_transfer_B_FT0_under1); # the array B is fully transfered on the last dimension
subject to con96: B_is_fully_transfered_on_last_dim_FT0 = level_transfer_B_FT0_under0 + perm0_S1 * (level_transfer_B_FT0_under1); # the array B is fully transfered on the last dimension
subject to con97: burst_B_is_1 * cte_0 * 1 = burst_B_is_1 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con98: is_tc1_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC1_for_B);
subject to con99: burst_B_is_1 * cte_1 * 1 = burst_B_is_1 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con100: burst_B_is_1 * cte_2 * 1 = burst_B_is_1 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con101: is_tc4_burst_witout_tiling_for_B =  min(1, cte_burst_without_tiling_TC4_for_B);
subject to con102: burst_B_is_1 * cte_3 * 1 = burst_B_is_1 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con103: burst_B_is_2 * cte_4 * 2 = burst_B_is_2 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con104: burst_B_is_2 * cte_5 * 2 = burst_B_is_2 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con105: burst_B_is_2 * cte_6 * 2 = burst_B_is_2 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con106: burst_B_is_2 * cte_7 * 2 = burst_B_is_2 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con107: burst_B_is_4 * cte_8 * 4 = burst_B_is_4 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con108: burst_B_is_4 * cte_9 * 4 = burst_B_is_4 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con109: burst_B_is_4 * cte_10 * 4 = burst_B_is_4 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con110: burst_B_is_4 * cte_11 * 4 = burst_B_is_4 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con111: burst_B_is_8 * cte_12 * 8 = burst_B_is_8 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con112: burst_B_is_8 * cte_13 * 8 = burst_B_is_8 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con113: burst_B_is_8 * cte_14 * 8 = burst_B_is_8 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con114: burst_B_is_8 * cte_15 * 8 = burst_B_is_8 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con115: burst_B_is_16 * cte_16 * 16 = burst_B_is_16 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con116: burst_B_is_16 * cte_17 * 16 = burst_B_is_16 * ((1-is_tc1_burst_witout_tiling_for_B) * (TC1_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC1 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC1_for_B + TC1));
subject to con117: burst_B_is_16 * cte_18 * 16 = burst_B_is_16 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con118: burst_B_is_16 * cte_19 * 16 = burst_B_is_16 * ((1-is_tc4_burst_witout_tiling_for_B) * (TC4_1 * (1-B_is_fully_transfered_on_last_dim_FT0) + TC4 * (B_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_B * (cte_burst_without_tiling_TC4_for_B + TC4));
subject to con119: burst_B = burst_B_is_1 * 1 + burst_B_is_2 * 2 + burst_B_is_4 * 4 + burst_B_is_8 * 8 + burst_B_is_16 * 16; # burst size of the array B
subject to con120: burst_B_is_1 + burst_B_is_2 + burst_B_is_4 + burst_B_is_8 + burst_B_is_16 = 1; # only one burst size for the array B
subject to con121: is_tc1_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT0;
subject to con122: is_tc4_burst_witout_tiling_for_B <= B_is_fully_transfered_on_last_dim_FT0;
subject to con123: C_is_fully_transfered_on_last_dim_FT0 = level_transfer_C_FT0_under0 + perm0_S0 * (level_transfer_C_FT0_under1) + perm1_S0 * (level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2) + perm4_S0 * (level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2) + perm5_S0 * (level_transfer_C_FT0_under1); # the array C is fully transfered on the last dimension
subject to con124: burst_C_is_1 * cte_20 * 1 = burst_C_is_1 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con125: is_tc1_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC1_for_C);
subject to con126: burst_C_is_2 * cte_21 * 2 = burst_C_is_2 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con127: burst_C_is_4 * cte_22 * 4 = burst_C_is_4 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con128: burst_C_is_8 * cte_23 * 8 = burst_C_is_8 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con129: burst_C_is_16 * cte_24 * 16 = burst_C_is_16 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con130: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con131: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con132: is_tc1_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT0;
subject to con133: A_is_fully_transfered_on_last_dim_FT0 = level_transfer_A_FT0_under0 + perm2_S0 * (level_transfer_A_FT0_under1) + perm3_S0 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2) + perm4_S0 * (level_transfer_A_FT0_under1) + perm5_S0 * (level_transfer_A_FT0_under1 + level_transfer_A_FT0_under2); # the array A is fully transfered on the last dimension
subject to con134: burst_A_is_1 * cte_25 * 1 = burst_A_is_1 * ((1-is_tc0_burst_witout_tiling_for_A) * (TC0_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC0 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC0_for_A + TC0));
subject to con135: is_tc0_burst_witout_tiling_for_A =  min(1, cte_burst_without_tiling_TC0_for_A);
subject to con136: burst_A_is_2 * cte_26 * 2 = burst_A_is_2 * ((1-is_tc0_burst_witout_tiling_for_A) * (TC0_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC0 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC0_for_A + TC0));
subject to con137: burst_A_is_4 * cte_27 * 4 = burst_A_is_4 * ((1-is_tc0_burst_witout_tiling_for_A) * (TC0_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC0 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC0_for_A + TC0));
subject to con138: burst_A_is_8 * cte_28 * 8 = burst_A_is_8 * ((1-is_tc0_burst_witout_tiling_for_A) * (TC0_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC0 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC0_for_A + TC0));
subject to con139: burst_A_is_16 * cte_29 * 16 = burst_A_is_16 * ((1-is_tc0_burst_witout_tiling_for_A) * (TC0_1 * (1-A_is_fully_transfered_on_last_dim_FT0) + TC0 * (A_is_fully_transfered_on_last_dim_FT0)) + is_tc0_burst_witout_tiling_for_A * (cte_burst_without_tiling_TC0_for_A + TC0));
subject to con140: burst_A = burst_A_is_1 * 1 + burst_A_is_2 * 2 + burst_A_is_4 * 4 + burst_A_is_8 * 8 + burst_A_is_16 * 16; # burst size of the array A
subject to con141: burst_A_is_1 + burst_A_is_2 + burst_A_is_4 + burst_A_is_8 + burst_A_is_16 = 1; # only one burst size for the array A
subject to con142: is_tc0_burst_witout_tiling_for_A <= A_is_fully_transfered_on_last_dim_FT0;
subject to con143: footprint_tot_B_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_B);
subject to con144: footprint_tot_B_FT0 = TC3_ori * TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_B);
subject to con145: footprint_tot_C_FT0 = TC2_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_C);
subject to con146: footprint_tot_A_FT0 = TC2_ori * TC0_0 * (TC0_1 + cte_burst_without_tiling_TC0_for_A);
subject to con147: TC2 = TC2_ori;
subject to con148: TC3 = TC3_ori;
subject to con149: obj = Lat_comp_fused_S0_S1 + 1/burst_B + 1/burst_C + 1/burst_A + 1/(is_slr0_used);
subject to con150: B_is_fully_transfered_on_last_dim_FT0 * B_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC3_1) = B_is_fully_transfered_on_last_dim_FT0 * B_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC3_1) * cte_tiling_0; # should divide for B in dim 0
subject to con151: B_is_fully_transfered_on_last_dim_FT0 * B_is_fully_transfered_on_last_dim_FT0 * max(TC1_1, TC4_1) = B_is_fully_transfered_on_last_dim_FT0 * B_is_fully_transfered_on_last_dim_FT0 * min(TC1_1, TC4_1) * cte_tiling_1; # should divide for B in dim 1
subject to con152: buffer_size = footprint_B_S0_S1_reuse + footprint_A_S0_reuse + footprint_C_S0_reuse; # total buffer size
subject to con153: fifo_size = 0; # total fifo size
subject to con154: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con155: perm4_S0 * level_reuse_B_FT0_under0 = perm4_S0 * 1;
subject to con156: perm5_S0 * level_reuse_B_FT0_under0 = perm5_S0 * 1;
subject to con157: perm0_S0 * level_reuse_C_FT0_under0 = perm0_S0 * 1;
subject to con158: perm1_S0 * level_reuse_C_FT0_under0 = perm1_S0 * 1;
subject to con159: perm2_S0 * level_reuse_A_FT0_under0 = perm2_S0 * 1;
subject to con160: perm3_S0 * level_reuse_A_FT0_under0 = perm3_S0 * 1;
solve;
display TC0;
display TC1;
display TC2;
display TC3;
display TC4;
display is_fused_task0_in_SLR_0;
display is_slr0_used;
display perm0_S0;
display perm1_S0;
display perm2_S0;
display perm3_S0;
display perm4_S0;
display perm5_S0;
display perm0_S1;
display Lat_comp_S1_for_off_chip;
display perm1_S1;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display footprint_B_S0_S1;
display footprint_B_S0_S1_reuse;
display footprint_A_S0;
display footprint_A_S0_reuse;
display footprint_C_S0;
display footprint_C_S0_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_B_FT0_under0;
display level_reuse_B_FT0_under0;
display level_transfer_B_FT0_under1;
display level_reuse_B_FT0_under1;
display level_transfer_B_FT0_under2;
display level_reuse_B_FT0_under2;
display level_transfer_A_FT0_under0;
display level_reuse_A_FT0_under0;
display level_transfer_A_FT0_under1;
display level_reuse_A_FT0_under1;
display level_transfer_A_FT0_under2;
display level_reuse_A_FT0_under2;
display level_transfer_C_FT0_under0;
display level_reuse_C_FT0_under0;
display level_transfer_C_FT0_under1;
display level_reuse_C_FT0_under1;
display level_transfer_C_FT0_under2;
display level_reuse_C_FT0_under2;
display Lat_comp_fused_S0_S1_3;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
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
display B_is_fully_transfered_on_last_dim_FT0;
display burst_B_is_1;
display cte_0;
display cte_burst_without_tiling_TC1_for_B;
display is_tc1_burst_witout_tiling_for_B;
display cte_1;
display cte_2;
display cte_burst_without_tiling_TC4_for_B;
display is_tc4_burst_witout_tiling_for_B;
display cte_3;
display burst_B_is_2;
display cte_4;
display cte_5;
display cte_6;
display cte_7;
display burst_B_is_4;
display cte_8;
display cte_9;
display cte_10;
display cte_11;
display burst_B_is_8;
display cte_12;
display cte_13;
display cte_14;
display cte_15;
display burst_B_is_16;
display cte_16;
display cte_17;
display cte_18;
display cte_19;
display C_is_fully_transfered_on_last_dim_FT0;
display burst_C_is_1;
display cte_20;
display cte_burst_without_tiling_TC1_for_C;
display is_tc1_burst_witout_tiling_for_C;
display burst_C_is_2;
display cte_21;
display burst_C_is_4;
display cte_22;
display burst_C_is_8;
display cte_23;
display burst_C_is_16;
display cte_24;
display A_is_fully_transfered_on_last_dim_FT0;
display burst_A_is_1;
display cte_25;
display cte_burst_without_tiling_TC0_for_A;
display is_tc0_burst_witout_tiling_for_A;
display burst_A_is_2;
display cte_26;
display burst_A_is_4;
display cte_27;
display burst_A_is_8;
display cte_28;
display burst_A_is_16;
display cte_29;
display footprint_tot_B_FT0;
display burst_B;
display footprint_tot_C_FT0;
display burst_C;
display footprint_tot_A_FT0;
display burst_A;
display Lat_comp_0_1;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display buffer_size;
display fifo_size;
display _total_solve_time;
