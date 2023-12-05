`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 12:35:11 AM
// Design Name: 
// Module Name: old_sobel_tb
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


module old_sobel_tb(

    );
    
    reg clk;
    reg start;
    reg rstn;
    
    old_sobel test(.clk(clk),.rstn(rstn),.start(start));
    
    always begin
        #0.001 clk=~clk;
    end
    always begin
       #1 start=1;
    end

    initial begin
        clk=1;
        start=0;
        #0.001 rstn=1;
        #0.001 rstn=0;
        #0.001 rstn=1;
    end
        
    
endmodule
