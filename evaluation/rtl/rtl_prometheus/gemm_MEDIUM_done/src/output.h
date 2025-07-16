#ifndef PROMETHEUS_H
#define PROMETHEUS_H

#include <algorithm>
#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <cstring>
#include <hls_stream.h>
#include <hls_vector.h>
#include <iostream>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

void load_vA_for_task1(hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                       float16 vA[3000]);
void load_vA_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    float16 vA[3000]);
void load_vB_for_task1(hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                       float16 vB[3360]);
void load_vB_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B_from_off_chip_to_S1,
    float16 vB[3360]);
void load_vC_for_task0(hls::stream<float16> &fifo_C_from_off_chip_to_S0,
                       float16 vC[2800]);
void load_vC_for_task0(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S0,
    float16 vC[2800]);
void store_vC_for_task0(hls::stream<float16> &fifo_C_to_off_chip,
                        float16 vC[2800]);
void store_vC_for_task0(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_to_off_chip,
                        float16 vC[2800]);
void FT0_level0(float alpha, float beta,
                hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                hls::stream<float16> &fifo_C_from_off_chip_to_S0,
                hls::stream<float16> &fifo_C_to_off_chip);
void compute_FT0_level1(float alpha, float beta,
                        hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_C_from_off_chip_to_S0,
                        hls::stream<float16> &fifo_C_to_off_chip,
                        float A[40][240], int i0, int j0, float C_0[40][16],
                        float C_1[40][16], float C_2[40][16],
                        float B_0[240][224], float B_1[240][224],
                        float B_2[240][224]);
void FT0_level1(float alpha, float beta,
                hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                hls::stream<float16> &fifo_C_from_off_chip_to_S0,
                hls::stream<float16> &fifo_C_to_off_chip, float A[40][240],
                float B_0[240][224], float B_1[240][224], float B_2[240][224],
                int i0);
void task0_intra(float alpha, float beta, float A[40][240], float B[240][224],
                 int i0, float C[40][16], int j0);
void task1_intra(float alpha, float beta, float A[40][240], float B[240][224],
                 int i0, float C[40][16], int j0);
void read_A_FT0(float A[40][240],
                hls::stream<float16> &fifo_A_from_off_chip_to_S1, int i0);
void read_A_FT0(float A[40][240],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
                int i0);
void read_C_FT0(float C[40][16],
                hls::stream<float16> &fifo_C_from_off_chip_to_S0, int j0,
                int i0);
void read_C_FT0(float C[40][16],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S0,
                int j0, int i0);
void read_B_FT0(float B[240][224],
                hls::stream<float16> &fifo_B_from_off_chip_to_S1, int j0,
                int i0);
void read_B_FT0(float B[240][224],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B_from_off_chip_to_S1,
                int j0, int i0);
void write_C_FT0(float C[40][16], hls::stream<float16> &fifo_C_to_off_chip,
                 int j0, int i0);
void write_C_FT0(float C[40][16],
                 hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_to_off_chip, int j0,
                 int i0);
void kernel_nlp_slr0(float alpha, float beta, float16 vC_for_task0[2800],
                     float16 vA_for_task1[3000], float16 vB_for_task1[3360]);
void kernel_nlp_slr1();
void kernel_nlp_slr2();
#endif // PROMETHEUS_H
