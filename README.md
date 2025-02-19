# Prometheus Artifact

[![DOI](https://zenodo.org/badge/935130604.svg)](https://doi.org/10.5281/zenodo.14895170)

This repository contains the artifact for the **Prometheus** project, which includes all the results from the evaluation.

---

## Dependencies

Ensure the following software dependencies are installed before proceeding:

### Required Software

- **AMPL Gurobi 11.0.0**  
  A powerful optimization solver. You can download it [here](https://ampl.com/products/solvers/solvers-we-sell/gurobi/).  
  Make sure you have a valid license for Gurobi.

- **AMD Vitis HLS 2023.2**  
  High-Level Synthesis (HLS) tool for AMD FPGA development. You can download it [here](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vitis/vitis-hls.html).  

- **AMD Merlin**  
  A source-to-source compiler built on top of AMD Vitis. You can download it [here](https://github.com/UCLA-VAST/Merlin-UCLA). 

### Git LFS (Large File Storage)

This repository uses Git LFS to manage large files such as binaries, datasets, or other resources. Git LFS must be installed before cloning the repository.

#### Install Git LFS

Follow the instructions for your platform:

- **macOS**:  
  ```sh
  brew install git-lfs
  ```

- **Linux**:  
  ```sh
  sudo apt install git-lfs
  ```
#### Initialize Git LFS

After installing Git LFS, initialize it by running:

  ```sh
  git lfs install
  ```

## Cloning the Repository

Use the following command to clone the repository with Git LFS support:

```sh
git clone git@github.com:S12P/prometheus-fccm25-artifact.git
```

Once cloned, Git LFS will automatically handle the large files. If needed, you can manually fetch all large files using:

```sh
git lfs pull
```

## Notes

1. Ensure that both **AMPL Gurobi** and **AMD Vitis HLS** are properly installed and licensed on your system before attempting to run any scripts or workflows from this repository.
2. If you encounter issues with Git LFS during the cloning process, verify that it is correctly installed and initialized as described above.
3. Refer to the official documentation of each tool for additional installation and configuration details. 
