# CADIO-GWO: Chaotic Adaptive Dholes Inspired Grey Wolf Optimizer

[![MATLAB](https://img.shields.io/badge/MATLAB-R2021a+-orange.svg)]()
## Overview

This repository contains the MATLAB implementation of the **CADIO-GWO (Chaotic Adaptive Dholes Inspired Grey Wolf Optimizer)** proposed for solving global optimization problems and its application to **Multi-UAV 3D Path Planning**.

The proposed algorithm combines the cooperative hunting behaviour of **Dholes Inspired Optimization (DIO)** with the leadership mechanism of the **Grey Wolf Optimizer (GWO)**. Several adaptive mechanisms are incorporated to improve exploration, exploitation, convergence speed, and solution quality.

The algorithm has been validated on the **IEEE CEC2017 benchmark suite** (30D, 50D and 100D) and further applied to **Multi-UAV trajectory planning**.

---

## Proposed Contributions

The proposed CADIO-GWO introduces the following improvements over the original DIO algorithm:

- Logistic chaotic population initialization
- Adaptive nonlinear control parameter
- Adaptive elite population selection
- Improved DIO hunting strategy
- Pack-guided search mechanism
- Grey Wolf guided position updating
- Adaptive hybridization between DIO and GWO
- Boundary handling mechanism

---

## Repository Structure

```
CADIO-GWO
│
├── CEC2017 Results
│   ├── 30 Dimensions
│   │   ├── CEC2017_Best_Dim30_Runs300.xlsx
│   │   ├── CEC2017_Mean_Dim30_Runs300.xlsx
│   │   └── CEC2017_Std_Dim30_Runs300.xlsx
│   │
│   ├── 50 Dimensions
│   │   ├── CEC2017_Best_Dim50_Runs300.xlsx
│   │   ├── CEC2017_Mean_Dim50_Runs300.xlsx
│   │   └── CEC2017_Std_Dim50_Runs300.xlsx
│   │
│   ├── 100 Dimensions
│   │   ├── CEC2017_Best_Dim100_Runs300.xlsx
│   │   ├── CEC2017_Mean_Dim100_Runs300.xlsx
│   │   └── CEC2017_Std_Dim100_Runs300.xlsx
│   │
│   ├── Sankey_Diagram.jpg
│   └── algo_pseudocode.pdf
│
├── Convergence Curves
│   ├── 30 Dimensions
│   ├── 50 Dimensions
│   └── 100 Dimensions
│
├── MATLAB_Code
│   ├── CADIO_GWO.m
│   ├── DIO.m
│   ├── GWO.m
│   ├── WOA.m
│   └── Main_all_cores.m
│
├── Multi-UAV Application
│   ├── Mathematical Model.md
│   ├── convergence_curve.fig
│   ├── convergence_curve.jpeg
│   └── environment.fig
│
└── README.md
```

---

## MATLAB Files

| File | Description |
|------|-------------|
| `CADIO_GWO.m` | Proposed CADIO-GWO algorithm |
| `DIO.m` | Original Dholes Inspired Optimization |
| `GWO.m` | Grey Wolf Optimizer |
| `WOA.m` | Whale Optimization Algorithm |
| `Main_all_cores.m` | Main execution script for running benchmark experiments |

---

## Benchmark Evaluation

The proposed algorithm is evaluated on the **IEEE CEC2017 benchmark suite** under

- 30 Dimensions
- 50 Dimensions
- 100 Dimensions

Performance metrics include

- Best
- Mean
- Standard Deviation
- Convergence Curves
- Sankey Rank Analysis

---

## Multi-UAV Path Planning

The repository also demonstrates the application of CADIO-GWO to **Multi-UAV 3D trajectory planning**.

The optimization model considers:

- Flight energy consumption
- Path length
- Flight altitude
- Threat avoidance
- Trajectory smoothness

The mathematical formulation is available in

```
Multi-UAV Application/
    Mathematical Model.md
```

---

## Requirements

- MATLAB R2021a or later
- Parallel Computing Toolbox (optional for parallel execution)

---

## Running the Code

Execute

```matlab
Main_all_cores
```

to reproduce the benchmark experiments.

---

