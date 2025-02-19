#include "output.h"
#include "xcl2.hpp"

#pragma ACCEL kernel

void kernel_2mm(float alpha, float beta, float tmp[180][190], float A[180][210],
                float B[210][190], float C[190][220], float D[180][220]) {
    int i;
    int j;
    int k;
    {
        for (i = 0; i < 180; i++) {
            for (j = 0; j < 190; j++) {
                tmp[i][j] = 0.0;

                for (k = 0; k < 210; ++k) {
                    tmp[i][j] += alpha * A[i][k] * B[k][j];
                }
            }
        }

        for (i = 0; i < 180; i++) {
            for (j = 0; j < 220; j++) {
                D[i][j] *= beta;

                for (k = 0; k < 190; ++k) {
                    D[i][j] += tmp[i][k] * C[k][j];
                }
            }
        }
    }
}

int main(int argc, char* argv[]) {
    printf("Starting C-simulation...\n");
    float v0[400*400];
    float v1[400];
    float v2[400];
    float v3[400];
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
                   sizeof(float) * 400 * 400, v0, &err);
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
                   sizeof(float) * 400, v2, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer BNewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v3NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                   sizeof(float) * 400, v3, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer CNewOCL, error number: " << err
                  << "\n";
        return EXIT_FAILURE;
    }
    cl::Buffer v4NewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 400, v4, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer DNewOCL, error number: " << err
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
                       {v0NewOCL, v1NewOCL, v2NewOCL}, 0, nullptr, nullptr));
    q.finish();
    cl::Event kernelCompute;
    OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
    q.finish();
    kernelCompute.wait();
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({v3NewOCL,v4NewOCL},
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
