# Synchronous FIFO Design & Verification (SystemVerilog)

This project debugs and verifies a Synchronous First-In, First-Out (FIFO) buffer using SystemVerilog. The project focuses on RTL debugging of the FIFO control logic and functional verification with a structured, constrained-random testbench.

## Features

* Parameterized data width and depth (default: 16-bit data, 8 entries)
* Read and write pointer management with wrap-around
* Occupancy counter for tracking stored entries
* Full, empty, almost-full, and almost-empty flags
* Write acknowledgment (`wr_ack`)
* Overflow and underflow detection (registered outputs)
* Active-low asynchronous reset
* Correct handling of simultaneous read and write requests:
   * FIFO empty: only the write takes place and the count increases
   * FIFO full: only the read takes place and the count decreases
* RTL debugging and correction of control logic
* Modular verification environment including:
   * Interface with `DUT`, `TEST`, and `MONITOR` modports
   * Shared package
   * Transaction class with constrained-random stimulus
   * Monitor
   * Scoreboard
   * Coverage collector
   * Testbench and top module
* SystemVerilog Assertions (SVA) for checking design behavior

## Verification

* Simulated using QuestaSim
* Verification plan (`FIFO_1` to `FIFO_12`) covers:
   * Reset and initialization (outputs, pointers, and counter)
   * FIFO write operation and write acknowledgment
   * FIFO read operation and `data_out` value
   * Full and empty conditions
   * Almost-full (`FIFO_DEPTH - 1`) and almost-empty (count = 1) thresholds
   * Overflow and underflow scenarios
   * Read and write pointer wrap-around
   * Occupancy counter limits
* Stimulus runs in three phases using `constraint_mode`:
   * Write-only (1,000 transactions)
   * Read-only (1,000 transactions)
   * Mixed read and write (10,000 transactions, 70% write enable and 30% read enable by default)
* Reset is deasserted most of the time (95%) during randomized phases
* Scoreboard-based checking of DUT outputs against a reference model
* Code coverage and functional coverage analysis
* Assertion coverage and simulation waveform inspection

### Results

| Metric | Result |
|--------|--------|
| Correct transactions | 12,000 |
| Errors | 0 |
| Functional coverage | 100% |
| Toggle and condition coverage | 100% |
| Assertion cover directives | All at 100% |

Functional coverage includes coverpoints on `wr_en`, `rd_en`, and every flag, plus crosses for `wr_ack`, `overflow`, `full`, `underflow`, and `empty`, with impossible combinations excluded using `ignore_bins`.

## Bugs Fixed

* Changed the design file from `.v` to `.sv` and connected it through the interface
* Cleared `wr_ack` and `overflow` in reset in the write block
* Cleared `data_out` and `underflow` in reset in the read block
* Reset `overflow` to zero on a successful write so it does not hold a past value
* Replaced the bitwise `&` with `&&` in the overflow condition
* Changed `underflow` from combinational to sequential
* Added counter conditions for simultaneous read and write when the FIFO is empty or full

## Tools

* HDL: SystemVerilog
* Simulation: QuestaSim
* Verification: SystemVerilog testbench, scoreboard, functional coverage, and assertions

## Project Documentation

The project report includes the verification plan, the original and fixed RTL, the verification environment code, simulation snippets, code and functional coverage reports, and the assertion coverage results.

## Author

Waad Rabie Mahmoud
