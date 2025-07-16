#ifndef PROMETHEUS_H
#define PROMETHEUS_H

#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>

#include <algorithm>
#include <cstring>
#include <iostream>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

void kernel_nlp(float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]);
#endif  // PROMETHEUS_H
