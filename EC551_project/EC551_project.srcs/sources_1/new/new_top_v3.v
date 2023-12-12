`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 10:39:30 PM
// Design Name: 
// Module Name: new_top_v3
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


module new_top_v3(
    input wire clk, 
    input wire reset,
    input wire rx,
    
    output wire tx,
    output wire tx_active,
    output wire reset_light,
    
    output wire dimension_light,
    output [1:0] height_light,
    output [1:0] width_light

    );
    
    assign reset_light = reset;
    
    wire [7:0] data;
    wire data_valid;
    
//    localparam BAUD_VAL = 10417; // matching the 9600 baud rate
    localparam BAUD_VAL = 868; // machign the 115200 baud rate 
    
    
    uart_receiver #(.BAUD_VAL(BAUD_VAL)) recv (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        
        .data(data),
        .data_valid(data_valid)
    );
    
    
    wire [7:0] data_out_r, data_out_g, data_out_b;
    wire [15:0] height, width;
    wire dimension_received, one_byte_ready;
    wire [7:0] gray_out;
    
    parse_v2 parse1(
    .clk(clk),
    .reset(reset),
    .data_in(data),
    .data_valid(data_valid),
    
    .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),
    .height(height),.width(width),
    .dimension_received(dimension_received),
    .one_byte_ready(one_byte_ready)
    );
    
    rgb2gray rgb2gray(
    .data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),
    .data_out(gray_out));
    
    
     wire tx_temp;
     uart_transmitter #(.BAUD_VAL(BAUD_VAL)) trans (
        .clk(clk),
        .data_valid(data_valid),
        .reset(reset),
        .data_in(data),
        
        .tx(tx_temp),
        .tx_active(tx_active),
        .tx_done()
    );
    
    
    assign tx = tx_active ? tx_temp : 1'b1;
    
    assign height_light = height[9:8];
    assign width_light = width[9:8];

    assign dimension_light = dimension_received;
    
    
endmodule

