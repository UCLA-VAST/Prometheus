#include "output.h"
#include "xcl2.hpp"

void kernel_gesummv(float alpha, float beta, float A[250][250],
                    float B[250][250], float tmp[250], float w[250],
                    float r[250], float y[250]) {
  int i;
  int j;
  {

    for (i = 0; i < 250; i++) {
      tmp[i] = 0.0;
    }

    for (i = 0; i < 250; i++) {
      for (j = 0; j < 250; j++) {
        tmp[i] += A[i][j] * w[j];
      }
    }
    for (i = 0; i < 250; i++) {
      y[i] = 0.0;
    }
    for (i = 0; i < 250; i++) {
      for (j = 0; j < 250; j++) {
        y[i] += B[i][j] * r[j];
      }
    }
    for (i = 0; i < 250; i++) {
      y[i] = y[i] * beta + alpha * tmp[i];
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float A_ori[250][250] = {0};
  float A_new_before_trans_0[250 * 256] = {0};
  float A_new_0[250 * 256] = {0};
  float B_ori[250][250] = {0};
  float B_new_before_trans_0[250 * 256] = {0};
  float B_new_0[250 * 256] = {0};
  float tmp_ori[250] = {0};
  float tmp_new_before_trans_0[250] = {0};
  float tmp_new_0[250] = {0};
  float w_ori[250] = {0};
  float w_new_before_trans_0[256] = {0};
  float w_new_0[256] = {0};
  float r_ori[250] = {0};
  float r_new_before_trans_0[256] = {0};
  float r_new_0[256] = {0};
  float y_ori[250] = {0};
  float y_new_before_trans_0[250] = {0};
  float y_new_0[250] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 250; i0++) {
    for (int i1 = 0; i1 < 250; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 256 + i1 * 1] = val;
      A_new_0[i0 * 256 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      for (int d1 = 0; d1 < 256; d1++) {
        int d0 = d0_0 * 5 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 256 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    for (int i1 = 0; i1 < 250; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 256 + i1 * 1] = val;
      B_new_0[i0 * 256 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      for (int d1 = 0; d1 < 256; d1++) {
        int d0 = d0_0 * 5 + d0_1;
        B_new_0[memIndex] = B_new_before_trans_0[d0 * 256 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    tmp_ori[i0] = val;
    tmp_new_before_trans_0[i0 * 1] = val;
    tmp_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    w_ori[i0] = val;
    w_new_before_trans_0[i0 * 1] = val;
    w_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    r_ori[i0] = val;
    r_new_before_trans_0[i0 * 1] = val;
    r_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    y_ori[i0] = val;
    y_new_before_trans_0[i0 * 1] = val;
    y_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      y_new_0[memIndex] = y_new_before_trans_0[d0 * 1];
      memIndex++;
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
                 sizeof(float) * 250 * 256, A_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer B_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 250 * 256, B_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer tmp_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 250, tmp_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer tmpNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer w_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 256, w_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer wNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer r_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 256, r_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer rNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer y_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 250, y_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer yNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, alpha_new);
  kernel.setArg(argN++, beta_new);
  kernel.setArg(argN++, tmp_0NewOCL);
  kernel.setArg(argN++, A_0NewOCL);
  kernel.setArg(argN++, w_0NewOCL);
  kernel.setArg(argN++, y_0NewOCL);
  kernel.setArg(argN++, B_0NewOCL);
  kernel.setArg(argN++, r_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {A_0NewOCL, B_0NewOCL, w_0NewOCL, r_0NewOCL}, 0, nullptr,
                     nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({tmp_0NewOCL, y_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_gesummv(alpha_ori, beta_ori, A_ori, B_ori, tmp_ori, w_ori, r_ori,
                 y_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      tmp_new_before_trans_0[d0 * 1] = tmp_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    if (abs(tmp_ori[i0] - tmp_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in tmp... %d %f %f\n", i0, tmp_ori[i0],
             tmp_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      y_new_before_trans_0[d0 * 1] = y_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    if (abs(y_ori[i0] - y_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in y... %d %f %f\n", i0, y_ori[i0],
             y_new_before_trans_0[i0 * 1]);
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
