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
    printf("Starting C-simulation...\n");
    float alpha_ori;
    float alpha_new;
    float beta_ori;
    float beta_new;
    float E_ori[180][190];
    float E_new[180][190];
    float A_ori[180][200];
    float A_new[180][200];
    float B_ori[200][190];
    float B_new[200][190];
    float F_ori[190][210];
    float F_new[190][210];
    float C_ori[190][220];
    float C_new[190][220];
    float D_ori[220][210];
    float D_new[220][210];
    float G_ori[180][210];
    float G_new[180][210];
    int memIndex = 0;
    float val;
    
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
    cl::Buffer E_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 180 * 190, E_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer A_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 180 * 200, A_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer B_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 200 * 190, B_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer F_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 190 * 210, F_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer C_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 190 * 220, C_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer D_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 220 * 210, D_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }

    cl::Buffer G_oriNewOCL =
        cl::Buffer(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE,
                   sizeof(float) * 180 * 210, G_ori, &err);
    if (err != CL_SUCCESS) {
        std::cerr << "Could not allocate buffer tmpNewOCL, error number: "
                  << err << "\n";
        return EXIT_FAILURE;
    }


    int argN = 0;
    // float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    kernel.setArg(argN++, E_oriNewOCL);
    kernel.setArg(argN++, A_oriNewOCL);
    kernel.setArg(argN++, B_oriNewOCL);
    kernel.setArg(argN++, F_oriNewOCL);
    kernel.setArg(argN++, C_oriNewOCL);
    kernel.setArg(argN++, D_oriNewOCL);
    kernel.setArg(argN++, G_oriNewOCL);

    
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects(
                       {A_oriNewOCL, B_oriNewOCL, C_oriNewOCL, D_oriNewOCL}, 0, nullptr, nullptr));
    q.finish();
    cl::Event kernelCompute;
    OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));
    q.finish();
    kernelCompute.wait();
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({E_oriNewOCL, F_oriNewOCL, G_oriNewOCL},
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
