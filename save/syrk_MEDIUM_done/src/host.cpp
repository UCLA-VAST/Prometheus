#include "output.h"
#include "xcl2.hpp"

void kernel_syrk(float alpha, float beta, float C[240][240], float A1[240][200],
                 float A2[240][200]) {
  int i;
  int j;
  int k;
  // BLAS PARAMS
  // TRANS = 'N'
  // UPLO  = 'L'
  //  =>  Form  C := alpha*A*A**T + beta*C.
  // A is NxM
  // C is NxN
  {

    for (i = 0; i < 240; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 240; i++) {
      for (k = 0; k < 200; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += alpha * A1[i][k] * A2[j][k];
        }
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
  float C_ori[240][240] = {0};
  float C_new_before_trans_0[240 * 240] = {0};
  float C_new_0[240 * 240] = {0};
  float A1_ori[240][200] = {0};
  float A1_new_before_trans_0[240 * 208] = {0};
  float A1_new_0[240 * 208] = {0};
  float A2_ori[240][200] = {0};
  float A2_new_before_trans_0[240 * 208] = {0};
  float A2_new_0[240 * 208] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      C_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d1_0 = 0; d1_0 < 15; d1_0++) {
      for (int d0_1 = 0; d0_1 < 60; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 60 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A1_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d0_1 = 0; d0_1 < 60; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 60 + d0_1;
        A1_new_0[memIndex] = A1_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A2_ori[i0][i1] = val;
      A2_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A2_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 15; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 16 + d0_1;
        A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
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
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 240 * 240, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A1_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 240 * 208, A1_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A1NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A2_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 240 * 208, A2_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A2NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, alpha_new);
  kernel.setArg(argN++, beta_new);
  kernel.setArg(argN++, C_0NewOCL);
  kernel.setArg(argN++, A1_0NewOCL);
  kernel.setArg(argN++, A2_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({A1_0NewOCL, A2_0NewOCL}, 0,
                                                  nullptr, nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({C_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_syrk(alpha_ori, beta_ori, C_ori, A1_ori, A2_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d1_0 = 0; d1_0 < 15; d1_0++) {
      for (int d0_1 = 0; d0_1 < 60; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 60 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_before_trans_0[d0 * 240 + d1 * 1] = C_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
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
