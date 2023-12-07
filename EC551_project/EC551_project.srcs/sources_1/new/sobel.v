`timescale 1ns / 1ps

module sobel #(parameter BAUD_VAL =9)
    (
        input clk,
        input rstn,
        input start,
        input [7:0] data0,
        input [7:0] data1,
        input [7:0] data2,
        input [7:0] data3,
        input [7:0] data4,
        input [7:0] data5,
        input [7:0] data6,
        input [7:0] data7,
        input [7:0] data8,
        output reg[15:0] W_counter  ,
        output reg[15:0] H_counter ,
        output reg [7:0]data_out,
        output reg ready,
        output reg transmit_valid,
        input [15:0]H,
        input [15:0]W 

    );    
    
                
    reg signed[15:0]   Gx = 0,
                       Gy = 0;
            
    integer first_time = 0;
    reg final = 0;
    
    integer count = 0;
     
    always @(posedge clk) begin
        if(rstn) begin
            first_time = 0;
            W_counter <=0;
            H_counter <= 0; 
            ready  <= 0;
            count = 0;
            final <= 0;
            transmit_valid = 1'b0;
        end else begin
            count = count + 1;
            if(start && !ready && (count >= 12 * BAUD_VAL) && (first_time >= 5)) begin
                count = 0;
                data_out = Gx + Gy;
                
    //            if (Gx + Gy > 8'd200) begin
    //                data_out = 8'd255;
    //            end else begin
    //                data_out = 8'd0;
    //            end
                
                transmit_valid = 1'b1;    
                if(W_counter != W-1-2) begin
                    W_counter = W_counter + 1;              
                end else begin
                    W_counter = 0;
                    H_counter = H_counter + 1;
                end
                if(W_counter == W-1-2    &&   H_counter == H-1-2) begin
                    ready <= 1;
                end
            end else begin
                transmit_valid = 1'b0;
            end
            
        end
    end
    
    
    
    always @(posedge clk && start) begin
        
        if (first_time < 5) begin
            first_time = first_time + 1;
        end
        Gx =    -data0 + data6          +
                 -2*data1 + 2*data7  +
                 -data2 + data8     ;
                 
        Gy =   -data0 - 2*data3 - data6      +
                 data2 + 2*data5 + data8  ;
    end
        
        
    
endmodule
