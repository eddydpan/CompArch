


## Notes

The example fade program has two states: a `PWM_INC` state and a `PWM_DEC` state. In order to implement a smooth HSV Color Wheel that smoothly cycles between colors requires another state--a steady state--that is neither increasing nor decreasing, but rather holding the PWM value at wherever it is. I am calling this state, `PWM_STD` (STD for steady)



## Design:

I want to keep my `pwm` module; it is very reusable and I can use it to update each of the RGB channels.

I also want to keep the code in `fade` module that calculates the `pwm_value`. I was considering utilizing 3 `fade` modules in my `top` module, but I want to ensure that the three `pwm_value`s for each RGB channel is using the same clock. Therefore, in my top module, I am deciding to use one `fade` module to calculate the RGB `pwm_value` to match the HSV color wheel and pairing it with three `pwm` modules to write to each RGB channel.

`inc_dec_count` is the timer for which the the triangle wave of increasing then decreasing occurs.

## Questions

If I have 3 `fade` modules each that use their own clk, would they be sync'd up? 

YES because it is an INPUT AHHHHHHHHHHhhh 