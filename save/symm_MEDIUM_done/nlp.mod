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
param TC0_ori = 200;
param TC1_ori = 240;
param TC2_ori = 200;
param TC3_ori = 240;
param TC4_ori = 200;
param TC5_ori = 200;
param TC6_ori = 240;
param TC7_ori = 200;
param TC8_ori = 200;
param TC9_ori = 240;
param IL_par_S0 = 1;
param IL_seq_S0 = 0;
param IL_par_S1 = 4;
param IL_seq_S1 = 7;
param IL_par_S2 = 30;
param IL_seq_S2 = 0;
param IL_par_S3 = 8;
param IL_seq_S3 = 7;
param DSP_S0 = 0;
param DSP_S1 = 5;
param DSP_S2 = 16;
param DSP_S3 = 8;

var TC0 integer >= 200 <= 208;
var TC1 integer >= 240 <= 240;
var TC2 integer >= 200 <= 208;
var TC3 integer >= 240 <= 240;
var TC4 integer >= 200 <= 208;
var TC5 integer >= 200 <= 208;
var TC6 integer >= 240 <= 240;
var TC7 integer >= 200 <= 208;
var TC8 integer >= 200 <= 208;
var TC9 integer >= 240 <= 240;
var is_fused_task0_in_SLR_0 binary;
var is_fused_task1_in_SLR_0 binary;
var is_slr0_used binary;
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
var footprint_B1_S1 integer >= 0;
var footprint_B1_S1_reuse integer >= 0;
var footprint_A1_S1 integer >= 0;
var footprint_A1_S1_reuse integer >= 0;
var footprint_tmp_S2 integer >= 0;
var footprint_tmp_S2_reuse integer >= 0;
var footprint_C_S2_S3 integer >= 0;
var footprint_C_S2_S3_reuse integer >= 0;
var footprint_B2_S2 integer >= 0;
var footprint_B2_S2_reuse integer >= 0;
var footprint_A2_S2 integer >= 0;
var footprint_A2_S2_reuse integer >= 0;
var footprint_B3_S3 integer >= 0;
var footprint_B3_S3_reuse integer >= 0;
var footprint_A3_S3 integer >= 0;
var footprint_A3_S3_reuse integer >= 0;
var Lat_comp_fused_S0_S1 >= 0;
var level_transfer_tmp_FT0_under0 binary;
var level_reuse_tmp_FT0_under0 binary;
var level_transfer_tmp_FT0_under1 binary;
var level_reuse_tmp_FT0_under1 binary;
var level_transfer_tmp_FT0_under2 binary;
var level_reuse_tmp_FT0_under2 binary;
var level_transfer_B1_FT0_under0 binary;
var level_reuse_B1_FT0_under0 binary;
var level_transfer_B1_FT0_under1 binary;
var level_reuse_B1_FT0_under1 binary;
var level_transfer_B1_FT0_under2 binary;
var level_reuse_B1_FT0_under2 binary;
var level_transfer_A1_FT0_under0 binary;
var level_reuse_A1_FT0_under0 binary;
var level_transfer_A1_FT0_under1 binary;
var level_reuse_A1_FT0_under1 binary;
var level_transfer_A1_FT0_under2 binary;
var level_reuse_A1_FT0_under2 binary;
var Lat_comp_fused_S0_S1_3 >= 0;
var Lat_comp_fused_S0_S1_2 >= 0;
var Lat_comp_fused_S0_S1_1 >= 0;
var Lat_comp_fused_S2_S3 >= 0;
var level_transfer_C_FT1_under0 binary;
var level_reuse_C_FT1_under0 binary;
var level_transfer_C_FT1_under1 binary;
var level_reuse_C_FT1_under1 binary;
var level_transfer_C_FT1_under2 binary;
var level_reuse_C_FT1_under2 binary;
var level_transfer_B2_FT1_under0 binary;
var level_reuse_B2_FT1_under0 binary;
var level_transfer_B2_FT1_under1 binary;
var level_reuse_B2_FT1_under1 binary;
var level_transfer_B2_FT1_under2 binary;
var level_reuse_B2_FT1_under2 binary;
var level_transfer_A2_FT1_under0 binary;
var level_reuse_A2_FT1_under0 binary;
var level_transfer_A2_FT1_under1 binary;
var level_reuse_A2_FT1_under1 binary;
var level_transfer_A2_FT1_under2 binary;
var level_reuse_A2_FT1_under2 binary;
var level_transfer_tmp_FT1_under0 binary;
var level_reuse_tmp_FT1_under0 binary;
var level_transfer_tmp_FT1_under1 binary;
var level_reuse_tmp_FT1_under1 binary;
var level_transfer_tmp_FT1_under2 binary;
var level_reuse_tmp_FT1_under2 binary;
var level_transfer_B3_FT1_under0 binary;
var level_reuse_B3_FT1_under0 binary;
var level_transfer_B3_FT1_under1 binary;
var level_reuse_B3_FT1_under1 binary;
var level_transfer_B3_FT1_under2 binary;
var level_reuse_B3_FT1_under2 binary;
var level_transfer_A3_FT1_under0 binary;
var level_reuse_A3_FT1_under0 binary;
var level_transfer_A3_FT1_under1 binary;
var level_reuse_A3_FT1_under1 binary;
var level_transfer_A3_FT1_under2 binary;
var level_reuse_A3_FT1_under2 binary;
var Lat_comp_fused_S2_S3_3 >= 0;
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
var TC6_0 integer >= 1;
var TC6_1 integer >= 1;
var TC7_0 integer >= 1;
var TC7_1 integer >= 1;
var TC8_0 integer >= 1;
var TC8_1 integer >= 1;
var TC9_0 integer >= 1;
var TC9_1 integer >= 1;
var B1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_B1_is_1 binary;
var cte_0 integer >=0;
var cte_burst_without_tiling_TC3_for_B1 integer >= 0 <= 0;
var is_tc3_burst_witout_tiling_for_B1 binary;
var burst_B1_is_2 binary;
var cte_1 integer >=0;
var burst_B1_is_4 binary;
var cte_2 integer >=0;
var burst_B1_is_8 binary;
var cte_3 integer >=0;
var burst_B1_is_16 binary;
var cte_4 integer >=0;
var A1_is_fully_transfered_on_last_dim_FT0 binary;
var burst_A1_is_1 binary;
var cte_5 integer >=0;
var cte_burst_without_tiling_TC4_for_A1 integer >= 0 <= 8;
var is_tc4_burst_witout_tiling_for_A1 binary;
var burst_A1_is_2 binary;
var cte_6 integer >=0;
var burst_A1_is_4 binary;
var cte_7 integer >=0;
var burst_A1_is_8 binary;
var cte_8 integer >=0;
var burst_A1_is_16 binary;
var cte_9 integer >=0;
var A3_is_fully_transfered_on_last_dim_FT1 binary;
var burst_A3_is_1 binary;
var cte_10 integer >=0;
var cte_burst_without_tiling_TC7_for_A3 integer >= 0 <= 8;
var is_tc7_burst_witout_tiling_for_A3 binary;
var burst_A3_is_2 binary;
var cte_11 integer >=0;
var burst_A3_is_4 binary;
var cte_12 integer >=0;
var burst_A3_is_8 binary;
var cte_13 integer >=0;
var burst_A3_is_16 binary;
var cte_14 integer >=0;
var A2_is_fully_transfered_on_last_dim_FT1 binary;
var burst_A2_is_1 binary;
var cte_15 integer >=0;
var cte_burst_without_tiling_TC5_for_A2 integer >= 0 <= 8;
var is_tc5_burst_witout_tiling_for_A2 binary;
var burst_A2_is_2 binary;
var cte_16 integer >=0;
var burst_A2_is_4 binary;
var cte_17 integer >=0;
var burst_A2_is_8 binary;
var cte_18 integer >=0;
var burst_A2_is_16 binary;
var cte_19 integer >=0;
var tmp_is_fully_transfered_on_last_dim_FT0 binary;
var tmp_is_fully_transfered_on_last_dim_FT1 binary;
var burst_tmp_is_1 binary;
var cte_20 integer >=0;
var cte_burst_without_tiling_TC1_for_tmp integer >= 0 <= 0;
var is_tc1_burst_witout_tiling_for_tmp binary;
var cte_21 integer >=0;
var cte_burst_without_tiling_TC3_for_tmp integer >= 0 <= 0;
var is_tc3_burst_witout_tiling_for_tmp binary;
var cte_22 integer >=0;
var cte_23 integer >=0;
var cte_burst_without_tiling_TC6_for_tmp integer >= 0 <= 0;
var is_tc6_burst_witout_tiling_for_tmp binary;
var burst_tmp_is_2 binary;
var cte_24 integer >=0;
var cte_25 integer >=0;
var cte_26 integer >=0;
var cte_27 integer >=0;
var burst_tmp_is_4 binary;
var cte_28 integer >=0;
var cte_29 integer >=0;
var cte_30 integer >=0;
var cte_31 integer >=0;
var burst_tmp_is_8 binary;
var cte_32 integer >=0;
var cte_33 integer >=0;
var cte_34 integer >=0;
var cte_35 integer >=0;
var burst_tmp_is_16 binary;
var cte_36 integer >=0;
var cte_37 integer >=0;
var cte_38 integer >=0;
var cte_39 integer >=0;
var B3_is_fully_transfered_on_last_dim_FT1 binary;
var burst_B3_is_1 binary;
var cte_40 integer >=0;
var cte_burst_without_tiling_TC9_for_B3 integer >= 0 <= 0;
var is_tc9_burst_witout_tiling_for_B3 binary;
var burst_B3_is_2 binary;
var cte_41 integer >=0;
var burst_B3_is_4 binary;
var cte_42 integer >=0;
var burst_B3_is_8 binary;
var cte_43 integer >=0;
var burst_B3_is_16 binary;
var cte_44 integer >=0;
var C_is_fully_transfered_on_last_dim_FT1 binary;
var burst_C_is_1 binary;
var cte_45 integer >=0;
var cte_burst_without_tiling_TC6_for_C integer >= 0 <= 0;
var is_tc6_burst_witout_tiling_for_C binary;
var cte_46 integer >=0;
var cte_47 integer >=0;
var cte_burst_without_tiling_TC9_for_C integer >= 0 <= 0;
var is_tc9_burst_witout_tiling_for_C binary;
var cte_48 integer >=0;
var burst_C_is_2 binary;
var cte_49 integer >=0;
var cte_50 integer >=0;
var cte_51 integer >=0;
var cte_52 integer >=0;
var burst_C_is_4 binary;
var cte_53 integer >=0;
var cte_54 integer >=0;
var cte_55 integer >=0;
var cte_56 integer >=0;
var burst_C_is_8 binary;
var cte_57 integer >=0;
var cte_58 integer >=0;
var cte_59 integer >=0;
var cte_60 integer >=0;
var burst_C_is_16 binary;
var cte_61 integer >=0;
var cte_62 integer >=0;
var cte_63 integer >=0;
var cte_64 integer >=0;
var B2_is_fully_transfered_on_last_dim_FT1 binary;
var burst_B2_is_1 binary;
var cte_65 integer >=0;
var cte_burst_without_tiling_TC6_for_B2 integer >= 0 <= 0;
var is_tc6_burst_witout_tiling_for_B2 binary;
var burst_B2_is_2 binary;
var cte_66 integer >=0;
var burst_B2_is_4 binary;
var cte_67 integer >=0;
var burst_B2_is_8 binary;
var cte_68 integer >=0;
var burst_B2_is_16 binary;
var cte_69 integer >=0;
var footprint_tot_B1_FT0 integer >= 1;
var burst_B1 integer >= 0;
var footprint_tot_A1_FT0 integer >= 1;
var burst_A1 integer >= 0;
var footprint_tot_A3_FT1 integer >= 1;
var burst_A3 integer >= 0;
var footprint_tot_A2_FT1 integer >= 1;
var burst_A2 integer >= 0;
var footprint_tot_tmp_FT0 integer >= 1;
var burst_tmp integer >= 0;
var footprint_tot_tmp_FT1 integer >= 1;
var footprint_tot_B3_FT1 integer >= 1;
var burst_B3 integer >= 0;
var footprint_tot_C_FT1 integer >= 1;
var burst_C integer >= 0;
var footprint_tot_B2_FT1 integer >= 1;
var burst_B2 integer >= 0;
var Lat_comp_0_1_2_3 >= 0;
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
#comment: Task 3 writes C to off-chip
#comment: Task 1 writes tmp to off-chip
#comment: Statement 0: tmp[i][j] = 0;
#comment: Statement 1: tmp[i][j] += B1[k][j] * A1[i][k];
#comment: Statement 2: C[i][j] = beta * C[i][j] + alpha * B2[i][j] * A2[i] + alpha * tmp[i][j];
#comment: Statement 3: C[i][j] += alpha * B3[k][j] * A3[k][i];
#comment: Loop_0: i
#comment: Loop_1: j
#comment: Loop_2: i
#comment: Loop_3: j
#comment: Loop_4: k
#comment: Loop_5: i
#comment: Loop_6: j
#comment: Loop_7: i
#comment: Loop_8: k
#comment: Loop_9: j
#comment: Argument 0: float alpha
#comment: Argument 1: float beta
#comment: Argument 2: float tmp[200][240]
#comment: Argument 3: float C[200][240]
#comment: Argument 4: float A1[200][200]
#comment: Argument 5: float B1[200][240]
#comment: Argument 6: float A2[200]
#comment: Argument 7: float B2[200][240]
#comment: Argument 8: float A3[200][200]
#comment: Argument 9: float B3[200][240]
#comment: Task 1 gives tmp to Task 2
#comment: Task 2 received tmp from Task 1
#comment:  4 is a reduction loop
#comment:  8 is a reduction loop
#comment: Task 1 reads B1 from off-chip
#comment: Task 1 reads A1 from off-chip
#comment: Task 3 reads A3 from off-chip
#comment: Task 2 reads A2 from off-chip
#comment: Task 3 reads B3 from off-chip
#comment: Task 2 reads C from off-chip
#comment: Task 2 reads B2 from off-chip
#comment: Array B1 has for tc in dim 0 TC4 (ori=TC4_ori) arg0
#comment: Array B1 has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array A1 has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array A1 has for tc in dim 1 TC4 (ori=TC4_ori) arg0
#comment: Array A3 has for tc in dim 0 TC8 (ori=TC8_ori) arg0
#comment: Array A3 has for tc in dim 1 TC7 (ori=TC7_ori) arg0
#comment: Array A2 has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array tmp has for tc in dim 0 TC0 (ori=TC0_ori) arg0
#comment: Array tmp has for tc in dim 0 TC2 (ori=TC2_ori) arg0
#comment: Array tmp has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array tmp has for tc in dim 1 TC1 (ori=TC1_ori) arg0
#comment: Array tmp has for tc in dim 1 TC3 (ori=TC3_ori) arg0
#comment: Array tmp has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array B3 has for tc in dim 0 TC8 (ori=TC8_ori) arg0
#comment: Array B3 has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array C has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array C has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array C has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array C has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array C has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array C has for tc in dim 0 TC7 (ori=TC7_ori) arg0
#comment: Array C has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Array C has for tc in dim 1 TC9 (ori=TC9_ori) arg0
#comment: Array B2 has for tc in dim 0 TC5 (ori=TC5_ori) arg0
#comment: Array B2 has for tc in dim 1 TC6 (ori=TC6_ori) arg0
#comment: Sched 0 has reuse buffer tmp[TC0_1][TC1_1]
#comment: Sched 1 has reuse buffer tmp[TC2_1][TC3_1]
#comment: Sched 1 has reuse buffer B1[TC4_1][TC3_1]
#comment: Sched 1 has reuse buffer A1[TC2_1][TC4_1]
#comment: Sched 2 has reuse buffer C[TC5_1][TC6_1]
#comment: Sched 2 has reuse buffer B2[TC5_1][TC6_1]
#comment: Sched 2 has reuse buffer A2[TC5_1]
#comment: Sched 2 has reuse buffer tmp[TC5_1][TC6_1]
#comment: Sched 3 has reuse buffer C[TC7_1][TC9_1]
#comment: Sched 3 has reuse buffer B3[TC8_1][TC9_1]
#comment: Sched 3 has reuse buffer A3[TC8_1][TC7_1]

