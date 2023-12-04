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
    wire rgbready;
    wire sobelready;
    wire [7:0]rgbdata;
    wire [31:0]rgbaddress;
    wire[7:0] out_sobel;
    wire [7:0]data0;
    wire [7:0]data1;
    wire [7:0]data2;
    wire [7:0]data3;
    wire [7:0]data4;
    wire [7:0]data5;
    wire [7:0]data6;
    wire [7:0]data7;
    wire [7:0]data8;
    wire [15:0]read_H;
    wire [15:0]read_W;
    
    
    //Shining
    wire hsync;
    wire vsync;
    
    
    
    
    //Tom
    //Add ready signals for rgb2gray
    uart uart1(.clk(clk),.receive(uart_in),.dout(data),.sample(clk_prime));
    parse parse1(.clk(clk_prime),.reset(reset), .data_in(data), .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),.height(height),.width(width), .data_ready());
    
    //Hamed
    rgb2gray #(.H(height), .W(width)) rgb2gray(.clk(clk_prime),.rstn(reset),.data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),.ready(rgbready),.data_out(rgbdata),.address(rgbaddress));
    DualPortROM #(.H(height), .W(width)) DualPortROM(.read_H(read_H),.read_W(read_W),.write_address(rgbaddress),.ready(rgbready),.clk(clk_prime),.write_data(rgbdata),.data0(data0),.data1(data1),.data2(data2),.data3(data3),.data4(data4),.data5(data5),.data6(data6),.data7(data7),.data8(data8))
    sobel #(.H(height), .W(width)) sobel(.clk(clk),.rstn(reset),.start(rgbready),.ready(sobelready),.data0(data0),.data1(data1),.data2(data2),.data3(data3),.data4(data4),.data5(data5),.data6(data6),.data7(data7),.data8(data8),.W_counter(read_W),.H_counter(read_H),.data_out(out_sobel),.ready(sobelready));
    
    //Shining
    top_module(.clock(clk),.red(out_sobel),.green(out_sobel),.blue(out_sobel),.hsync(hsync),.vsync(vsync));
    
    
endmodule