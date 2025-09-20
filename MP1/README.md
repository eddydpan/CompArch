# ENGR3410: MiniProject 1 -- Blinking RGB

## For submission:

1. source files in this directory (blink.sv)
2. video demo: MP1_video_demo.MOV

## Brief reflection:
I enjoyed this mini project. I liked that it was pretty straightforward, and the only challenging part was learning the proper syntax and style for SystemVerilog. Thank you to CA Drew Pang for giving me a review of my source code and pointing out style changes and code changes such as consistent port indents, using `localparam` instead of `parameter`, and breaking out my implementation for my case block into an `always_comb`.


## Notes During Implementation
0° = red = (R=1,G=0,B=0)
60° = yellow = (1,1,0)
120° = green = (0,1,0)
180° = cyan = (0,1,1)
240° = blue = (0,0,1)
300° = magenta = (1,0,1)

Red channel is ON for 300, 0, and 60 degrees
Green channel is ON for 60, 120, and 180 degrees
Blue channel is ON for 180, 240, and 300 degrees

Hold red channel from [300, 119] degrees
Hold green channel from [60,239] degrees
Hold blue channel from [180,359] degrees

Each are held for 180 degrees
