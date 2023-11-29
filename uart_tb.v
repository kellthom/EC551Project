`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2023 04:50:19 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(

    );
    
    reg clk;
    reg rec;
    wire[7:0] dout;
    
    uart test(.clk(clk),.rec(rec),.dout(dout));
    
    initial begin
        clk=0;
        rec=1;
    end
    
    always begin
        #1 clk=~clk;
    end
    
    always begin
        #50 rec=0;
        #40 rec=0;
        #40 rec=0;
        #40 rec=1;
        #40 rec=1;
        #40 rec=0;
        #40 rec=1;
        #40 rec=0;
        #40 rec=0;
        #40 rec=1;
        
        #50 rec=0;
        #40 rec=0;
        #40 rec=0;
        #40 rec=0;
        #40 rec=1;
        #40 rec=1;
        #40 rec=1;
        #40 rec=0;
        #40 rec=0;
        #40 rec=1;
    end
    
    
endmodule
