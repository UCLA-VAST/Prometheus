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


void load_vB1_for_task1(hls::stream<float16>& fifo_B1_from_off_chip_to_S1, float16 vB1[3120]);
void load_vA1_for_task1(hls::stream<float16>& fifo_A1_from_off_chip_to_S1, float16 vA1[3120]);
void load_vA2_for_task1(hls::stream<float16>& fifo_A2_from_off_chip_to_S1, float16 vA2[3120]);
void load_vB2_for_task1(hls::stream<float16>& fifo_B2_from_off_chip_to_S1, float16 vB2[3120]);
void load_vC_for_task0(hls::stream<float4>& fifo_C_from_off_chip_to_S0, float4 vC[14400]);
void store_vC_for_task0(hls::stream<float4>& fifo_C_to_off_chip, float4 vC[14400]);
void FT0_level0(float alpha, float beta, hls::stream<float16>& fifo_B1_from_off_chip_to_S1, hls::stream<float16>& fifo_A1_from_off_chip_to_S1, hls::stream<float16>& fifo_A2_from_off_chip_to_S1, hls::stream<float16>& fifo_B2_from_off_chip_to_S1, hls::stream<float4>& fifo_C_from_off_chip_to_S0, hls::stream<float4>& fifo_C_to_off_chip);
void FT0_level1(float alpha, float beta, hls::stream<float16>& fifo_B1_from_off_chip_to_S1, hls::stream<float16>& fifo_A1_from_off_chip_to_S1, hls::stream<float16>& fifo_A2_from_off_chip_to_S1, hls::stream<float16>& fifo_B2_from_off_chip_to_S1, hls::stream<float4>& fifo_C_from_off_chip_to_S0, hls::stream<float4>& fifo_C_to_off_chip, float B1[40][208], float A2[40][208], float A1_0[240][208], float A1_1[240][208], float A1_2[240][208], float B2_0[240][208], float B2_1[240][208], float B2_2[240][208], int i0);
void task0_intra(float alpha, float beta, float B1[40][208], float A2[40][208], float A1[240][208], float B2[240][208], int i0, float C[40][12], int j0);
void task1_intra(float alpha, float beta, float B1[40][208], float A2[40][208], float A1[240][208], float B2[240][208], int i0, float C[40][12], int j0);
void read_B1_FT0(float B1[40][208], hls::stream<float16>& fifo_B1_from_off_chip_to_S1, int i0);
void read_A2_FT0(float A2[40][208], hls::stream<float16>& fifo_A2_from_off_chip_to_S1, int i0);
void read_C_FT0(float C[40][12], hls::stream<float4>& fifo_C_from_off_chip_to_S0, int j0, int i0);
void read_A1_FT0(float A1[240][208], hls::stream<float16>& fifo_A1_from_off_chip_to_S1, int j0, int i0);
void read_B2_FT0(float B2[240][208], hls::stream<float16>& fifo_B2_from_off_chip_to_S1, int j0, int i0);
void write_C_FT0(float C[40][12], hls::stream<float4>& fifo_C_to_off_chip, int j0, int i0);
void kernel_nlp(float alpha, float beta, float4 vC_for_task0[14400], float16 vA1_for_task1[3120], float16 vB1_for_task1[3120], float16 vB2_for_task1[3120], float16 vA2_for_task1[3120]);

#endif // PROMETHEUS_H
