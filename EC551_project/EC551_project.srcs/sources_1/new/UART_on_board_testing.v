`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 07:31:23 PM
// Design Name: 
// Module Name: UART_on_board_testing
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


module UART_on_board_testing(
    input wire clk, 
    input wire reset,
    input wire rx,
    
    output wire tx,
    output wire tx_active,
    output wire tx_done,
    
    output wire dummy,
    output wire reset_light,
    output wire rx_light,
    output wire data_valid_light,
    output wire tx_light,
    output wire [3:0] data_light 
    );
    wire [7:0] data;
    wire data_valid;
    
    localparam BAUD_VAL = 10417;
    
    assign dummy = 1'b1;
    assign reset_light = reset;
    assign rx_light = rx;
    assign tx_light = tx;
    assign data_valid_light = data_valid;
    assign data_light[3:0] = data [3:0];
    
    
    uart_receiver #(.BAUD_VAL(BAUD_VAL)) recv (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        
        .data(data),
        .data_valid(data_valid)
    );
    
   
     uart_transmitter #(.BAUD_VAL(BAUD_VAL)) trans (
        .clk(clk),
        .data_valid(data_valid),
        .reset(reset),
        .data_in(data),
        
        .tx(tx_temp),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );
    
    
    assign tx = tx_active ? tx_temp : 1'b1;
endmodule
