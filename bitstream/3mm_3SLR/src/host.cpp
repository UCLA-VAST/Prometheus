#include "output.h"
#include "xcl2.hpp"

void kernel_3mm(float E[180][190], float A[180][200], float B[200][190],
                float F[190][210], float C[190][220], float D[220][210],
                float G[180][210]) {
  int i;
  int j;
  int k;
  {

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        E[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        for (k = 0; k < 200; ++k) {
          E[i][j] += A[i][k] * B[k][j];
        }
      }
    }

    for (i = 0; i < 190; i++) {
      for (j = 0; j < 210; j++) {
        F[i][j] = 0.0;
      }
    }
    for (i = 0; i < 190; i++) {
      for (j = 0; j < 210; j++) {
        for (k = 0; k < 220; ++k) {
          F[i][j] += C[i][k] * D[k][j];
        }
      }
    }

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 210; j++) {
        G[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 210; j++) {
        for (k = 0; k < 190; ++k) {
          G[i][j] += E[i][k] * F[k][j];
        }
      }
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float E_ori[180][190] = {0};
  float E_new_before_trans_0[180 * 192] = {0};
  float E_new_0[180 * 192] = {0};
  float A_ori[180][200] = {0};
  float A_new_before_trans_0[180 * 208] = {0};
  float A_new_0[180 * 208] = {0};
  float B_ori[200][190] = {0};
  float B_new_before_trans_0[200 * 192] = {0};
  float B_new_0[200 * 192] = {0};
  float F_ori[190][210] = {0};
  float F_new_before_trans_0[192 * 216] = {0};
  float F_new_0[192 * 216] = {0};
  float C_ori[190][220] = {0};
  float C_new_before_trans_0[190 * 224] = {0};
  float C_new_0[190 * 224] = {0};
  float D_ori[220][210] = {0};
  float D_new_before_trans_0[224 * 216] = {0};
  float D_new_0[224 * 216] = {0};
  float G_ori[180][210] = {0};
  float G_new_before_trans_0[180 * 216] = {0};
  float G_new_0[180 * 216] = {0};
  int memIndex = 0;
  float val;
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      E_ori[i0][i1] = val;
      E_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      E_new_0[i0 * 192 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 18; d0_0++) {
    for (int d1_0 = 0; d1_0 < 4; d1_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 48; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 48 + d1_1;
          E_new_0[memIndex] = E_new_before_trans_0[d0 * 192 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 18; d0_0++) {
    for (int d0_1 = 0; d0_1 < 10; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 10 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      B_new_0[i0 * 192 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 190; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      val = ((float)rand() / RAND_MAX);
      F_ori[i0][i1] = val;
      F_new_before_trans_0[i0 * 216 + i1 * 1] = val;
      F_new_0[i0 * 216 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 9; d1_0++) {
    for (int d0_0 = 0; d0_0 < 19; d0_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          F_new_0[memIndex] = F_new_before_trans_0[d0 * 216 + d1 * 1];
          memIndex++;
        }
      }
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
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 19; d0_0++) {
    for (int d0_1 = 0; d0_1 < 10; d0_1++) {
      for (int d1 = 0; d1 < 224; d1++) {
        int d0 = d0_0 * 10 + d0_1;
        C_new_0[memIndex] = C_new_before_trans_0[d0 * 224 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 220; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      val = ((float)rand() / RAND_MAX);
      D_ori[i0][i1] = val;
      D_new_before_trans_0[i0 * 216 + i1 * 1] = val;
      D_new_0[i0 * 216 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 9; d1_0++) {
    for (int d0_0 = 0; d0_0 < 56; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          D_new_0[memIndex] = D_new_before_trans_0[d0 * 216 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      val = ((float)rand() / RAND_MAX);
      G_ori[i0][i1] = val;
      G_new_before_trans_0[i0 * 216 + i1 * 1] = val;
      G_new_0[i0 * 216 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 9; d1_0++) {
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          G_new_0[memIndex] = G_new_before_trans_0[d0 * 216 + d1 * 1];
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
  cl::Buffer E_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 180 * 192, E_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ENewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 180 * 208, A_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 192, B_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer F_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 192 * 216, F_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer FNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 190 * 224, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer D_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 224 * 216, D_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer DNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer G_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 180 * 216, G_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer GNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, E_0NewOCL);
  kernel.setArg(argN++, A_0NewOCL);
  kernel.setArg(argN++, B_0NewOCL);
  kernel.setArg(argN++, F_0NewOCL);
  kernel.setArg(argN++, C_0NewOCL);
  kernel.setArg(argN++, D_0NewOCL);
  kernel.setArg(argN++, G_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {A_0NewOCL, B_0NewOCL, C_0NewOCL, D_0NewOCL}, 0, nullptr,
                     nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {E_0NewOCL, F_0NewOCL, G_0NewOCL},
                     CL_MIGRATE_MEM_OBJECT_HOST, nullptr, nullptr));
  q.finish();
  kernel_3mm(E_ori, A_ori, B_ori, F_ori, C_ori, D_ori, G_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 18; d0_0++) {
    for (int d1_0 = 0; d1_0 < 4; d1_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 48; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 48 + d1_1;
          E_new_before_trans_0[d0 * 192 + d1 * 1] = E_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      if (abs(E_ori[i0][i1] - E_new_before_trans_0[i0 * 192 + i1 * 1]) >
          4) {
        printf("Error in E... %d  %d %f %f\n", i0, i1, E_ori[i0][i1],
               E_new_before_trans_0[i0 * 192 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 9; d1_0++) {
    for (int d0_0 = 0; d0_0 < 19; d0_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          F_new_before_trans_0[d0 * 216 + d1 * 1] = F_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 190; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      if (abs(F_ori[i0][i1] - F_new_before_trans_0[i0 * 216 + i1 * 1]) >
          4) {
        printf("Error in F... %d  %d %f %f\n", i0, i1, F_ori[i0][i1],
               F_new_before_trans_0[i0 * 216 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 9; d1_0++) {
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
      for (int d0_1 = 0; d0_1 < 10; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 10 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          G_new_before_trans_0[d0 * 216 + d1 * 1] = G_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      if (abs(G_ori[i0][i1] - G_new_before_trans_0[i0 * 216 + i1 * 1]) >
          4) {
        printf("Error in G... %d  %d %f %f\n", i0, i1, G_ori[i0][i1],
               G_new_before_trans_0[i0 * 216 + i1 * 1]);
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
