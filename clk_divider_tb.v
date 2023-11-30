`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 05:28:58 PM
// Design Name: 
// Module Name: clk_divider_tb
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


module clk_divider_tb(

    );
    
    reg clk;
    wire clk_out;
    
    clk_divider test(.clk(clk),.clk_out(clk_out));
    
    
    initial begin
        clk=0;
    end
    
    always begin
        #10 clk=~clk;
    end
    
endmodule
