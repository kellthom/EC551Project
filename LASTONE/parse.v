
`timescale 1ns / 1ps

//Thomas Kelly

module parse_v2(
    input clk,
    input reset,
    input[7:0] data_in,
    input data_valid,
    
    output reg[7:0] data_out_r,
    output reg[7:0] data_out_g,
    output reg[7:0] data_out_b,
    output reg [15:0] height,
    output reg [15:0] width,
    output reg dimension_received,
    output reg one_byte_ready
    
    );
    
    //Count clock cycles
    integer count=0;
    
    reg[7:0] data_r;
    reg[7:0] data_g;
        
    always@(posedge clk) begin
    if(reset)begin
         count = 0;
         dimension_received = 0;
         one_byte_ready = 0;
    end
    else begin
        one_byte_ready = 0;
        
        if (data_valid ) begin
            //Zeroth and first byte reserved for height
            if (count==0) begin
                height[15:8]=data_in;
            end
            if (count==1) begin
                height[7:0]=data_in;
            end
            
            //Second and third byte reserved for width
            if (count==2) begin
                width[15:8]=data_in;
            end
            if (count==3) begin
                width[7:0]=data_in;
            end
            
            
            //Rest of bytes are rgb data
            if (count>3) begin
                dimension_received=1;
                if((count-4)%3==0) begin
                    data_r=data_in;
                end
                if((count-4)%3==1) begin
                    data_g=data_in;
                end
                if((count-4)%3==2) begin
                    one_byte_ready = 1;
                    data_out_b=data_in;
                    data_out_r=data_r;
                    data_out_g=data_g;
                end
            end
            
            
            count=count+1;
            end
        end
    
    end
    
//    always@(posedge reset) begin
//        count = 0;
//        dimension_received = 0;
//        one_byte_ready = 0;
//    end
    
    
    
    
endmodule