#include "output.h"
#include "xcl2.hpp"

void kernel_symm(float alpha, float beta, float tmp[200][240],
                 float C[200][240], float A1[200][200], float B1[200][240],
                 float A2[200], float B2[200][240], float A3[200][200],
                 float B3[200][240]) {
  int i;
  int j;
  int k;

  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      tmp[i][j] = 0;
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      for (k = 0; k < 200; k++) {
        tmp[i][j] += B1[k][j] * A1[i][k];
      }
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      C[i][j] = beta * C[i][j] + alpha * B2[i][j] * A2[i] + alpha * tmp[i][j];
    }
  }
  for (i = 0; i < 200; i++) {
    for (k = 0; k < 200; k++) {
      for (j = 0; j < 240; j++) {
        C[i][j] += alpha * B3[k][j] * A3[k][i];
      }
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float tmp_ori[200][240] = {0};
  float tmp_new_before_trans_0[200 * 240] = {0};
  float tmp_new_0[200 * 240] = {0};
  float C_ori[200][240] = {0};
  float C_new_before_trans_0[200 * 240] = {0};
  float C_new_0[200 * 240] = {0};
  float A1_ori[200][200] = {0};
  float A1_new_before_trans_0[200 * 208] = {0};
  float A1_new_0[200 * 208] = {0};
  float B1_ori[200][240] = {0};
  float B1_new_before_trans_0[208 * 240] = {0};
  float B1_new_0[208 * 240] = {0};
  float A2_ori[200] = {0};
  float A2_new_before_trans_0[200] = {0};
  float A2_new_0[200] = {0};
  float B2_ori[200][240] = {0};
  float B2_new_before_trans_0[200 * 240] = {0};
  float B2_new_0[200 * 240] = {0};
  float A3_ori[200][200] = {0};
  float A3_new_before_trans_0[200 * 208] = {0};
  float A3_new_0[200 * 208] = {0};
  float B3_ori[200][240] = {0};
  float B3_new_before_trans_0[200 * 240] = {0};
  float B3_new_0[200 * 240] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      tmp_ori[i0][i1] = val;
      tmp_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      tmp_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      C_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A1_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B1_ori[i0][i1] = val;
      B1_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B1_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 52; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B1_new_0[memIndex] = B1_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    val = ((float)rand() / RAND_MAX);
    A2_ori[i0] = val;
    A2_new_before_trans_0[i0 * 1] = val;
    A2_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 10; d0_0++) {
    for (int d0_1 = 0; d0_1 < 20; d0_1++) {
      int d0 = d0_0 * 20 + d0_1;
      A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B2_ori[i0][i1] = val;
      B2_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B2_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B2_new_0[memIndex] = B2_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A3_ori[i0][i1] = val;
      A3_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A3_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B3_ori[i0][i1] = val;
      B3_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B3_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 40; d0_0++) {
      for (int d0_1 = 0; d0_1 < 5; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 5 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B3_new_0[memIndex] = B3_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  cl_int err;
  std::vector<cl::Device> devices = xcl::get_xil_devices();
  cl::Device device;
  for (unsigned int i = 0; i < devices.size(); i++) {
    device = devices[i];
    std::cout << "Trying to program device[" << i
              << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;
#ifndef HW_SIM
    if (device.getInfo<CL_DEVICE_NAME>() == "xilinx_u55c_gen3x16_xdma_base_3") {
#else
    if (device.getInfo<CL_DEVICE_NAME>() ==
        "xilinx_u55c_gen3x16_xdma_3_202210_1") {
#endif
      break;
    }
  }
  OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
  OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE,
                                    &err));
  OCL_CHECK(err,
            std::string device_name = device.getInfo<CL_DEVICE_NAME>(&err));
  std::string binary(argv[1]);
  auto fileBuf = xcl::read_binary_file(binary);
  cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
  OCL_CHECK(err, cl::Program program(context, {device}, bins, NULL, &err));
  OCL_CHECK(err, cl::Kernel kernel(program, "kernel_nlp_slr0", &err));
  cl::Buffer tmp_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 200 * 240, tmp_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer tmpNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 200 * 240, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A1_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 208, A1_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A1NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B1_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 208 * 240, B1_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer B1NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A2_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200, A2_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A2NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B2_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 240, B2_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer B2NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A3_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 208, A3_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A3NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B3_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 240, B3_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer B3NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, alpha_new);
  kernel.setArg(argN++, beta_new);
  kernel.setArg(argN++, tmp_0NewOCL);
  kernel.setArg(argN++, B1_0NewOCL);
  kernel.setArg(argN++, A1_0NewOCL);
  kernel.setArg(argN++, C_0NewOCL);
  kernel.setArg(argN++, B2_0NewOCL);
  kernel.setArg(argN++, A2_0NewOCL);
  kernel.setArg(argN++, B3_0NewOCL);
  kernel.setArg(argN++, A3_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({A1_0NewOCL, B1_0NewOCL,
                                                   A2_0NewOCL, B2_0NewOCL,
                                                   A3_0NewOCL, B3_0NewOCL},
                                                  0, nullptr, nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({tmp_0NewOCL, C_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_symm(alpha_ori, beta_ori, tmp_ori, C_ori, A1_ori, B1_ori, A2_ori,
              B2_ori, A3_ori, B3_ori);
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          tmp_new_before_trans_0[d0 * 240 + d1 * 1] = tmp_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(tmp_ori[i0][i1] - tmp_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in tmp... %d  %d %f %f\n", i0, i1, tmp_ori[i0][i1],
               tmp_new_before_trans_0[i0 * 240 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_before_trans_0[d0 * 240 + d1 * 1] = C_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(C_ori[i0][i1] - C_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in C... %d  %d %f %f\n", i0, i1, C_ori[i0][i1],
               C_new_before_trans_0[i0 * 240 + i1 * 1]);
        return 1;
      }
    }
  }
  printf("C-simulation passed!\n");
  uint64_t executionTime =
      kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_END>() -
      kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_START>();
  std::cout << "Time in seconds: " << (double)executionTime / pow(1000, 3)
            << "\n";
  return 0;
}
