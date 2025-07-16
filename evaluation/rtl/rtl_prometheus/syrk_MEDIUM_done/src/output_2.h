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


void load_vA2_for_task1(hls::stream<float16>& fifo_A2_from_off_chip_to_S1, float16 vA2[3120]);
void load_vA1_for_task1(hls::stream<float16>& fifo_A1_from_off_chip_to_S1, float16 vA1[3120]);
void load_vC_for_task0(hls::stream<float8>& fifo_C_from_off_chip_to_S0, float8 vC[7200]);
void store_vC_for_task0(hls::stream<float8>& fifo_C_to_off_chip, float8 vC[7200]);
void FT0_level0(float alpha, float beta, hls::stream<float16>& fifo_A2_from_off_chip_to_S1, hls::stream<float16>& fifo_A1_from_off_chip_to_S1, hls::stream<float8>& fifo_C_from_off_chip_to_S0, hls::stream<float8>& fifo_C_to_off_chip);
void FT0_level1(float alpha, float beta, hls::stream<float16>& fifo_A2_from_off_chip_to_S1, hls::stream<float16>& fifo_A1_from_off_chip_to_S1, hls::stream<float8>& fifo_C_from_off_chip_to_S0, hls::stream<float8>& fifo_C_to_off_chip, float A1[60][208], float A2_0[240][208], float A2_1[240][208], float A2_2[240][208], int i0);
void task0_intra(float alpha, float beta, float A1[60][208], float A2[240][208], int i0, float C[60][8], int j0);
void task1_intra(float alpha, float beta, float A1[60][208], float A2[240][208], int i0, float C[60][8], int j0);
void read_A1_FT0(float A1[60][208], hls::stream<float16>& fifo_A1_from_off_chip_to_S1, int i0);
void read_C_FT0(float C[60][8], hls::stream<float8>& fifo_C_from_off_chip_to_S0, int j0, int i0);
void read_A2_FT0(float A2[240][208], hls::stream<float16>& fifo_A2_from_off_chip_to_S1, int j0, int i0);
void write_C_FT0(float C[60][8], hls::stream<float8>& fifo_C_to_off_chip, int j0, int i0);
void kernel_nlp(float alpha, float beta, float8 vC_for_task0[7200], float16 vA1_for_task1[3120], float16 vA2_for_task1[3120]);

#endif // PROMETHEUS_H
