`timescale 1ns / 1ps

module rgb2gray
#(
    parameter H = 391,
    parameter W = 317
)
(
    input clk,
    input rstn,
    input[7:0] data_in_red,
    input[7:0] data_in_green,
    input[7:0] data_in_blue,
    output reg ready,
    output reg [7:0] data_out,
    output reg [31:0]address
    
);

    localparam R_coeff = 30;
    localparam G_coeff = 59;
    localparam B_coeff = 11;
    localparam ROM_SIZE = H * W;
    wire [7:0] gray_value;
    assign gray_value = (R_coeff * data_in_red + G_coeff * data_in_green + B_coeff * data_in_blue) >> 7;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            address <= 0;
            ready <= 0;
        end else if (start && address < ROM_SIZE) begin
            data_out <= gray_value;
            address <= address + 1;
            ready <= 0;
        end else if (address == ROM_SIZE) begin
            ready <= 1;
        end
    end
    
endmodule