`include "fade.sv"
`include "pwm.sv"

// Fade top level module

module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic     clk, 
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    logic [$clog2(PWM_INTERVAL) - 1:0] rgb_r_pwm_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] rgb_g_pwm_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] rgb_b_pwm_value;
    logic rgb_r_pwm_out;
    logic rgb_g_pwm_out;
    logic rgb_b_pwm_out;

    fade #(
        .INITIAL_STATE  (3'b010), // start at pwm_hi1
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u1 (
        .clk            (clk), 
        .pwm_value      (rgb_r_pwm_value)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u2 (
        .clk            (clk), 
        .pwm_value      (rgb_r_pwm_value), 
        .pwm_out        (rgb_r_pwm_out)
    );

    fade #(
        .INITIAL_STATE  (3'b000), // start at pwm_inc
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u3 (
        .clk            (clk), 
        .pwm_value      (rgb_g_pwm_value)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u4 (
        .clk            (clk), 
        .pwm_value      (rgb_g_pwm_value), 
        .pwm_out        (rgb_g_pwm_out)
    );

    fade #(
        .INITIAL_STATE  (3'b100),   // start at pwm_lo
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u5 (
        .clk            (clk), 
        .pwm_value      (rgb_b_pwm_value)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u6 (
        .clk            (clk), 
        .pwm_value      (rgb_b_pwm_value), 
        .pwm_out        (rgb_b_pwm_out)
    );


    assign RGB_R = ~rgb_r_pwm_out;
    assign RGB_G = ~rgb_g_pwm_out;
    assign RGB_B = ~rgb_b_pwm_out;

endmodule
