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

void load_vA2_for_task2(hls::stream<float4> &fifo_A2_from_off_chip_to_S2,
                        float4 vA2[50]);
void load_vA2_for_task2(
    hls::stream<ap_axiu<128, 0, 0, 0>> &fifo_A2_from_off_chip_to_S2,
    float4 vA2[50]);
void load_vB2_for_task2(hls::stream<float16> &fifo_B2_from_off_chip_to_S2,
                        float16 vB2[3000]);
void load_vB2_for_task2(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B2_from_off_chip_to_S2,
    float16 vB2[3000]);
void load_vC_for_task2(hls::stream<float16> &fifo_C_from_off_chip_to_S2,
                       float16 vC[3000]);
void load_vC_for_task2(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S2,
    float16 vC[3000]);
void load_vA3_for_task3(hls::stream<float16> &fifo_A3_from_off_chip_to_S3,
                        float16 vA3[2600]);
void load_vA3_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A3_from_off_chip_to_S3,
    float16 vA3[2600]);
void load_vB3_for_task3(hls::stream<float16> &fifo_B3_from_off_chip_to_S3,
                        float16 vB3[3000]);
void load_vB3_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B3_from_off_chip_to_S3,
    float16 vB3[3000]);
void load_vA1_for_task1(hls::stream<float16> &fifo_A1_from_off_chip_to_S1,
                        float16 vA1[2600]);
void load_vA1_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A1_from_off_chip_to_S1,
    float16 vA1[2600]);
void load_vB1_for_task1(hls::stream<float16> &fifo_B1_from_off_chip_to_S1,
                        float16 vB1[3120]);
void load_vB1_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B1_from_off_chip_to_S1,
    float16 vB1[3120]);
void store_vC_for_task2(hls::stream<float16> &fifo_C_to_off_chip,
                        float16 vC[3000]);
void store_vC_for_task2(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_to_off_chip,
                        float16 vC[3000]);
void store_vtmp_for_task1(hls::stream<float16> &fifo_tmp_to_off_chip,
                          float16 vtmp[3000]);
void store_vtmp_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_to_off_chip,
    float16 vtmp[3000]);
void FT0_level0(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                hls::stream<float16> &fifo_A1_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B1_from_off_chip_to_S1,
                hls::stream<float16> &fifo_tmp_to_off_chip);
void compute_FT0_level1(float alpha, float beta,
                        hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                        hls::stream<float16> &fifo_A1_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_B1_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_tmp_to_off_chip,
                        float B1[208][16], float A1[200][208], int j0, int i0,
                        float tmp_0[20][16], float tmp_1[20][16]);
void FT0_level1(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                hls::stream<float16> &fifo_A1_from_off_chip_to_S1,
                hls::stream<float16> &fifo_B1_from_off_chip_to_S1,
                hls::stream<float16> &fifo_tmp_to_off_chip, float B1[208][16],
                float A1[200][208], int j0);
void FT1_level0(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                hls::stream<float4> &fifo_A2_from_off_chip_to_S2,
                hls::stream<float16> &fifo_B2_from_off_chip_to_S2,
                hls::stream<float16> &fifo_C_from_off_chip_to_S2,
                hls::stream<float16> &fifo_A3_from_off_chip_to_S3,
                hls::stream<float16> &fifo_B3_from_off_chip_to_S3,
                hls::stream<float16> &fifo_C_to_off_chip);
void compute_FT1_level1(float alpha, float beta,
                        hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                        hls::stream<float4> &fifo_A2_from_off_chip_to_S2,
                        hls::stream<float16> &fifo_B2_from_off_chip_to_S2,
                        hls::stream<float16> &fifo_C_from_off_chip_to_S2,
                        hls::stream<float16> &fifo_A3_from_off_chip_to_S3,
                        hls::stream<float16> &fifo_B3_from_off_chip_to_S3,
                        hls::stream<float16> &fifo_C_to_off_chip,
                        float B3[200][16], float A3[200][200], int j0, int i0,
                        float C_0[20][16], float C_1[20][16], float C_2[20][16],
                        float B2_0[20][16], float B2_1[20][16],
                        float B2_2[20][16], float tmp_0[20][16],
                        float tmp_1[20][16], float tmp_2[20][16],
                        float A2_0[200], float A2_1[200], float A2_2[200]);
