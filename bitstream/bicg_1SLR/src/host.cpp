#include "output.h"
#include "xcl2.hpp"

void kernel_bicg(float A[410][390], float s[390], float q[410], float p[390],
                 float r[410]) {
  int i;
  int j;
  {

    for (j = 0; j < 390; j++) {
      s[j] = 0.0;
    }

    for (i = 0; i < 410; i++) {
      for (j = 0; j < 390; j++) {
        s[j] = s[j] + r[i] * A[i][j];
      }
    }

    for (i = 0; i < 410; i++) {
      q[i] = 0.0;
    }

    for (i = 0; i < 410; i++) {
      for (j = 0; j < 390; j++) {
        q[i] = q[i] + A[i][j] * p[j];
      }
    }
  }
}

int main(int argc, char *argv[]) {
  printf("Starting C-simulation...\n");
  float A_ori[410][390] = {0};
  float A_new_before_trans_0[416 * 400] = {0};
  float A_new_0[416 * 400] = {0};
  float A_new_before_trans_1[416 * 400] = {0};
  float A_new_1[416 * 400] = {0};
  float s_ori[390] = {0};
  float s_new_before_trans_0[400] = {0};
  float s_new_0[400] = {0};
  float q_ori[410] = {0};
  float q_new_before_trans_0[410] = {0};
  float q_new_0[410] = {0};
  float p_ori[390] = {0};
  float p_new_before_trans_0[400] = {0};
  float p_new_0[400] = {0};
  float r_ori[410] = {0};
  float r_new_before_trans_0[416] = {0};
  float r_new_0[416] = {0};
  int memIndex = 0;
  float val;
  for (int i0 = 0; i0 < 410; i0++) {
    for (int i1 = 0; i1 < 390; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A_new_0[i0 * 400 + i1 * 1] = val;
      A_new_before_trans_1[i0 * 400 + i1 * 1] = val;
      A_new_1[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 25; d1_0++) {
    for (int d0_0 = 0; d0_0 < 26; d0_0++) {
      for (int d0_1 = 0; d0_1 < 16; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 16 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          A_new_0[memIndex] = A_new_before_trans_0[d0 * 400 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 41; d0_0++) {
    for (int d0_1 = 0; d0_1 < 10; d0_1++) {
      for (int d1 = 0; d1 < 400; d1++) {
        int d0 = d0_0 * 10 + d0_1;
        A_new_1[memIndex] = A_new_before_trans_1[d0 * 400 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 390; i0++) {
    val = ((float)rand() / RAND_MAX);
    s_ori[i0] = val;
    s_new_before_trans_0[i0 * 1] = val;
    s_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      s_new_0[memIndex] = s_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 410; i0++) {
    val = ((float)rand() / RAND_MAX);
    q_ori[i0] = val;
    q_new_before_trans_0[i0 * 1] = val;
    q_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 41; d0_0++) {
    for (int d0_1 = 0; d0_1 < 10; d0_1++) {
      int d0 = d0_0 * 10 + d0_1;
      q_new_0[memIndex] = q_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 390; i0++) {
    val = ((float)rand() / RAND_MAX);
    p_ori[i0] = val;
    p_new_before_trans_0[i0 * 1] = val;
    p_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 410; i0++) {
    val = ((float)rand() / RAND_MAX);
    r_ori[i0] = val;
    r_new_before_trans_0[i0 * 1] = val;
    r_new_0[i0 * 1] = val;
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
                 sizeof(float) * 416 * 400, A_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer A_1NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 416 * 400, A_new_1, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer s_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 400, s_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer sNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer q_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                 sizeof(float) * 410, q_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer qNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer p_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 400, p_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer pNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  cl::Buffer r_0NewOCL =
      cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                 sizeof(float) * 416, r_new_0, &err);
  if (err != CL_SUCCESS) {
    std::cerr << "Could not allocate buffer rNewOCL, error number: " << err
              << "\n";
    return EXIT_FAILURE;
  }
  int argN = 0;
  kernel.setArg(argN++, s_0NewOCL);
  kernel.setArg(argN++, r_0NewOCL);
  kernel.setArg(argN++, A_0NewOCL);
  kernel.setArg(argN++, A_1NewOCL);
  kernel.setArg(argN++, q_0NewOCL);
  kernel.setArg(argN++, p_0NewOCL);
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                     {A_0NewOCL, A_1NewOCL, p_0NewOCL, r_0NewOCL}, 0, nullptr,
                     nullptr));
  q.finish();
  cl::Event kernelCompute;
  OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
  q.finish();
  kernelCompute.wait();
  OCL_CHECK(err, err = q.enqueueMigrateMemObjects({s_0NewOCL, q_0NewOCL},
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  nullptr, nullptr));
  q.finish();
  kernel_bicg(A_ori, s_ori, q_ori, p_ori, r_ori);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      s_new_before_trans_0[d0 * 1] = s_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 390; i0++) {
    if (abs(s_ori[i0] - s_new_before_trans_0[i0 * 1]) > 0.1) {
      printf("Error in s... %d %f %f\n", i0, s_ori[i0],
             s_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 41; d0_0++) {
    for (int d0_1 = 0; d0_1 < 10; d0_1++) {
      int d0 = d0_0 * 10 + d0_1;
      q_new_before_trans_0[d0 * 1] = q_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 410; i0++) {
    if (abs(q_ori[i0] - q_new_before_trans_0[i0 * 1]) > 0.1) {
      printf("Error in q... %d %f %f\n", i0, q_ori[i0],
             q_new_before_trans_0[i0 * 1]);
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
