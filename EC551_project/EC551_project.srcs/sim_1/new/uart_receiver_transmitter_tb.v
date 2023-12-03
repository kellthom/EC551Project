`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 01:11:27 PM
// Design Name: 
// Module Name: uart_receiver_tb
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

module uart_receiver_transmitter_tb();
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire data_valid;
    reg [7:0]  image_data [0:14]; // size of image 640 x 240
    integer i;
    integer j;

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 101_50000;
    localparam BAUD_VAL = CLK_FREQ / BAUD_RATE;
    
    // to conver the numbder of clk cycles into nano seconds, * for the two edge of the clk
    localparam BAUD_CLK = BAUD_VAL * 2;

//    initial $readmemh("example.mem", image_data);
    initial begin
        
        for (i = 0; i < 5; i = i + 1) begin
            image_data[i] = 8'ha;
        end
        
        for (i = 5; i < 10; i = i + 1) begin
            image_data[i] = 8'hb;
        end
        for (i = 10; i < 15; i = i + 1) begin
            image_data[i] = 8'hc;
        end
    end
    // Clock generation
    always begin
        #1 clk = ~clk;
    end

    // Transmit UART data
    task transmit_byte(input [7:0] byte);
        integer i;
        begin
            rx = 0; // Start bit
            #BAUD_CLK;

            for(i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #BAUD_CLK;
            end

            rx = 1; // Stop bit
            #BAUD_CLK;
        end
    endtask



// Testbench
    initial begin
        // Initialize signals
        
        #50
        clk = 0;
        reset = 0;
        rx = 1;

        // Reset
        reset = 1;
        #20 reset = 0;

        // Transmit image data
        for (j = 0; j < 64; j = j + 1) begin
            transmit_byte(image_data[j]); // Transmit a byte of the image data
            #BAUD_CLK; // Wait for one baud time duration to avoid back-to-back transmission
        end

        // Finish
        #100000000 $finish;
    end

    //The first UUT is a receiver, receives data from RX pin and turn them into bytes
    uart_receiver UUT (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        
        .data(data),
        .data_valid(data_valid)
    );
    
    //The second UUT is a transmitter, transmit the data just received to the tx pin
    wire tx, tx_active, tx_done;
    uart_transmitter UUT2 (
        .clk(clk),
        .data_valid(data_valid),
        .reset(reset),
        .data_in(data),
        
        .tx(tx),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );
    
    
    //The third UUT is a same receiver as the first one, used here to verify that the receiver and the transmitter works together
    
    wire[7:0] data2;
    wire data_valid2;
        uart_receiver UUT3 (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        
        .data(data2),
        .data_valid(data_valid2)
    );


endmodule