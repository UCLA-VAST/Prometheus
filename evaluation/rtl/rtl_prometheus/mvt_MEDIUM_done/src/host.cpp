#include "output.h"
#include "xcl2.hpp"

void kernel_mvt(float x1[400], float x2[400], float B[400], float C[400],
                float A1[400][400], float A2[400][400]) {
  int i;
  int j;
  {

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        x1[i] += A1[i][j] * B[j];
      }
    }

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        x2[i] += A2[j][i] * C[j];
      }
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float x1_ori[400] = {0};
  float x1_new_before_trans_0[400] = {0};
  float x1_new_0[400] = {0};
  float x2_ori[400] = {0};
  float x2_new_before_trans_0[400] = {0};
  float x2_new_0[400] = {0};
  float B_ori[400] = {0};
  float B_new_before_trans_0[400] = {0};
  float B_new_0[400] = {0};
  float C_ori[400] = {0};
  float C_new_before_trans_0[400] = {0};
  float C_new_0[400] = {0};
  float A1_ori[400][400] = {0};
  float A1_new_before_trans_0[400 * 400] = {0};
  float A1_new_0[400 * 400] = {0};
  float A2_ori[400][400] = {0};
  float A2_new_before_trans_0[400 * 400] = {0};
  float A2_new_0[400 * 400] = {0};
  int memIndex = 0;
  float val;
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    x1_ori[i0] = val;
    x1_new_before_trans_0[i0 * 1] = val;
    x1_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      int d0 = d0_0 * 4 + d0_1;
      x1_new_0[memIndex] = x1_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    x2_ori[i0] = val;
    x2_new_before_trans_0[i0 * 1] = val;
    x2_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x2_new_0[memIndex] = x2_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    B_ori[i0] = val;
    B_new_before_trans_0[i0 * 1] = val;
    B_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    C_ori[i0] = val;
    C_new_before_trans_0[i0 * 1] = val;
    C_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A1_new_0[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      for (int d1 = 0; d1 < 400; d1++) {
        int d0 = d0_0 * 4 + d0_1;
        A1_new_0[memIndex] = A1_new_before_trans_0[d0 * 400 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      val = ((float)rand() / RAND_MAX);
      A2_ori[i0][i1] = val;
      A2_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A2_new_0[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 25; d1_0++) {
    for (int d0_0 = 0; d0_0 < 8; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 400 + d1 * 1];
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
  cl::Buffer x1_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 400, x1_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer x1NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer x2_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 400, x2_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer x2NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 400, B_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer C_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 400, C_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A1_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 400 * 400, A1_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A1NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A2_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 400 * 400, A2_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer A2NewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, x1_0NewOCL);
  kernel.setArg(argN++, A1_0NewOCL);
  kernel.setArg(argN++, B_0NewOCL);
  kernel.setArg(argN++, x2_0NewOCL);
  kernel.setArg(argN++, A2_0NewOCL);
  kernel.setArg(argN++, C_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {B_0NewOCL, C_0NewOCL, A1_0NewOCL, A2_0NewOCL}, 0, nullptr,
                     nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({x1_0NewOCL, x2_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_mvt(x1_ori, x2_ori, B_ori, C_ori, A1_ori, A2_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      int d0 = d0_0 * 4 + d0_1;
      x1_new_before_trans_0[d0 * 1] = x1_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(x1_ori[i0] - x1_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in x1... %d %f %f\n", i0, x1_ori[i0],
             x1_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x2_new_before_trans_0[d0 * 1] = x2_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(x2_ori[i0] - x2_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in x2... %d %f %f\n", i0, x2_ori[i0],
             x2_new_before_trans_0[i0 * 1]);
      return 1;
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
