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

void load_vC_for_task3(hls::stream<float16> &fifo_C_from_off_chip_to_S3,
                       float16 vC[2688]);
void load_vC_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S3,
    float16 vC[2688]);
void load_vD_for_task2(hls::stream<float16> &fifo_D_from_off_chip_to_S2,
                       float16 vD[2520]);
void load_vD_for_task2(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_D_from_off_chip_to_S2,
    float16 vD[2520]);
void load_vA_for_task1(hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                       float16 vA[2520]);
void load_vA_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    float16 vA[2520]);
void load_vB_for_task1(hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                       float16 vB[2544]);
void load_vB_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B_from_off_chip_to_S1,
    float16 vB[2544]);
void store_vtmp_for_task1(hls::stream<float16> &fifo_tmp_to_off_chip,
                          float16 vtmp[2160]);
void store_vtmp_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_to_off_chip,
    float16 vtmp[2160]);
void store_vD_for_task2(hls::stream<float16> &fifo_D_to_off_chip,
                        float16 vD[2520]);
void store_vD_for_task2(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_D_to_off_chip,
                        float16 vD[2520]);
void FT0_level0(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                hls::stream<float16> &fifo_tmp_to_off_chip);
void compute_FT0_level1(float alpha, float beta,
                        hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                        hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_tmp_to_off_chip,
                        float A[4][212], float B[212][192], int i0, int j0,
                        float tmp_0[4][32], float tmp_1[4][32]);
void FT0_level1(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B_from_off_chip_to_S1,
                hls::stream<float16> &fifo_tmp_to_off_chip, float A[4][212],
                float B[212][192], int i0);
void FT1_level0(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_C_from_off_chip_to_S3,
                hls::stream<float16> &fifo_D_from_off_chip_to_S2,
                hls::stream<float16> &fifo_D_to_off_chip);
void compute_FT1_level1(float alpha, float beta,
                        hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                        hls::stream<float16> &fifo_C_from_off_chip_to_S3,
                        hls::stream<float16> &fifo_D_from_off_chip_to_S2,
                        hls::stream<float16> &fifo_D_to_off_chip,
                        float C[192][32], int j0, int i0, float D_0[4][32],
                        float D_1[4][32], float D_2[4][32],
                        float tmp_0[180][192], float tmp_1[180][192],
                        float tmp_2[180][192]);
void FT1_level1(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_C_from_off_chip_to_S3,
                hls::stream<float16> &fifo_D_from_off_chip_to_S2,
                hls::stream<float16> &fifo_D_to_off_chip, float C[192][32],
                float tmp_0[180][192], float tmp_1[180][192],
                float tmp_2[180][192], int j0);
void task0_intra(float alpha, float beta, float A[4][212], float B[212][192],
                 int i0, float tmp[4][32], int j0);
void task1_intra(float alpha, float beta, float A[4][212], float B[212][192],
                 int i0, float tmp[4][32], int j0);
void task2_intra(float alpha, float beta, float C[192][32], float tmp[180][192],
                 int j0, float D[4][32], int i0);
void task3_intra(float alpha, float beta, float C[192][32], float tmp[180][192],
                 int j0, float D[4][32], int i0);
void read_B_FT0(float B[212][192],
                hls::stream<float16> &fifo_B_from_off_chip_to_S1);
void read_B_FT0(float B[212][192],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B_from_off_chip_to_S1);
void read_A_FT0(float A[4][212],
                hls::stream<float16> &fifo_A_from_off_chip_to_S1, int i0);
void read_A_FT0(float A[4][212],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
                int i0);
void read_C_FT1(float C[192][32],
                hls::stream<float16> &fifo_C_from_off_chip_to_S3, int j0);
void read_C_FT1(float C[192][32],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S3,
                int j0);
void read_D_FT1(float D[4][32],
                hls::stream<float16> &fifo_D_from_off_chip_to_S2, int i0,
                int j0);
void read_D_FT1(float D[4][32],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_D_from_off_chip_to_S2,
                int i0, int j0);
void read_tmp_FT1(float tmp[180][192],
                  hls::stream<float16> &fifo_tmp_from_task1_to_task3, int i0,
                  int j0);
void read_tmp_FT1(
    float tmp[180][192],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task3, int i0,
    int j0);
void write_tmp_FT0(float tmp[4][32],
                   hls::stream<float16> &fifo_tmp_from_task1_to_task3, int j0,
                   int i0);
void write_tmp_FT0(
    float tmp[4][32],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task3, int j0,
    int i0);
void write_D_FT1(float D[4][32], hls::stream<float16> &fifo_D_to_off_chip,
                 int i0, int j0);
void write_D_FT1(float D[4][32],
                 hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_D_to_off_chip, int i0,
                 int j0);
void kernel_nlp_slr0(float alpha, float beta, float16 vtmp_for_task1[2160],
                     float16 vA_for_task1[2520], float16 vB_for_task1[2544],
                     float16 vD_for_task2[2520], float16 vC_for_task3[2688]);
#endif // PROMETHEUS_H
