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


void load_vB_for_task3(hls::stream<float16>& fifo_B_from_off_chip_to_S3, float16 vB[4000]);
void load_vr_for_task3(hls::stream<float16>& fifo_r_from_off_chip_to_S3, float16 vr[16]);
void load_vw_for_task1(hls::stream<float16>& fifo_w_from_off_chip_to_S1, float16 vw[16]);
void load_vA_for_task1(hls::stream<float16>& fifo_A_from_off_chip_to_S1, float16 vA[4000]);
void store_vtmp_for_task1(hls::stream<float1>& fifo_tmp_to_off_chip, float1 vtmp[250]);
void store_vy_for_task3(hls::stream<float1>& fifo_y_to_off_chip, float1 vy[250]);
void FT0_level0(float alpha, float beta, hls::stream<float1>& fifo_tmp_from_task1_to_task4, hls::stream<float16>& fifo_w_from_off_chip_to_S1, hls::stream<float16>& fifo_A_from_off_chip_to_S1, hls::stream<float1>& fifo_tmp_to_off_chip);
void FT1_level0(float alpha, float beta, hls::stream<float1>& fifo_tmp_from_task1_to_task4, hls::stream<float16>& fifo_B_from_off_chip_to_S3, hls::stream<float16>& fifo_r_from_off_chip_to_S3, hls::stream<float1>& fifo_y_to_off_chip);
void task0_intra(float alpha, float beta, float tmp[5], float A[5][255], float w[255], int i0);
void task1_intra(float alpha, float beta, float tmp[5], float A[5][255], float w[255], int i0);
void task2_intra(float alpha, float beta, float y[5], float B[5][256], float tmp[5], float r[256], int i0);
void task3_intra(float alpha, float beta, float y[5], float B[5][256], float tmp[5], float r[256], int i0);
void task4_intra(float alpha, float beta, float y[5], float B[5][256], float tmp[5], float r[256], int i0);
void read_w_FT0(float w[255], hls::stream<float16>& fifo_w_from_off_chip_to_S1);
void read_A_FT0(float A[5][255], hls::stream<float16>& fifo_A_from_off_chip_to_S1, int i0);
void read_r_FT1(float r[256], hls::stream<float16>& fifo_r_from_off_chip_to_S3);
void read_B_FT1(float B[5][256], hls::stream<float16>& fifo_B_from_off_chip_to_S3, int i0);
void read_tmp_FT1(float tmp[5], hls::stream<float1>& fifo_tmp_from_task1_to_task4, int i0);
void write_tmp_FT0(float tmp[5], hls::stream<float1>& fifo_tmp_from_task1_to_task4, int i0);
void write_y_FT1(float y[5], hls::stream<float1>& fifo_y_to_off_chip, int i0);
void kernel_nlp(float alpha, float beta, float1 vtmp_for_task1[250], float16 vA_for_task1[4000], float16 vw_for_task1[16], float1 vy_for_task3[250], float16 vB_for_task3[4000], float16 vr_for_task3[16]);

#endif // PROMETHEUS_H
