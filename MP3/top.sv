`include "game_of_life.sv"
`include "ws2812b.sv"
`include "controller.sv"

module top(
    input logic     clk, 
    input logic     SW, 
    input logic     BOOT, 
    output logic    _48b, 
    output logic    _45a
);

    logic [5:0] pixel;
    logic [4:0] frame;

    logic [23:0] shift_reg = 24'd0;
    logic load_sreg;
    logic transmit_pixel;
    logic shift;
    logic ws2812b_out;

    // Shared game control flags
    logic game_start;
    logic game_done;
    logic game_updating;
    
    // Trigger game update once per frame
    assign game_start = (pixel == 6'd0) && load_sreg && !game_updating;

    logic [63:0] green_board = 64'h0000_0000_0000_0000; 
    logic [63:0] red_board = 64'h0000_0000_0000_0000;
    logic [63:0] blue_board = 64'h0000_0000_0000_0000;

    logic [0:63] green_init_board [0:0]; // 64 element unpacked array
    logic [0:63] red_init_board [0:0];
    logic [0:63] blue_init_board [0:0];

    logic boards_initialized = 1'b0;

    logic [63:0] green_next;
    logic [63:0] red_next;
    logic [63:0] blue_next;

    logic green_done, red_done, blue_done;
    logic green_updating, red_updating, blue_updating;

    // All games done when all three complete
    assign game_done = green_done && red_done && blue_done;
    
    assign game_updating = green_updating || red_updating || blue_updating;
    
    
    initial begin
        $readmemh("initial_led_state/green.txt", green_init_board);
        $readmemh("initial_led_state/red.txt", red_init_board);
        $readmemh("initial_led_state/blue.txt", blue_init_board);
    end

    // Update all boards when all calculations complete
    always_ff @(posedge clk) begin

         if (boards_initialized == 1'b0) begin
            green_board = green_init_board[0];
            red_board   = red_init_board[0];
            blue_board  = blue_init_board[0];
            boards_initialized = 1'b1;
        end
        else if (game_done) begin
            green_board <= green_next;
            red_board   <= red_next;
            blue_board  <= blue_next;
        end
    end

    // ========== THREE GAME INSTANCES ==========
    game_of_life green (
        .clk(clk),
        .start(game_start),
        .init_state(green_board),
        .curr_state(green_next),
        .done(green_done),
        .updating(green_updating)
    );

    game_of_life red (
        .clk(clk),
        .start(game_start),
        .init_state(red_board),
        .curr_state(red_next),
        .done(red_done),
        .updating(red_updating)
    );

    game_of_life blue (
        .clk(clk),
        .start(game_start),
        .init_state(blue_board),
        .curr_state(blue_next),
        .done(blue_done),
        .updating(blue_updating)
    );

    
    ws2812b u4 (
        .clk            (clk), 
        .serial_in      (shift_reg[23]), 
        .transmit       (transmit_pixel), 
        .ws2812b_out    (ws2812b_out), 
        .shift          (shift)
    );

    controller u5 (
        .clk            (clk), 
        .load_sreg      (load_sreg), 
        .transmit_pixel (transmit_pixel), 
        .pixel          (pixel), 
        .frame          (frame)
    );

    // Load shift register with RGB data based on switches
    always_ff @(posedge clk) begin
        if (load_sreg) begin
            logic g_alive, r_alive, b_alive;
            g_alive = green_board[pixel];
            r_alive = red_board[pixel];
            b_alive = blue_board[pixel];
            
            unique case ({ SW, BOOT })
                2'b00:  // Green only
                    shift_reg <= {g_alive ? 8'h0F : 8'h00, 16'h0000};
                2'b01:  // Red only
                    shift_reg <= {8'h00, r_alive ? 8'h0F : 8'h00, 8'h00};
                2'b10:  // Blue only
                    shift_reg <= {16'h0000, b_alive ? 8'h0F : 8'h00};
                2'b11:  // All colors combined
                    shift_reg <= {g_alive ? 8'h0F : 8'h00,
                                  r_alive ? 8'h0F : 8'h00,
                                  b_alive ? 8'h0F : 8'h00};
            endcase
        end
        else if (shift) begin
            shift_reg <= { shift_reg[22:0], 1'b0 };
        end
    end

    assign _48b = ws2812b_out;
    assign _45a = ~ws2812b_out;

endmodule