minimize cost: obj;

subject to con0: is_slr0_used = min(1,is_fused_task0_in_SLR_0 + is_fused_task1_in_SLR_0);
subject to con1: is_fused_task0_in_SLR_0 = 1; # only one SLR for fused task 0
subject to con2: is_fused_task1_in_SLR_0 = 1; # only one SLR for fused task 1
subject to con3: perm0_S0 + perm1_S0 = 1; # only one permutation
subject to con4: TC2_1 = TC5_1; # same tiling factor
subject to con5: TC3_1 = TC6_1; # same tiling factor
subject to con6: TC2_1 = TC5_1; # same tiling factor
subject to con7: TC3_1 = TC6_1; # same tiling factor
subject to con8: TC2_1 = TC5_1; # same tiling factor
subject to con9: TC3_1 = TC6_1; # same tiling factor
subject to con10: TC2_1 = TC5_1; # same tiling factor
subject to con11: TC3_1 = TC6_1; # same tiling factor
subject to con12: TC2_1 = TC5_1; # same tiling factor
subject to con13: TC3_1 = TC6_1; # same tiling factor
subject to con14: TC2_1 = TC5_1; # same tiling factor
subject to con15: TC3_1 = TC6_1; # same tiling factor
subject to con16: perm0_S1 + perm1_S1 + perm2_S1 + perm3_S1 + perm4_S1 + perm5_S1 = 1; # only one permutation
subject to con17: perm0_S2 + perm1_S2 = 1; # only one permutation
subject to con18: perm0_S3 + perm1_S3 + perm2_S3 + perm3_S3 + perm4_S3 + perm5_S3 = 1; # only one permutation
subject to con19: Lat_comp_S0_intra_tile = IL_par_S0 + IL_seq_S0; # latency of the intra-tile S0
subject to con20: Lat_comp_S1_intra_tile = IL_par_S1 + IL_seq_S1 * log(TC4_1)/log(2); # latency of the intra-tile S1
subject to con21: Lat_comp_S2_intra_tile = IL_par_S2 + IL_seq_S2; # latency of the intra-tile S2
subject to con22: Lat_comp_S3_intra_tile = IL_par_S3 + IL_seq_S3 * log(TC8_1)/log(2); # latency of the intra-tile S3
subject to con23: perm1_S1 = 0; # because of the fused task 0
subject to con24: perm3_S1 = 0; # because of the fused task 0
subject to con25: perm4_S1 = 0; # because of the fused task 0
subject to con26: perm5_S1 = 0; # because of the fused task 0
subject to con27: perm0_S3 = 0; # because of the fused task 1
subject to con28: perm2_S3 = 0; # because of the fused task 1
subject to con29: perm3_S3 = 0; # because of the fused task 1
subject to con30: perm5_S3 = 0; # because of the fused task 1
subject to con31: perm0_S0 = perm0_S1; # same iteration of output in FT 0
subject to con32: perm1_S0 = perm2_S1; # same iteration of output in FT 0
subject to con33: perm0_S2 = perm1_S3; # same iteration of output in FT 1
subject to con34: perm1_S2 = perm4_S3; # same iteration of output in FT 1
subject to con35: is_fused_task0_in_SLR_0 * (footprint_tmp_S0_S1_reuse + footprint_B1_S1_reuse + footprint_A1_S1_reuse) + is_fused_task1_in_SLR_0 * (footprint_tmp_S2_reuse + footprint_C_S2_S3_reuse + footprint_B2_S2_reuse + footprint_A2_S2_reuse + footprint_B3_S3_reuse + footprint_A3_S3_reuse) <= SLR0_mem; # memory constraint per SLR
subject to con36: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con37: level_reuse_tmp_FT0_under2 = 1; # transfer innermost for output
subject to con38: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con39: level_reuse_tmp_FT0_under2 = level_transfer_tmp_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con40: level_transfer_tmp_FT0_under0 + level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2 = 1; # only one level of transfer for tmp
subject to con41: level_reuse_tmp_FT0_under0 + level_reuse_tmp_FT0_under1 + level_reuse_tmp_FT0_under2 = 1; # only one level of reuse for tmp
subject to con42: level_reuse_tmp_FT0_under0 = level_transfer_tmp_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con43: level_reuse_tmp_FT0_under1 = level_transfer_tmp_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con44: level_reuse_tmp_FT0_under2 = level_transfer_tmp_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con45: level_reuse_B1_FT0_under0 >= level_transfer_B1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con46: level_reuse_B1_FT0_under0 + level_reuse_B1_FT0_under1 >= level_transfer_B1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con47: level_reuse_B1_FT0_under0 + level_reuse_B1_FT0_under1 + level_reuse_B1_FT0_under2 >= level_transfer_B1_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con48: level_transfer_B1_FT0_under0 + level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2 = 1; # only one level of transfer for B1
subject to con49: level_reuse_B1_FT0_under0 + level_reuse_B1_FT0_under1 + level_reuse_B1_FT0_under2 = 1; # only one level of reuse for B1
subject to con50: level_reuse_A1_FT0_under0 >= level_transfer_A1_FT0_under0; # reuse level have to be outermost or equal to transfer
subject to con51: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 >= level_transfer_A1_FT0_under1; # reuse level have to be outermost or equal to transfer
subject to con52: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 + level_reuse_A1_FT0_under2 >= level_transfer_A1_FT0_under2; # reuse level have to be outermost or equal to transfer
subject to con53: level_transfer_A1_FT0_under0 + level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2 = 1; # only one level of transfer for A1
subject to con54: level_reuse_A1_FT0_under0 + level_reuse_A1_FT0_under1 + level_reuse_A1_FT0_under2 = 1; # only one level of reuse for A1
subject to con55: Lat_comp_fused_S0_S1_3 = ((Lat_comp_S0_intra_tile) + (Lat_comp_S1_intra_tile + II_S1_seq * TC4_0)); # latency of the fused task S0_S1 level 3
subject to con56: Lat_comp_fused_S0_S1_2 = (perm0_S0 * TC1_0 + perm1_S0 * TC0_0) * max(Lat_comp_fused_S0_S1_3, level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_B1_FT0_under2 * footprint_B1_S1 / burst_B1, level_transfer_A1_FT0_under2 * footprint_A1_S1 / burst_A1) + Lat_comp_fused_S0_S1_3 + max(level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_B1_FT0_under2 * footprint_B1_S1 / burst_B1, level_transfer_A1_FT0_under2 * footprint_A1_S1 / burst_A1  + level_transfer_tmp_FT0_under2 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 2
subject to con57: Lat_comp_fused_S0_S1_1 = (perm0_S0 * TC0_0 + perm1_S0 * TC1_0) * max(Lat_comp_fused_S0_S1_2, level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_B1_FT0_under1 * footprint_B1_S1 / burst_B1, level_transfer_A1_FT0_under1 * footprint_A1_S1 / burst_A1) + Lat_comp_fused_S0_S1_2 + max(level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp, level_transfer_B1_FT0_under1 * footprint_B1_S1 / burst_B1, level_transfer_A1_FT0_under1 * footprint_A1_S1 / burst_A1  + level_transfer_tmp_FT0_under1 * footprint_tmp_S0_S1 / burst_tmp); # latency of the fused task S0_S1 level 1
subject to con58: Lat_comp_fused_S0_S1 = Lat_comp_fused_S0_S1_1 + level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 / burst_tmp + level_transfer_B1_FT0_under0 * footprint_tot_B1_FT0 / burst_B1 + level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 / burst_A1; # latency of the fused task S0_S1
subject to con59: level_reuse_C_FT1_under0 = level_transfer_C_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con60: level_reuse_C_FT1_under2 = 1; # transfer innermost for output
subject to con61: level_reuse_C_FT1_under1 = level_transfer_C_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con62: level_reuse_C_FT1_under2 = level_transfer_C_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con63: level_transfer_C_FT1_under0 + level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2 = 1; # only one level of transfer for C
subject to con64: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 = 1; # only one level of reuse for C
subject to con65: level_reuse_B2_FT1_under0 = level_transfer_B2_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con66: level_reuse_B2_FT1_under1 = level_transfer_B2_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con67: level_reuse_B2_FT1_under2 = level_transfer_B2_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con68: level_transfer_B2_FT1_under0 + level_transfer_B2_FT1_under1 + level_transfer_B2_FT1_under2 = 1; # only one level of transfer for B2
subject to con69: level_reuse_B2_FT1_under0 + level_reuse_B2_FT1_under1 + level_reuse_B2_FT1_under2 = 1; # only one level of reuse for B2
subject to con70: level_reuse_A2_FT1_under0 >= level_transfer_A2_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con71: level_reuse_A2_FT1_under0 + level_reuse_A2_FT1_under1 >= level_transfer_A2_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con72: level_reuse_A2_FT1_under0 + level_reuse_A2_FT1_under1 + level_reuse_A2_FT1_under2 >= level_transfer_A2_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con73: level_transfer_A2_FT1_under0 + level_transfer_A2_FT1_under1 + level_transfer_A2_FT1_under2 = 1; # only one level of transfer for A2
subject to con74: level_reuse_A2_FT1_under0 + level_reuse_A2_FT1_under1 + level_reuse_A2_FT1_under2 = 1; # only one level of reuse for A2
subject to con75: level_reuse_tmp_FT1_under0 = level_transfer_tmp_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con76: level_reuse_tmp_FT1_under1 = level_transfer_tmp_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con77: level_reuse_tmp_FT1_under2 = level_transfer_tmp_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con78: level_transfer_tmp_FT1_under0 + level_transfer_tmp_FT1_under1 + level_transfer_tmp_FT1_under2 = 1; # only one level of transfer for tmp
subject to con79: level_reuse_tmp_FT1_under0 + level_reuse_tmp_FT1_under1 + level_reuse_tmp_FT1_under2 = 1; # only one level of reuse for tmp
subject to con80: level_reuse_C_FT1_under0 >= level_transfer_C_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con81: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 >= level_transfer_C_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con82: level_reuse_C_FT1_under0 + level_reuse_C_FT1_under1 + level_reuse_C_FT1_under2 >= level_transfer_C_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con83: level_reuse_B3_FT1_under0 >= level_transfer_B3_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con84: level_reuse_B3_FT1_under0 + level_reuse_B3_FT1_under1 >= level_transfer_B3_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con85: level_reuse_B3_FT1_under0 + level_reuse_B3_FT1_under1 + level_reuse_B3_FT1_under2 >= level_transfer_B3_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con86: level_transfer_B3_FT1_under0 + level_transfer_B3_FT1_under1 + level_transfer_B3_FT1_under2 = 1; # only one level of transfer for B3
subject to con87: level_reuse_B3_FT1_under0 + level_reuse_B3_FT1_under1 + level_reuse_B3_FT1_under2 = 1; # only one level of reuse for B3
subject to con88: level_reuse_A3_FT1_under0 = level_transfer_A3_FT1_under0; # reuse level have to be outermost or equal to transfer
subject to con89: level_reuse_A3_FT1_under1 = level_transfer_A3_FT1_under1; # reuse level have to be outermost or equal to transfer
subject to con90: level_reuse_A3_FT1_under2 = level_transfer_A3_FT1_under2; # reuse level have to be outermost or equal to transfer
subject to con91: level_transfer_A3_FT1_under0 + level_transfer_A3_FT1_under1 + level_transfer_A3_FT1_under2 = 1; # only one level of transfer for A3
subject to con92: level_reuse_A3_FT1_under0 + level_reuse_A3_FT1_under1 + level_reuse_A3_FT1_under2 = 1; # only one level of reuse for A3
subject to con93: Lat_comp_fused_S2_S3_3 = ((Lat_comp_S2_intra_tile) + (Lat_comp_S3_intra_tile + II_S3_seq * TC8_0)); # latency of the fused task S2_S3 level 3
subject to con94: Lat_comp_fused_S2_S3_2 = (perm0_S2 * TC6_0 + perm1_S2 * TC5_0) * max(Lat_comp_fused_S2_S3_3, level_transfer_C_FT1_under2 * footprint_C_S2_S3 / burst_C, level_transfer_B2_FT1_under2 * footprint_B2_S2 / burst_B2, level_transfer_A2_FT1_under2 * footprint_A2_S2 / burst_A2, level_transfer_tmp_FT1_under2 * footprint_tmp_S2 / burst_tmp, level_transfer_B3_FT1_under2 * footprint_B3_S3 / burst_B3, level_transfer_A3_FT1_under2 * footprint_A3_S3 / burst_A3) + Lat_comp_fused_S2_S3_3 + max(level_transfer_C_FT1_under2 * footprint_C_S2_S3 / burst_C, level_transfer_B2_FT1_under2 * footprint_B2_S2 / burst_B2, level_transfer_A2_FT1_under2 * footprint_A2_S2 / burst_A2, level_transfer_tmp_FT1_under2 * footprint_tmp_S2 / burst_tmp, level_transfer_B3_FT1_under2 * footprint_B3_S3 / burst_B3, level_transfer_A3_FT1_under2 * footprint_A3_S3 / burst_A3  + level_transfer_C_FT1_under2 * footprint_C_S2_S3 / burst_C); # latency of the fused task S2_S3 level 2
subject to con95: Lat_comp_fused_S2_S3_1 = (perm0_S2 * TC5_0 + perm1_S2 * TC6_0) * max(Lat_comp_fused_S2_S3_2, level_transfer_C_FT1_under1 * footprint_C_S2_S3 / burst_C, level_transfer_B2_FT1_under1 * footprint_B2_S2 / burst_B2, level_transfer_A2_FT1_under1 * footprint_A2_S2 / burst_A2, level_transfer_tmp_FT1_under1 * footprint_tmp_S2 / burst_tmp, level_transfer_B3_FT1_under1 * footprint_B3_S3 / burst_B3, level_transfer_A3_FT1_under1 * footprint_A3_S3 / burst_A3) + Lat_comp_fused_S2_S3_2 + max(level_transfer_C_FT1_under1 * footprint_C_S2_S3 / burst_C, level_transfer_B2_FT1_under1 * footprint_B2_S2 / burst_B2, level_transfer_A2_FT1_under1 * footprint_A2_S2 / burst_A2, level_transfer_tmp_FT1_under1 * footprint_tmp_S2 / burst_tmp, level_transfer_B3_FT1_under1 * footprint_B3_S3 / burst_B3, level_transfer_A3_FT1_under1 * footprint_A3_S3 / burst_A3  + level_transfer_C_FT1_under1 * footprint_C_S2_S3 / burst_C); # latency of the fused task S2_S3 level 1
subject to con96: Lat_comp_fused_S2_S3 = Lat_comp_fused_S2_S3_1 + level_transfer_C_FT1_under0 * footprint_tot_C_FT1 / burst_C + level_transfer_B2_FT1_under0 * footprint_tot_B2_FT1 / burst_B2 + level_transfer_A2_FT1_under0 * footprint_tot_A2_FT1 / burst_A2 + level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 / burst_tmp + level_transfer_B3_FT1_under0 * footprint_tot_B3_FT1 / burst_B3 + level_transfer_A3_FT1_under0 * footprint_tot_A3_FT1 / burst_A3; # latency of the fused task S2_S3
subject to con97: footprint_tmp_S0_S1 = level_transfer_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_transfer_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0) + level_transfer_tmp_FT0_under2 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con98: footprint_tmp_S0_S1_reuse = level_reuse_tmp_FT0_under0 * footprint_tot_tmp_FT0 + level_reuse_tmp_FT0_under1 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0) + level_reuse_tmp_FT0_under2 * (perm0_S0 * footprint_tot_tmp_FT0/ TC0_0/ TC1_0 + perm1_S0 * footprint_tot_tmp_FT0/ TC1_0/ TC0_0); # footprint of the array tmp for the fused task 0
subject to con99: perm0_S1 * level_transfer_B1_FT0_under1 = 0; # useless to transfer under this loop
subject to con100: perm0_S1 * level_reuse_B1_FT0_under1 = 0; # useless to reuse under this loop
subject to con101: perm1_S1 * level_transfer_B1_FT0_under1 = 0; # useless to transfer under this loop
subject to con102: perm1_S1 * level_reuse_B1_FT0_under1 = 0; # useless to reuse under this loop
subject to con103: perm2_S1 * level_transfer_B1_FT0_under2 = 0; # useless to transfer under this loop
subject to con104: perm2_S1 * level_reuse_B1_FT0_under2 = 0; # useless to reuse under this loop
subject to con105: perm4_S1 * level_transfer_B1_FT0_under2 = 0; # useless to transfer under this loop
subject to con106: perm4_S1 * level_reuse_B1_FT0_under2 = 0; # useless to reuse under this loop
subject to con107: footprint_B1_S1 = level_transfer_B1_FT0_under0 * footprint_tot_B1_FT0 + level_transfer_B1_FT0_under1 * (perm0_S1 * footprint_tot_B1_FT0 + perm1_S1 * footprint_tot_B1_FT0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0/ TC4_0 + perm5_S1 * footprint_tot_B1_FT0/ TC4_0) + level_transfer_B1_FT0_under2 * (perm0_S1 * footprint_tot_B1_FT0/ TC3_0 + perm1_S1 * footprint_tot_B1_FT0/ TC4_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B1_FT0/ TC4_0 + perm5_S1 * footprint_tot_B1_FT0/ TC4_0/ TC3_0); # footprint of the array B1 for the fused task 0
subject to con108: footprint_B1_S1_reuse = level_reuse_B1_FT0_under0 * footprint_tot_B1_FT0 + level_reuse_B1_FT0_under1 * (perm0_S1 * footprint_tot_B1_FT0 + perm1_S1 * footprint_tot_B1_FT0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0 + perm4_S1 * footprint_tot_B1_FT0/ TC4_0 + perm5_S1 * footprint_tot_B1_FT0/ TC4_0) + level_reuse_B1_FT0_under2 * (perm0_S1 * footprint_tot_B1_FT0/ TC3_0 + perm1_S1 * footprint_tot_B1_FT0/ TC4_0 + perm2_S1 * footprint_tot_B1_FT0/ TC3_0 + perm3_S1 * footprint_tot_B1_FT0/ TC3_0/ TC4_0 + perm4_S1 * footprint_tot_B1_FT0/ TC4_0 + perm5_S1 * footprint_tot_B1_FT0/ TC4_0/ TC3_0); # footprint of the array B1 for the fused task 0
subject to con109: perm2_S1 * level_transfer_A1_FT0_under1 = 0; # useless to transfer under this loop
subject to con110: perm2_S1 * level_reuse_A1_FT0_under1 = 0; # useless to reuse under this loop
subject to con111: perm3_S1 * level_transfer_A1_FT0_under1 = 0; # useless to transfer under this loop
subject to con112: perm3_S1 * level_reuse_A1_FT0_under1 = 0; # useless to reuse under this loop
subject to con113: perm0_S1 * level_transfer_A1_FT0_under2 = 0; # useless to transfer under this loop
subject to con114: perm0_S1 * level_reuse_A1_FT0_under2 = 0; # useless to reuse under this loop
subject to con115: perm5_S1 * level_transfer_A1_FT0_under2 = 0; # useless to transfer under this loop
subject to con116: perm5_S1 * level_reuse_A1_FT0_under2 = 0; # useless to reuse under this loop
subject to con117: footprint_A1_S1 = level_transfer_A1_FT0_under0 * footprint_tot_A1_FT0 + level_transfer_A1_FT0_under1 * (perm0_S1 * footprint_tot_A1_FT0/ TC2_0 + perm1_S1 * footprint_tot_A1_FT0/ TC2_0 + perm2_S1 * footprint_tot_A1_FT0 + perm3_S1 * footprint_tot_A1_FT0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0) + level_transfer_A1_FT0_under2 * (perm0_S1 * footprint_tot_A1_FT0/ TC2_0 + perm1_S1 * footprint_tot_A1_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A1_FT0/ TC2_0 + perm3_S1 * footprint_tot_A1_FT0/ TC4_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0); # footprint of the array A1 for the fused task 0
subject to con118: footprint_A1_S1_reuse = level_reuse_A1_FT0_under0 * footprint_tot_A1_FT0 + level_reuse_A1_FT0_under1 * (perm0_S1 * footprint_tot_A1_FT0/ TC2_0 + perm1_S1 * footprint_tot_A1_FT0/ TC2_0 + perm2_S1 * footprint_tot_A1_FT0 + perm3_S1 * footprint_tot_A1_FT0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0) + level_reuse_A1_FT0_under2 * (perm0_S1 * footprint_tot_A1_FT0/ TC2_0 + perm1_S1 * footprint_tot_A1_FT0/ TC2_0/ TC4_0 + perm2_S1 * footprint_tot_A1_FT0/ TC2_0 + perm3_S1 * footprint_tot_A1_FT0/ TC4_0 + perm4_S1 * footprint_tot_A1_FT0/ TC4_0/ TC2_0 + perm5_S1 * footprint_tot_A1_FT0/ TC4_0); # footprint of the array A1 for the fused task 0
subject to con119: footprint_tmp_S2 = level_transfer_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_transfer_tmp_FT1_under1 * (perm0_S2 * footprint_tot_tmp_FT1/ TC5_0 + perm1_S2 * footprint_tot_tmp_FT1/ TC6_0) + level_transfer_tmp_FT1_under2 * (perm0_S2 * footprint_tot_tmp_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_tmp_FT1/ TC6_0/ TC5_0); # footprint of the array tmp for the fused task 1
subject to con120: footprint_tmp_S2_reuse = level_reuse_tmp_FT1_under0 * footprint_tot_tmp_FT1 + level_reuse_tmp_FT1_under1 * (perm0_S2 * footprint_tot_tmp_FT1/ TC5_0 + perm1_S2 * footprint_tot_tmp_FT1/ TC6_0) + level_reuse_tmp_FT1_under2 * (perm0_S2 * footprint_tot_tmp_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_tmp_FT1/ TC6_0/ TC5_0); # footprint of the array tmp for the fused task 1
subject to con121: footprint_C_S2_S3 = level_transfer_C_FT1_under0 * footprint_tot_C_FT1 + level_transfer_C_FT1_under1 * (perm0_S2 * footprint_tot_C_FT1/ TC5_0 + perm1_S2 * footprint_tot_C_FT1/ TC6_0) + level_transfer_C_FT1_under2 * (perm0_S2 * footprint_tot_C_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_C_FT1/ TC6_0/ TC5_0); # footprint of the array C for the fused task 1
subject to con122: footprint_C_S2_S3_reuse = level_reuse_C_FT1_under0 * footprint_tot_C_FT1 + level_reuse_C_FT1_under1 * (perm0_S2 * footprint_tot_C_FT1/ TC5_0 + perm1_S2 * footprint_tot_C_FT1/ TC6_0) + level_reuse_C_FT1_under2 * (perm0_S2 * footprint_tot_C_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_C_FT1/ TC6_0/ TC5_0); # footprint of the array C for the fused task 1
subject to con123: footprint_B2_S2 = level_transfer_B2_FT1_under0 * footprint_tot_B2_FT1 + level_transfer_B2_FT1_under1 * (perm0_S2 * footprint_tot_B2_FT1/ TC5_0 + perm1_S2 * footprint_tot_B2_FT1/ TC6_0) + level_transfer_B2_FT1_under2 * (perm0_S2 * footprint_tot_B2_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_B2_FT1/ TC6_0/ TC5_0); # footprint of the array B2 for the fused task 1
subject to con124: footprint_B2_S2_reuse = level_reuse_B2_FT1_under0 * footprint_tot_B2_FT1 + level_reuse_B2_FT1_under1 * (perm0_S2 * footprint_tot_B2_FT1/ TC5_0 + perm1_S2 * footprint_tot_B2_FT1/ TC6_0) + level_reuse_B2_FT1_under2 * (perm0_S2 * footprint_tot_B2_FT1/ TC5_0/ TC6_0 + perm1_S2 * footprint_tot_B2_FT1/ TC6_0/ TC5_0); # footprint of the array B2 for the fused task 1
subject to con125: perm1_S2 * level_transfer_A2_FT1_under1 = 0; # useless to transfer under this loop
subject to con126: perm1_S2 * level_reuse_A2_FT1_under1 = 0; # useless to reuse under this loop
subject to con127: perm0_S2 * level_transfer_A2_FT1_under2 = 0; # useless to transfer under this loop
subject to con128: perm0_S2 * level_reuse_A2_FT1_under2 = 0; # useless to reuse under this loop
subject to con129: footprint_A2_S2 = level_transfer_A2_FT1_under0 * footprint_tot_A2_FT1 + level_transfer_A2_FT1_under1 * (perm0_S2 * footprint_tot_A2_FT1/ TC5_0 + perm1_S2 * footprint_tot_A2_FT1) + level_transfer_A2_FT1_under2 * (perm0_S2 * footprint_tot_A2_FT1/ TC5_0 + perm1_S2 * footprint_tot_A2_FT1/ TC5_0); # footprint of the array A2 for the fused task 1
subject to con130: footprint_A2_S2_reuse = level_reuse_A2_FT1_under0 * footprint_tot_A2_FT1 + level_reuse_A2_FT1_under1 * (perm0_S2 * footprint_tot_A2_FT1/ TC5_0 + perm1_S2 * footprint_tot_A2_FT1) + level_reuse_A2_FT1_under2 * (perm0_S2 * footprint_tot_A2_FT1/ TC5_0 + perm1_S2 * footprint_tot_A2_FT1/ TC5_0); # footprint of the array A2 for the fused task 1
subject to con131: perm0_S3 * level_transfer_B3_FT1_under1 = 0; # useless to transfer under this loop
subject to con132: perm0_S3 * level_reuse_B3_FT1_under1 = 0; # useless to reuse under this loop
subject to con133: perm1_S3 * level_transfer_B3_FT1_under1 = 0; # useless to transfer under this loop
subject to con134: perm1_S3 * level_reuse_B3_FT1_under1 = 0; # useless to reuse under this loop
subject to con135: perm2_S3 * level_transfer_B3_FT1_under2 = 0; # useless to transfer under this loop
subject to con136: perm2_S3 * level_reuse_B3_FT1_under2 = 0; # useless to reuse under this loop
subject to con137: perm4_S3 * level_transfer_B3_FT1_under2 = 0; # useless to transfer under this loop
subject to con138: perm4_S3 * level_reuse_B3_FT1_under2 = 0; # useless to reuse under this loop
subject to con139: footprint_B3_S3 = level_transfer_B3_FT1_under0 * footprint_tot_B3_FT1 + level_transfer_B3_FT1_under1 * (perm0_S3 * footprint_tot_B3_FT1 + perm1_S3 * footprint_tot_B3_FT1 + perm2_S3 * footprint_tot_B3_FT1/ TC8_0 + perm3_S3 * footprint_tot_B3_FT1/ TC8_0 + perm4_S3 * footprint_tot_B3_FT1/ TC9_0 + perm5_S3 * footprint_tot_B3_FT1/ TC9_0) + level_transfer_B3_FT1_under2 * (perm0_S3 * footprint_tot_B3_FT1/ TC8_0 + perm1_S3 * footprint_tot_B3_FT1/ TC9_0 + perm2_S3 * footprint_tot_B3_FT1/ TC8_0 + perm3_S3 * footprint_tot_B3_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_B3_FT1/ TC9_0 + perm5_S3 * footprint_tot_B3_FT1/ TC9_0/ TC8_0); # footprint of the array B3 for the fused task 1
subject to con140: footprint_B3_S3_reuse = level_reuse_B3_FT1_under0 * footprint_tot_B3_FT1 + level_reuse_B3_FT1_under1 * (perm0_S3 * footprint_tot_B3_FT1 + perm1_S3 * footprint_tot_B3_FT1 + perm2_S3 * footprint_tot_B3_FT1/ TC8_0 + perm3_S3 * footprint_tot_B3_FT1/ TC8_0 + perm4_S3 * footprint_tot_B3_FT1/ TC9_0 + perm5_S3 * footprint_tot_B3_FT1/ TC9_0) + level_reuse_B3_FT1_under2 * (perm0_S3 * footprint_tot_B3_FT1/ TC8_0 + perm1_S3 * footprint_tot_B3_FT1/ TC9_0 + perm2_S3 * footprint_tot_B3_FT1/ TC8_0 + perm3_S3 * footprint_tot_B3_FT1/ TC8_0/ TC9_0 + perm4_S3 * footprint_tot_B3_FT1/ TC9_0 + perm5_S3 * footprint_tot_B3_FT1/ TC9_0/ TC8_0); # footprint of the array B3 for the fused task 1
subject to con141: perm4_S3 * level_transfer_A3_FT1_under1 = 0; # useless to transfer under this loop
subject to con142: perm4_S3 * level_reuse_A3_FT1_under1 = 0; # useless to reuse under this loop
subject to con143: perm5_S3 * level_transfer_A3_FT1_under1 = 0; # useless to transfer under this loop
subject to con144: perm5_S3 * level_reuse_A3_FT1_under1 = 0; # useless to reuse under this loop
subject to con145: perm1_S3 * level_transfer_A3_FT1_under2 = 0; # useless to transfer under this loop
subject to con146: perm1_S3 * level_reuse_A3_FT1_under2 = 0; # useless to reuse under this loop
subject to con147: perm3_S3 * level_transfer_A3_FT1_under2 = 0; # useless to transfer under this loop
subject to con148: perm3_S3 * level_reuse_A3_FT1_under2 = 0; # useless to reuse under this loop
subject to con149: footprint_A3_S3 = level_transfer_A3_FT1_under0 * footprint_tot_A3_FT1 + level_transfer_A3_FT1_under1 * (perm0_S3 * footprint_tot_A3_FT1/ TC7_0 + perm1_S3 * footprint_tot_A3_FT1/ TC7_0 + perm2_S3 * footprint_tot_A3_FT1/ TC8_0 + perm3_S3 * footprint_tot_A3_FT1/ TC8_0 + perm4_S3 * footprint_tot_A3_FT1 + perm5_S3 * footprint_tot_A3_FT1) + level_transfer_A3_FT1_under2 * (perm0_S3 * footprint_tot_A3_FT1/ TC7_0/ TC8_0 + perm1_S3 * footprint_tot_A3_FT1/ TC7_0 + perm2_S3 * footprint_tot_A3_FT1/ TC8_0/ TC7_0 + perm3_S3 * footprint_tot_A3_FT1/ TC8_0 + perm4_S3 * footprint_tot_A3_FT1/ TC7_0 + perm5_S3 * footprint_tot_A3_FT1/ TC8_0); # footprint of the array A3 for the fused task 1
subject to con150: footprint_A3_S3_reuse = level_reuse_A3_FT1_under0 * footprint_tot_A3_FT1 + level_reuse_A3_FT1_under1 * (perm0_S3 * footprint_tot_A3_FT1/ TC7_0 + perm1_S3 * footprint_tot_A3_FT1/ TC7_0 + perm2_S3 * footprint_tot_A3_FT1/ TC8_0 + perm3_S3 * footprint_tot_A3_FT1/ TC8_0 + perm4_S3 * footprint_tot_A3_FT1 + perm5_S3 * footprint_tot_A3_FT1) + level_reuse_A3_FT1_under2 * (perm0_S3 * footprint_tot_A3_FT1/ TC7_0/ TC8_0 + perm1_S3 * footprint_tot_A3_FT1/ TC7_0 + perm2_S3 * footprint_tot_A3_FT1/ TC8_0/ TC7_0 + perm3_S3 * footprint_tot_A3_FT1/ TC8_0 + perm4_S3 * footprint_tot_A3_FT1/ TC7_0 + perm5_S3 * footprint_tot_A3_FT1/ TC8_0); # footprint of the array A3 for the fused task 1
subject to con151: shift_0_to_1 = ( + Lat_comp_S0_intra_tile + Lat_comp_S1_intra_tile + II_S1_seq * TC4_0 + footprint_tmp_S0_S1) * footprint_tmp_S2 / footprint_tmp_S0_S1;
subject to con152: TC0_1 * TC1_1 <= MAX_UF;
subject to con153: TC2_1 * TC3_1 * TC4_1 <= MAX_UF;
subject to con154: TC5_1 * TC6_1 <= MAX_UF;
subject to con155: TC7_1 * TC8_1 * TC9_1 <= MAX_UF;
subject to con156: TC0_1 * TC1_1 * DSP_S0  + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq + TC5_1 * TC6_1 * DSP_S2  + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq <= DSP_avail; # DSP constraint
subject to con157: nb_dsp_used_SLR0 = is_fused_task0_in_SLR_0 * (TC0_1 * TC1_1 * DSP_S0 + TC2_1 * TC3_1 * TC4_1 * DSP_S1 / II_S1_seq) + is_fused_task1_in_SLR_0 * (TC5_1 * TC6_1 * DSP_S2 + TC7_1 * TC8_1 * TC9_1 * DSP_S3 / II_S3_seq); # DSP constraint per SLR
subject to con158: nb_dsp_used_SLR0 <= SLR0_DSP; # DSP constraint per SLR
subject to con159: TC0_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con160: TC0_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con161: TC2_1 * TC1_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con162: TC2_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con163: TC4_1 * TC3_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B1 
subject to con164: TC2_1 * TC4_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A1 
subject to con165: TC5_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con166: TC5_1 * TC9_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con167: TC7_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con168: TC7_1 * TC9_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array C 
subject to con169: TC5_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B2 
subject to con170: TC5_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A2 
subject to con171: TC5_1 * TC6_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array tmp 
subject to con172: TC8_1 * TC9_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array B3 
subject to con173: TC8_1 * TC7_1 <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array A3 
subject to con174: Lat_comp_S3_for_off_chip = perm0_S3 * TC8_0 * TC9_0 * II_S3_par + perm1_S3 * TC8_0 * II_S3_seq + perm2_S3 * TC8_0 * TC7_0 * TC9_0 * II_S3_par + perm3_S3 * TC8_0 * TC9_0 * TC7_0 * II_S3_par + perm4_S3 * TC8_0 * II_S3_seq + perm5_S3 * TC8_0 * TC7_0 * II_S3_par; # stall between task
subject to con175: TC0_0 <= TC0; # TC of split loop
subject to con176: TC0_1 <= TC0; # TC of split loop
subject to con177: TC0_0 * TC0_1 = TC0; # product of the TC of split loop = original TC
subject to con178: TC1_0 <= TC1; # TC of split loop
subject to con179: TC1_1 <= TC1; # TC of split loop
subject to con180: TC1_0 * TC1_1 = TC1; # product of the TC of split loop = original TC
subject to con181: TC2_0 <= TC2; # TC of split loop
subject to con182: TC2_1 <= TC2; # TC of split loop
subject to con183: TC2_0 * TC2_1 = TC2; # product of the TC of split loop = original TC
subject to con184: TC3_0 <= TC3; # TC of split loop
subject to con185: TC3_1 <= TC3; # TC of split loop
subject to con186: TC3_0 * TC3_1 = TC3; # product of the TC of split loop = original TC
subject to con187: TC4_0 <= TC4; # TC of split loop
subject to con188: TC4_1 <= TC4; # TC of split loop
subject to con189: TC4_0 * TC4_1 = TC4; # product of the TC of split loop = original TC
subject to con190: TC5_0 <= TC5; # TC of split loop
subject to con191: TC5_1 <= TC5; # TC of split loop
subject to con192: TC5_0 * TC5_1 = TC5; # product of the TC of split loop = original TC
subject to con193: TC6_0 <= TC6; # TC of split loop
subject to con194: TC6_1 <= TC6; # TC of split loop
subject to con195: TC6_0 * TC6_1 = TC6; # product of the TC of split loop = original TC
subject to con196: TC7_0 <= TC7; # TC of split loop
subject to con197: TC7_1 <= TC7; # TC of split loop
subject to con198: TC7_0 * TC7_1 = TC7; # product of the TC of split loop = original TC
subject to con199: TC8_0 <= TC8; # TC of split loop
subject to con200: TC8_1 <= TC8; # TC of split loop
subject to con201: TC8_0 * TC8_1 = TC8; # product of the TC of split loop = original TC
subject to con202: TC9_0 <= TC9; # TC of split loop
subject to con203: TC9_1 <= TC9; # TC of split loop
subject to con204: TC9_0 * TC9_1 = TC9; # product of the TC of split loop = original TC
subject to con205: TC0_1 = TC2_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con206: TC1_1 = TC3_1; # same intra tile for the same dimension of the array tmp in the fused task
subject to con207: TC5_1 = TC7_1; # same intra tile for the same dimension of the array C in the fused task
subject to con208: TC6_1 = TC9_1; # same intra tile for the same dimension of the array C in the fused task
subject to con209: B1_is_fully_transfered_on_last_dim_FT0 = level_transfer_B1_FT0_under0 + perm0_S1 * (level_transfer_B1_FT0_under1) + perm1_S1 * (level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2) + perm4_S1 * (level_transfer_B1_FT0_under1 + level_transfer_B1_FT0_under2) + perm5_S1 * (level_transfer_B1_FT0_under1); # the array B1 is fully transfered on the last dimension
subject to con210: burst_B1_is_1 * cte_0 * 1 = burst_B1_is_1 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con211: is_tc3_burst_witout_tiling_for_B1 =  min(1, cte_burst_without_tiling_TC3_for_B1);
subject to con212: burst_B1_is_2 * cte_1 * 2 = burst_B1_is_2 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con213: burst_B1_is_4 * cte_2 * 4 = burst_B1_is_4 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con214: burst_B1_is_8 * cte_3 * 8 = burst_B1_is_8 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con215: burst_B1_is_16 * cte_4 * 16 = burst_B1_is_16 * ((1-is_tc3_burst_witout_tiling_for_B1) * (TC3_1 * (1-B1_is_fully_transfered_on_last_dim_FT0) + TC3 * (B1_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_B1 * (cte_burst_without_tiling_TC3_for_B1 + TC3));
subject to con216: burst_B1 = burst_B1_is_1 * 1 + burst_B1_is_2 * 2 + burst_B1_is_4 * 4 + burst_B1_is_8 * 8 + burst_B1_is_16 * 16; # burst size of the array B1
subject to con217: burst_B1_is_1 + burst_B1_is_2 + burst_B1_is_4 + burst_B1_is_8 + burst_B1_is_16 = 1; # only one burst size for the array B1
subject to con218: is_tc3_burst_witout_tiling_for_B1 <= B1_is_fully_transfered_on_last_dim_FT0;
subject to con219: A1_is_fully_transfered_on_last_dim_FT0 = level_transfer_A1_FT0_under0 + perm0_S1 * (level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2) + perm1_S1 * (level_transfer_A1_FT0_under1) + perm2_S1 * (level_transfer_A1_FT0_under1 + level_transfer_A1_FT0_under2) + perm3_S1 * (level_transfer_A1_FT0_under1); # the array A1 is fully transfered on the last dimension
subject to con220: burst_A1_is_1 * cte_5 * 1 = burst_A1_is_1 * ((1-is_tc4_burst_witout_tiling_for_A1) * (TC4_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC4 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC4_for_A1 + TC4));
subject to con221: is_tc4_burst_witout_tiling_for_A1 =  min(1, cte_burst_without_tiling_TC4_for_A1);
subject to con222: burst_A1_is_2 * cte_6 * 2 = burst_A1_is_2 * ((1-is_tc4_burst_witout_tiling_for_A1) * (TC4_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC4 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC4_for_A1 + TC4));
subject to con223: burst_A1_is_4 * cte_7 * 4 = burst_A1_is_4 * ((1-is_tc4_burst_witout_tiling_for_A1) * (TC4_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC4 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC4_for_A1 + TC4));
subject to con224: burst_A1_is_8 * cte_8 * 8 = burst_A1_is_8 * ((1-is_tc4_burst_witout_tiling_for_A1) * (TC4_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC4 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC4_for_A1 + TC4));
subject to con225: burst_A1_is_16 * cte_9 * 16 = burst_A1_is_16 * ((1-is_tc4_burst_witout_tiling_for_A1) * (TC4_1 * (1-A1_is_fully_transfered_on_last_dim_FT0) + TC4 * (A1_is_fully_transfered_on_last_dim_FT0)) + is_tc4_burst_witout_tiling_for_A1 * (cte_burst_without_tiling_TC4_for_A1 + TC4));
subject to con226: burst_A1 = burst_A1_is_1 * 1 + burst_A1_is_2 * 2 + burst_A1_is_4 * 4 + burst_A1_is_8 * 8 + burst_A1_is_16 * 16; # burst size of the array A1
subject to con227: burst_A1_is_1 + burst_A1_is_2 + burst_A1_is_4 + burst_A1_is_8 + burst_A1_is_16 = 1; # only one burst size for the array A1
subject to con228: is_tc4_burst_witout_tiling_for_A1 <= A1_is_fully_transfered_on_last_dim_FT0;
subject to con229: A3_is_fully_transfered_on_last_dim_FT1 = level_transfer_A3_FT1_under0 + perm2_S3 * (level_transfer_A3_FT1_under1) + perm3_S3 * (level_transfer_A3_FT1_under1 + level_transfer_A3_FT1_under2) + perm4_S3 * (level_transfer_A3_FT1_under1) + perm5_S3 * (level_transfer_A3_FT1_under1 + level_transfer_A3_FT1_under2); # the array A3 is fully transfered on the last dimension
subject to con230: burst_A3_is_1 * cte_10 * 1 = burst_A3_is_1 * ((1-is_tc7_burst_witout_tiling_for_A3) * (TC7_1 * (1-A3_is_fully_transfered_on_last_dim_FT1) + TC7 * (A3_is_fully_transfered_on_last_dim_FT1)) + is_tc7_burst_witout_tiling_for_A3 * (cte_burst_without_tiling_TC7_for_A3 + TC7));
subject to con231: is_tc7_burst_witout_tiling_for_A3 =  min(1, cte_burst_without_tiling_TC7_for_A3);
subject to con232: burst_A3_is_2 * cte_11 * 2 = burst_A3_is_2 * ((1-is_tc7_burst_witout_tiling_for_A3) * (TC7_1 * (1-A3_is_fully_transfered_on_last_dim_FT1) + TC7 * (A3_is_fully_transfered_on_last_dim_FT1)) + is_tc7_burst_witout_tiling_for_A3 * (cte_burst_without_tiling_TC7_for_A3 + TC7));
subject to con233: burst_A3_is_4 * cte_12 * 4 = burst_A3_is_4 * ((1-is_tc7_burst_witout_tiling_for_A3) * (TC7_1 * (1-A3_is_fully_transfered_on_last_dim_FT1) + TC7 * (A3_is_fully_transfered_on_last_dim_FT1)) + is_tc7_burst_witout_tiling_for_A3 * (cte_burst_without_tiling_TC7_for_A3 + TC7));
subject to con234: burst_A3_is_8 * cte_13 * 8 = burst_A3_is_8 * ((1-is_tc7_burst_witout_tiling_for_A3) * (TC7_1 * (1-A3_is_fully_transfered_on_last_dim_FT1) + TC7 * (A3_is_fully_transfered_on_last_dim_FT1)) + is_tc7_burst_witout_tiling_for_A3 * (cte_burst_without_tiling_TC7_for_A3 + TC7));
subject to con235: burst_A3_is_16 * cte_14 * 16 = burst_A3_is_16 * ((1-is_tc7_burst_witout_tiling_for_A3) * (TC7_1 * (1-A3_is_fully_transfered_on_last_dim_FT1) + TC7 * (A3_is_fully_transfered_on_last_dim_FT1)) + is_tc7_burst_witout_tiling_for_A3 * (cte_burst_without_tiling_TC7_for_A3 + TC7));
subject to con236: burst_A3 = burst_A3_is_1 * 1 + burst_A3_is_2 * 2 + burst_A3_is_4 * 4 + burst_A3_is_8 * 8 + burst_A3_is_16 * 16; # burst size of the array A3
subject to con237: burst_A3_is_1 + burst_A3_is_2 + burst_A3_is_4 + burst_A3_is_8 + burst_A3_is_16 = 1; # only one burst size for the array A3
subject to con238: is_tc7_burst_witout_tiling_for_A3 <= A3_is_fully_transfered_on_last_dim_FT1;
subject to con239: A2_is_fully_transfered_on_last_dim_FT1 = level_transfer_A2_FT1_under0 + perm1_S2 * (level_transfer_A2_FT1_under1); # the array A2 is fully transfered on the last dimension
subject to con240: burst_A2_is_1 * cte_15 * 1 = burst_A2_is_1 * ((1-is_tc5_burst_witout_tiling_for_A2) * (TC5_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC5 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC5_for_A2 + TC5));
subject to con241: is_tc5_burst_witout_tiling_for_A2 =  min(1, cte_burst_without_tiling_TC5_for_A2);
subject to con242: burst_A2_is_2 * cte_16 * 2 = burst_A2_is_2 * ((1-is_tc5_burst_witout_tiling_for_A2) * (TC5_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC5 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC5_for_A2 + TC5));
subject to con243: burst_A2_is_4 * cte_17 * 4 = burst_A2_is_4 * ((1-is_tc5_burst_witout_tiling_for_A2) * (TC5_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC5 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC5_for_A2 + TC5));
subject to con244: burst_A2_is_8 * cte_18 * 8 = burst_A2_is_8 * ((1-is_tc5_burst_witout_tiling_for_A2) * (TC5_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC5 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC5_for_A2 + TC5));
subject to con245: burst_A2_is_16 * cte_19 * 16 = burst_A2_is_16 * ((1-is_tc5_burst_witout_tiling_for_A2) * (TC5_1 * (1-A2_is_fully_transfered_on_last_dim_FT1) + TC5 * (A2_is_fully_transfered_on_last_dim_FT1)) + is_tc5_burst_witout_tiling_for_A2 * (cte_burst_without_tiling_TC5_for_A2 + TC5));
subject to con246: burst_A2 = burst_A2_is_1 * 1 + burst_A2_is_2 * 2 + burst_A2_is_4 * 4 + burst_A2_is_8 * 8 + burst_A2_is_16 * 16; # burst size of the array A2
subject to con247: burst_A2_is_1 + burst_A2_is_2 + burst_A2_is_4 + burst_A2_is_8 + burst_A2_is_16 = 1; # only one burst size for the array A2
subject to con248: is_tc5_burst_witout_tiling_for_A2 <= A2_is_fully_transfered_on_last_dim_FT1;
subject to con249: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm0_S0 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con250: tmp_is_fully_transfered_on_last_dim_FT0 = level_transfer_tmp_FT0_under0 + perm0_S1 * (level_transfer_tmp_FT0_under1) + perm1_S1 * (level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2) + perm4_S1 * (level_transfer_tmp_FT0_under1 + level_transfer_tmp_FT0_under2) + perm5_S1 * (level_transfer_tmp_FT0_under1); # the array tmp is fully transfered on the last dimension
subject to con251: tmp_is_fully_transfered_on_last_dim_FT1 = level_transfer_tmp_FT1_under0 + perm0_S2 * (level_transfer_tmp_FT1_under1); # the array tmp is fully transfered on the last dimension
subject to con252: burst_tmp_is_1 * cte_20 * 1 = burst_tmp_is_1 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con253: is_tc1_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC1_for_tmp);
subject to con254: burst_tmp_is_1 * cte_21 * 1 = burst_tmp_is_1 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con255: is_tc3_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC3_for_tmp);
subject to con256: burst_tmp_is_1 * cte_22 * 1 = burst_tmp_is_1 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con257: burst_tmp_is_1 * cte_23 * 1 = burst_tmp_is_1 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con258: is_tc6_burst_witout_tiling_for_tmp =  min(1, cte_burst_without_tiling_TC6_for_tmp);
subject to con259: burst_tmp_is_2 * cte_24 * 2 = burst_tmp_is_2 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con260: burst_tmp_is_2 * cte_25 * 2 = burst_tmp_is_2 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con261: burst_tmp_is_2 * cte_26 * 2 = burst_tmp_is_2 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con262: burst_tmp_is_2 * cte_27 * 2 = burst_tmp_is_2 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con263: burst_tmp_is_4 * cte_28 * 4 = burst_tmp_is_4 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con264: burst_tmp_is_4 * cte_29 * 4 = burst_tmp_is_4 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con265: burst_tmp_is_4 * cte_30 * 4 = burst_tmp_is_4 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con266: burst_tmp_is_4 * cte_31 * 4 = burst_tmp_is_4 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con267: burst_tmp_is_8 * cte_32 * 8 = burst_tmp_is_8 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con268: burst_tmp_is_8 * cte_33 * 8 = burst_tmp_is_8 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con269: burst_tmp_is_8 * cte_34 * 8 = burst_tmp_is_8 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con270: burst_tmp_is_8 * cte_35 * 8 = burst_tmp_is_8 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con271: burst_tmp_is_16 * cte_36 * 16 = burst_tmp_is_16 * ((1-is_tc1_burst_witout_tiling_for_tmp) * (TC1_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC1 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc1_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC1_for_tmp + TC1));
subject to con272: burst_tmp_is_16 * cte_37 * 16 = burst_tmp_is_16 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con273: burst_tmp_is_16 * cte_38 * 16 = burst_tmp_is_16 * ((1-is_tc3_burst_witout_tiling_for_tmp) * (TC3_1 * (1-tmp_is_fully_transfered_on_last_dim_FT0) + TC3 * (tmp_is_fully_transfered_on_last_dim_FT0)) + is_tc3_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC3_for_tmp + TC3));
subject to con274: burst_tmp_is_16 * cte_39 * 16 = burst_tmp_is_16 * ((1-is_tc6_burst_witout_tiling_for_tmp) * (TC6_1 * (1-tmp_is_fully_transfered_on_last_dim_FT1) + TC6 * (tmp_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_tmp * (cte_burst_without_tiling_TC6_for_tmp + TC6));
subject to con275: burst_tmp = burst_tmp_is_1 * 1 + burst_tmp_is_2 * 2 + burst_tmp_is_4 * 4 + burst_tmp_is_8 * 8 + burst_tmp_is_16 * 16; # burst size of the array tmp
subject to con276: burst_tmp_is_1 + burst_tmp_is_2 + burst_tmp_is_4 + burst_tmp_is_8 + burst_tmp_is_16 = 1; # only one burst size for the array tmp
subject to con277: is_tc1_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con278: is_tc3_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT0;
subject to con279: is_tc6_burst_witout_tiling_for_tmp <= tmp_is_fully_transfered_on_last_dim_FT1;
subject to con280: B3_is_fully_transfered_on_last_dim_FT1 = level_transfer_B3_FT1_under0 + perm0_S3 * (level_transfer_B3_FT1_under1 + level_transfer_B3_FT1_under2) + perm1_S3 * (level_transfer_B3_FT1_under1) + perm2_S3 * (level_transfer_B3_FT1_under1 + level_transfer_B3_FT1_under2) + perm3_S3 * (level_transfer_B3_FT1_under1); # the array B3 is fully transfered on the last dimension
subject to con281: burst_B3_is_1 * cte_40 * 1 = burst_B3_is_1 * ((1-is_tc9_burst_witout_tiling_for_B3) * (TC9_1 * (1-B3_is_fully_transfered_on_last_dim_FT1) + TC9 * (B3_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_B3 * (cte_burst_without_tiling_TC9_for_B3 + TC9));
subject to con282: is_tc9_burst_witout_tiling_for_B3 =  min(1, cte_burst_without_tiling_TC9_for_B3);
subject to con283: burst_B3_is_2 * cte_41 * 2 = burst_B3_is_2 * ((1-is_tc9_burst_witout_tiling_for_B3) * (TC9_1 * (1-B3_is_fully_transfered_on_last_dim_FT1) + TC9 * (B3_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_B3 * (cte_burst_without_tiling_TC9_for_B3 + TC9));
subject to con284: burst_B3_is_4 * cte_42 * 4 = burst_B3_is_4 * ((1-is_tc9_burst_witout_tiling_for_B3) * (TC9_1 * (1-B3_is_fully_transfered_on_last_dim_FT1) + TC9 * (B3_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_B3 * (cte_burst_without_tiling_TC9_for_B3 + TC9));
subject to con285: burst_B3_is_8 * cte_43 * 8 = burst_B3_is_8 * ((1-is_tc9_burst_witout_tiling_for_B3) * (TC9_1 * (1-B3_is_fully_transfered_on_last_dim_FT1) + TC9 * (B3_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_B3 * (cte_burst_without_tiling_TC9_for_B3 + TC9));
subject to con286: burst_B3_is_16 * cte_44 * 16 = burst_B3_is_16 * ((1-is_tc9_burst_witout_tiling_for_B3) * (TC9_1 * (1-B3_is_fully_transfered_on_last_dim_FT1) + TC9 * (B3_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_B3 * (cte_burst_without_tiling_TC9_for_B3 + TC9));
subject to con287: burst_B3 = burst_B3_is_1 * 1 + burst_B3_is_2 * 2 + burst_B3_is_4 * 4 + burst_B3_is_8 * 8 + burst_B3_is_16 * 16; # burst size of the array B3
subject to con288: burst_B3_is_1 + burst_B3_is_2 + burst_B3_is_4 + burst_B3_is_8 + burst_B3_is_16 = 1; # only one burst size for the array B3
subject to con289: is_tc9_burst_witout_tiling_for_B3 <= B3_is_fully_transfered_on_last_dim_FT1;
subject to con290: C_is_fully_transfered_on_last_dim_FT1 = level_transfer_C_FT1_under0 + perm0_S2 * (level_transfer_C_FT1_under1); # the array C is fully transfered on the last dimension
subject to con291: C_is_fully_transfered_on_last_dim_FT1 = level_transfer_C_FT1_under0 + perm0_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm1_S3 * (level_transfer_C_FT1_under1) + perm2_S3 * (level_transfer_C_FT1_under1 + level_transfer_C_FT1_under2) + perm3_S3 * (level_transfer_C_FT1_under1); # the array C is fully transfered on the last dimension
subject to con292: burst_C_is_1 * cte_45 * 1 = burst_C_is_1 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con293: is_tc6_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC6_for_C);
subject to con294: burst_C_is_1 * cte_46 * 1 = burst_C_is_1 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con295: burst_C_is_1 * cte_47 * 1 = burst_C_is_1 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con296: is_tc9_burst_witout_tiling_for_C =  min(1, cte_burst_without_tiling_TC9_for_C);
subject to con297: burst_C_is_1 * cte_48 * 1 = burst_C_is_1 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con298: burst_C_is_2 * cte_49 * 2 = burst_C_is_2 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con299: burst_C_is_2 * cte_50 * 2 = burst_C_is_2 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con300: burst_C_is_2 * cte_51 * 2 = burst_C_is_2 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con301: burst_C_is_2 * cte_52 * 2 = burst_C_is_2 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con302: burst_C_is_4 * cte_53 * 4 = burst_C_is_4 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con303: burst_C_is_4 * cte_54 * 4 = burst_C_is_4 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con304: burst_C_is_4 * cte_55 * 4 = burst_C_is_4 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con305: burst_C_is_4 * cte_56 * 4 = burst_C_is_4 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con306: burst_C_is_8 * cte_57 * 8 = burst_C_is_8 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con307: burst_C_is_8 * cte_58 * 8 = burst_C_is_8 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con308: burst_C_is_8 * cte_59 * 8 = burst_C_is_8 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con309: burst_C_is_8 * cte_60 * 8 = burst_C_is_8 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con310: burst_C_is_16 * cte_61 * 16 = burst_C_is_16 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con311: burst_C_is_16 * cte_62 * 16 = burst_C_is_16 * ((1-is_tc6_burst_witout_tiling_for_C) * (TC6_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC6 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC6_for_C + TC6));
subject to con312: burst_C_is_16 * cte_63 * 16 = burst_C_is_16 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con313: burst_C_is_16 * cte_64 * 16 = burst_C_is_16 * ((1-is_tc9_burst_witout_tiling_for_C) * (TC9_1 * (1-C_is_fully_transfered_on_last_dim_FT1) + TC9 * (C_is_fully_transfered_on_last_dim_FT1)) + is_tc9_burst_witout_tiling_for_C * (cte_burst_without_tiling_TC9_for_C + TC9));
subject to con314: burst_C = burst_C_is_1 * 1 + burst_C_is_2 * 2 + burst_C_is_4 * 4 + burst_C_is_8 * 8 + burst_C_is_16 * 16; # burst size of the array C
subject to con315: burst_C_is_1 + burst_C_is_2 + burst_C_is_4 + burst_C_is_8 + burst_C_is_16 = 1; # only one burst size for the array C
subject to con316: is_tc6_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT1;
subject to con317: is_tc9_burst_witout_tiling_for_C <= C_is_fully_transfered_on_last_dim_FT1;
subject to con318: B2_is_fully_transfered_on_last_dim_FT1 = level_transfer_B2_FT1_under0 + perm0_S2 * (level_transfer_B2_FT1_under1); # the array B2 is fully transfered on the last dimension
subject to con319: burst_B2_is_1 * cte_65 * 1 = burst_B2_is_1 * ((1-is_tc6_burst_witout_tiling_for_B2) * (TC6_1 * (1-B2_is_fully_transfered_on_last_dim_FT1) + TC6 * (B2_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC6_for_B2 + TC6));
subject to con320: is_tc6_burst_witout_tiling_for_B2 =  min(1, cte_burst_without_tiling_TC6_for_B2);
subject to con321: burst_B2_is_2 * cte_66 * 2 = burst_B2_is_2 * ((1-is_tc6_burst_witout_tiling_for_B2) * (TC6_1 * (1-B2_is_fully_transfered_on_last_dim_FT1) + TC6 * (B2_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC6_for_B2 + TC6));
subject to con322: burst_B2_is_4 * cte_67 * 4 = burst_B2_is_4 * ((1-is_tc6_burst_witout_tiling_for_B2) * (TC6_1 * (1-B2_is_fully_transfered_on_last_dim_FT1) + TC6 * (B2_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC6_for_B2 + TC6));
subject to con323: burst_B2_is_8 * cte_68 * 8 = burst_B2_is_8 * ((1-is_tc6_burst_witout_tiling_for_B2) * (TC6_1 * (1-B2_is_fully_transfered_on_last_dim_FT1) + TC6 * (B2_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC6_for_B2 + TC6));
subject to con324: burst_B2_is_16 * cte_69 * 16 = burst_B2_is_16 * ((1-is_tc6_burst_witout_tiling_for_B2) * (TC6_1 * (1-B2_is_fully_transfered_on_last_dim_FT1) + TC6 * (B2_is_fully_transfered_on_last_dim_FT1)) + is_tc6_burst_witout_tiling_for_B2 * (cte_burst_without_tiling_TC6_for_B2 + TC6));
subject to con325: burst_B2 = burst_B2_is_1 * 1 + burst_B2_is_2 * 2 + burst_B2_is_4 * 4 + burst_B2_is_8 * 8 + burst_B2_is_16 * 16; # burst size of the array B2
subject to con326: burst_B2_is_1 + burst_B2_is_2 + burst_B2_is_4 + burst_B2_is_8 + burst_B2_is_16 = 1; # only one burst size for the array B2
subject to con327: is_tc6_burst_witout_tiling_for_B2 <= B2_is_fully_transfered_on_last_dim_FT1;
subject to con328: footprint_tot_B1_FT0 = TC4_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_B1);
subject to con329: footprint_tot_A1_FT0 = TC2_ori * TC4_0 * (TC4_1 + cte_burst_without_tiling_TC4_for_A1);
subject to con330: footprint_tot_A3_FT1 = TC8_ori * TC7_0 * (TC7_1 + cte_burst_without_tiling_TC7_for_A3);
subject to con331: footprint_tot_A2_FT1 = TC5_0 * (TC5_1 + cte_burst_without_tiling_TC5_for_A2);
subject to con332: footprint_tot_tmp_FT0 = TC0_ori * TC1_0 * (TC1_1 + cte_burst_without_tiling_TC1_for_tmp);
subject to con333: footprint_tot_tmp_FT0 = TC2_ori * TC3_0 * (TC3_1 + cte_burst_without_tiling_TC3_for_tmp);
subject to con334: footprint_tot_tmp_FT1 = TC5_ori * TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_tmp);
subject to con335: footprint_tot_B3_FT1 = TC8_ori * TC9_0 * (TC9_1 + cte_burst_without_tiling_TC9_for_B3);
subject to con336: footprint_tot_C_FT1 = TC5_ori * TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_C);
subject to con337: footprint_tot_C_FT1 = TC7_ori * TC9_0 * (TC9_1 + cte_burst_without_tiling_TC9_for_C);
subject to con338: footprint_tot_B2_FT1 = TC5_ori * TC6_0 * (TC6_1 + cte_burst_without_tiling_TC6_for_B2);
subject to con339: TC0 = TC0_ori;
subject to con340: TC2 = TC2_ori;
subject to con341: TC8 = TC8_ori;
subject to con342: obj = max(shift_0_to_1 + Lat_comp_fused_S2_S3, Lat_comp_fused_S0_S1) + 1/burst_B1 + 1/burst_A1 + 1/burst_A3 + 1/burst_A2 + 1/burst_tmp + 1/burst_B3 + 1/burst_C + 1/burst_B2 + 1/(is_slr0_used);
subject to con343: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC0_1, TC2_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC0_1, TC2_1) * cte_tiling_0; # should divide for tmp in dim 0
subject to con344: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC0_1, TC5_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC0_1, TC5_1) * cte_tiling_1; # should divide for tmp in dim 0
subject to con345: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC2_1, TC5_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC2_1, TC5_1) * cte_tiling_2; # should divide for tmp in dim 0
subject to con346: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * max(TC1_1, TC3_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT0 * min(TC1_1, TC3_1) * cte_tiling_3; # should divide for tmp in dim 1
subject to con347: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC1_1, TC6_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC1_1, TC6_1) * cte_tiling_4; # should divide for tmp in dim 1
subject to con348: tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * max(TC3_1, TC6_1) = tmp_is_fully_transfered_on_last_dim_FT0 * tmp_is_fully_transfered_on_last_dim_FT1 * min(TC3_1, TC6_1) * cte_tiling_5; # should divide for tmp in dim 1
subject to con349: C_is_fully_transfered_on_last_dim_FT1 * C_is_fully_transfered_on_last_dim_FT1 * max(TC5_1, TC7_1) = C_is_fully_transfered_on_last_dim_FT1 * C_is_fully_transfered_on_last_dim_FT1 * min(TC5_1, TC7_1) * cte_tiling_6; # should divide for C in dim 0
subject to con350: C_is_fully_transfered_on_last_dim_FT1 * C_is_fully_transfered_on_last_dim_FT1 * max(TC6_1, TC9_1) = C_is_fully_transfered_on_last_dim_FT1 * C_is_fully_transfered_on_last_dim_FT1 * min(TC6_1, TC9_1) * cte_tiling_7; # should divide for C in dim 1
subject to con351: buffer_size = footprint_tmp_S0_S1_reuse + footprint_B1_S1_reuse + footprint_A1_S1_reuse + footprint_tmp_S2_reuse + footprint_C_S2_S3_reuse + footprint_B2_S2_reuse + footprint_A2_S2_reuse + footprint_B3_S3_reuse + footprint_A3_S3_reuse; # total buffer size
subject to con352: fifo_size = 0; # total fifo size
subject to con353: buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size
subject to con354: perm0_S0 * perm1_S2 * level_transfer_tmp_FT1_under0 = perm0_S0 * perm1_S2 * 1;
subject to con355: perm1_S0 * perm0_S2 * level_transfer_tmp_FT1_under0 = perm1_S0 * perm0_S2 * 1;
subject to con356: perm0_S1 * perm1_S2 * level_transfer_tmp_FT1_under0 = perm0_S1 * perm1_S2 * 1;
subject to con357: perm1_S1 * perm1_S2 * level_transfer_tmp_FT1_under0 = perm1_S1 * perm1_S2 * 1;
subject to con358: perm2_S1 * perm0_S2 * level_transfer_tmp_FT1_under0 = perm2_S1 * perm0_S2 * 1;
subject to con359: perm3_S1 * perm0_S2 * level_transfer_tmp_FT1_under0 = perm3_S1 * perm0_S2 * 1;
subject to con360: perm4_S1 * perm1_S2 * level_transfer_tmp_FT1_under0 = perm4_S1 * perm1_S2 * 1;
subject to con361: perm5_S1 * perm0_S2 * level_transfer_tmp_FT1_under0 = perm5_S1 * perm0_S2 * 1;
subject to con362: perm0_S1 * level_reuse_B1_FT0_under0 = perm0_S1 * 1;
subject to con363: perm1_S1 * level_reuse_B1_FT0_under0 = perm1_S1 * 1;
subject to con364: perm2_S1 * level_reuse_A1_FT0_under0 = perm2_S1 * 1;
subject to con365: perm3_S1 * level_reuse_A1_FT0_under0 = perm3_S1 * 1;
subject to con366: perm4_S3 * level_reuse_A3_FT1_under0 = perm4_S3 * 1;
subject to con367: perm5_S3 * level_reuse_A3_FT1_under0 = perm5_S3 * 1;
subject to con368: perm1_S2 * level_reuse_A2_FT1_under0 = perm1_S2 * 1;
subject to con369: perm4_S1 * level_reuse_tmp_FT0_under0 = perm4_S1 * 1;
subject to con370: perm5_S1 * level_reuse_tmp_FT0_under0 = perm5_S1 * 1;
subject to con371: perm0_S3 * level_reuse_B3_FT1_under0 = perm0_S3 * 1;
subject to con372: perm1_S3 * level_reuse_B3_FT1_under0 = perm1_S3 * 1;
subject to con373: perm2_S3 * level_reuse_C_FT1_under0 = perm2_S3 * 1;
subject to con374: perm3_S3 * level_reuse_C_FT1_under0 = perm3_S3 * 1;
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
display is_fused_task1_in_SLR_0;
display is_slr0_used;
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
display footprint_B1_S1;
display footprint_B1_S1_reuse;
display footprint_A1_S1;
display footprint_A1_S1_reuse;
display footprint_tmp_S2;
display footprint_tmp_S2_reuse;
display footprint_C_S2_S3;
display footprint_C_S2_S3_reuse;
display footprint_B2_S2;
display footprint_B2_S2_reuse;
display footprint_A2_S2;
display footprint_A2_S2_reuse;
display footprint_B3_S3;
display footprint_B3_S3_reuse;
display footprint_A3_S3;
display footprint_A3_S3_reuse;
display Lat_comp_fused_S0_S1;
display level_transfer_tmp_FT0_under0;
display level_reuse_tmp_FT0_under0;
display level_transfer_tmp_FT0_under1;
display level_reuse_tmp_FT0_under1;
display level_transfer_tmp_FT0_under2;
display level_reuse_tmp_FT0_under2;
display level_transfer_B1_FT0_under0;
display level_reuse_B1_FT0_under0;
display level_transfer_B1_FT0_under1;
display level_reuse_B1_FT0_under1;
display level_transfer_B1_FT0_under2;
display level_reuse_B1_FT0_under2;
display level_transfer_A1_FT0_under0;
display level_reuse_A1_FT0_under0;
display level_transfer_A1_FT0_under1;
display level_reuse_A1_FT0_under1;
display level_transfer_A1_FT0_under2;
display level_reuse_A1_FT0_under2;
display Lat_comp_fused_S0_S1_3;
display Lat_comp_fused_S0_S1_2;
display Lat_comp_fused_S0_S1_1;
display Lat_comp_fused_S2_S3;
display level_transfer_C_FT1_under0;
display level_reuse_C_FT1_under0;
display level_transfer_C_FT1_under1;
display level_reuse_C_FT1_under1;
display level_transfer_C_FT1_under2;
display level_reuse_C_FT1_under2;
display level_transfer_B2_FT1_under0;
display level_reuse_B2_FT1_under0;
display level_transfer_B2_FT1_under1;
display level_reuse_B2_FT1_under1;
display level_transfer_B2_FT1_under2;
display level_reuse_B2_FT1_under2;
display level_transfer_A2_FT1_under0;
display level_reuse_A2_FT1_under0;
display level_transfer_A2_FT1_under1;
display level_reuse_A2_FT1_under1;
display level_transfer_A2_FT1_under2;
display level_reuse_A2_FT1_under2;
display level_transfer_tmp_FT1_under0;
display level_reuse_tmp_FT1_under0;
display level_transfer_tmp_FT1_under1;
display level_reuse_tmp_FT1_under1;
display level_transfer_tmp_FT1_under2;
display level_reuse_tmp_FT1_under2;
display level_transfer_B3_FT1_under0;
display level_reuse_B3_FT1_under0;
display level_transfer_B3_FT1_under1;
display level_reuse_B3_FT1_under1;
display level_transfer_B3_FT1_under2;
display level_reuse_B3_FT1_under2;
display level_transfer_A3_FT1_under0;
display level_reuse_A3_FT1_under0;
display level_transfer_A3_FT1_under1;
display level_reuse_A3_FT1_under1;
display level_transfer_A3_FT1_under2;
display level_reuse_A3_FT1_under2;
display Lat_comp_fused_S2_S3_3;
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
display TC6_0;
display TC6_1;
display TC7_0;
display TC7_1;
display TC8_0;
display TC8_1;
display TC9_0;
display TC9_1;
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
display A1_is_fully_transfered_on_last_dim_FT0;
display burst_A1_is_1;
display cte_5;
display cte_burst_without_tiling_TC4_for_A1;
display is_tc4_burst_witout_tiling_for_A1;
display burst_A1_is_2;
display cte_6;
display burst_A1_is_4;
display cte_7;
display burst_A1_is_8;
display cte_8;
display burst_A1_is_16;
display cte_9;
display A3_is_fully_transfered_on_last_dim_FT1;
display burst_A3_is_1;
display cte_10;
display cte_burst_without_tiling_TC7_for_A3;
display is_tc7_burst_witout_tiling_for_A3;
display burst_A3_is_2;
display cte_11;
display burst_A3_is_4;
display cte_12;
display burst_A3_is_8;
display cte_13;
display burst_A3_is_16;
display cte_14;
display A2_is_fully_transfered_on_last_dim_FT1;
display burst_A2_is_1;
display cte_15;
display cte_burst_without_tiling_TC5_for_A2;
display is_tc5_burst_witout_tiling_for_A2;
display burst_A2_is_2;
display cte_16;
display burst_A2_is_4;
display cte_17;
display burst_A2_is_8;
display cte_18;
display burst_A2_is_16;
display cte_19;
display tmp_is_fully_transfered_on_last_dim_FT0;
display tmp_is_fully_transfered_on_last_dim_FT1;
display burst_tmp_is_1;
display cte_20;
display cte_burst_without_tiling_TC1_for_tmp;
display is_tc1_burst_witout_tiling_for_tmp;
display cte_21;
display cte_burst_without_tiling_TC3_for_tmp;
display is_tc3_burst_witout_tiling_for_tmp;
display cte_22;
display cte_23;
display cte_burst_without_tiling_TC6_for_tmp;
display is_tc6_burst_witout_tiling_for_tmp;
display burst_tmp_is_2;
display cte_24;
display cte_25;
display cte_26;
display cte_27;
display burst_tmp_is_4;
display cte_28;
display cte_29;
display cte_30;
display cte_31;
display burst_tmp_is_8;
display cte_32;
display cte_33;
display cte_34;
display cte_35;
display burst_tmp_is_16;
display cte_36;
display cte_37;
display cte_38;
display cte_39;
display B3_is_fully_transfered_on_last_dim_FT1;
display burst_B3_is_1;
display cte_40;
display cte_burst_without_tiling_TC9_for_B3;
display is_tc9_burst_witout_tiling_for_B3;
display burst_B3_is_2;
display cte_41;
display burst_B3_is_4;
display cte_42;
display burst_B3_is_8;
display cte_43;
display burst_B3_is_16;
display cte_44;
display C_is_fully_transfered_on_last_dim_FT1;
display burst_C_is_1;
display cte_45;
display cte_burst_without_tiling_TC6_for_C;
display is_tc6_burst_witout_tiling_for_C;
display cte_46;
display cte_47;
display cte_burst_without_tiling_TC9_for_C;
display is_tc9_burst_witout_tiling_for_C;
display cte_48;
display burst_C_is_2;
display cte_49;
display cte_50;
display cte_51;
display cte_52;
display burst_C_is_4;
display cte_53;
display cte_54;
display cte_55;
display cte_56;
display burst_C_is_8;
display cte_57;
display cte_58;
display cte_59;
display cte_60;
display burst_C_is_16;
display cte_61;
display cte_62;
display cte_63;
display cte_64;
display B2_is_fully_transfered_on_last_dim_FT1;
display burst_B2_is_1;
display cte_65;
display cte_burst_without_tiling_TC6_for_B2;
display is_tc6_burst_witout_tiling_for_B2;
display burst_B2_is_2;
display cte_66;
display burst_B2_is_4;
display cte_67;
display burst_B2_is_8;
display cte_68;
display burst_B2_is_16;
display cte_69;
display footprint_tot_B1_FT0;
display burst_B1;
display footprint_tot_A1_FT0;
display burst_A1;
display footprint_tot_A3_FT1;
display burst_A3;
display footprint_tot_A2_FT1;
display burst_A2;
display footprint_tot_tmp_FT0;
display burst_tmp;
display footprint_tot_tmp_FT1;
display footprint_tot_B3_FT1;
display burst_B3;
display footprint_tot_C_FT1;
display burst_C;
display footprint_tot_B2_FT1;
display burst_B2;
display Lat_comp_0_1_2_3;
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
