`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 06:40:17 PM
// Design Name: 
// Module Name: sobel_v2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sobel_v2(
    input clk,
    input rstn,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready,
    input [15:0] H,
    input [15:0] W
    );    
        
    reg signed [15:0] Gx = 0, Gy = 0;
    reg [7:0] window[0:8]; // 3x3 window for Sobel
    integer i;
    
    // Counters
    reg [15:0] W_counter = 0, H_counter = 0;
    
    // State
    reg [2:0] state = 0;
    
    always @(posedge clk) begin
        if (!rstn) begin
            W_counter <= 0;
            H_counter <= 0; 
            ready <= 0;
            state <= 0;
            for (i = 0; i < 9; i = i + 1) window[i] <= 0;
        end
        else begin
            case (state)
                0: begin // Wait for start
                    if (start) state <= 1;
                end
                1: begin // Load data into window
                    for (i = 8; i > 0; i = i - 1) window[i] <= window[i - 1];
                    window[0] <= data_in;
                    
                    // Increment counters
                    if (W_counter < W - 1) begin
                        W_counter <= W_counter + 1;
                    end
                    else begin
                        W_counter <= 0;
                        if (H_counter < H - 1) H_counter <= H_counter + 1;
                        else H_counter <= 0;
                    end
    
                    // Check if window is filled
                    if (W_counter >= 2 && H_counter >= 2) state <= 2;
                end
                2: begin // Perform Sobel calculation
                    Gx <= -window[0] + window[6] +
                          -2*window[1] + 2*window[7] +
                          -window[2] + window[8];
                    
                    Gy <= -window[0] - 2*window[3] - window[6] +
                           window[2] + 2*window[5] + window[8];
    
                    data_out <= Gx + Gy;
                    ready <= 1;
                    state <= 1; // Go back to loading data
                end
            endcase
        end
    end

endmodule
