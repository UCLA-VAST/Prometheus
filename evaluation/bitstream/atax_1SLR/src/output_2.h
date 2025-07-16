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


void load_vA_for_task3(hls::stream<float16>& fifo_A_from_off_chip_to_S3, float16 vA[10192]);
void load_vx_for_task1(hls::stream<float16>& fifo_x_from_off_chip_to_S1, float16 vx[26]);
void load_vA_for_task1(hls::stream<float16>& fifo_A_from_off_chip_to_S1, float16 vA[10192]);
void store_vtmp_for_task1(hls::stream<float8>& fifo_tmp_to_off_chip, float8 vtmp[49]);
void store_vy_for_task3(hls::stream<float16>& fifo_y_to_off_chip, float16 vy[26]);
void FT0_level0(hls::stream<float8>& fifo_tmp_from_task1_to_task3, hls::stream<float16>& fifo_x_from_off_chip_to_S1, hls::stream<float16>& fifo_A_from_off_chip_to_S1, hls::stream<float8>& fifo_tmp_to_off_chip);
void FT1_level0(hls::stream<float8>& fifo_tmp_from_task1_to_task3, hls::stream<float16>& fifo_A_from_off_chip_to_S3, hls::stream<float16>& fifo_y_to_off_chip);
void task0_intra(float tmp[56], float A[392][416], float x[416], int i0);
void task1_intra(float tmp[56], float A[392][416], float x[416], int i0);
void task2_intra(float y[16], float A[392][16], float tmp[392], int j0);
void task3_intra(float y[16], float A[392][16], float tmp[392], int j0);
void read_A_FT0(float A[392][416], hls::stream<float16>& fifo_A_from_off_chip_to_S1);
void read_x_FT0(float x[416], hls::stream<float16>& fifo_x_from_off_chip_to_S1);
void read_tmp_FT1(float tmp[392], hls::stream<float8>& fifo_tmp_from_task1_to_task3);
void read_A_FT1(float A[392][16], hls::stream<float16>& fifo_A_from_off_chip_to_S3, int j0);
void write_tmp_FT0(float tmp[56], hls::stream<float8>& fifo_tmp_from_task1_to_task3, int i0);
void write_y_FT1(float y[16], hls::stream<float16>& fifo_y_to_off_chip, int j0);
void kernel_nlp(float8 vtmp_for_task1[49], float16 vA_for_task1[10192], float16 vA_for_task3[10192], float16 vx_for_task1[26], float16 vy_for_task3[26]);

#endif // PROMETHEUS_H
