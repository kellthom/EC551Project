`timescale 1ns / 1ps

module rgb2gray
(
    input clk,
    input rstn,
    input[7:0] data_in_red,
    input[7:0] data_in_green,
    input[7:0] data_in_blue,
    output reg ready,
    output reg [7:0] data_out,
    output reg[15:0]   W_counter ,
    output reg[15:0]   H_counter ,
    input [15:0] H,
    input [15:0] W
);
	
    localparam R_coeff = 30;
    localparam G_coeff = 59;
    localparam B_coeff = 11;
    reg ROM_SIZE ;
    wire [7:0] gray_value;
    assign gray_value = (R_coeff * data_in_red + G_coeff * data_in_green + B_coeff * data_in_blue) >> 7;

    always @(posedge clk or negedge rstn) 
    begin

        if (!rstn) 
        begin
            ready <= 0;
            W_counter<=0;
            H_counter<=0;
            ROM_SIZE<=H*W;
        end 
        else 
        begin
        if (!ready) 
        begin
            data_out <= gray_value;
            if(W_counter != W-1) 
            begin
                W_counter <= W_counter + 1;              
            end
            
            else 
            begin
                W_counter <= 0;
                H_counter <= H_counter + 1;
            end
            if(W_counter == W-1    &&   H_counter == H-1) begin
                ready <= 1;
            end
            
        end 
        end
    end
    
endmodule
