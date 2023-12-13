`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 10:39:30 PM
// Design Name: 
// Module Name: new_top_v3
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


module new_top_v3 #(parameter BAUD_VAL = 868) 
(
    input wire clk,
    input wire reset,
    input wire rx,
    
    output wire tx,
    
    output wire dimension_light,    
    output wire reset_light,
    output loaded_light,
//    output wire [7:0] sobel_light,
    
    output wire tx_active,
    
    output [1:0] height_light,
//    output [1:0] width_light
    output write_en,
    output Sobel_Counter_flag,
    output Sobel_Counter_flag2,
    output sobelready,
    
//    output dv,
    output [3:0] red, 
    output [3:0] green, 
    output [3:0] blue,
    output hsync, 
    output vsync

);

    
    wire [7:0] sobel_light;

    assign reset_light = reset;
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
    
    assign dv = ~one_byte_ready;
    
    parse_v2 parse1(
    .clk(clk),
    .reset(reset),
    .data_in(data),
    .data_valid(data_valid),
    
    .data_out_r(data_out_r),.data_out_g(data_out_g),.data_out_b(data_out_b),
    .height(height),.width(width),
    .dimension_received(dimension_received),
    .one_byte_ready(one_byte_ready)
    );
    
    rgb2gray rgb2gray(
    .data_in_red(data_out_r),.data_in_green(data_out_g),.data_in_blue(data_out_b),
    .data_out(gray_out));
    
    wire [15:0] read_H, read_W,counter_H,counter_W,VGA_Hread,VGA_Wread;
    wire sobelready;
    wire transmit_valid;
    wire [7:0]out_sobel;
   

    wire all_loaded;
    wire [7:0]BRAM_OUT;

block_ram  Block_Rom(
    .all_loaded(all_loaded),
    .graypixel(8'hff),
    .data_valid(1'b1),
    .read_H(read_H),
    .read_W(read_W),
    .VGA_Hread(VGA_Hread),
    .VGA_Wread(VGA_Wread),
    .counter_H(counter_H),
    .counter_W(counter_W),
    .reset(reset),
    .H(480),
    .W(640),
    .clk(clk),
    .sobel_ready(sobelready),
    .transmit_valid(transmit_valid),
    .write_data(out_sobel),
    .data_out(BRAM_OUT),
    .write_en(write_en)
    );    

    wire matrix_ready;
    
sobel_v3 sobel (
    .all_loaded(all_loaded),
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
    .H(480),
    .W(640),
    .Sobel_Counter_flag(Sobel_Counter_flag),
    .Sobel_Counter_flag2(Sobel_Counter_flag2)
    );
    
//wire green,blue,vsync,hsync,VGA_Hread,VGA_Wread;
vga VGA(
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
    
    wire tx_temp;
    uart_transmitter #(.BAUD_VAL(BAUD_VAL)) trans (
        .clk(clk),
        .data_valid(one_byte_ready),
        .reset(reset),
        .data_in(gray_out),
        
        .tx(tx_temp),
        .tx_active(tx_active),
        .tx_done()
    );
    
     assign tx = tx_active ? tx_temp : 1'b1;
    
    
    assign height_light = height[9:8];

    assign dimension_light = dimension_received;
    assign gray_light = gray_out;
    assign loaded_light = all_loaded;
    assign sobel_light [7:0] = out_sobel[7:0];
endmodule

