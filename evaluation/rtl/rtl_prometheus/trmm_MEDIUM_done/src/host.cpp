#include "output.h"
#include "xcl2.hpp"

void kernel_trmm(float alpha, float A[200][200], float B[200][240],
                 float C[200][240]) {
  int i;
  int j;
  int k;

  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      for (k = i + 1; k < 200; k++) {
        B[i][j] += A[k][i] * C[k][j];
      }
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      B[i][j] *= alpha;
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float A_ori[200][200] = {0};
  float A_new_before_trans_0[200 * 208] = {0};
  float A_new_0[200 * 208] = {0};
  float B_ori[200][240] = {0};
  float B_new_before_trans_0[200 * 240] = {0};
  float B_new_0[200 * 240] = {0};
  float C_ori[200][240] = {0};
  float C_new_before_trans_0[200 * 240] = {0};
  float C_new_0[200 * 240] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 4; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B_new_0[memIndex] = B_new_before_trans_0[d0 * 240 + d1 * 1];
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
    for (int d0_0 = 0; d0_0 < 40; d0_0++) {
      for (int d0_1 = 0; d0_1 < 5; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 5 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
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
  cl::Buffer A_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 208, A_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 200 * 240, B_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 200 * 240, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, alpha_new);
  kernel.setArg(argN++, B_0NewOCL);
  kernel.setArg(argN++, A_0NewOCL);
  kernel.setArg(argN++, C_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({A_0NewOCL, C_0NewOCL}, 0,
                                                  nullptr, nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({B_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_trmm(alpha_ori, A_ori, B_ori, C_ori);
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 4; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B_new_before_trans_0[d0 * 240 + d1 * 1] = B_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(B_ori[i0][i1] - B_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in B... %d  %d %f %f\n", i0, i1, B_ori[i0][i1],
               B_new_before_trans_0[i0 * 240 + i1 * 1]);
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
