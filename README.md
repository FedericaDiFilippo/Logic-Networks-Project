# VHDL Hardware Module for Sequence Processing

This project involves the design and implementation of a VHDL hardware module capable of processing a sequence of 8-bit words. The project adheres to the specifications outlined in the accompanying report and implements a convolution encoding algorithm using a Mealy state machine architecture. The component is designed to interact with a synchronous memory for both input and output operations.

## Features

- **Convolution Encoding Algorithm**: Processes input sequences and produces encoded output sequences as per the specified state machine logic.
- **Mealy State Machine**: Implements a finite state machine to determine the next state and output based on the current state and input.
- **Memory Interface**: Reads data from and writes processed results back to a synchronous memory.
- **Synthesis and Simulation**: Tested and validated for functional correctness under various scenarios.

## Component Interface

The VHDL module uses the following signals:

- `i_clk`: Clock signal (input).
- `i_rst`: Reset signal for initializing the module (input).
- `i_start`: Start signal to begin processing (input).
- `i_data`: 8-bit input data from memory (input).
- `o_address`: 16-bit output address for memory operations (output).
- `o_done`: Signal indicating the completion of processing (output).
- `o_en`: Enable signal for memory communication (output).
- `o_we`: Write enable signal for memory operations (output).
- `o_data`: 8-bit output data written to memory (output).

## How It Works

1. The component waits for the `i_start` signal to begin processing.
2. Reads a specified number of 8-bit words from memory.
3. Processes each word through the Mealy state machine to generate two output words for each input word.
4. Writes the resulting sequence to the memory.
5. Signals the completion of the process through `o_done`.

## Synthesis and Performance

- **Resource Utilization**: The design uses 93 LUTs and 70 Flip-Flops, with no latches, ensuring a compact and efficient implementation.
- **Timing**: The design meets timing requirements with a slack of 97.113 ns for a clock period of 100 ns.
- **Simulation**: The module passed all behavioral and post-synthesis functional tests under various edge cases, confirming its correctness and reliability.

## Repository Contents

- `Project.vhd`: The VHDL code for the hardware module.
- `Relazione.pdf`: The detailed report describing the project, including specifications, architecture, and test results.

## Academic Recognition

This project was developed as part of a course on logic networks at Politecnico di Milano during the academic year 2021-2022 with the evaluation of 30L.

## Usage

To use this module:
1. Include the `Project.vhd` file in your VHDL project.
2. Configure the testbench with the desired input data and clock/reset signals.
3. Run synthesis and simulation to validate the module in your environment.

## Author

Federica Di Filippo  
Politecnico di Milano  

