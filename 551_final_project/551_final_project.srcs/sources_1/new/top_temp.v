`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 06:08:31 PM
// Design Name: 
// Module Name: top_temp
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


module top_temp(
    input uart_in,
    input clk,
    input reset,
    output [7:0] data_out_r,
    output [7:0] data_out_g,
    output [7:0] data_out_b,
    output [15:0] height,
    output [15:0] width
    );
    
    //Xiteng
    wire data_valid;
    
    
    //Tom
    wire[7:0] data;
    wire clk_prime;
    wire data_ready_parse;
    wire parse_sample;
    
    //Hamed
    wire[7:0] rom;
    wire[7:0] out_sobel;
    
    //Shining
    wire hsync;
    wire vsync;
    
    //Xiteng
    //uart_receiver uart(.clk(clk),.reset(reset),.rx(uart_in),.data(data),.data_valid(clk_prime));
    
    //Tom
    uart uart1(.clk(clk),.receive(uart_in),.dout(data),.sample(clk_prime));
    parse parse1(.clk(clk_prime),.reset(reset), .data_in(data), .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),.height(height),.width(width), .data_ready(data_ready_parse),.sample());
    
    //Hamed
    rgb2gray rgb2gray(.clk(parse_sample),.rstn(reset),.start(),.data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),.ready(data_ready_parse),.rom(rom));
    sobel sobel(.ROM_Gray(rom),.clk(parse_sample),.rstn(reset),.start(),.ready(),.out_sobel(out_sobel));
    
    //Shining
    top_module(.clock(clk),.red(out_sobel),.green(out_sobel),.blue(out_sobel),.hsync(hsync),.vsync(vsync));
    
    
endmodule
