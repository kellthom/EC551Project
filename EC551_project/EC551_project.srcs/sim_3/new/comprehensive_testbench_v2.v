`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 07:54:02 PM
// Design Name: 
// Module Name: comprehensive_testbench_v2
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


module comprehensive_testbench_v2(
);

    //parameter number_of_elements = 768 * 512;
    parameter number_of_elements = 768 * 512 * 3 + 4;
    reg clk;
    reg reset;
    reg rx;
    reg [7:0]  image_data [0:number_of_elements-1];
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
        $readmemh("rgb_image_data.txt", image_data);
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
        for (j = 0; j < number_of_elements; j = j + 1) begin
            transmit_byte(image_data[j]); // Transmit a byte of the image data
            #BAUD_CLK; // Wait for one baud time duration to avoid back-to-back transmission
        end

        // Finish
//        #400_000_000

        # 40_000_000        $finish;
        $fclose(file);
    end
    
    new_top #(.BAUD_VAL(BAUD_VAL)) top(
        clk, reset, rx,
        tx, tx_active, tx_done
    );


    wire[7:0] recv_data2;
    wire data_valid2;
        uart_receiver #(.BAUD_VAL(BAUD_VAL)) recv (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        
        .data(recv_data2),
        .data_valid(data_valid2)
    );

    integer output_count = 0;
    always @(data_valid2) begin
        if (data_valid2) begin
            output_count = output_count + 1;
            $fwrite(file, "%h\n",recv_data2); // Write received byte to file
        end
    end

endmodule
