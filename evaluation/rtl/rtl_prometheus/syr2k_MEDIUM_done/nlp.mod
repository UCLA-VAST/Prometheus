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
param TC0_ori = 240;
param TC1_ori = 240;
param TC2_ori = 240;
param TC3_ori = 200;
param TC4_ori = 240;
param IL_par_S0 = 4;
param IL_seq_S0 = 0;
param IL_par_S1 = 23;
param IL_seq_S1 = 7;
param DSP_S0 = 3;
param DSP_S1 = 16;

var TC0 integer >= 240 <= 240;
var TC1 integer >= 240 <= 240;
var TC2 integer >= 240 <= 240;
var TC3 integer >= 200 <= 208;
var TC4 integer >= 240 <= 240;
var is_fused_task0_in_SLR_0 binary;
var is_slr0_used binary;
var perm0_S0 binary; # [0, 0, 0, 1, 0, 0, 0, 1, 0]
var perm1_S0 binary; # [0, 1, 0, 0, 0, 1, 0, 0, 0]
var perm0_S1 binary; # [1, 2, 0, 3, 0, 4, 0, 2, 0, 3, 0, 4, 0]
var Lat_comp_S1_for_off_chip >= 0;
var perm1_S1 binary; # [1, 2, 0, 4, 0, 3, 0, 2, 0, 4, 0, 3, 0]
var perm2_S1 binary; # [1, 3, 0, 2, 0, 4, 0, 3, 0, 2, 0, 4, 0]
var perm3_S1 binary; # [1, 3, 0, 4, 0, 2, 0, 3, 0, 4, 0, 2, 0]
var perm4_S1 binary; # [1, 4, 0, 2, 0, 3, 0, 4, 0, 2, 0, 3, 0]
var perm5_S1 binary; # [1, 4, 0, 3, 0, 2, 0, 4, 0, 3, 0, 2, 0]
var Lat_comp_S0_intra_tile >= 0;
var Lat_comp_S1_intra_tile >= 0;
var footprint_C_S0_S1 integer >= 0;
var footprint_C_S0_S1_reuse integer >= 0;
var footprint_A1_S1 integer >= 0;
var footprint_A1_S1_reuse integer >= 0;
var footprint_B1_S1 integer >= 0;
var footprint_B1_S1_reuse integer >= 0;
var footprint_B2_S1 integer >= 0;
var footprint_B2_S1_reuse integer >= 0;
var footprint_A2_S1 integer >= 0;
var footprint_A2_S1_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_C_FT0_under0 binary;
var level_reuse_C_FT0_under0 binary;
var level_transfer_C_FT0_under1 binary;
var level_reuse_C_FT0_under1 binary;
var level_transfer_C_FT0_under2 binary;
var level_reuse_C_FT0_under2 binary;
var level_transfer_A1_FT0_under0 binary;
var level_reuse_A1_FT0_under0 binary;
var level_transfer_A1_FT0_under1 binary;
var level_reuse_A1_FT0_under1 binary;
var level_transfer_A1_FT0_under2 binary;
var level_reuse_A1_FT0_under2 binary;
var level_transfer_B1_FT0_under0 binary;
var level_reuse_B1_FT0_under0 binary;
var level_transfer_B1_FT0_under1 binary;
var level_reuse_B1_FT0_under1 binary;
var level_transfer_B1_FT0_under2 binary;
var level_reuse_B1_FT0_under2 binary;
var level_transfer_B2_FT0_under0 binary;
var level_reuse_B2_FT0_under0 binary;
var level_transfer_B2_FT0_under1 binary;
var level_reuse_B2_FT0_under1 binary;
var level_transfer_B2_FT0_under2 binary;
var level_reuse_B2_FT0_under2 binary;
var level_transfer_A2_FT0_under0 binary;
var level_reuse_A2_FT0_under0 binary;
var level_transfer_A2_FT0_under1 binary;
var level_reuse_A2_FT0_under1 binary;
var level_transfer_A2_FT0_under2 binary;
var level_reuse_A2_FT0_under2 binary;
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
var B1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B1_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC3_for_B1 integer >= 0 <= 8;
var is_tc3_burst_witout_tiling_for_B1 binary;
var burst_B1_is_2 binary;
var cte_1 integer >=0;
var burst_B1_is_4 binary;
var cte_2 integer >=0;
var burst_B1_is_8 binary;
var cte_3 integer >=0;
var burst_B1_is_16 binary;
var cte_4 integer >=0;
var C_is_fully_transfered_on_last_dim_FT0 binary;
var burst_C_is_1 binary;
var cte_5 integer >=0;
var cte_burst_without_tiling_TC1_for_C integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_C binary;
var cte_6 integer >=0;
var cte_7 integer >=0;
var cte_burst_without_tiling_TC4_for_C integer >= 0 <= 0;
var is_tc4_burst_witout_tiling_for_C binary;
var cte_8 integer >=0;
var burst_C_is_2 binary;
var cte_9 integer >=0;
var cte_10 integer >=0;
var cte_11 integer >=0;
var cte_12 integer >=0;
var burst_C_is_4 binary;
var cte_13 integer >=0;
var cte_14 integer >=0;
var cte_15 integer >=0;
var cte_16 integer >=0;
var burst_C_is_8 binary;
var cte_17 integer >=0;
var cte_18 integer >=0;
var cte_19 integer >=0;
var cte_20 integer >=0;
var burst_C_is_16 binary;
var cte_21 integer >=0;
var cte_22 integer >=0;
var cte_23 integer >=0;
var cte_24 integer >=0;
var A1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A1_is_1 binary;
var cte_25 integer >=0;
var cte_burst_without_tiling_TC3_for_A1 integer >= 0 <= 8;
var is_tc3_burst_witout_tiling_for_A1 binary;
var burst_A1_is_2 binary;
var cte_26 integer >=0;
var burst_A1_is_4 binary;
var cte_27 integer >=0;
var burst_A1_is_8 binary;
var cte_28 integer >=0;
var burst_A1_is_16 binary;
var cte_29 integer >=0;
var A2_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A2_is_1 binary;
var cte_30 integer >=0;
var cte_burst_without_tiling_TC3_for_A2 integer >= 0 <= 8;
var is_tc3_burst_witout_tiling_for_A2 binary;
var burst_A2_is_2 binary;
var cte_31 integer >=0;
var burst_A2_is_4 binary;
var cte_32 integer >=0;
var burst_A2_is_8 binary;
var cte_33 integer >=0;
var burst_A2_is_16 binary;
var cte_34 integer >=0;
var B2_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B2_is_1 binary;
var cte_35 integer >=0;
var cte_burst_without_tiling_TC3_for_B2 integer >= 0 <= 8;
var is_tc3_burst_witout_tiling_for_B2 binary;
var burst_B2_is_2 binary;
var cte_36 integer >=0;
var burst_B2_is_4 binary;
var cte_37 integer >=0;
var burst_B2_is_8 binary;
var cte_38 integer >=0;
var burst_B2_is_16 binary;
var cte_39 integer >=0;
var footprint_tot_B1_FT0 integer >= 1;
var burst_B1 integer >= 0;
var footprint_tot_C_FT0 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_A1_FT0 integer >= 1;
var burst_A1 integer >= 0;
var footprint_tot_A2_FT0 integer >= 1;
var burst_A2 integer >= 0;
var footprint_tot_B2_FT0 integer >= 1;
var burst_B2 integer >= 0;
var Lat_comp_0_1 >= 0;
var obj >= 0;
var cte_tiling_0 integer >= 0;
var cte_tiling_1 integer >= 0;
var buffer_size >= 0;
var fifo_size >= 0;

