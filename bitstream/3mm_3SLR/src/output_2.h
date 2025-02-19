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


void load_vB_for_task1(hls::stream<float16>& fifo_B_from_off_chip_to_S1, float16 vB[2400]);
void load_vA_for_task1(hls::stream<float16>& fifo_A_from_off_chip_to_S1, float16 vA[2340]);
void load_vC_for_task3(hls::stream<float16>& fifo_C_from_off_chip_to_S3, float16 vC[2660]);
void load_vD_for_task3(hls::stream<float8>& fifo_D_from_off_chip_to_S3, float8 vD[6048]);
void store_vF_for_task3(hls::stream<float8>& fifo_F_to_off_chip, float8 vF[5184]);
void store_vG_for_task5(hls::stream<float8>& fifo_G_to_off_chip, float8 vG[4860]);
void store_vE_for_task1(hls::stream<float16>& fifo_E_to_off_chip, float16 vE[2160]);
void FT0_level0(hls::stream<float16>& fifo_E_from_task1_to_task5, hls::stream<float16>& fifo_B_from_off_chip_to_S1, hls::stream<float16>& fifo_A_from_off_chip_to_S1, hls::stream<float16>& fifo_E_to_off_chip);
void FT0_level1(hls::stream<float16>& fifo_E_from_task1_to_task5, hls::stream<float16>& fifo_B_from_off_chip_to_S1, hls::stream<float16>& fifo_A_from_off_chip_to_S1, hls::stream<float16>& fifo_E_to_off_chip, float A[10][200], float B[200][192], int i0);
void FT1_level0(hls::stream<float8>& fifo_F_from_task3_to_task5, hls::stream<float16>& fifo_C_from_off_chip_to_S3, hls::stream<float8>& fifo_D_from_off_chip_to_S3, hls::stream<float8>& fifo_F_to_off_chip);
void FT1_level1(hls::stream<float8>& fifo_F_from_task3_to_task5, hls::stream<float16>& fifo_C_from_off_chip_to_S3, hls::stream<float8>& fifo_D_from_off_chip_to_S3, hls::stream<float8>& fifo_F_to_off_chip, float D[224][24], float C_0[190][224], float C_1[190][224], float C_2[190][224], int j0);
void FT2_level0(hls::stream<float16>& fifo_E_from_task1_to_task5, hls::stream<float8>& fifo_F_from_task3_to_task5, hls::stream<float8>& fifo_G_to_off_chip);
void FT2_level1(hls::stream<float16>& fifo_E_from_task1_to_task5, hls::stream<float8>& fifo_F_from_task3_to_task5, hls::stream<float8>& fifo_G_to_off_chip, float F[192][24], float E_0[180][192], float E_1[180][192], float E_2[180][192], int j0);
void task0_intra(float A[10][200], float B[200][192], int i0, float E[10][48], int j0);
void task1_intra(float A[10][200], float B[200][192], int i0, float E[10][48], int j0);
void task2_intra(float D[224][24], float C[190][224], int j0, float F[10][24], int i0);
void task3_intra(float D[224][24], float C[190][224], int j0, float F[10][24], int i0);
void task4_intra(float F[192][24], float E[180][192], int j0, float G[10][24], int i0);
void task5_intra(float F[192][24], float E[180][192], int j0, float G[10][24], int i0);
void read_B_FT0(float B[200][192], hls::stream<float16>& fifo_B_from_off_chip_to_S1);
void read_A_FT0(float A[10][200], hls::stream<float16>& fifo_A_from_off_chip_to_S1, int i0);
void read_D_FT1(float D[224][24], hls::stream<float8>& fifo_D_from_off_chip_to_S3, int j0);
void read_C_FT1(float C[190][224], hls::stream<float16>& fifo_C_from_off_chip_to_S3, int i0, int j0);
void read_F_FT2(float F[192][24], hls::stream<float8>& fifo_F_from_task3_to_task5, int j0);
void read_E_FT2(float E[180][192], hls::stream<float16>& fifo_E_from_task1_to_task5, int i0, int j0);
void write_E_FT0(float E[10][48], hls::stream<float16>& fifo_E_from_task1_to_task5, int j0, int i0);
void write_F_FT1(float F[10][24], hls::stream<float8>& fifo_F_from_task3_to_task5, int i0, int j0);
void write_G_FT2(float G[10][24], hls::stream<float8>& fifo_G_to_off_chip, int i0, int j0);
void kernel_nlp(float16 vE_for_task1[2160], float16 vA_for_task1[2340], float16 vB_for_task1[2400], float8 vF_for_task3[5184], float16 vC_for_task3[2660], float8 vD_for_task3[6048], float8 vG_for_task5[4860]);

#endif // PROMETHEUS_H
