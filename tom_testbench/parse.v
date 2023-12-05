`timescale 1ns / 1ps

//Thomas Kelly

module parse(
    input[7:0] data_in,
    input reset,
    input clk,
    
    output reg[7:0] data_out_r,
    output reg[7:0] data_out_g,
    output reg[7:0] data_out_b,
    output reg [15:0] height,
    output reg [15:0] width,
    output reg data_ready,
    output reg sample
    
    );
    
    //Count clock cycles
    integer count=3;
    
    reg[7:0] data_r;
    reg[7:0] data_g;
    
    initial begin
        data_ready=0;//Indictaes that the height and width have not yet been passed through
    end
  
    
    always@(posedge clk) begin
        sample=0;
        
        //Zeroth and first byte reserved for height
        if (count==0) begin
            height[7:0]=data_in;
        end
        if (count==1) begin
            height[15:8]=data_in;
        end
        
        //Second and third byte reserved for width
        if (count==2) begin
            width[7:0]=data_in;
        end
        if (count==3) begin
            width[15:8]=data_in;
        end
        
        
        //Rest of bytes are rgb data
        if (count>3) begin
            data_ready=1;
            if((count-4)%3==0) begin
                data_r=data_in;
            end
            if((count-4)%3==1) begin
                data_g=data_in;
            end
            if((count-4)%3==2) begin
                sample=1;
                data_out_b=data_in;
                data_out_r=data_r;
                data_out_g=data_g;
            end
        end
        
        
        count=count+1;
        
    
    end
    
    always@(posedge reset) begin
        count=0;
        data_ready=0;
        sample=0;
    end
    
    
    
    
endmodule
