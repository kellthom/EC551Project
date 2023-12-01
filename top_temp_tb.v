`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 06:18:33 PM
// Design Name: 
// Module Name: top_temp_tb
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


module top_temp_tb(

    );
    
    reg uart_in;
    reg clk;
    wire[7:0] data_out_r;
    wire[7:0] data_out_g;
    wire[7:0] data_out_b;
    wire[7:0] height;
    wire[7:0] width;
    
    top_temp test(.uart_in(uart_in),.clk(clk),.data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),.height(height),.width(width));
endmodule
