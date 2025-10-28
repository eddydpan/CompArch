# MP3: Conway's Game of Life

## Adaptable Sample Code

### `ws2812b` module 
State machine to handle how the WS2812B handles input signals and "latching" states to each of the sixty-four 24-bit RGB LEDs. 

State machine for sending bits over serial based on `clk` input
- IDLE
- TRANSMITTING

Essentially, I can use this module to write whatever I have in my shift-register over to the board.

### `controller` module

### `top` module
Load shift register in conjunction with the `ws2812b` module to update `_48b` pin with the signal

## What to do
Update the load shift register according to Conway's game of life using another module: "game_of_life()