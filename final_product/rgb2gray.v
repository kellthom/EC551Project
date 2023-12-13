`timescale 1ns / 1ps

module rgb2gray
(

    input[7:0] data_in_red,
    input[7:0] data_in_green,
    input[7:0] data_in_blue,
    output reg[7:0] data_out
);
	
    localparam R_coeff = 30;
    localparam G_coeff = 59;
    localparam B_coeff = 11;

    always@(*) begin
        data_out =
            (R_coeff * data_in_red +
            G_coeff * data_in_green +
            B_coeff * data_in_blue) >> 7; // divide by 128
    end
    
endmodule
