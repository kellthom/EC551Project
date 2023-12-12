`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 01:32:44 AM
// Design Name: 
// Module Name: new_top
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


module new_top #(parameter BAUD_VAL =9, IMG_WIDTH = 640, IMG_HEIGHT = 480) 
(
    input clk,
    input reset,
    input rx,

    output tx,
    output tx_active,
    output tx_done

    //For VGA port output
//    output [3:0] red, 
//    output [3:0] green, 
//    output [3:0] blue,
//    output hsync, 
//    output vsync
);

    wire [7:0] data;
    wire data_valid;

    uart_receiver #(.BAUD_VAL(BAUD_VAL)) recv (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(data),
        .data_valid(data_valid)
    );

    wire [7:0] data_out_r, data_out_g, data_out_b;
    wire [15:0] height, width;
    wire dimension_received, one_byte_ready;
    wire [7:0] gray_out;

    parse parse1(
    .clk(clk),
    .reset(reset),
    .data_in(data),
    .data_valid(data_valid),

    .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),
    .height(height),.width(width),
    .dimension_received(dimension_received),
    .one_byte_ready(one_byte_ready));

    rgb2gray rgb2gray(
    .data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),
    .data_out(gray_out));


    // MultiPortRAM here for storing 

    wire [15:0] read_H, read_W;
    wire [7:0] data0;

//    assign H = 16'd512;
//    assign W = 16'd768; 
    wire all_loaded;

    MultiPortRAM  MultiPortRAM(
    .read_H(read_H),
    .read_W(read_W),
    .reset(reset),
    .H(height),
    .W(width),
    .data_valid(one_byte_ready),
    .clk(clk),
    .write_data(gray_out),
    .all_loaded(all_loaded),
    .data0(data0)
    );

    wire sobelready;
    wire [7:0]out_sobel;
    wire transmit_valid;
	wire matrix_ready;

    sobel #(.BAUD_VAL(BAUD_VAL)) sobel (
    .clk(clk),
    .rstn(reset),
    .start(all_loaded),
    .data0(data0),
    .W_read(read_W),
    .H_read(read_H),
    .data_out(out_sobel),
    .ready(sobelready),
    .transmit_valid(transmit_valid),
	.matrix_ready(matrix_ready),
    .H(height),
    .W(width)
    );

    uart_transmitter #(.BAUD_VAL(BAUD_VAL)) trans (
        .clk(clk),
        .data_valid(transmit_valid),
        .reset(reset),
        .data_in(out_sobel),

        .tx(tx),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    //Sobel output ROM
	/*
    wire array_ready;
    wire [3:0]stream_out;
    wire stream_valid;
    sobel_output_recv #(.IMG_HEIGHT(IMG_HEIGHT),.IMG_WIDTH(IMG_WIDTH)) sobel_recv_inst (
        .clk(clk),
        .rstn(rstn),
        .sobel_out(out_sobel),
        .sobel_ready(sobelready),
        .array_ready(array_ready),
        .stream_out(stream_out),
        .stream_valid(stream_valid)
    );
    
    //VGA port
    VGA vga_inst(
        .clock(clk),
        .stream_rdy(stream_valid),
        .stream_in(stream_out),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync)
    );
*/
endmodule