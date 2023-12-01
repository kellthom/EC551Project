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
    
    wire[7:0] data;
    wire clk_prime;
    
    
    //clk_divider clkdiv(.clk(clk),.clk_out(clk_prime));
    uart uart1(.clk(clk),.receive(uart_in),.dout(data),.sample(clk_prime));
    parse parse1(.clk(clk_prime),.reset(reset), .data_in(data), .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),.height(height),.width(width), .data_ready());
    
endmodule
