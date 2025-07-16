#include "output.h"
#include "xcl2.hpp"

#pragma ACCEL kernel

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

int main(int argc, char* argv[]) {
    printf("Starting C-simulation...\n");
    float v0[410*400];
    float v1[400];
    float v2[416];
    float v3[416];
    float v4[400];
    
    
    cl_int err;
    std::vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device;
    for (unsigned int i = 0; i < devices.size(); i++) {
        device = devices[i];
        std::cout << "Trying to program device[" << i
                  << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;
#ifndef HW_SIM
        if (device.getInfo<CL_DEVICE_NAME>() ==
            "xilinx_u55c_gen3x16_xdma_base_3") {
#else
        if (device.getInfo<CL_DEVICE_NAME>() ==
            "xilinx_u55c_gen3x16_xdma_3_202210_1") {
#endif
            break;
        }
    }
    OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
    OCL_CHECK(err, cl::CommandQueue q(context, device,
                                      CL_QUEUE_PROFILING_ENABLE, &err));
    OCL_CHECK(err,
              std::string device_name = device.getInfo<CL_DEVICE_NAME>(&err));
    std::string binary(argv[1]);
    auto fileBuf = xcl::read_binary_file(binary);
    cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    OCL_CHECK(err, cl::Program program(context, {device}, bins, NULL, &err));
    OCL_CHECK(err, cl::Kernel kernel(program, "kernel_nlp", &err));
    cl::Buffer v0NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 400 * 410, v0, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v1NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                   sizeof(float) * 400, v1, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer ANewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v2NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                   sizeof(float) * 416, v2, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v3NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                   sizeof(float) * 416, v3, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v4NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                   sizeof(float) * 400, v4, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }

    int argN = 0;
    
    kernel.setArg(argN++, v0NewOCL);
    kernel.setArg(argN++, v1NewOCL);
    kernel.setArg(argN++, v2NewOCL);
    kernel.setArg(argN++, v3NewOCL);
    kernel.setArg(argN++, v4NewOCL);

    
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                       {v0NewOCL, v1NewOCL, v2NewOCL}, 0, nullptr,
                       nullptr));
    q.finish();
    cl::Event kernelCompute;
    OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
    q.finish();
    kernelCompute.wait();
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({v3NewOCL, v4NewOCL},
                                                    CL_MIGRATE_MEM_OBJECT_HOST,
                                                    nullptr, nullptr));
    q.finish();

    
    printf("C-simulation passed!\n");
    uint64_t executionTime =
        kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_END>() -
        kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_START>();
    std::cout << "Time in seconds: " << (double)executionTime / pow(1000, 3)
              << "\n";
    return 0;
}
