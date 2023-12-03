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
    output [7:0] data_out_r,
    output [7:0] data_out_g,
    output [7:0] data_out_b,
    output [15:0] height,
    output [15:0] width
    );
    
    
    //Tom
    wire[7:0] data;
    wire clk_prime;
    
    //Hamed
    wire[7:0] rom;
    wire[7:0] out_sobel;
    
    //Shining
    wire hsync;
    wire vsync;
    
    
    
    //Tom
    //Add ready signals for rgb2gray
    uart uart1(.clk(clk),.receive(uart_in),.dout(data),.sample(clk_prime));
    parse parse1(.clk(clk_prime),.reset(reset), .data_in(data), .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),.height(height),.width(width), .data_ready());
    
    //Hamed
    rgb2gray rgb2gray(.clk(clk_prime),.rstn(reset),.start(),.data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),.ready(),.rom(rom));
    sobel sobel(.ROM_Gray(rom),.clk(clk),.rstn(reset),.start(),.ready(),.out_sobel(out_sobel));
    
    //Shining
    top_module(.clock(clk),.red(out_sobel),.green(out_sobel),.blue(out_sobel),.hsync(hsync),.vsync(vsync));
    
    
endmodule
