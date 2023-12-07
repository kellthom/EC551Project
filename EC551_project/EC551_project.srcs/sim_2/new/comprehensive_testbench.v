`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 07:44:30 PM
// Design Name: 
// Module Name: comprehensive_testbench
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


module comprehensive_testbench(
);

    //parameter number_of_elements = 768 * 512;
    parameter number_of_elements = 768 * 512;
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire data_valid;
    reg [7:0]  image_data [0:number_of_elements-1];
    integer i;
    integer j;

    // for the slow clock
    reg [7:0] counter;
    reg clkout;
    
    reg [7:0] stored_sobel;

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 401_50000;
    localparam BAUD_VAL = CLK_FREQ / BAUD_RATE;
    
    // to conver the numbder of clk cycles into nano seconds, * for the two edge of the clk
    localparam BAUD_CLK = BAUD_VAL * 2;

    integer file;
//    initial begin
//        for (i = 0; i < 5; i = i + 1) begin
//            image_data[i] = 8'ha;
//        end
        
//        for (i = 5; i < 10; i = i + 1) begin
//            image_data[i] = 8'hb;
//        end
//        for (i = 10; i < 15; i = i + 1) begin
//            image_data[i] = 8'hc;
//        end
//    end
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
        $readmemh("grayscale_image_data.txt", image_data);
        file = $fopen("received_data.hex", "w");
    
        // Initialize signals
        counter = 0;
        clkout = 0;
        #50
        clk = 0;
        reset = 0;
        rx = 1;
        
        stored_sobel = 8'b0;

        // Reset
        reset = 1;
        #20 reset = 0;

        // Transmit image data
        for (j = 0; j < number_of_elements + 1; j = j + 1) begin
            transmit_byte(image_data[j]); // Transmit a byte of the image data
            #BAUD_CLK; // Wait for one baud time duration to avoid back-to-back transmission
        end

        // Finish
//        #400_000_000

        # 40_000_000
        $finish;
        $fclose(file);
    end

    //The first UUT is a receiver, receives data from RX pin and turn them into bytes
    uart_receiver UUT (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        
        .data(data),
        .data_valid(data_valid)
    );
    
   
    
    // MultiPortRAM here for storing 
    
    wire [15:0] read_H, read_W;
    wire [7:0] data0, data1, data2, data3, data4, data5, data6, data7, data8;
    wire [15:0] H, W;




    assign H = 16'd512;
    assign W = 16'd768; 
    wire all_loaded;
    
    MultiPortRAM  MultiPortRAM(
    .read_H(read_H),
    .read_W(read_W),
    .reset(reset),
    .H(H),
    .W(W),
    .all_loaded(all_loaded),
    .data_valid(data_valid),
    .clk(clk),
    .write_data(data),
    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .data6(data6),
    .data7(data7),
    .data8(data8)
    );
    
    
    
    //slow clock
    always @(posedge clk) begin
        if (counter == 0) begin
            counter <= 10;
            clkout <= ~clkout;
        end else begin
            counter <= counter -1;
        end
    end
    
    wire sobelready;
    wire [7:0]out_sobel;
    wire transmit_valid;
    
    sobel sobel(
    .clk(clkout),
    .rstn(reset),
    .start(all_loaded),
    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .data6(data6),
    .data7(data7),
    .data8(data8),
    .W_counter(read_W),
    .H_counter(read_H),
    .data_out(out_sobel),
    .ready(sobelready),
    .transmit_valid(transmit_valid),
    .H(H),
    .W(W)
    );
    
//    reg transmit_valid;
    
//    always @(posedge clk) begin
//        if(out_sobel != stored_sobel) begin
//            transmit_valid = 1'b1;
//            stored_sobel = out_sobel;
//        end
//        else begin 
//            transmit_valid = 1'b0;
//        end
        
//    end
    
    //The second UUT is a transmitter, transmit the data just received to the tx pin
    wire tx, tx_active, tx_done;
    uart_transmitter UUT2 (
        .clk(clk),
        .data_valid(transmit_valid),
        .reset(reset),
        .data_in(out_sobel),
        
        .tx(tx),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );
    
    
    //The third UUT is a same receiver as the first one, used here to verify that the receiver and the transmitter works together
    
    wire[7:0] recv_data2;
    wire data_valid2;
        uart_receiver UUT3 (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        
        .data(recv_data2),
        .data_valid(data_valid2)
    );

    always @(data_valid2) begin
        if (data_valid2) begin
            $fwrite(file, "%h\n",recv_data2); // Write received byte to file
        end
    end

endmodule