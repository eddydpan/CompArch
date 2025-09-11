// Blink

module top(
    input logic     clk, 
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    // CLK frequency is 12MHz, so 12,000,000 cycles is 1s
    parameter BLINK_INTERVAL = 12000000;
    parameter COLOR_CYCLE = 6;
    logic [2:0] cycle = 0; //only need 3 bits
    parameter SWITCH_COLOR_INTERVAL = BLINK_INTERVAL / COLOR_CYCLE; // Change color every 1/6 second
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

    always_ff @(posedge clk) begin
        // Reset count each second
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
            // LED <= ~LED;
        end

        // Increment count
        else begin
            count <= count + 1;
        end

        //

        case(count / SWITCH_COLOR_INTERVAL)
            0: begin RGB_R <= 1'b0; RGB_G <= 1'b1; RGB_B <= 1'b1; end // Red
            1: begin RGB_R <= 1'b0; RGB_G <= 1'b0; RGB_B <= 1'b1; end // Yellow
            2: begin RGB_R <= 1'b1; RGB_G <= 1'b0; RGB_B <= 1'b1; end // Green
            3: begin RGB_R <= 1'b1; RGB_G <= 1'b0; RGB_B <= 1'b0; end // Cyan
            4: begin RGB_R <= 1'b1; RGB_G <= 1'b1; RGB_B <= 1'b0; end // Blue
            5: begin RGB_R <= 1'b0; RGB_G <= 1'b1; RGB_B <= 1'b0; end // Magenta
            default: begin RGB_R <= 1'b0; RGB_G <= 1'b0; RGB_B <= 1'b0; end // Off
        endcase

    end

endmodule
