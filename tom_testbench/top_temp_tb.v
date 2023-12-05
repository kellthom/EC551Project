`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 10:20:47 PM
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
    
    reg clk;
    wire[7:0] data;
    wire[7:0] data_out_r;
    wire[7:0] data_out_b;
    wire[7:0] data_out_g;
    wire[7:0] gray_out;
    
    top_temp test(.clk(clk),.data(data),.data_out_r(data_out_r),.data_out_b(data_out_b),.data_out_g(data_out_g),.gray_out(gray_out));
    
    initial begin
        clk=1;
    end
    
    always begin
        #0.001 clk=~clk;
    end
endmodule
