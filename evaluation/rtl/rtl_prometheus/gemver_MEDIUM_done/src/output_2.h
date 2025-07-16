#ifndef PROMETHEUS_H
#define PROMETHEUS_H

#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>
#include <algorithm>
#include <iostream>
#include <ap_axi_sdata.h>


typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;


void load_vy_for_task1(hls::stream<float16>& fifo_y_from_off_chip_to_S1, float16 vy[25]);
void load_vx_for_task1(hls::stream<float16>& fifo_x_from_off_chip_to_S1, float16 vx[25]);
void load_vw_for_task3(hls::stream<float8>& fifo_w_from_off_chip_to_S3, float8 vw[50]);
void load_ve2_for_task0(hls::stream<float16>& fifo_e2_from_off_chip_to_S0, float16 ve2[25]);
void load_vA_for_task0(hls::stream<float16>& fifo_A_from_off_chip_to_S0, float16 vA[10000]);
void load_ve1_for_task0(hls::stream<float16>& fifo_e1_from_off_chip_to_S0, float16 ve1[25]);
void load_vu2_for_task0(hls::stream<float16>& fifo_u2_from_off_chip_to_S0, float16 vu2[25]);
void load_vu1_for_task0(hls::stream<float16>& fifo_u1_from_off_chip_to_S0, float16 vu1[25]);
void load_vz_for_task2(hls::stream<float16>& fifo_z_from_off_chip_to_S2, float16 vz[25]);
void store_vx_for_task1(hls::stream<float16>& fifo_x_to_off_chip, float16 vx[25]);
void store_vA_for_task0(hls::stream<float16>& fifo_A_to_off_chip, float16 vA[10000]);
void store_vw_for_task3(hls::stream<float8>& fifo_w_to_off_chip, float8 vw[50]);
void FT0_level0(float alpha, float beta, hls::stream<float16>& fifo_A_from_task0_to_task1, hls::stream<float16>& fifo_A_from_task0_to_task3, hls::stream<float16>& fifo_e2_from_off_chip_to_S0, hls::stream<float16>& fifo_A_from_off_chip_to_S0, hls::stream<float16>& fifo_e1_from_off_chip_to_S0, hls::stream<float16>& fifo_u2_from_off_chip_to_S0, hls::stream<float16>& fifo_u1_from_off_chip_to_S0, hls::stream<float16>& fifo_A_to_off_chip);
void FT0_level1(float alpha, float beta, hls::stream<float16>& fifo_A_from_task0_to_task1, hls::stream<float16>& fifo_A_from_task0_to_task3, hls::stream<float16>& fifo_e2_from_off_chip_to_S0, hls::stream<float16>& fifo_A_from_off_chip_to_S0, hls::stream<float16>& fifo_e1_from_off_chip_to_S0, hls::stream<float16>& fifo_u2_from_off_chip_to_S0, hls::stream<float16>& fifo_u1_from_off_chip_to_S0, hls::stream<float16>& fifo_A_to_off_chip, float e1[16], float u1[400], float u2[400], float e2[400], int j0);
void FT1_level0(float alpha, float beta, hls::stream<float16>& fifo_A_from_task0_to_task1, hls::stream<float16>& fifo_y_from_off_chip_to_S1, hls::stream<float16>& fifo_x_from_off_chip_to_S1, hls::stream<float16>& fifo_x_from_task2_to_task3, hls::stream<float16>& fifo_z_from_off_chip_to_S2, hls::stream<float16>& fifo_x_to_off_chip);
void FT2_level0(float alpha, float beta, hls::stream<float16>& fifo_A_from_task0_to_task3, hls::stream<float16>& fifo_x_from_task2_to_task3, hls::stream<float8>& fifo_w_from_off_chip_to_S3, hls::stream<float8>& fifo_w_to_off_chip);
void task0_intra(float alpha, float beta, float e1[16], float u1[400], float u2[400], float e2[400], int j0, float A[40][16], int i0);
void task1_intra(float alpha, float beta, float x[16], float A[400][16], float y[400], float z[400], int i0);
void task2_intra(float alpha, float beta, float x[16], float A[400][16], float y[400], float z[400], int i0);
void task3_intra(float alpha, float beta, float w[40], float A[400][400], float x[400], int i0);
void read_u1_FT0(float u1[400], hls::stream<float16>& fifo_u1_from_off_chip_to_S0);
void read_u2_FT0(float u2[400], hls::stream<float16>& fifo_u2_from_off_chip_to_S0);
void read_e2_FT0(float e2[400], hls::stream<float16>& fifo_e2_from_off_chip_to_S0);
void read_e1_FT0(float e1[16], hls::stream<float16>& fifo_e1_from_off_chip_to_S0, int j0);
void read_A_FT0(float A[40][16], hls::stream<float16>& fifo_A_from_off_chip_to_S0, int i0, int j0);
void read_y_FT1(float y[400], hls::stream<float16>& fifo_y_from_off_chip_to_S1);
void read_z_FT1(float z[400], hls::stream<float16>& fifo_z_from_off_chip_to_S2);
void read_x_FT1(float x[16], hls::stream<float16>& fifo_x_from_off_chip_to_S1, int i0);
void read_A_FT1(float A[400][16], hls::stream<float16>& fifo_A_from_task0_to_task1, int i0);
void read_A_FT2(float A[400][400], hls::stream<float16>& fifo_A_from_task0_to_task3);
void read_x_FT2(float x[400], hls::stream<float16>& fifo_x_from_task2_to_task3);
void read_w_FT2(float w[40], hls::stream<float8>& fifo_w_from_off_chip_to_S3, int i0);
void write_A_FT0(float A[40][16], hls::stream<float16>& fifo_A_from_task0_to_task1, int i0, int j0);
void write_x_FT1(float x[16], hls::stream<float16>& fifo_x_from_task2_to_task3, int i0);
void write_w_FT2(float w[40], hls::stream<float8>& fifo_w_to_off_chip, int i0);
void kernel_nlp(float alpha, float beta, float16 vA_for_task0[10000], float16 vu1_for_task0[25], float16 ve1_for_task0[25], float16 vu2_for_task0[25], float16 ve2_for_task0[25], float16 vx_for_task1[25], float16 vy_for_task1[25], float16 vz_for_task2[25], float8 vw_for_task3[50]);

#endif // PROMETHEUS_H
