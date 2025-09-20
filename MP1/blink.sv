module top(
    input logic    clk, 
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    // CLK frequency is 12MHz, so 12,000,000 cycles is 1s
    localparam BLINK_INTERVAL = 12000000;
    localparam COLOR_CYCLE = 6;
    localparam SWITCH_COLOR_INTERVAL = BLINK_INTERVAL / COLOR_CYCLE; // Change color every 1/6 second
    localparam COUNT_BITS = $clog2(BLINK_INTERVAL);
    logic [COUNT_BITS - 1:0] count = 0;

    always_ff @(posedge clk) begin
        // Reset count each second
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
        end

        // Increment count
        else begin
            count <= count + 1;
        end

    end

    always_comb begin
        // Change color based on count (use blocking assignment)
        case(count / SWITCH_COLOR_INTERVAL)
            0: {RGB_R, RGB_B, RGB_G} = 3'b011; // Red
            1: {RGB_R, RGB_B, RGB_G} = 3'b001; // Yellow
            2: {RGB_R, RGB_B, RGB_G} = 3'b101; // Green
            3: {RGB_R, RGB_B, RGB_G} = 3'b100; // Cyan
            4: {RGB_R, RGB_B, RGB_G} = 3'b110; // Blue
            5: {RGB_R, RGB_B, RGB_G} = 3'b010; // Magenta
            default: {RGB_R, RGB_B, RGB_G} = 3'b000; // Off
        endcase
    end

endmodule
