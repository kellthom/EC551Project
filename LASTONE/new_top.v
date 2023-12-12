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


module new_top #(IMG_WIDTH = 640, IMG_HEIGHT = 480) 
(
    input clk,
    input reset,
    
//    output sobelready,
//    output [7:0]BRAM_OUT
    output [3:0] red, 
    output [3:0] green, 
    output [3:0] blue,
    output hsync, 
    output vsync
    //For VGA port output
//    output [3:0] red, 
//    output [3:0] green, 
//    output [3:0] blue,
//    output hsync, 
//    output vsync
);

//    wire [7:0] data;
//    wire data_valid;

//    uart_receiver #(.BAUD_VAL(BAUD_VAL)) recv (
//        .clk(clk),
//        .reset(reset),
//        .rx(rx),
//        .data(data),
//        .data_valid(data_valid)
//    );
    
//    wire [7:0] data_out_r, data_out_g, data_out_b;
//    wire [15:0] height, width;
//    wire dimension_received, one_byte_ready;
//    wire [7:0] gray_out;
    
//    parse parse1(
//    .clk(clk),
//    .reset(reset),
//    .data_in(data),
//    .data_valid(data_valid),
    
//    .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),
//    .height(height),.width(width),
//    .dimension_received(dimension_received),
//    .one_byte_ready(one_byte_ready));
    
//    rgb2gray rgb2gray(
//    .data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),
//    .data_out(gray_out));
    
   
    // MultiPortRAM here for storing 
    
wire [15:0] read_H, read_W,counter_H,counter_W,VGA_Hread,VGA_Wread;
wire sobelready;
wire transmit_valid;
wire [7:0]out_sobel;
//    wire [7:0] data0;

////    assign H = 16'd512;
////    assign W = 16'd768; 
//    wire all_loaded;

    wire [7:0]BRAM_OUT;
    Block_Rom  Block_Rom(
    .read_H(read_H),
    .read_W(read_W),
    .VGA_Hread(VGA_Hread),
    .VGA_Wread(VGA_Wread),
    .counter_H(counter_H),
    .counter_W(counter_W),
    .reset(reset),
    .H(IMG_HEIGHT),
    .W(IMG_WIDTH),
    .clk(clk),
    .sobel_ready(sobelready),
    .transmit_valid(transmit_valid),
    .write_data(out_sobel),
    .data_out(BRAM_OUT)
    );


//    wire [7:0]out_sobel;
//    wire transmit_valid;
    wire matrix_ready;
    
    sobel sobel (
    .clk(clk),
    .rstn(reset),
    .data0(BRAM_OUT),
    .W_read(read_W),
    .H_read(read_H),
    .W_counter(counter_W),
    .H_counter(counter_H) ,
    .data_out(out_sobel),
    .ready(sobelready),
    .transmit_valid(transmit_valid),
    .matrix_ready(matrix_ready),
    .H(IMG_HEIGHT),
    .W(IMG_WIDTH)
    );
//wire green,blue,vsync,hsync,VGA_Hread,VGA_Wread;
VGA VGA(
         .clk(clk),
         .Braminput(BRAM_OUT), // 4-bit input stream
         .sobelready(sobelready), // Ready signal from sobel module
         .red(red), 
         .green(green), 
         .blue(blue),
         .hsync(hsync), 
         .vsync(vsync),
         .Hread(VGA_Hread),
         .Wread(VGA_Wread)
    );
//    uart_transmitter #(.BAUD_VAL(BAUD_VAL)) trans (
//        .clk(clk),
//        .data_valid(transmit_valid),
//        .reset(reset),
//        .data_in(out_sobel),
        
//        .tx(tx),
//        .tx_active(tx_active),
//        .tx_done(tx_done)
//    );
    
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