# Bitstream Evaluation

You can find the results of **AutoDSE** and **Sisyphus** at the following link:  
[Sisyphus FPGA25 Artifact Repository](https://github.com/UCLA-VAST/sisyphus-fpga25-artifact/tree/main/bitstream).

## On-board Evaluation Comparison

| Framework & SLR | Kernel  | T (ms) | GF/s  | DSP  | BRAM  | L(K)  | FF(K)  | F (MHz)  |
|-----------|------|---------|--------|------|------|------|------|------|
| **Sisyphus** | 1 SLR | 2mm    | 1.20  | 30.57  | 556  | 510  | 213  | 276  | 220  |
|            |      | 3mm    | 1.52  | 29.89  | 984  | 611  | 230  | 300  | 220  |
|            |      | Atax   | 0.62  | 1.03   | 173  | 450  | 240  | 250  | 220  |
|            |      | Bicg   | 0.63  | 1.02   | 173  | 451  | 238  | 265  | 217  |
| **AutoDSE** | 1 SLR | 2mm    | 92.25 | 0.40   | 963  | 353.5 | 287  | 292  | 205  |
|            |      | 3mm    | 110.34 | 0.41   | 1117 | 470   | 278  | 306  | 220  |
|            |      | Atax   | 2.88  | 0.22   | 452  | 630.5 | 170  | 212  | 220  |
|            |      | Bicg   | 1.13  | 0.56   | 196  | 867.5 | 168  | 217  | 214  |
| **Ours** | 1 SLR | 2mm    | 0.56  | 65.13  | 1941 | 635.5 | 371  | 454  | 216  |
|            |      | 3mm    | 0.87  | 51.95  | 1551 | 635.5 | 342  | 423  | 220  |
|            |      | Atax   | 0.24  | 2.62   | 1081 | 533.5 | 234  | 287  | 184  |
|            |      | Bicg   | 0.15  | 4.04   | 732  | 311.5 | 250  | 302  | 220  |
| **Ours** | 3 SLR | 2mm    | 0.29  | 125.54 | 2752 | 546   | 428  | 549  | 220  |
|            |      | 3mm    | 0.34  | 134.07 | 4379 | 600   | 684  | 840  | 207  |
|            |      | Atax   | 0.20  | 3.10   | 1823 | 634.5 | 405  | 539  | 137  |
|            |      | Bicg   | 0.14  | 4.34   | 1226 | 241   | 291  | 380  | 177  |