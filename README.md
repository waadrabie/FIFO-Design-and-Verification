# Synchronous FIFO Design & Verification (SystemVerilog)

This project implements and verifies a **Synchronous First-In, First-Out (FIFO)** using SystemVerilog. The project focuses on RTL debugging, FIFO control logic, and functional verification using a structured testbench environment.

## Features

- Configurable FIFO data width and depth
- Read and write pointer management
- Occupancy counter for tracking stored entries
- Full, empty, almost-full, and almost-empty flags
- Write acknowledgment (`wr_ack`)
- Overflow and underflow detection
- Active-low asynchronous reset
- Handling of simultaneous read and write requests
- RTL debugging and correction of control logic
- Modular verification environment including:
  - Interface and shared package
  - Transaction
  - Monitor
  - Scoreboard
  - Coverage
  - Testbench and top module
- **SystemVerilog Assertions (SVA)** for checking design behavior

## Verification

- Simulated using **QuestaSim**
- Verification plan covers:
  - Reset and initialization
  - FIFO read and write operations
  - Full and empty conditions
  - Almost-full and almost-empty thresholds
  - Overflow and underflow scenarios
  - Simultaneous read and write operations
  - Occupancy counter behavior
- Scoreboard-based checking of FIFO functionality
- Code coverage and functional coverage analysis
- Assertion coverage and simulation waveform inspection

## Tools

- **HDL:** SystemVerilog
- **Simulation:** QuestaSim
- **Verification:** SystemVerilog testbench, scoreboard, functional coverage, and assertions

