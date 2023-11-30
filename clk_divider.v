`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 05:23:48 PM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input clk,
    output reg clk_out
    );
    
    parameter cycles_per_bit=4;//10000000/115200;
    
    integer counter;
    
    initial begin
        counter=0;
        clk_out=0;
    end
    
    always@(posedge clk) begin
        counter=counter+1;
        if (counter==(cycles_per_bit/2)) begin
            clk_out=~clk_out;
            counter=0;
        end
    end
    
endmodule
