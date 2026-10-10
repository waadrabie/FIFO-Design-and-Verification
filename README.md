# Synchronous FIFO Design and Verification using SystemVerilog

## Overview

This project focuses on the RTL design and functional verification of a **Synchronous First-In, First-Out (FIFO)** buffer using SystemVerilog. The design stores data temporarily and outputs it in the same order it was written, with read and write operations synchronized to a common clock.

The project covers RTL debugging and correction, testbench development, scoreboard-based checking, functional coverage, and assertion-based verification using QuestaSim.

## Features

- Synchronous FIFO with configurable data width and depth.
- Read and write pointer management.
- Occupancy counter to track the number of stored entries.
- Full and empty status flags.
- Almost-full and almost-empty flags.
- Write acknowledgment (`wr_ack`).
- Overflow and underflow detection.
- Handling of simultaneous read and write requests.
- Active-low asynchronous reset.
- SystemVerilog Assertions (SVA) for checking design behavior.

## Design Specifications

| Signal / Feature | Description |
|---|---|
| `clk` | Clock input |
| `rst_n` | Active-low reset |
| `wr_en` | Write enable |
| `rd_en` | Read enable |
| `data_in` | Input data |
| `data_out` | Output data |
| `wr_ack` | Indicates an accepted write |
| `full` | Indicates that the FIFO is full |
| `empty` | Indicates that the FIFO is empty |
| `almostfull` | Indicates that one entry remains before full |
| `almostempty` | Indicates that one entry remains before empty |
| `overflow` | Indicates an attempted write while full |
| `underflow` | Indicates an attempted read while empty |

The FIFO depth and data width are configurable through the interface parameters.

## Verification Environment

The project includes a SystemVerilog-based verification environment with the following components:

- **Interface:** Connects the DUT signals to the testbench.
- **Transaction:** Represents the operations and data used during verification.
- **Monitor:** Observes DUT activity and collects relevant signal information.
- **Scoreboard:** Checks the correctness of FIFO behavior against expected results.
- **Coverage:** Tracks exercised verification scenarios.
- **Assertions:** Check important design properties throughout simulation.
- **Testbench and top module:** Organize and execute the verification environment.

## Verification Scenarios

The verification plan covers the following scenarios:

1. **Reset behavior:** Verify that pointers, counter, and relevant outputs are initialized correctly.
2. **Basic write and read operations:** Check correct data storage and retrieval in FIFO order.
3. **Full and empty conditions:** Verify status flags at the occupancy limits.
4. **Almost-full and almost-empty conditions:** Check threshold flag behavior.
5. **Overflow and underflow:** Verify error indicators for invalid write and read attempts.
6. **Simultaneous read and write:** Check occupancy updates and operation handling when both enables are asserted.
7. **Pointer wraparound:** Verify that read and write pointers return to zero after reaching the final FIFO address.
8. **Pointer and counter thresholds:** Ensure pointers remain within the valid address range and the occupancy counter remains between zero and the FIFO depth.
9. **Assertion-based checks:** Validate control signals, status flags, reset behavior, and pointer boundaries.

## Assertion-Based Verification

SystemVerilog Assertions (SVA) are used to check design behavior during simulation.

The assertions cover:

- Write acknowledgment.
- Overflow and underflow detection.
- Full, empty, almost-full, and almost-empty flags.
- Read and write pointer wraparound.
- Pointer and occupancy counter limits.
- Reset behavior.

Cover properties are also included to identify whether selected scenarios have been exercised during simulation.

## Tools Used

- **SystemVerilog** — RTL design, testbench, and assertions.
- **QuestaSim** — RTL simulation, assertion checking, and coverage analysis.




