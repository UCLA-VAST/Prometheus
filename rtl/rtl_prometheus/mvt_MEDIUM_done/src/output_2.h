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


void load_vA1_for_task0(hls::stream<float16>& fifo_A1_from_off_chip_to_S0, float16 vA1[10000]);
void load_vB_for_task0(hls::stream<float16>& fifo_B_from_off_chip_to_S0, float16 vB[25]);
void load_vx1_for_task0(hls::stream<float4>& fifo_x1_from_off_chip_to_S0, float4 vx1[100]);
void load_vC_for_task1(hls::stream<float16>& fifo_C_from_off_chip_to_S1, float16 vC[25]);
void load_vx2_for_task1(hls::stream<float16>& fifo_x2_from_off_chip_to_S1, float16 vx2[25]);
void load_vA2_for_task1(hls::stream<float16>& fifo_A2_from_off_chip_to_S1, float16 vA2[10000]);
void store_vx2_for_task1(hls::stream<float16>& fifo_x2_to_off_chip, float16 vx2[25]);
void store_vx1_for_task0(hls::stream<float4>& fifo_x1_to_off_chip, float4 vx1[100]);
void FT0_level0(hls::stream<float16>& fifo_A1_from_off_chip_to_S0, hls::stream<float16>& fifo_B_from_off_chip_to_S0, hls::stream<float4>& fifo_x1_from_off_chip_to_S0, hls::stream<float4>& fifo_x1_to_off_chip);
void FT1_level0(hls::stream<float16>& fifo_C_from_off_chip_to_S1, hls::stream<float16>& fifo_x2_from_off_chip_to_S1, hls::stream<float16>& fifo_A2_from_off_chip_to_S1, hls::stream<float16>& fifo_x2_to_off_chip);
void task0_intra(float x1[4], float A1[4][400], float B[400], int i0);
void task1_intra(float x2[16], float A2[400][16], float C[400], int i0);
void read_B_FT0(float B[400], hls::stream<float16>& fifo_B_from_off_chip_to_S0);
void read_x1_FT0(float x1[4], hls::stream<float4>& fifo_x1_from_off_chip_to_S0, int i0);
void read_A1_FT0(float A1[4][400], hls::stream<float16>& fifo_A1_from_off_chip_to_S0, int i0);
void read_C_FT1(float C[400], hls::stream<float16>& fifo_C_from_off_chip_to_S1);
void read_x2_FT1(float x2[16], hls::stream<float16>& fifo_x2_from_off_chip_to_S1, int i0);
void read_A2_FT1(float A2[400][16], hls::stream<float16>& fifo_A2_from_off_chip_to_S1, int i0);
void write_x1_FT0(float x1[4], hls::stream<float4>& fifo_x1_to_off_chip, int i0);
void write_x2_FT1(float x2[16], hls::stream<float16>& fifo_x2_to_off_chip, int i0);
void kernel_nlp(float4 vx1_for_task0[100], float16 vA1_for_task0[10000], float16 vB_for_task0[25], float16 vx2_for_task1[25], float16 vA2_for_task1[10000], float16 vC_for_task1[25]);

#endif // PROMETHEUS_H
