module game_of_life(
    input logic clk, 
    input logic start,
    input logic [63:0] init_state,
    output logic [63:0] curr_state, 
    output logic done,
    output logic updating
);

    logic [63:0] next_state = 64'b0;
    logic [5:0] index = 6'd0;
    logic [3:0] alive_neighbors;

    initial begin
        done = 1'b0;
        updating = 1'b0;
    end

    always_comb begin
        // Calculate neighbors for current cell
        alive_neighbors = count_alive_neighbors(init_state, index);
    end

    always_ff @(posedge clk) begin
        if (start && !updating) begin
            index <= 6'd0;
            updating <= 1'b1;
            done <= 1'b0;
        end 
        else if (updating) begin
        
            // Apply GOL rules
            if (alive_neighbors == 4'd3 || 
                (alive_neighbors == 4'd2 && init_state[index])) begin
                next_state[index] <= 1'b1;
            end else begin
                next_state[index] <= 1'b0;
            end
            
            // Last cell, update curr_state and set done flag
            if (index == 6'd63) begin
                curr_state <= next_state;
                done <= 1'b1;
                updating <= 1'b0;
            end else begin
                index <= index + 6'd1;
            end
        end
        else begin
            done <= 1'b0;
        end
    end

    // Function to count alive neighbors
    function automatic [3:0] count_alive_neighbors(
        input logic [63:0] board,
        input logic [5:0] idx
    );
        logic [2:0] row, col;
        logic [2:0] row_above, row_below, col_left, col_right;
        logic [5:0] n_idx[0:7];  // neighbor indices
        
        row = idx[5:3];  // idx / 8
        col = idx[2:0];  // idx % 8
        
        // Calculate wrapped coordinates
        row_above = (row == 3'd0) ? 3'd7 : (row - 3'd1);
        row_below = (row == 3'd7) ? 3'd0 : (row + 3'd1);
        col_left  = (col == 3'd0) ? 3'd7 : (col - 3'd1);
        col_right = (col == 3'd7) ? 3'd0 : (col + 3'd1);
        
        // Calculate neighbor indices
        n_idx[0] = {row_above, col_left};   // top-left
        n_idx[1] = {row_above, col};        // top
        n_idx[2] = {row_above, col_right};  // top-right
        n_idx[3] = {row, col_left};         // left
        n_idx[4] = {row, col_right};        // right
        n_idx[5] = {row_below, col_left};   // bottom-left
        n_idx[6] = {row_below, col};        // bottom
        n_idx[7] = {row_below, col_right};  // bottom-right

        // Count alive neighbors
        count_alive_neighbors = board[n_idx[0]] + board[n_idx[1]] + 
                               board[n_idx[2]] + board[n_idx[3]] +
                               board[n_idx[4]] + board[n_idx[5]] + 
                               board[n_idx[6]] + board[n_idx[7]];
    endfunction

endmodule