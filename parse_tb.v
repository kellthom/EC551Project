`timescale 1ns / 1ps





module parse_tb(

    );
    
    reg clk, reset;
    reg[7:0] data_in;
    wire[7:0] data_out;
    wire[15:0] height;
    wire[15:0] width;
    wire data_ready;
    
    parse test(.clk(clk),.reset(reset), .data_in(data_in), .data_out(data_out),.height(height),.width(width), .data_ready(data_ready));
    
    
    initial begin
        clk=0;
    end
    
    always begin;
        
        #10 clk=~clk;
        data_in=8'b10111110;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b10001110;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b10111000;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b00111110;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b00111111;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b10110110;
        #10 clk=~clk;
        #10 clk=~clk;
        data_in=8'b11011110;
        
        
    end
        
    
endmodule