void FT1_level1(float alpha, float beta,
                hls::stream<float16> &fifo_tmp_from_task1_to_task2,
                hls::stream<float4> &fifo_A2_from_off_chip_to_S2,
                hls::stream<float16> &fifo_B2_from_off_chip_to_S2,
                hls::stream<float16> &fifo_C_from_off_chip_to_S2,
                hls::stream<float16> &fifo_A3_from_off_chip_to_S3,
                hls::stream<float16> &fifo_B3_from_off_chip_to_S3,
                hls::stream<float16> &fifo_C_to_off_chip, float B3[200][16],
                float A2_0[200], float A2_1[200], float A2_2[200],
                float A3[200][200], int j0);
void task0_intra(float alpha, float beta, float B1[208][16], float A1[200][208],
                 int j0, float tmp[20][16], int i0);
void task1_intra(float alpha, float beta, float B1[208][16], float A1[200][208],
                 int j0, float tmp[20][16], int i0);
void task2_intra(float alpha, float beta, float B3[200][16], float A2[200],
                 float A3[200][200], int j0, float C[20][16], float B2[20][16],
                 float tmp[20][16], int i0);
void task3_intra(float alpha, float beta, float B3[200][16], float A2[200],
                 float A3[200][200], int j0, float C[20][16], float B2[20][16],
                 float tmp[20][16], int i0);
void read_A1_FT0(float A1[200][208],
                 hls::stream<float16> &fifo_A1_from_off_chip_to_S1);
void read_A1_FT0(
    float A1[200][208],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A1_from_off_chip_to_S1);
void read_B1_FT0(float B1[208][16],
                 hls::stream<float16> &fifo_B1_from_off_chip_to_S1, int j0);
void read_B1_FT0(
    float B1[208][16],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B1_from_off_chip_to_S1, int j0);
void read_A3_FT1(float A3[200][200],
                 hls::stream<float16> &fifo_A3_from_off_chip_to_S3);
void read_A3_FT1(
    float A3[200][200],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A3_from_off_chip_to_S3);
void read_B3_FT1(float B3[200][16],
                 hls::stream<float16> &fifo_B3_from_off_chip_to_S3, int j0);
void read_B3_FT1(
    float B3[200][16],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B3_from_off_chip_to_S3, int j0);
void read_C_FT1(float C[20][16],
                hls::stream<float16> &fifo_C_from_off_chip_to_S2, int i0,
                int j0);
void read_C_FT1(float C[20][16],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_from_off_chip_to_S2,
                int i0, int j0);
void read_B2_FT1(float B2[20][16],
                 hls::stream<float16> &fifo_B2_from_off_chip_to_S2, int i0,
                 int j0);
void read_B2_FT1(
    float B2[20][16],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_B2_from_off_chip_to_S2, int i0,
    int j0);
void read_A2_FT1(float A2[200],
                 hls::stream<float4> &fifo_A2_from_off_chip_to_S2, int i0,
                 int j0);
void read_A2_FT1(
    float A2[200],
    hls::stream<ap_axiu<128, 0, 0, 0>> &fifo_A2_from_off_chip_to_S2, int i0,
    int j0);
void read_tmp_FT1(float tmp[20][16],
                  hls::stream<float16> &fifo_tmp_from_task1_to_task2, int i0,
                  int j0);
void read_tmp_FT1(
    float tmp[20][16],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task2, int i0,
    int j0);
void write_tmp_FT0(float tmp[20][16],
                   hls::stream<float16> &fifo_tmp_from_task1_to_task2, int i0,
                   int j0);
void write_tmp_FT0(
    float tmp[20][16],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task2, int i0,
    int j0);
void write_C_FT1(float C[20][16], hls::stream<float16> &fifo_C_to_off_chip,
                 int i0, int j0);
void write_C_FT1(float C[20][16],
                 hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_C_to_off_chip, int i0,
                 int j0);
void kernel_nlp_slr0(float alpha, float beta, float16 vtmp_for_task1[3000],
                     float16 vB1_for_task1[3120], float16 vA1_for_task1[2600],
                     float16 vC_for_task2[3000], float16 vB2_for_task2[3000],
                     float4 vA2_for_task2[50], float16 vB3_for_task3[3000],
                     float16 vA3_for_task3[2600]);
#endif // PROMETHEUS_H
