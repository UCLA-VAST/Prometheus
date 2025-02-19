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

void load_vA_for_task3(hls::stream<float16> &fifo_A_from_off_chip_to_S3,
                       float16 vA[10400]);
void load_vA_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
    float16 vA[10400]);
void load_vA_for_task1(hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                       float16 vA[10400]);
void load_vA_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    float16 vA[10400]);
void load_vx_for_task1(hls::stream<float16> &fifo_x_from_off_chip_to_S1,
                       float16 vx[26]);
void load_vx_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_x_from_off_chip_to_S1,
    float16 vx[26]);
void store_vtmp_for_task1(hls::stream<float16> &fifo_tmp_to_off_chip,
                          float16 vtmp[25]);
void store_vtmp_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_to_off_chip, float16 vtmp[25]);
void store_vy_for_task3(hls::stream<float16> &fifo_y_to_off_chip,
                        float16 vy[26]);
void store_vy_for_task3(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_y_to_off_chip,
                        float16 vy[26]);
void compute_FT0_level0(hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                        hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_x_from_off_chip_to_S1,
                        hls::stream<float16> &fifo_tmp_to_off_chip, int i0,
                        float tmp_0[400], float tmp_1[400], float A[400][416],
                        float x[416]);
void FT0_level0(hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                hls::stream<float16> &fifo_x_from_off_chip_to_S1,
                hls::stream<float16> &fifo_tmp_to_off_chip);
void compute_FT1_level0(hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                        hls::stream<float16> &fifo_A_from_off_chip_to_S3,
                        hls::stream<float16> &fifo_y_to_off_chip, int j0,
                        float y_0[16], float y_1[16], float A_0[400][16],
                        float A_1[400][16], float tmp[400]);
void FT1_level0(hls::stream<float16> &fifo_tmp_from_task1_to_task3,
                hls::stream<float16> &fifo_A_from_off_chip_to_S3,
                hls::stream<float16> &fifo_y_to_off_chip);
void task0_intra(float tmp[400], float A[400][416], float x[416], int i0);
void task1_intra(float tmp[400], float A[400][416], float x[416], int i0);
void task2_intra(float y[16], float A[400][16], float tmp[400], int j0);
void task3_intra(float y[16], float A[400][16], float tmp[400], int j0);
void read_A_FT0(float A[400][416],
                hls::stream<float16> &fifo_A_from_off_chip_to_S1);
void read_A_FT0(float A[400][416],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1);
void read_x_FT0(float x[416], hls::stream<float16> &fifo_x_from_off_chip_to_S1);
void read_x_FT0(float x[416],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_x_from_off_chip_to_S1);
void read_tmp_FT1(float tmp[400],
                  hls::stream<float16> &fifo_tmp_from_task1_to_task3);
void read_tmp_FT1(
    float tmp[400],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task3);
void read_A_FT1(float A[400][16],
                hls::stream<float16> &fifo_A_from_off_chip_to_S3, int j0);
void read_A_FT1(float A[400][16],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
                int j0);
void write_tmp_FT0(float tmp[400],
                   hls::stream<float16> &fifo_tmp_from_task1_to_task3, int i0);
void write_tmp_FT0(
    float tmp[400],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_tmp_from_task1_to_task3, int i0);
void write_y_FT1(float y[16], hls::stream<float16> &fifo_y_to_off_chip, int j0);
void write_y_FT1(float y[16],
                 hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_y_to_off_chip,
                 int j0);
void kernel_nlp_slr0(float16 vtmp_for_task1[25], float16 vA_for_task1[10400],
                     float16 vA_for_task3[10400], float16 vx_for_task1[26],
                     float16 vy_for_task3[26]);
void kernel_nlp_slr1();
void kernel_nlp_slr2();
#endif // PROMETHEUS_H
