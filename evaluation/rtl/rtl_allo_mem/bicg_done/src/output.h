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

void kernel_nlp(
  float16 vv22[10045], // A
  float16 vv23[10045], // A copy
  float16 vv24[25], // p
  float16 vv25[26], // r
  float16 vv26[26], // q
  float16 vv27[25] // s
);
#endif  // PROMETHEUS_H
