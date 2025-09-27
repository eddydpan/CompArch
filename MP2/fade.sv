// Fade calculates the PWM value to create a fading effect on an LED

module fade #(
    parameter INITIAL_STATE = 3'b000,       // Default to the inc state
    parameter INC_DEC_INTERVAL = 12000,     // CLK frequency is 12MHz, so 12,000 cycles is 1ms
    parameter INC_DEC_MAX = 166,            // Transition to next state after 166 increments / decrements, which is 0.166s
    parameter PWM_INTERVAL = 1200,          // CLK frequency is 12MHz, so 1,200 cycles is 100us
    parameter INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX
)(
    input logic clk, 
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value
);

    // Define state variable values
    localparam pwm_inc = 3'b000;
    localparam pwm_hi = 3'b001;
    localparam pwm_hi2 = 3'b010;
    localparam pwm_dec = 3'b011;
    localparam pwm_lo = 3'b100;
    localparam pwm_lo2 = 3'b101;

    // Declare state variables
    logic [2:0] current_state = INITIAL_STATE;
    logic [2:0] next_state;

    // Declare variables for timing state transitions
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;
    logic time_to_transition = 1'b0;

    initial begin
        case (INITIAL_STATE)
            pwm_hi,
            pwm_hi2,
            pwm_dec:
                pwm_value = PWM_INTERVAL;
            pwm_lo,
            pwm_lo2,
            pwm_inc:
                pwm_value = 0;
            default:
                pwm_value = 0;
        endcase
    end

    // Register the next state of the FSM
    always_ff @(posedge time_to_transition)

        // current_state <= (current_state == 3'b101) ? 3'b000 : current_state + 1; // wrap around to initial state
        current_state <= next_state;

    // Compute the next state of the FSM
    always_comb begin
        next_state = 3'bxxx;
        case (current_state)
            pwm_inc:
                next_state = pwm_hi;
            pwm_hi:
                next_state = pwm_hi2;
            pwm_hi2:
                next_state = pwm_dec;
            pwm_dec:
                next_state = pwm_lo;
            pwm_lo:
                next_state = pwm_lo2;
            pwm_lo2:
                next_state = pwm_inc; 
        endcase
    end

    // Implement counter for incrementing / decrementing PWM value
    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end
        else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end

    // Increment / Decrement PWM value as appropriate given current state
    always_ff @(posedge time_to_inc_dec) begin
        case (current_state)
            pwm_inc:
                pwm_value <= pwm_value + INC_DEC_VAL;
            pwm_dec:
                pwm_value <= pwm_value - INC_DEC_VAL;

        endcase
    end

    // Implement counter for timing state transitions
    always_ff @(posedge time_to_inc_dec) begin
        if (inc_dec_count == INC_DEC_MAX - 1) begin
            inc_dec_count <= 0;
            time_to_transition <= 1'b1;
        end
        else begin
            inc_dec_count <= inc_dec_count + 1;
            time_to_transition <= 1'b0;
        end
    end

endmodule
