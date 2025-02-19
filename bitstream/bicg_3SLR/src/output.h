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

void load_vr_for_task1(hls::stream<float16> &fifo_r_from_off_chip_to_S1,
                       float16 vr[26]);
void load_vr_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1,
    float16 vr[26]);
void load_vA_for_task1(hls::stream<float16> &fifo_A_from_off_chip_to_S1,
                       float16 vA[10400]);
void load_vA_for_task1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    float16 vA[10400]);
void load_vA_for_task3(hls::stream<float16> &fifo_A_from_off_chip_to_S3,
                       float16 vA[10400]);
void load_vA_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
    float16 vA[10400]);
void load_vp_for_task3(hls::stream<float16> &fifo_p_from_off_chip_to_S3,
                       float16 vp[25]);
void load_vp_for_task3(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3,
    float16 vp[25]);
void store_vs_for_task1(hls::stream<float16> &fifo_s_to_off_chip,
                        float16 vs[25]);
void store_vs_for_task1(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip,
                        float16 vs[25]);
void store_vq_for_task3(hls::stream<float2> &fifo_q_to_off_chip,
                        float2 vq[205]);
void store_vq_for_task3(hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip,
                        float2 vq[205]);
void kernel_nlp_slr0(
    float16 vs_for_task1[25], float16 vr_for_task1[26],
    float16 vA_for_task1[10400], float16 vA_for_task3[10400],
    float2 vq_for_task3[205], float16 vp_for_task3[25],
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip,
    hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip);
void compute_FT1_level0(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3,
    hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip, int i0,
    float q_0[10], float q_1[10], float A_0[10][400], float A_1[10][400],
    float p[400]);
void FT1_level0(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3,
                hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip);
void task2_intra(float q[10], float A[10][400], float p[400], int i0);
void task3_intra(float q[10], float A[10][400], float p[400], int i0);
void read_p_FT1(float p[400], hls::stream<float16> &fifo_p_from_off_chip_to_S3);
void read_p_FT1(float p[400],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3);
void read_A_FT1(float A[10][400],
                hls::stream<float16> &fifo_A_from_off_chip_to_S3, int i0);
void read_A_FT1(float A[10][400],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
                int i0);
void write_q_FT1(float q[10], hls::stream<float2> &fifo_q_to_off_chip, int i0);
void write_q_FT1(float q[10],
                 hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip, int i0);
void kernel_nlp_slr1(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S3,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_p_from_off_chip_to_S3,
    hls::stream<ap_axiu<64, 0, 0, 0>> &fifo_q_to_off_chip);
void compute_FT0_level0(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip, int j0,
    float s_0[16], float s_1[16], float A_0[416][16], float A_1[416][16],
    float r[416]);
void FT0_level0(hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1,
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip);
void task0_intra(float s[16], float A[416][16], float r[416], int j0);
void task1_intra(float s[16], float A[416][16], float r[416], int j0);
void read_r_FT0(float r[416], hls::stream<float16> &fifo_r_from_off_chip_to_S1);
void read_r_FT0(float r[416],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1);
void read_A_FT0(float A[416][16],
                hls::stream<float16> &fifo_A_from_off_chip_to_S1, int j0);
void read_A_FT0(float A[416][16],
                hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
                int j0);
void write_s_FT0(float s[16], hls::stream<float16> &fifo_s_to_off_chip, int j0);
void write_s_FT0(float s[16],
                 hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip,
                 int j0);
void kernel_nlp_slr2(
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_r_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_A_from_off_chip_to_S1,
    hls::stream<ap_axiu<512, 0, 0, 0>> &fifo_s_to_off_chip);
#endif // PROMETHEUS_H
