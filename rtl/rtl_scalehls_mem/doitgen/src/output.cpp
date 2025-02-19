

#include <algorithm>
#include <ap_axi_sdata.h>
#include <ap_fixed.h>
#include <ap_int.h>
#include <hls_math.h>
#include <hls_stream.h>
#include <math.h>
#include <stdint.h>
#include <string.h>

#include <hls_vector.h>

using namespace std;

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;


//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated file for High-level Synthesis (HLS).
//
//===----------------------------------------------------------------------===//

#include <algorithm>
#include <ap_axi_sdata.h>
#include <ap_fixed.h>
#include <ap_int.h>
#include <hls_math.h>
#include <hls_stream.h>
#include <math.h>
#include <stdint.h>
#include <string.h>

using namespace std;

/// This is top function.
/// Latency=582104, interval=582104
/// DSP=75, BRAM=0
void kernel_nlp(
  float16 vv0[7500],
  float16 vv1[225],
  float16 vv2[7500]
) {	// L6, [0,582104)


  #pragma HLS interface m_axi port=vv0 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv1 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv2 offset=slave bundle=gmem2

  
  #pragma HLS INTERFACE s_axilite port = vv0 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv1 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv2 bundle = control


  #pragma HLS INTERFACE s_axilite port = return bundle = control

  float v0[50][40][60];
  float v1[60][60];
  float v2[50][40][60];

  #pragma HLS array_partition variable=v0 cyclic factor=12 dim=3
  #pragma HLS resource variable=v0 core=ram_t2p_bram

  #pragma HLS array_partition variable=v1 cyclic factor=2 dim=1
  #pragma HLS array_partition variable=v1 cyclic factor=15 dim=2
  #pragma HLS resource variable=v1 core=ram_t2p_bram

  #pragma HLS array_partition variable=v2 cyclic factor=15 dim=3
  #pragma HLS resource variable=v2 core=ram_t2p_bram


  for (int i=0; i<50*40*60; i+=16) {
    float16 v = vv0[i/16];
    for (int k=0; k<16; k++) {
      int i0 = i0 / (40*60);
      int i1 = (i0 % (40*60)) / 60;
      int i2 = i0 % 60;
      v0[i0][i1][i2] = v[k];
    }
    
  }

  for (int i=0; i<60*60; i+=16) {
    float16 v = vv1[i/16];
    for (int k=0; k<16; k++) {
      int i0 = i0 / 60;
      int i1 = i0 % 60;
      v1[i0][i1] = v[k];
    }
    
  }

  for (int i=0; i<50*40*60; i+=16) {
    float16 v = vv2[i/16];
    for (int k=0; k<16; k++) {
      int i0 = i0 / (40*60);
      int i1 = (i0 % (40*60)) / 60;
      int i2 = i0 % 60;
      v2[i0][i1][i2] = v[k];
    }
    
  }


  for (int v3 = 0; v3 < 50; v3 += 1) {	// L8, [0,582102), iterCycle=11642, II=11642
    for (int v4 = 0; v4 < 40; v4 += 1) {	// L9, [0,11642), iterCycle=291, II=291
      for (int v5 = 0; v5 < 30; v5 += 1) {	// L10, [0,257), iterCycle=17, II=2
        for (int v6 = 0; v6 < 4; v6 += 1) {	// L11, [34,59), iterCycle=17, II=2
          #pragma HLS pipeline II=2
          float v7 = v0[v3][v4][(v5 * 2)];	// L12, [0,2)
          float v8 = v1[(v5 * 2)][(v6 * 15)];	// L13, [0,2)
          float v9 = v7 * v8;	// L14, [2,6)
          float v10 = v1[(v5 * 2)][((v6 * 15) + 1)];	// L15, [0,2)
          float v11 = v7 * v10;	// L16, [2,6)
          float v12 = v1[(v5 * 2)][((v6 * 15) + 2)];	// L17, [0,2)
          float v13 = v7 * v12;	// L18, [2,6)
          float v14 = v1[(v5 * 2)][((v6 * 15) + 3)];	// L19, [0,2)
          float v15 = v7 * v14;	// L20, [2,6)
          float v16 = v1[(v5 * 2)][((v6 * 15) + 4)];	// L21, [0,2)
          float v17 = v7 * v16;	// L22, [2,6)
          float v18 = v1[(v5 * 2)][((v6 * 15) + 5)];	// L23, [0,2)
          float v19 = v7 * v18;	// L24, [2,6)
          float v20 = v1[(v5 * 2)][((v6 * 15) + 6)];	// L25, [0,2)
          float v21 = v7 * v20;	// L26, [2,6)
          float v22 = v1[(v5 * 2)][((v6 * 15) + 7)];	// L27, [0,2)
          float v23 = v7 * v22;	// L28, [2,6)
          float v24 = v1[(v5 * 2)][((v6 * 15) + 8)];	// L29, [0,2)
          float v25 = v7 * v24;	// L30, [2,6)
          float v26 = v1[(v5 * 2)][((v6 * 15) + 9)];	// L31, [0,2)
          float v27 = v7 * v26;	// L32, [2,6)
          float v28 = v1[(v5 * 2)][((v6 * 15) + 10)];	// L33, [0,2)
          float v29 = v7 * v28;	// L34, [2,6)
          float v30 = v1[(v5 * 2)][((v6 * 15) + 11)];	// L35, [0,2)
          float v31 = v7 * v30;	// L36, [2,6)
          float v32 = v1[(v5 * 2)][((v6 * 15) + 12)];	// L37, [0,2)
          float v33 = v7 * v32;	// L38, [2,6)
          float v34 = v1[(v5 * 2)][((v6 * 15) + 13)];	// L39, [0,2)
          float v35 = v7 * v34;	// L40, [2,6)
          float v36 = v1[(v5 * 2)][((v6 * 15) + 14)];	// L41, [0,2)
          float v37 = v7 * v36;	// L42, [2,6)
          float v38 = v0[v3][v4][((v5 * 2) + 1)];	// L43, [0,2)
          float v39 = v1[((v5 * 2) + 1)][(v6 * 15)];	// L44, [0,2)
          float v40 = v38 * v39;	// L45, [2,6)
          float v41 = v9 + v40;	// L46, [6,11)
          float v42 = v2[v3][v4][(v6 * 15)];	// L47, [9,11)
          float v43 = ((v5 * 2) == 0) ? (float)0.000000 : v42;	// L48, [11,11)
          float v44 = v43 + v41;	// L49, [11,16)
          v2[v3][v4][(v6 * 15)] = v44;	// L50, [16,17)
          float v45 = v1[((v5 * 2) + 1)][((v6 * 15) + 1)];	// L51, [0,2)
          float v46 = v38 * v45;	// L52, [2,6)
          float v47 = v11 + v46;	// L53, [6,11)
          float v48 = v2[v3][v4][((v6 * 15) + 1)];	// L54, [9,11)
          float v49 = ((v5 * 2) == 0) ? (float)0.000000 : v48;	// L55, [11,11)
          float v50 = v49 + v47;	// L56, [11,16)
          v2[v3][v4][((v6 * 15) + 1)] = v50;	// L57, [16,17)
          float v51 = v1[((v5 * 2) + 1)][((v6 * 15) + 2)];	// L58, [0,2)
          float v52 = v38 * v51;	// L59, [2,6)
          float v53 = v13 + v52;	// L60, [6,11)
          float v54 = v2[v3][v4][((v6 * 15) + 2)];	// L61, [9,11)
          float v55 = ((v5 * 2) == 0) ? (float)0.000000 : v54;	// L62, [11,11)
          float v56 = v55 + v53;	// L63, [11,16)
          v2[v3][v4][((v6 * 15) + 2)] = v56;	// L64, [16,17)
          float v57 = v1[((v5 * 2) + 1)][((v6 * 15) + 3)];	// L65, [0,2)
          float v58 = v38 * v57;	// L66, [2,6)
          float v59 = v15 + v58;	// L67, [6,11)
          float v60 = v2[v3][v4][((v6 * 15) + 3)];	// L68, [9,11)
          float v61 = ((v5 * 2) == 0) ? (float)0.000000 : v60;	// L69, [11,11)
          float v62 = v61 + v59;	// L70, [11,16)
          v2[v3][v4][((v6 * 15) + 3)] = v62;	// L71, [16,17)
          float v63 = v1[((v5 * 2) + 1)][((v6 * 15) + 4)];	// L72, [0,2)
          float v64 = v38 * v63;	// L73, [2,6)
          float v65 = v17 + v64;	// L74, [6,11)
          float v66 = v2[v3][v4][((v6 * 15) + 4)];	// L75, [9,11)
          float v67 = ((v5 * 2) == 0) ? (float)0.000000 : v66;	// L76, [11,11)
          float v68 = v67 + v65;	// L77, [11,16)
          v2[v3][v4][((v6 * 15) + 4)] = v68;	// L78, [16,17)
          float v69 = v1[((v5 * 2) + 1)][((v6 * 15) + 5)];	// L79, [0,2)
          float v70 = v38 * v69;	// L80, [2,6)
          float v71 = v19 + v70;	// L81, [6,11)
          float v72 = v2[v3][v4][((v6 * 15) + 5)];	// L82, [9,11)
          float v73 = ((v5 * 2) == 0) ? (float)0.000000 : v72;	// L83, [11,11)
          float v74 = v73 + v71;	// L84, [11,16)
          v2[v3][v4][((v6 * 15) + 5)] = v74;	// L85, [16,17)
          float v75 = v1[((v5 * 2) + 1)][((v6 * 15) + 6)];	// L86, [0,2)
          float v76 = v38 * v75;	// L87, [2,6)
          float v77 = v21 + v76;	// L88, [6,11)
          float v78 = v2[v3][v4][((v6 * 15) + 6)];	// L89, [9,11)
          float v79 = ((v5 * 2) == 0) ? (float)0.000000 : v78;	// L90, [11,11)
          float v80 = v79 + v77;	// L91, [11,16)
          v2[v3][v4][((v6 * 15) + 6)] = v80;	// L92, [16,17)
          float v81 = v1[((v5 * 2) + 1)][((v6 * 15) + 7)];	// L93, [0,2)
          float v82 = v38 * v81;	// L94, [2,6)
          float v83 = v23 + v82;	// L95, [6,11)
          float v84 = v2[v3][v4][((v6 * 15) + 7)];	// L96, [9,11)
          float v85 = ((v5 * 2) == 0) ? (float)0.000000 : v84;	// L97, [11,11)
          float v86 = v85 + v83;	// L98, [11,16)
          v2[v3][v4][((v6 * 15) + 7)] = v86;	// L99, [16,17)
          float v87 = v1[((v5 * 2) + 1)][((v6 * 15) + 8)];	// L100, [0,2)
          float v88 = v38 * v87;	// L101, [2,6)
          float v89 = v25 + v88;	// L102, [6,11)
          float v90 = v2[v3][v4][((v6 * 15) + 8)];	// L103, [9,11)
          float v91 = ((v5 * 2) == 0) ? (float)0.000000 : v90;	// L104, [11,11)
          float v92 = v91 + v89;	// L105, [11,16)
          v2[v3][v4][((v6 * 15) + 8)] = v92;	// L106, [16,17)
          float v93 = v1[((v5 * 2) + 1)][((v6 * 15) + 9)];	// L107, [0,2)
          float v94 = v38 * v93;	// L108, [2,6)
          float v95 = v27 + v94;	// L109, [6,11)
          float v96 = v2[v3][v4][((v6 * 15) + 9)];	// L110, [9,11)
          float v97 = ((v5 * 2) == 0) ? (float)0.000000 : v96;	// L111, [11,11)
          float v98 = v97 + v95;	// L112, [11,16)
          v2[v3][v4][((v6 * 15) + 9)] = v98;	// L113, [16,17)
          float v99 = v1[((v5 * 2) + 1)][((v6 * 15) + 10)];	// L114, [0,2)
          float v100 = v38 * v99;	// L115, [2,6)
          float v101 = v29 + v100;	// L116, [6,11)
          float v102 = v2[v3][v4][((v6 * 15) + 10)];	// L117, [9,11)
          float v103 = ((v5 * 2) == 0) ? (float)0.000000 : v102;	// L118, [11,11)
          float v104 = v103 + v101;	// L119, [11,16)
          v2[v3][v4][((v6 * 15) + 10)] = v104;	// L120, [16,17)
          float v105 = v1[((v5 * 2) + 1)][((v6 * 15) + 11)];	// L121, [0,2)
          float v106 = v38 * v105;	// L122, [2,6)
          float v107 = v31 + v106;	// L123, [6,11)
          float v108 = v2[v3][v4][((v6 * 15) + 11)];	// L124, [9,11)
          float v109 = ((v5 * 2) == 0) ? (float)0.000000 : v108;	// L125, [11,11)
          float v110 = v109 + v107;	// L126, [11,16)
          v2[v3][v4][((v6 * 15) + 11)] = v110;	// L127, [16,17)
          float v111 = v1[((v5 * 2) + 1)][((v6 * 15) + 12)];	// L128, [0,2)
          float v112 = v38 * v111;	// L129, [2,6)
          float v113 = v33 + v112;	// L130, [6,11)
          float v114 = v2[v3][v4][((v6 * 15) + 12)];	// L131, [9,11)
          float v115 = ((v5 * 2) == 0) ? (float)0.000000 : v114;	// L132, [11,11)
          float v116 = v115 + v113;	// L133, [11,16)
          v2[v3][v4][((v6 * 15) + 12)] = v116;	// L134, [16,17)
          float v117 = v1[((v5 * 2) + 1)][((v6 * 15) + 13)];	// L135, [0,2)
          float v118 = v38 * v117;	// L136, [2,6)
          float v119 = v35 + v118;	// L137, [6,11)
          float v120 = v2[v3][v4][((v6 * 15) + 13)];	// L138, [9,11)
          float v121 = ((v5 * 2) == 0) ? (float)0.000000 : v120;	// L139, [11,11)
          float v122 = v121 + v119;	// L140, [11,16)
          v2[v3][v4][((v6 * 15) + 13)] = v122;	// L141, [16,17)
          float v123 = v1[((v5 * 2) + 1)][((v6 * 15) + 14)];	// L142, [0,2)
          float v124 = v38 * v123;	// L143, [2,6)
          float v125 = v37 + v124;	// L144, [6,11)
          float v126 = v2[v3][v4][((v6 * 15) + 14)];	// L145, [9,11)
          float v127 = ((v5 * 2) == 0) ? (float)0.000000 : v126;	// L146, [11,11)
          float v128 = v127 + v125;	// L147, [11,16)
          v2[v3][v4][((v6 * 15) + 14)] = v128;	// L148, [16,17)
        }
      }
      for (int v129 = 0; v129 < 5; v129 += 1) {	// L151, [257,291), iterCycle=8, II=6
        #pragma HLS pipeline II=1
        float v130 = v2[v3][v4][(v129 * 12)];	// L152, [0,2)
        v0[v3][v4][(v129 * 12)] = v130;	// L153, [7,8)
        float v131 = v2[v3][v4][((v129 * 12) + 1)];	// L154, [0,2)
        v0[v3][v4][((v129 * 12) + 1)] = v131;	// L155, [7,8)
        float v132 = v2[v3][v4][((v129 * 12) + 2)];	// L156, [1,3)
        v0[v3][v4][((v129 * 12) + 2)] = v132;	// L157, [7,8)
        float v133 = v2[v3][v4][((v129 * 12) + 3)];	// L158, [1,3)
        v0[v3][v4][((v129 * 12) + 3)] = v133;	// L159, [7,8)
        float v134 = v2[v3][v4][((v129 * 12) + 4)];	// L160, [2,4)
        v0[v3][v4][((v129 * 12) + 4)] = v134;	// L161, [7,8)
        float v135 = v2[v3][v4][((v129 * 12) + 5)];	// L162, [2,4)
        v0[v3][v4][((v129 * 12) + 5)] = v135;	// L163, [7,8)
        float v136 = v2[v3][v4][((v129 * 12) + 6)];	// L164, [3,5)
        v0[v3][v4][((v129 * 12) + 6)] = v136;	// L165, [7,8)
        float v137 = v2[v3][v4][((v129 * 12) + 7)];	// L166, [3,5)
        v0[v3][v4][((v129 * 12) + 7)] = v137;	// L167, [7,8)
        float v138 = v2[v3][v4][((v129 * 12) + 8)];	// L168, [4,6)
        v0[v3][v4][((v129 * 12) + 8)] = v138;	// L169, [7,8)
        float v139 = v2[v3][v4][((v129 * 12) + 9)];	// L170, [4,6)
        v0[v3][v4][((v129 * 12) + 9)] = v139;	// L171, [7,8)
        float v140 = v2[v3][v4][((v129 * 12) + 10)];	// L172, [5,7)
        v0[v3][v4][((v129 * 12) + 10)] = v140;	// L173, [7,8)
        float v141 = v2[v3][v4][((v129 * 12) + 11)];	// L174, [5,7)
        v0[v3][v4][((v129 * 12) + 11)] = v141;	// L175, [7,8)
      }
    }
  }


  for (int i=0; i<50*40*60; i+=16) {
    float16 v;
    for (int k=0; k<16; k++) {
      int i0 = i0 / (40*60);
      int i1 = (i0 % (40*60)) / 60;
      int i2 = i0 % 60;
      v[k] = v0[i0][i1][i2];
    }
    vv0[i/16] = v;
    
  }

  for (int i=0; i<60*60; i+=16) {
    float16 v;
    for (int k=0; k<16; k++) {
      int i0 = i0 / 60;
      int i1 = i0 % 60;
      v[k] = v1[i0][i1];
    }
    vv1[i/16] = v;
    
  }

  for (int i=0; i<50*40*60; i+=16) {
    float16 v;
    for (int k=0; k<16; k++) {
      int i0 = i0 / (40*60);
      int i1 = (i0 % (40*60)) / 60;
      int i2 = i0 % 60;
      v[k] = v2[i0][i1][i2];
    }
    vv2[i/16] = v;
    
  }


}

