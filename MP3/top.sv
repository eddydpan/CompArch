`include "game_of_life.sv"
`include "ws2812b.sv"
`include "controller.sv"

// led_matrix top level module

module top(
    input logic     clk, 
    input logic     SW, 
    input logic     BOOT, 
    output logic    _48b, 
    output logic    _45a
);

    logic [7:0] green_data = 8'b00000000;
    logic [7:0] blue_data = 8'b00000000;
    logic [7:0] red_data = 8'b00000000;


    logic [5:0] pixel;
    // logic [4:0] frame;
    // logic [10:0] address;

    logic [23:0] shift_reg = 24'd0;
    logic load_sreg;
    logic transmit_pixel;
    logic shift;
    logic ws2812b_out;

    // assign address = { frame, pixel };

    // // Instance sample memory for red channel
    // memory #(
    //     .INIT_FILE      ("spiral/red.txt")
    // ) u1 (
    //     .clk            (clk), 
    //     .read_address   (address), 
    //     .read_data      (red_data)
    // );

    // // Instance sample memory for green channel
    // memory #(
    //     .INIT_FILE      ("spiral/green.txt")
    // ) u2 (
    //     .clk            (clk), 
    //     .read_address   (address), 
    //     .read_data      (green_data)
    // );

    // // Instance sample memory for blue channel
    // memory #(
    //     .INIT_FILE      ("spiral/blue.txt")
    // ) u3 (
    //     .clk            (clk), 
    //     .read_address   (address), 
    //     .read_data      (blue_data)
    // );


    // Game of Life state
    logic [63:0] green_game_board =  64'h0000_0000_1C00_0000;
    logic [63:0] green_next_state;
    // logic [63:0] init_board =  64'h0000_0000_1C00_0000; // Example: spinner
    //                              row0 row1 row2 row3 row4 row5 row6 row7
    //                              0000 0000 0001 1100 0000 0000 0000 0000
    //                              Bits at positions 18, 19, 20 (row 2, cols 3,4,5)
    logic green_game_done;
    logic red_game_done;
    logic blue_game_done;

    // logic start_game;
    logic green_game_ready = 1'b1;

    // Start a new game iteration at the beginning of each frame
    assign green_start_game = (pixel == 6'd0) && load_sreg && green_game_ready;

    always_ff @(posedge clk) begin
        if (green_start_game) begin
            green_game_ready <= 1'b0;
        end
        else if (clk == 1'b0 && green_game_done) begin
            green_game_ready <= 1'b1;
        end
    end

    always_ff @(posedge green_game_done) begin
        green_game_board <= green_next_state;
        // this is triggering on game done but only once per game_done
    end

    // Game of Life instance
    game_of_life green (
        .clk(clk),
        .start(green_start_game),
        .init_state(green_game_board),
        .curr_state(green_next_state),
        .done(green_game_done)
    );

    game_of_life red (
        .clk(clk),
        .start(red_start_game),
        .init_state(red_game_board),
        .curr_state(red_next_state),
        .done(red_game_done)
    );

    game_of_life blue (
        .clk(clk),
        .start(blue_start_game),
        .init_state(blue_game_board),
        .curr_state(blue_next_state),
        .done(blue_game_done)
    );

    // Instance the WS2812B output driver
    ws2812b u4 (
        .clk            (clk), 
        .serial_in      (shift_reg[23]), 
        .transmit       (transmit_pixel), 
        .ws2812b_out    (ws2812b_out), 
        .shift          (shift)
    );

    // Instance the controller
    controller u5 (
        .clk            (clk), 
        .load_sreg      (load_sreg), 
        .transmit_pixel (transmit_pixel), 
        .pixel          (pixel), 
        .frame          (frame)
    );

    always_ff @(posedge clk) begin
        if (game_board[pixel] == 1'b1) begin
            green_data <= 8'hFF;
            red_data <= 8'h00;
            blue_data <= 8'h00;
        end
        else begin
            green_data <= 8'h00;
            red_data <= 8'h00;
            blue_data <= 8'h00;
        end

        if (load_sreg) begin
            unique case ({ SW, BOOT })
                2'b00:
                    shift_reg <= { green_data, 16'd0 };
                2'b01:
                    shift_reg <= { 8'd0, red_data, 8'd0 };
                2'b10:
                    shift_reg <= { 16'd0, blue_data };
                2'b11:
                    shift_reg <= { green_data, red_data, blue_data };
            endcase
        end
        else if (shift) begin
            shift_reg <= { shift_reg[22:0], 1'b0 };
        end
    end


    assign _48b = ws2812b_out;
    assign _45a = ~ws2812b_out;

endmodule