#comment: Fuse [0, 1]
#comment: Task 1 writes C to off-chip
#comment: Statement 0: C[i][j] *= beta;
#comment: Statement 1: C[i][j] += A1[j][k] * alpha * B1[i][k] + B2[j][k] * alpha * A2[i][k];
#comment: Loop_0: i
#comment: Loop_1: j
#comment: Loop_2: i
#comment: Loop_3: k
#comment: Loop_4: j
#comment: Argument 0: float alpha
#comment: Argument 1: float beta
#comment: Argument 2: float C[240][240]
#comment: Argument 3: float A1[240][200]
#comment: Argument 4: float B1[240][200]
#comment: Argument 5: float A2[240][200]
#comment: Argument 6: float B2[240][200]
#comment:  3 is a reduction loop
#comment: Task 1 reads B1 from off-chip
#comment: Task 0 reads C from off-chip
#comment: Task 1 reads A1 from off-chip
#comment: Task 1 reads A2 from off-chip
#comment: Task 1 reads B2 from off-chip
#comment: Array B1 has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array B1 has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array C has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array C has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array C has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array C has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array C has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array C has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array C has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array C has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array A1 has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array A1 has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array A2 has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A2 has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array B2 has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array B2 has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Sched 0 has reuse buffer C[TC0_1][TC1_1]
#comment: Sched 1 has reuse buffer C[TC2_1][TC4_1]
#comment: Sched 1 has reuse buffer A1[TC4_1][TC3_1]
#comment: Sched 1 has reuse buffer B1[TC2_1][TC3_1]
#comment: Sched 1 has reuse buffer B2[TC4_1][TC3_1]
#comment: Sched 1 has reuse buffer A2[TC2_1][TC3_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: perm0_S0 + perm1_S0 = 1; # only one permutation
subject to con3: perm0_S1 + perm1_S1 + perm2_S1 + perm3_S1 + perm4_S1 + perm5_S1 = 1; # only one permutation
subject to con4: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con5: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC3_1)/log(2); # latency of the intra-tile S1
subject to con6: perm0_S1 = 0; # because of the fused task 0
subject to con7: perm2_S1 = 0; # because of the fused task 0
subject to con8: perm3_S1 = 0; # because of the fused task 0
subject to con9: perm5_S1 = 0; # because of the fused task 0
subject to con10: perm0_S0 = perm1_S1; # same iteration of output in FT 0
subject to con11: perm1_S0 = perm4_S1; # same iteration of output in FT 0
subject to con12: is_fused_task0_in_SLR_0 * (footprint_C_S0_S1_reuse + footprint_A1_S1_reuse + footprint_B1_S1_reuse + footprint_B2_S1_reuse + footprint_A2_S1_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con13: level_reuse_C_FT0_under0 = level_transfer_C_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con14: level_reuse_C_FT0_under2 = 1; # transfer innermost for output
subject to con15: level_reuse_C_FT0_under1 = level_transfer_C_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con16: level_reuse_C_FT0_under2 = level_transfer_C_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con17: level_transfer_C_FT0_under0 + level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2 = 1; # only one level of transfer for C
subject to con18: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 + level_reuse_C_FT0_under2 = 1; # only one level of reuse for C
subject to con19: level_reuse_C_FT0_under0 >= level_transfer_C_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con20: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 >= level_transfer_C_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con21: level_reuse_C_FT0_under0 + level_reuse_C_FT0_under1 + level_reuse_C_FT0_under2 >= level_transfer_C_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con22: level_reuse_A1_FT0_under0 >= level_transfer_A1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con23: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 >= level_transfer_A1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con24: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 + level_reuse_A1_FT0_under2 >= level_transfer_A1_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con25: level_transfer_A1_FT0_under0 + level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2 = 1; # only one level of transfer for A1
subject to con26: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 + level_reuse_A1_FT0_under2 = 1; # only one level of reuse for A1
subject to con27: level_reuse_B1_FT0_under0 = level_transfer_B1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con28: level_reuse_B1_FT0_under1 = level_transfer_B1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con29: level_reuse_B1_FT0_under2 = level_transfer_B1_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con30: level_transfer_B1_FT0_under0 + level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2 = 1; # only one level of transfer for B1
subject to con31: level_reuse_B1_FT0_under0 + level_reuse_B1_FT0_under1 + level_reuse_B1_FT0_under2 = 1; # only one level of reuse for B1
subject to con32: level_reuse_B2_FT0_under0 >= level_transfer_B2_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con33: level_reuse_B2_FT0_under0 + level_reuse_B2_FT0_under1 >= level_transfer_B2_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con34: level_reuse_B2_FT0_under0 + level_reuse_B2_FT0_under1 + level_reuse_B2_FT0_under2 >= level_transfer_B2_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con35: level_transfer_B2_FT0_under0 + level_transfer_B2_FT0_under1 + level_transfer_B2_FT0_under2 = 1; # only one level of transfer for B2
subject to con36: level_reuse_B2_FT0_under0 + level_reuse_B2_FT0_under1 + level_reuse_B2_FT0_under2 = 1; # only one level of reuse for B2
subject to con37: level_reuse_A2_FT0_under0 = level_transfer_A2_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con38: level_reuse_A2_FT0_under1 = level_transfer_A2_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con39: level_reuse_A2_FT0_under2 = level_transfer_A2_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con40: level_transfer_A2_FT0_under0 + level_transfer_A2_FT0_under1 + level_transfer_A2_FT0_under2 = 1; # only one level of transfer for A2
subject to con41: level_reuse_A2_FT0_under0 + level_reuse_A2_FT0_under1 + level_reuse_A2_FT0_under2 = 1; # only one level of reuse for A2
subject to con42: Lat_comp_fused_S0_S1_3 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC3_0)); # latency of the fused task S0_S1 level 3
subject to con43: Lat_comp_fused_S0_S1_2 = (perm0_S0 * TC1_0 + perm1_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_3, level_transfer_C_FT0_under2 * footprint_C_S0_S1 / burst_C, level_transfer_A1_FT0_under2 * footprint_A1_S1 / burst_A1, level_transfer_B1_FT0_under2 * footprint_B1_S1 / burst_B1, level_transfer_B2_FT0_under2 * footprint_B2_S1 / burst_B2, level_transfer_A2_FT0_under2 * footprint_A2_S1 / burst_A2) + Lat_comp_fused_S0_S1_3 + max(level_transfer_C_FT0_under2 * footprint_C_S0_S1 / burst_C, level_transfer_A1_FT0_under2 * footprint_A1_S1 / burst_A1, level_transfer_B1_FT0_under2 * footprint_B1_S1 / burst_B1, level_transfer_B2_FT0_under2 * footprint_B2_S1 / burst_B2, level_transfer_A2_FT0_under2 * footprint_A2_S1 / burst_A2  + level_transfer_C_FT0_under2 * footprint_C_S0_S1 / burst_C); # latency of the fused task S0_S1 level 2
subject to con44: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC1_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_C_FT0_under1 * footprint_C_S0_S1 / burst_C, level_transfer_A1_FT0_under1 * footprint_A1_S1 / burst_A1, level_transfer_B1_FT0_under1 * footprint_B1_S1 / burst_B1, level_transfer_B2_FT0_under1 * footprint_B2_S1 / burst_B2, level_transfer_A2_FT0_under1 * footprint_A2_S1 / burst_A2) + Lat_comp_fused_S0_S1_2 + max(level_transfer_C_FT0_under1 * footprint_C_S0_S1 / burst_C, level_transfer_A1_FT0_under1 * footprint_A1_S1 / burst_A1, level_transfer_B1_FT0_under1 * footprint_B1_S1 / burst_B1, level_transfer_B2_FT0_under1 * footprint_B2_S1 / burst_B2, level_transfer_A2_FT0_under1 * footprint_A2_S1 / burst_A2  + level_transfer_C_FT0_under1 * footprint_C_S0_S1 / burst_C); # latency of the fused task S0_S1 level 1
subject to con45: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_C_FT0_under0 * footprint_tot_C_FT0 / burst_C + level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 / burst_A1 + level_transfer_B1_FT0_under0 * footprint_tot_B1_FT0 / burst_B1 + level_transfer_B2_FT0_under0 * footprint_tot_B2_FT0 / burst_B2 + level_transfer_A2_FT0_under0 * footprint_tot_A2_FT0 / burst_A2; # latency of the fused task S0_S1
subject to con46: footprint_C_S0_S1 = level_transfer_C_FT0_under0 * footprint_tot_C_FT0 + level_transfer_C_FT0_under1 * (perm0_S0 * footprint_tot_C_FT0/ TC0_0 + perm1_S0 * footprint_tot_C_FT0/ TC1_0) + level_transfer_C_FT0_under2 * (perm0_S0 * footprint_tot_C_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_C_FT0/ TC1_0/ TC0_0); # footprint of the array C for the fused task 0
subject to con47: footprint_C_S0_S1_reuse = level_reuse_C_FT0_under0 * footprint_tot_C_FT0 + level_reuse_C_FT0_under1 * (perm0_S0 * footprint_tot_C_FT0/ TC0_0 + perm1_S0 * footprint_tot_C_FT0/ TC1_0) + level_reuse_C_FT0_under2 * (perm0_S0 * footprint_tot_C_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_C_FT0/ TC1_0/ TC0_0); # footprint of the array C for the fused task 0
subject to con48: perm0_S1 * level_transfer_A1_FT0_under1 = 0; # useless to transfer under this loop
subject to con49: perm0_S1 * level_reuse_A1_FT0_under1 = 0; # useless to reuse under this loop
subject to con50: perm1_S1 * level_transfer_A1_FT0_under1 = 0; # useless to transfer under this loop
subject to con51: perm1_S1 * level_reuse_A1_FT0_under1 = 0; # useless to reuse under this loop
subject to con52: perm2_S1 * level_transfer_A1_FT0_under2 = 0; # useless to transfer under this loop
subject to con53: perm2_S1 * level_reuse_A1_FT0_under2 = 0; # useless to reuse under this loop
subject to con54: perm4_S1 * level_transfer_A1_FT0_under2 = 0; # useless to transfer under this loop
subject to con55: perm4_S1 * level_reuse_A1_FT0_under2 = 0; # useless to reuse under this loop
subject to con56: footprint_A1_S1 = level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 + level_transfer_A1_FT0_under1 * (perm0_S1 * footprint_tot_A1_FT0 + perm1_S1 * footprint_tot_A1_FT0 + perm2_S1 * footprint_tot_A1_FT0/ TC3_0 + perm3_S1 * footprint_tot_A1_FT0/ TC3_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0) + level_transfer_A1_FT0_under2 * (perm0_S1 * footprint_tot_A1_FT0/ TC3_0 + perm1_S1 * footprint_tot_A1_FT0/ TC4_0 + perm2_S1 * footprint_tot_A1_FT0/ TC3_0 + perm3_S1 * footprint_tot_A1_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0/ TC3_0); # footprint of the array A1 for the fused task 0
subject to con57: footprint_A1_S1_reuse = level_reuse_A1_FT0_under0 * footprint_tot_A1_FT0 + level_reuse_A1_FT0_under1 * (perm0_S1 * footprint_tot_A1_FT0 + perm1_S1 * footprint_tot_A1_FT0 + perm2_S1 * footprint_tot_A1_FT0/ TC3_0 + perm3_S1 * footprint_tot_A1_FT0/ TC3_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0) + level_reuse_A1_FT0_under2 * (perm0_S1 * footprint_tot_A1_FT0/ TC3_0 + perm1_S1 * footprint_tot_A1_FT0/ TC4_0 + perm2_S1 * footprint_tot_A1_FT0/ TC3_0 + perm3_S1 * footprint_tot_A1_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0/ TC3_0); # footprint of the array A1 for the fused task 0
subject to con58: perm4_S1 * level_transfer_B1_FT0_under1 = 0; # useless to transfer under this loop
subject to con59: perm4_S1 * level_reuse_B1_FT0_under1 = 0; # useless to reuse under this loop
subject to con60: perm5_S1 * level_transfer_B1_FT0_under1 = 0; # useless to transfer under this loop
subject to con61: perm5_S1 * level_reuse_B1_FT0_under1 = 0; # useless to reuse under this loop
subject to con62: perm1_S1 * level_transfer_B1_FT0_under2 = 0; # useless to transfer under this loop
subject to con63: perm1_S1 * level_reuse_B1_FT0_under2 = 0; # useless to reuse under this loop
subject to con64: perm3_S1 * level_transfer_B1_FT0_under2 = 0; # useless to transfer under this loop
subject to con65: perm3_S1 * level_reuse_B1_FT0_under2 = 0; # useless to reuse under this loop
subject to con66: footprint_B1_S1 = level_transfer_B1_FT0_under0 * footprint_tot_B1_FT0 + level_transfer_B1_FT0_under1 * (perm0_S1 * footprint_tot_B1_FT0/ TC2_0 + perm1_S1 * footprint_tot_B1_FT0/ TC2_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0 + perm5_S1 * footprint_tot_B1_FT0) + level_transfer_B1_FT0_under2 * (perm0_S1 * footprint_tot_B1_FT0/ TC2_0/ TC3_0 + perm1_S1 * footprint_tot_B1_FT0/ TC2_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0/ TC2_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0/ TC2_0 + perm5_S1 * footprint_tot_B1_FT0/ TC3_0); # footprint of the array B1 for the fused task 0
subject to con67: footprint_B1_S1_reuse = level_reuse_B1_FT0_under0 * footprint_tot_B1_FT0 + level_reuse_B1_FT0_under1 * (perm0_S1 * footprint_tot_B1_FT0/ TC2_0 + perm1_S1 * footprint_tot_B1_FT0/ TC2_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0 + perm5_S1 * footprint_tot_B1_FT0) + level_reuse_B1_FT0_under2 * (perm0_S1 * footprint_tot_B1_FT0/ TC2_0/ TC3_0 + perm1_S1 * footprint_tot_B1_FT0/ TC2_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0/ TC2_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0/ TC2_0 + perm5_S1 * footprint_tot_B1_FT0/ TC3_0); # footprint of the array B1 for the fused task 0
subject to con68: perm0_S1 * level_transfer_B2_FT0_under1 = 0; # useless to transfer under this loop
subject to con69: perm0_S1 * level_reuse_B2_FT0_under1 = 0; # useless to reuse under this loop
subject to con70: perm1_S1 * level_transfer_B2_FT0_under1 = 0; # useless to transfer under this loop
subject to con71: perm1_S1 * level_reuse_B2_FT0_under1 = 0; # useless to reuse under this loop
subject to con72: perm2_S1 * level_transfer_B2_FT0_under2 = 0; # useless to transfer under this loop
subject to con73: perm2_S1 * level_reuse_B2_FT0_under2 = 0; # useless to reuse under this loop
subject to con74: perm4_S1 * level_transfer_B2_FT0_under2 = 0; # useless to transfer under this loop
subject to con75: perm4_S1 * level_reuse_B2_FT0_under2 = 0; # useless to reuse under this loop
subject to con76: footprint_B2_S1 = level_transfer_B2_FT0_under0 * footprint_tot_B2_FT0 + level_transfer_B2_FT0_under1 * (perm0_S1 * footprint_tot_B2_FT0 + perm1_S1 * footprint_tot_B2_FT0 + perm2_S1 * footprint_tot_B2_FT0/ TC3_0 + perm3_S1 * footprint_tot_B2_FT0/ TC3_0 + perm4_S1 * footprint_tot_B2_FT0/ TC4_0 + perm5_S1 * footprint_tot_B2_FT0/ TC4_0) + level_transfer_B2_FT0_under2 * (perm0_S1 * footprint_tot_B2_FT0/ TC3_0 + perm1_S1 * footprint_tot_B2_FT0/ TC4_0 + perm2_S1 * footprint_tot_B2_FT0/ TC3_0 + perm3_S1 * footprint_tot_B2_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B2_FT0/ TC4_0 + perm5_S1 * footprint_tot_B2_FT0/ TC4_0/ TC3_0); # footprint of the array B2 for the fused task 0
subject to con77: footprint_B2_S1_reuse = level_reuse_B2_FT0_under0 * footprint_tot_B2_FT0 + level_reuse_B2_FT0_under1 * (perm0_S1 * footprint_tot_B2_FT0 + perm1_S1 * footprint_tot_B2_FT0 + perm2_S1 * footprint_tot_B2_FT0/ TC3_0 + perm3_S1 * footprint_tot_B2_FT0/ TC3_0 + perm4_S1 * footprint_tot_B2_FT0/ TC4_0 + perm5_S1 * footprint_tot_B2_FT0/ TC4_0) + level_reuse_B2_FT0_under2 * (perm0_S1 * footprint_tot_B2_FT0/ TC3_0 + perm1_S1 * footprint_tot_B2_FT0/ TC4_0 + perm2_S1 * footprint_tot_B2_FT0/ TC3_0 + perm3_S1 * footprint_tot_B2_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B2_FT0/ TC4_0 + perm5_S1 * footprint_tot_B2_FT0/ TC4_0/ TC3_0); # footprint of the array B2 for the fused task 0
subject to con78: perm4_S1 * level_transfer_A2_FT0_under1 = 0; # useless to transfer under this loop
subject to con79: perm4_S1 * level_reuse_A2_FT0_under1 = 0; # useless to reuse under this loop
subject to con80: perm5_S1 * level_transfer_A2_FT0_under1 = 0; # useless to transfer under this loop
subject to con81: perm5_S1 * level_reuse_A2_FT0_under1 = 0; # useless to reuse under this loop
subject to con82: perm1_S1 * level_transfer_A2_FT0_under2 = 0; # useless to transfer under this loop
subject to con83: perm1_S1 * level_reuse_A2_FT0_under2 = 0; # useless to reuse under this loop
subject to con84: perm3_S1 * level_transfer_A2_FT0_under2 = 0; # useless to transfer under this loop
subject to con85: perm3_S1 * level_reuse_A2_FT0_under2 = 0; # useless to reuse under this loop
subject to con86: footprint_A2_S1 = level_transfer_A2_FT0_under0 * footprint_tot_A2_FT0 + level_transfer_A2_FT0_under1 * (perm0_S1 * footprint_tot_A2_FT0/ TC2_0 + perm1_S1 * footprint_tot_A2_FT0/ TC2_0 + perm2_S1 * footprint_tot_A2_FT0/ TC3_0 + perm3_S1 * footprint_tot_A2_FT0/ TC3_0 + perm4_S1 * footprint_tot_A2_FT0 + perm5_S1 * footprint_tot_A2_FT0) + level_transfer_A2_FT0_under2 * (perm0_S1 * footprint_tot_A2_FT0/ TC2_0/ TC3_0 + perm1_S1 * footprint_tot_A2_FT0/ TC2_0 + perm2_S1 * footprint_tot_A2_FT0/ TC3_0/ TC2_0 + perm3_S1 * footprint_tot_A2_FT0/ TC3_0 + perm4_S1 * footprint_tot_A2_FT0/ TC2_0 + perm5_S1 * footprint_tot_A2_FT0/ TC3_0); # footprint of the array A2 for the fused task 0
subject to con87: footprint_A2_S1_reuse = level_reuse_A2_FT0_under0 * footprint_tot_A2_FT0 + level_reuse_A2_FT0_under1 * (perm0_S1 * footprint_tot_A2_FT0/ TC2_0 + perm1_S1 * footprint_tot_A2_FT0/ TC2_0 + perm2_S1 * footprint_tot_A2_FT0/ TC3_0 + perm3_S1 * footprint_tot_A2_FT0/ TC3_0 + perm4_S1 * footprint_tot_A2_FT0 + perm5_S1 * footprint_tot_A2_FT0) + level_reuse_A2_FT0_under2 * (perm0_S1 * footprint_tot_A2_FT0/ TC2_0/ TC3_0 + perm1_S1 * footprint_tot_A2_FT0/ TC2_0 + perm2_S1 * footprint_tot_A2_FT0/ TC3_0/ TC2_0 + perm3_S1 * footprint_tot_A2_FT0/ TC3_0 + perm4_S1 * footprint_tot_A2_FT0/ TC2_0 + perm5_S1 * footprint_tot_A2_FT0/ TC3_0); # footprint of the array A2 for the fused task 0
subject to con88: TC0_1 * TC1_1 <= MAX_UF;
subject to con89: TC2_1 * TC3_1 * TC4_1 <= MAX_UF;
subject to con90: TC0_1 * TC1_1 * DSP_S0  + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq <= DSP_avail; # DSP constraint
subject to con91: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq); # DSP constraint per SLR
subject to con92: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con93: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con94: TC0_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con95: TC2_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con96: TC2_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con97: TC4_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A1 
subject to con98: TC2_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B1 
subject to con99: TC4_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B2 
subject to con100: TC2_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A2 
subject to con101: Lat_comp_S1_for_off_chip = perm0_S1 * TC3_0 * TC4_0 * II_S1_par + perm1_S1 * TC3_0 * II_S1_seq + perm2_S1 * TC3_0 * TC2_0 * TC4_0 * II_S1_par + perm3_S1 * TC3_0 * TC4_0 * TC2_0 * II_S1_par + perm4_S1 * TC3_0 * II_S1_seq + perm5_S1 * TC3_0 * TC2_0 * II_S1_par; # stall between task
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
subject to con117: TC0_1 = TC2_1; # same intra tile for the same dimension of the array C in the fused task
subject to con118: TC1_1 = TC4_1; # same intra tile for the same dimension of the array C in the fused task
subject to con119: B1_is_fully_transfered_on_last_dim_FT0 = level_transfer_B1_FT0_under0 + perm0_S1 * (level_transfer_B1_FT0_under1) + perm1_S1 * (level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2) + perm4_S1 * (level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2) + perm5_S1 * (level_transfer_B1_FT0_under1); # the array B1 is fully transfered on the last dimension
subject to con120: burst_B1_is_1 * cte_0 * 1 = burst_B1_is_1 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con121: is_tc3_burst_witout_tiling_for_B1 =  min(1, cte_burst_without_tiling_TC3_for_B1);
subject to con122: burst_B1_is_2 * cte_1 * 2 = burst_B1_is_2 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con123: burst_B1_is_4 * cte_2 * 4 = burst_B1_is_4 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con124: burst_B1_is_8 * cte_3 * 8 = burst_B1_is_8 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con125: burst_B1_is_16 * cte_4 * 16 = burst_B1_is_16 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con126: burst_B1 = burst_B1_is_1 * 1 + burst_B1_is_2 * 2 + burst_B1_is_4 * 4 + burst_B1_is_8 * 8 + burst_B1_is_16 * 16; # burst size of the array B1
subject to con127: burst_B1_is_1 + burst_B1_is_2 + burst_B1_is_4 + burst_B1_is_8 + burst_B1_is_16 = 1; # only one burst size for the array B1
subject to con128: is_tc3_burst_witout_tiling_for_B1 <= B1_is_fully_transfered_on_last_dim_FT0;
subject to con129: C_is_fully_transfered_on_last_dim_FT0 = level_transfer_C_FT0_under0 + perm0_S0 * (level_transfer_C_FT0_under1); # the array C is fully transfered on the last dimension
subject to con130: C_is_fully_transfered_on_last_dim_FT0 = level_transfer_C_FT0_under0 + perm0_S1 * (level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2) + perm1_S1 * (level_transfer_C_FT0_under1) + perm2_S1 * (level_transfer_C_FT0_under1 + level_transfer_C_FT0_under2) + perm3_S1 * (level_transfer_C_FT0_under1); # the array C is fully transfered on the last dimension
subject to con131: burst_C_is_1 * cte_5 * 1 = burst_C_is_1 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con132: is_tc1_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC1_for_C);
subject to con133: burst_C_is_1 * cte_6 * 1 = burst_C_is_1 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con134: burst_C_is_1 * cte_7 * 1 = burst_C_is_1 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con135: is_tc4_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC4_for_C);
subject to con136: burst_C_is_1 * cte_8 * 1 = burst_C_is_1 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con137: burst_C_is_2 * cte_9 * 2 = burst_C_is_2 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con138: burst_C_is_2 * cte_10 * 2 = burst_C_is_2 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con139: burst_C_is_2 * cte_11 * 2 = burst_C_is_2 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con140: burst_C_is_2 * cte_12 * 2 = burst_C_is_2 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con141: burst_C_is_4 * cte_13 * 4 = burst_C_is_4 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con142: burst_C_is_4 * cte_14 * 4 = burst_C_is_4 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con143: burst_C_is_4 * cte_15 * 4 = burst_C_is_4 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con144: burst_C_is_4 * cte_16 * 4 = burst_C_is_4 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con145: burst_C_is_8 * cte_17 * 8 = burst_C_is_8 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con146: burst_C_is_8 * cte_18 * 8 = burst_C_is_8 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con147: burst_C_is_8 * cte_19 * 8 = burst_C_is_8 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con148: burst_C_is_8 * cte_20 * 8 = burst_C_is_8 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con149: burst_C_is_16 * cte_21 * 16 = burst_C_is_16 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con150: burst_C_is_16 * cte_22 * 16 = burst_C_is_16 * ((1-is_tc1_burst_witout_tiling_for_C) * (TC1_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC1 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC1_for_C + TC1));
subject to con151: burst_C_is_16 * cte_23 * 16 = burst_C_is_16 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con152: burst_C_is_16 * cte_24 * 16 = burst_C_is_16 * ((1-is_tc4_burst_witout_tiling_for_C) * (TC4_1 * (1-C_is_fully_transfered_on_last_dim_FT0) + TC4 * (C_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC4_for_C + TC4));
subject to con153: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con154: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con155: is_tc1_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT0;
subject to con156: is_tc4_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT0;
subject to con157: A1_is_fully_transfered_on_last_dim_FT0 = level_transfer_A1_FT0_under0 + perm0_S1 * (level_transfer_A1_FT0_under1) + perm1_S1 * (level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2) + perm4_S1 * (level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2) + perm5_S1 * (level_transfer_A1_FT0_under1); # the array A1 is fully transfered on the last dimension
subject to con158: burst_A1_is_1 * cte_25 * 1 = burst_A1_is_1 * ((1-is_tc3_burst_witout_tiling_for_A1) * (TC3_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC3 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC3_for_A1 + TC3));
subject to con159: is_tc3_burst_witout_tiling_for_A1 =  min(1, cte_burst_without_tiling_TC3_for_A1);
subject to con160: burst_A1_is_2 * cte_26 * 2 = burst_A1_is_2 * ((1-is_tc3_burst_witout_tiling_for_A1) * (TC3_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC3 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC3_for_A1 + TC3));
subject to con161: burst_A1_is_4 * cte_27 * 4 = burst_A1_is_4 * ((1-is_tc3_burst_witout_tiling_for_A1) * (TC3_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC3 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC3_for_A1 + TC3));
subject to con162: burst_A1_is_8 * cte_28 * 8 = burst_A1_is_8 * ((1-is_tc3_burst_witout_tiling_for_A1) * (TC3_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC3 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC3_for_A1 + TC3));
subject to con163: burst_A1_is_16 * cte_29 * 16 = burst_A1_is_16 * ((1-is_tc3_burst_witout_tiling_for_A1) * (TC3_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC3 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC3_for_A1 + TC3));
subject to con164: burst_A1 = burst_A1_is_1 * 1 + burst_A1_is_2 * 2 + burst_A1_is_4 * 4 + burst_A1_is_8 * 8 + burst_A1_is_16 * 16; # burst size of the array A1
subject to con165: burst_A1_is_1 + burst_A1_is_2 + burst_A1_is_4 + burst_A1_is_8 + burst_A1_is_16 = 1; # only one burst size for the array A1
subject to con166: is_tc3_burst_witout_tiling_for_A1 <= A1_is_fully_transfered_on_last_dim_FT0;
subject to con167: A2_is_fully_transfered_on_last_dim_FT0 = level_transfer_A2_FT0_under0 + perm0_S1 * (level_transfer_A2_FT0_under1) + perm1_S1 * (level_transfer_A2_FT0_under1 + level_transfer_A2_FT0_under2) + perm4_S1 * (level_transfer_A2_FT0_under1 + level_transfer_A2_FT0_under2) + perm5_S1 * (level_transfer_A2_FT0_under1); # the array A2 is fully transfered on the last dimension
subject to con168: burst_A2_is_1 * cte_30 * 1 = burst_A2_is_1 * ((1-is_tc3_burst_witout_tiling_for_A2) * (TC3_1 * (1-A2_is_fully_transfered_on_last_dim_FT0) + TC3 * (A2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC3_for_A2 + TC3));
subject to con169: is_tc3_burst_witout_tiling_for_A2 =  min(1, cte_burst_without_tiling_TC3_for_A2);
subject to con170: burst_A2_is_2 * cte_31 * 2 = burst_A2_is_2 * ((1-is_tc3_burst_witout_tiling_for_A2) * (TC3_1 * (1-A2_is_fully_transfered_on_last_dim_FT0) + TC3 * (A2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC3_for_A2 + TC3));
subject to con171: burst_A2_is_4 * cte_32 * 4 = burst_A2_is_4 * ((1-is_tc3_burst_witout_tiling_for_A2) * (TC3_1 * (1-A2_is_fully_transfered_on_last_dim_FT0) + TC3 * (A2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC3_for_A2 + TC3));
subject to con172: burst_A2_is_8 * cte_33 * 8 = burst_A2_is_8 * ((1-is_tc3_burst_witout_tiling_for_A2) * (TC3_1 * (1-A2_is_fully_transfered_on_last_dim_FT0) + TC3 * (A2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC3_for_A2 + TC3));
subject to con173: burst_A2_is_16 * cte_34 * 16 = burst_A2_is_16 * ((1-is_tc3_burst_witout_tiling_for_A2) * (TC3_1 * (1-A2_is_fully_transfered_on_last_dim_FT0) + TC3 * (A2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC3_for_A2 + TC3));
subject to con174: burst_A2 = burst_A2_is_1 * 1 + burst_A2_is_2 * 2 + burst_A2_is_4 * 4 + burst_A2_is_8 * 8 + burst_A2_is_16 * 16; # burst size of the array A2
subject to con175: burst_A2_is_1 + burst_A2_is_2 + burst_A2_is_4 + burst_A2_is_8 + burst_A2_is_16 = 1; # only one burst size for the array A2
subject to con176: is_tc3_burst_witout_tiling_for_A2 <= A2_is_fully_transfered_on_last_dim_FT0;
subject to con177: B2_is_fully_transfered_on_last_dim_FT0 = level_transfer_B2_FT0_under0 + perm0_S1 * (level_transfer_B2_FT0_under1) + perm1_S1 * (level_transfer_B2_FT0_under1 + level_transfer_B2_FT0_under2) + perm4_S1 * (level_transfer_B2_FT0_under1 + level_transfer_B2_FT0_under2) + perm5_S1 * (level_transfer_B2_FT0_under1); # the array B2 is fully transfered on the last dimension
subject to con178: burst_B2_is_1 * cte_35 * 1 = burst_B2_is_1 * ((1-is_tc3_burst_witout_tiling_for_B2) * (TC3_1 * (1-B2_is_fully_transfered_on_last_dim_FT0) + TC3 * (B2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC3_for_B2 + TC3));
subject to con179: is_tc3_burst_witout_tiling_for_B2 =  min(1, cte_burst_without_tiling_TC3_for_B2);
subject to con180: burst_B2_is_2 * cte_36 * 2 = burst_B2_is_2 * ((1-is_tc3_burst_witout_tiling_for_B2) * (TC3_1 * (1-B2_is_fully_transfered_on_last_dim_FT0) + TC3 * (B2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC3_for_B2 + TC3));
subject to con181: burst_B2_is_4 * cte_37 * 4 = burst_B2_is_4 * ((1-is_tc3_burst_witout_tiling_for_B2) * (TC3_1 * (1-B2_is_fully_transfered_on_last_dim_FT0) + TC3 * (B2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC3_for_B2 + TC3));
subject to con182: burst_B2_is_8 * cte_38 * 8 = burst_B2_is_8 * ((1-is_tc3_burst_witout_tiling_for_B2) * (TC3_1 * (1-B2_is_fully_transfered_on_last_dim_FT0) + TC3 * (B2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC3_for_B2 + TC3));
subject to con183: burst_B2_is_16 * cte_39 * 16 = burst_B2_is_16 * ((1-is_tc3_burst_witout_tiling_for_B2) * (TC3_1 * (1-B2_is_fully_transfered_on_last_dim_FT0) + TC3 * (B2_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC3_for_B2 + TC3));
subject to con184: burst_B2 = burst_B2_is_1 * 1 + burst_B2_is_2 * 2 + burst_B2_is_4 * 4 + burst_B2_is_8 * 8 + burst_B2_is_16 * 16; # burst size of the array B2
subject to con185: burst_B2_is_1 + burst_B2_is_2 + burst_B2_is_4 + burst_B2_is_8 + burst_B2_is_16 = 1; # only one burst size for the array B2
subject to con186: is_tc3_burst_witout_tiling_for_B2 <= B2_is_fully_transfered_on_last_dim_FT0;
subject to con187: footprint_tot_B1_FT0 = TC2_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_B1);
subject to con188: footprint_tot_C_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_C);
subject to con189: footprint_tot_C_FT0 = TC2_ori * TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_C);
subject to con190: footprint_tot_A1_FT0 = TC4_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_A1);
subject to con191: footprint_tot_A2_FT0 = TC2_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_A2);
subject to con192: footprint_tot_B2_FT0 = TC4_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_B2);
subject to con193: TC0 = TC0_ori;
subject to con194: TC2 = TC2_ori;
subject to con195: obj = Lat_comp_fused_S0_S1 + 1/burst_B1 + 1/burst_C + 1/burst_A1 + 1/burst_A2 + 1/burst_B2 + 1/(is_slr0_used);
subject to con196: C_is_fully_transfered_on_last_dim_FT0 * C_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC2_1) = C_is_fully_transfered_on_last_dim_FT0 * C_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC2_1) * cte_tiling_0; # should divide for C in dim 0
subject to con197: C_is_fully_transfered_on_last_dim_FT0 * C_is_fully_transfered_on_last_dim_FT0 * max(TC1_1, TC4_1) = C_is_fully_transfered_on_last_dim_FT0 * C_is_fully_transfered_on_last_dim_FT0 * min(TC1_1, TC4_1) * cte_tiling_1; # should divide for C in dim 1
subject to con198: buffer_size = footprint_C_S0_S1_reuse + footprint_A1_S1_reuse + footprint_B1_S1_reuse + footprint_B2_S1_reuse + footprint_A2_S1_reuse; # total buffer size
subject to con199: fifo_size = 0; # total fifo size
subject to con200: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con201: perm4_S1 * level_reuse_B1_FT0_under0 = perm4_S1 * 1;
subject to con202: perm5_S1 * level_reuse_B1_FT0_under0 = perm5_S1 * 1;
subject to con203: perm2_S1 * level_reuse_C_FT0_under0 = perm2_S1 * 1;
subject to con204: perm3_S1 * level_reuse_C_FT0_under0 = perm3_S1 * 1;
subject to con205: perm0_S1 * level_reuse_A1_FT0_under0 = perm0_S1 * 1;
subject to con206: perm1_S1 * level_reuse_A1_FT0_under0 = perm1_S1 * 1;
subject to con207: perm4_S1 * level_reuse_A2_FT0_under0 = perm4_S1 * 1;
subject to con208: perm5_S1 * level_reuse_A2_FT0_under0 = perm5_S1 * 1;
subject to con209: perm0_S1 * level_reuse_B2_FT0_under0 = perm0_S1 * 1;
subject to con210: perm1_S1 * level_reuse_B2_FT0_under0 = perm1_S1 * 1;
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
display perm0_S1;
display Lat_comp_S1_for_off_chip;
display perm1_S1;
display perm2_S1;
display perm3_S1;
display perm4_S1;
display perm5_S1;
display Lat_comp_S0_intra_tile;
display Lat_comp_S1_intra_tile;
display footprint_C_S0_S1;
display footprint_C_S0_S1_reuse;
display footprint_A1_S1;
display footprint_A1_S1_reuse;
display footprint_B1_S1;
display footprint_B1_S1_reuse;
display footprint_B2_S1;
display footprint_B2_S1_reuse;
display footprint_A2_S1;
display footprint_A2_S1_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_C_FT0_under0;
display level_reuse_C_FT0_under0;
display level_transfer_C_FT0_under1;
display level_reuse_C_FT0_under1;
display level_transfer_C_FT0_under2;
display level_reuse_C_FT0_under2;
display level_transfer_A1_FT0_under0;
display level_reuse_A1_FT0_under0;
display level_transfer_A1_FT0_under1;
display level_reuse_A1_FT0_under1;
display level_transfer_A1_FT0_under2;
display level_reuse_A1_FT0_under2;
display level_transfer_B1_FT0_under0;
display level_reuse_B1_FT0_under0;
display level_transfer_B1_FT0_under1;
display level_reuse_B1_FT0_under1;
display level_transfer_B1_FT0_under2;
display level_reuse_B1_FT0_under2;
display level_transfer_B2_FT0_under0;
display level_reuse_B2_FT0_under0;
display level_transfer_B2_FT0_under1;
display level_reuse_B2_FT0_under1;
display level_transfer_B2_FT0_under2;
display level_reuse_B2_FT0_under2;
display level_transfer_A2_FT0_under0;
display level_reuse_A2_FT0_under0;
display level_transfer_A2_FT0_under1;
display level_reuse_A2_FT0_under1;
display level_transfer_A2_FT0_under2;
display level_reuse_A2_FT0_under2;
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
display B1_is_fully_transfered_on_last_dim_FT0;
display burst_B1_is_1;
display cte_0;
display cte_burst_without_tiling_TC3_for_B1;
display is_tc3_burst_witout_tiling_for_B1;
display burst_B1_is_2;
display cte_1;
display burst_B1_is_4;
display cte_2;
display burst_B1_is_8;
display cte_3;
display burst_B1_is_16;
display cte_4;
display C_is_fully_transfered_on_last_dim_FT0;
display burst_C_is_1;
display cte_5;
display cte_burst_without_tiling_TC1_for_C;
display is_tc1_burst_witout_tiling_for_C;
display cte_6;
display cte_7;
display cte_burst_without_tiling_TC4_for_C;
display is_tc4_burst_witout_tiling_for_C;
display cte_8;
display burst_C_is_2;
display cte_9;
display cte_10;
display cte_11;
display cte_12;
display burst_C_is_4;
display cte_13;
display cte_14;
display cte_15;
display cte_16;
display burst_C_is_8;
display cte_17;
display cte_18;
display cte_19;
display cte_20;
display burst_C_is_16;
display cte_21;
display cte_22;
display cte_23;
display cte_24;
display A1_is_fully_transfered_on_last_dim_FT0;
display burst_A1_is_1;
display cte_25;
display cte_burst_without_tiling_TC3_for_A1;
display is_tc3_burst_witout_tiling_for_A1;
display burst_A1_is_2;
display cte_26;
display burst_A1_is_4;
display cte_27;
display burst_A1_is_8;
display cte_28;
display burst_A1_is_16;
display cte_29;
display A2_is_fully_transfered_on_last_dim_FT0;
display burst_A2_is_1;
display cte_30;
display cte_burst_without_tiling_TC3_for_A2;
display is_tc3_burst_witout_tiling_for_A2;
display burst_A2_is_2;
display cte_31;
display burst_A2_is_4;
display cte_32;
display burst_A2_is_8;
display cte_33;
display burst_A2_is_16;
display cte_34;
display B2_is_fully_transfered_on_last_dim_FT0;
display burst_B2_is_1;
display cte_35;
display cte_burst_without_tiling_TC3_for_B2;
display is_tc3_burst_witout_tiling_for_B2;
display burst_B2_is_2;
display cte_36;
display burst_B2_is_4;
display cte_37;
display burst_B2_is_8;
display cte_38;
display burst_B2_is_16;
display cte_39;
display footprint_tot_B1_FT0;
display burst_B1;
display footprint_tot_C_FT0;
display burst_C;
display footprint_tot_A1_FT0;
display burst_A1;
display footprint_tot_A2_FT0;
display burst_A2;
display footprint_tot_B2_FT0;
display burst_B2;
display Lat_comp_0_1;
display obj;
display cte_tiling_0;
display cte_tiling_1;
display buffer_size;
display fifo_size;
display _total_solve_time;
