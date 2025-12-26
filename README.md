# CompArch

This repository serves as a track record of the projects I implemented for `ENGR3410 -- Computer Architecture` at Olin College of Engineering. This work includes all of my miniprojects and final project code.

## MP1: Blinking RGB

A simple introduction to SystemVerilog and FPGA development: this project implements a basic RGB LED blink pattern on the iceBlinkPico, cycling through colors at discrete 60-degree intervals around the color wheel (red > yellow > green > cyan > blue > magenta). The implementation uses a finite state machine to control each RGB channel's on/off state.

See [MP1 README](MP1/README.md) for more details.

## MP2: HSV Color Wheel

Building on MP1, this project creates smooth color transitions through the HSV color wheel using PWM. The implementation features a modular design with separate `fade` and `pwm` modules for each RGB channel. The `fade` module generates trapezoidal waveforms through a 6-state FSM, enabling smooth transitions between colors at 60-degree segments, while the `pwm` module converts these values into digital RGB outputs.

See [MP2 README](MP2/README.md) for more details.

## MP3: Conway's Game of Life on an LED Matrix

An implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) on a **WS2812B 8x8 RGB LED Matrix**. The project runs three simultaneous Game of Life simulations--one per color channel (red, green, blue)--each starting from different initial states. The design handles cyclic boundary conditions to better emulate an infinite 2D grid, allowing stable patterns like the Glider to travel indefinitely.

See [MP3 README](MP3/README.md) for more details.

## MP4: Unpipelined Multicycle RISC-V Processor

A complete 32-bit RISC-V processor implementation using a 6-stage multicycle architecture (`IDLE`, `FETCH`, `DECODE`, `EXECUTE`, `MEMORY`, `WRITEBACK`). The processor supports the full **RV32I instruction set** including R-type, I-type, B-type, J-type, S-type, and U-type instructions. The modular design includes a 32-register file, ALU with flag support, immediate generator, and instruction/data memory. The processor achieves a throughput of 1 instruction per 6 cycles with an RGB LED providing visual feedback based on instruction opcodes.

See [MP4 README](MP4/README.md) for more details.

## Final Project: FPGA Sequencer

A digital beat sequencer implemented on the iceBlinkPico with integrated hardware peripherals and Qt-based PC visualization. The sequencer features a 16-beat step sequencer with 8 selectable pitches (C4-C5 octave) controlled via a 4x4 button matrix and rotary encoder. Audio output is generated using PWM square waves to a buzzer, while a seven-segment display shows the currently selected pitch. The system includes UART communication to stream sequencer state to a custom Qt GUI visualizer for real-time feedback and validation.

See [FPGA Sequencer README](fpga-sequencer/README.md) for more details.

