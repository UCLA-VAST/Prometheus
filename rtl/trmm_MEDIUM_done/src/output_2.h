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


void load_vB_for_task0(hls::stream<float16>& fifo_B_from_off_chip_to_S0, float16 vB[3000]);
void load_vC_for_task0(hls::stream<float16>& fifo_C_from_off_chip_to_S0, float16 vC[3000]);
void load_vA_for_task0(hls::stream<float16>& fifo_A_from_off_chip_to_S0, float16 vA[2600]);
void store_vB_for_task0(hls::stream<float16>& fifo_B_to_off_chip, float16 vB[3000]);
void FT0_level0(float alpha, hls::stream<float16>& fifo_B_from_off_chip_to_S0, hls::stream<float16>& fifo_C_from_off_chip_to_S0, hls::stream<float16>& fifo_A_from_off_chip_to_S0, hls::stream<float16>& fifo_B_to_off_chip);
void FT0_level1(float alpha, hls::stream<float16>& fifo_B_from_off_chip_to_S0, hls::stream<float16>& fifo_C_from_off_chip_to_S0, hls::stream<float16>& fifo_A_from_off_chip_to_S0, hls::stream<float16>& fifo_B_to_off_chip, float C[200][16], float A[200][200], int j0);
void task0_intra(float alpha, float C[200][16], float A[200][200], int j0, float B[50][16], int i0);
void task1_intra(float alpha, float C[200][16], float A[200][200], int j0, float B[50][16], int i0);
void read_A_FT0(float A[200][200], hls::stream<float16>& fifo_A_from_off_chip_to_S0);
void read_C_FT0(float C[200][16], hls::stream<float16>& fifo_C_from_off_chip_to_S0, int j0);
void read_B_FT0(float B[50][16], hls::stream<float16>& fifo_B_from_off_chip_to_S0, int i0, int j0);
void write_B_FT0(float B[50][16], hls::stream<float16>& fifo_B_to_off_chip, int i0, int j0);
void kernel_nlp(float alpha, float16 vB_for_task0[3000], float16 vA_for_task0[2600], float16 vC_for_task0[3000]);

#endif // PROMETHEUS_H
