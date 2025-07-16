# Prometheus: Automatic HLS Optimization and Code Generation Framework

Prometheus is a holistic toolchain for automatic design-space exploration and code generation for FPGA accelerators. It focuses on High-Level Synthesis (HLS) from affine C/C++ kernels and leverages optimization techniques to generate efficient hardware implementations.

## ✨ Key Features

- Support for **affine C/C++ kernels** with static loop bounds.
- Automatic **loop scheduling**, **pragmas insertion**, and **code generation**.
- Integration with **AMPL** for **Nonlinear Programming (NLP)**-based resource allocation.
- Generation of optimized **HLS-C++** and **host code**.
- Optional simulation and synthesis with **Vitis HLS**.
- Support for **graph partitioning**, **cyclic buffer**, **burst inference**, and more.

---

## 🚀 Quick Start

### 1. Requirements

- Python 3.8+
- AMPL (path configured in `main.py`)
- Clang-format (for formatting the output code)
- AMD Vitis HLS (for synthesis and CSIM)

To run PoCC and ISCC, please use the provided Docker container, as the Python code assumes these tools are executed from within the Docker environment. You can pull the latest image with:

```bash
docker pull ghcr.io/ucla-vast/pocc:latest
```

### 2. Example Usage

```bash
python main.py \
  --file examples/gemm.c \
  --vitis \
  --csim \
  --SLR 3 \
  --DSP 1440 \
  --MAX_BUFFER_SIZE 512 \
  --ON_CHIP_MEM_SIZE 8192 \
  --MAX_UF 32 \
  --code_generation \
  --folder output_dir
```

### 3. Evaluation

Please find the folder evaluation.

## ⚙️ Command-Line Arguments

| Argument                 | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `--file`                 | Path to the input C/C++ kernel                                              |
| `--folder`               | Output folder for generated code and reports                               |
| `--name_function`        | Kernel function name (default: `kernel_nlp`)                               |
| `--SLR`                  | Number of available Super Logic Regions                                    |
| `--DSP`                  | Total number of DSP slices available                                       |
| `--BRAM`, `--FF`, `--LUT`| FPGA resource budgets (optional)                                           |
| `--MAX_BUFFER_SIZE`      | Maximum allowed on-chip buffer size per array                             |
| `--ON_CHIP_MEM_SIZE`     | Total available on-chip memory                                             |
| `--MAX_UF`               | Maximum loop unrolling factor                                              |
| `--reuse_nlp`            | Use previously computed NLP results                                        |
| `--vitis`                | Enable synthesis using AMD Vitis HLS                                       |
| `--csim`                 | Enable C simulation with Vitis HLS                                         |
| `--code_generation`      | Enable output of HLS-C++ and host code                                     |
| `--graph_partitioning`   | Enable graph partitioning across SLRs or compute units                     |
| `--no_distribution`      | Disable ISCC-based loop distribution                                       |
| `--update_shape`         | Automatically update shape-related constraints                             |
| `--ap_multiple_burst`    | Enable multiple AXI burst access inference                                 |
| `--cyclic_buffer`        | Use cyclic buffering strategy for data reuse                               |
| `--verbose`              | Print detailed information during execution                                |
| `--debug`                | Enable debug mode                                                          |
