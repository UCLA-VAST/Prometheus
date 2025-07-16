#include "output.h"
#include "xcl2.hpp"

void kernel_2mm(float alpha, float beta, float tmp[180][190], float A[180][210],
                float B[210][190], float C[190][220], float D[180][220]) {
  int i;
  int j;
  int k;
  {

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        for (k = 0; k < 210; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        for (k = 0; k < 190; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
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
  float tmp_ori[180][190] = {0};
  float tmp_new_before_trans_0[180 * 192] = {0};
  float tmp_new_0[180 * 192] = {0};
  float A_ori[180][210] = {0};
  float A_new_before_trans_0[180 * 224] = {0};
  float A_new_0[180 * 224] = {0};
  float B_ori[210][190] = {0};
  float B_new_before_trans_0[212 * 192] = {0};
  float B_new_0[212 * 192] = {0};
  float C_ori[190][220] = {0};
  float C_new_before_trans_0[192 * 224] = {0};
  float C_new_0[192 * 224] = {0};
  float D_ori[180][220] = {0};
  float D_new_before_trans_0[180 * 224] = {0};
  float D_new_0[180 * 224] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      tmp_ori[i0][i1] = val;
      tmp_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      tmp_new_0[i0 * 192 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 45; d0_0++) {
    for (int d1_0 = 0; d1_0 < 6; d1_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 32; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 32 + d1_1;
          tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 192 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      A_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 45; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      for (int d1 = 0; d1 < 224; d1++) {
        int d0 = d0_0 * 4 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 224 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 210; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      B_new_0[i0 * 192 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 190; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      C_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 7; d1_0++) {
    for (int d0_0 = 0; d0_0 < 48; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 32; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 32 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 224 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      val = ((float)rand() / RAND_MAX);
      D_ori[i0][i1] = val;
      D_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      D_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 7; d1_0++) {
    for (int d0_0 = 0; d0_0 < 45; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 32; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 32 + d1_1;
          D_new_0[memIndex] = D_new_before_trans_0[d0 * 224 + d1 * 1];
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
                 sizeof(float) * 180 * 192, tmp_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer tmpNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 180 * 224, A_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 212 * 192, B_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 192 * 224, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer D_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 180 * 224, D_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer DNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, alpha_new);
  kernel.setArg(argN++, beta_new);
  kernel.setArg(argN++, tmp_0NewOCL);
  kernel.setArg(argN++, A_0NewOCL);
  kernel.setArg(argN++, B_0NewOCL);
  kernel.setArg(argN++, D_0NewOCL);
  kernel.setArg(argN++, C_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {A_0NewOCL, B_0NewOCL, C_0NewOCL}, 0, nullptr, nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({tmp_0NewOCL, D_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_2mm(alpha_ori, beta_ori, tmp_ori, A_ori, B_ori, C_ori, D_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 45; d0_0++) {
    for (int d1_0 = 0; d1_0 < 6; d1_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 32; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 32 + d1_1;
          tmp_new_before_trans_0[d0 * 192 + d1 * 1] = tmp_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      if (abs(tmp_ori[i0][i1] - tmp_new_before_trans_0[i0 * 192 + i1 * 1]) >
          0.01) {
        printf("Error in tmp... %d  %d %f %f\n", i0, i1, tmp_ori[i0][i1],
               tmp_new_before_trans_0[i0 * 192 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 7; d1_0++) {
    for (int d0_0 = 0; d0_0 < 45; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 32; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 32 + d1_1;
          D_new_before_trans_0[d0 * 224 + d1 * 1] = D_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      if (abs(D_ori[i0][i1] - D_new_before_trans_0[i0 * 224 + i1 * 1]) >
          0.01) {
        printf("Error in D... %d  %d %f %f\n", i0, i1, D_ori[i0][i1],
               D_new_before_trans_0[i0 * 224 + i1 * 1]);
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
