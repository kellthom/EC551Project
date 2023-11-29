`timescale 1ns / 1ps



module parse(
    input[7:0] data_in,
    input reset,
    input clk,
    output reg[7:0] data_out,
    output reg [15:0] height,
    output reg [15:0] width,
    output reg data_ready
    );
    
    //Count clock cycles
    integer count=0;
    
    initial begin
        data_ready=0;//Indictaes that the height and width have not yet been passed through
    end
    
  
    
    always@(posedge clk) begin
    
        //Zeroth and first byte reserved for height
        if (count==0) begin
            height[7:0]=data_in;
        end
        if (count==1) begin
            height[15:8]=data_in;
        end
        
        //Second and third byte reserves for width
        if (count==2) begin
            width[7:0]=data_in;
        end
        if (count==3) begin
            width[15:8]=data_in;
        end
        
        
        //Rest of bytes are rgb data
        if (count>3) begin
            data_ready=1;
            data_out=data_in;
        end
        
        count=count+1;
    
    
    end
    
    always@(posedge reset) begin
        count=0;
        data_ready=0;
    end
    
    
    
    
endmodule
