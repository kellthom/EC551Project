`timescale 1ns / 1ps


module rgb2gray
#(
    parameter H = 391,
    parameter W = 317
)
(
    // input clk,
    // input rstn,
    // input start,
    input[7:0] data_in_red,
    input[7:0] data_in_green,
    input[7:0] data_in_blue,
    // output reg ready,
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

    // reg[7:0] ROM_R[H-1:0][W-1:0];
    // reg[7:0] ROM_G[H-1:0][W-1:0];
    // reg[7:0] ROM_B[H-1:0][W-1:0];
    // reg[7:0] ROM_Gray[H-1:0][W-1:0];

    // reg[15:0] W_counter;
    // reg[15:0] H_counter; 

    // reg final;

    // reg[7:0] data_out_temp;

    // always @(posedge clk) begin
    //     if(~rstn) begin
    //         // ready <= 0;
    //         // final <= 0;
    //         // W_counter <= 0;
    //         // H_counter <= 0;
    //         data_out <= 0;
    //     end else begin
    //         data_out <= data_out_temp;
    //         // if(start & !ready) begin
    //             // ROM_Gray[H_counter][W_counter] <=
    //             //     (R_coeff * ROM_R[H_counter][W_counter] +
    //             //     G_coeff * ROM_G[H_counter][W_counter] +
    //             //     B_coeff * ROM_B[H_counter][W_counter]) / (128);

    //             // if(W_counter != W-1) begin
    //             //     W_counter <= W_counter + 1;
    //             // end else begin
    //             //     W_counter <= 0;
    //             //     H_counter <= H_counter + 1;
    //             // end

    //             // if(W_counter == W-1 && H_counter == H-1) begin
    //             //     ready <= 1;
    //             // end
    //         // end else if (ready & ~final) begin
    //         //     final <= 1;
    //         // end
    //     end
    // end

endmodule
