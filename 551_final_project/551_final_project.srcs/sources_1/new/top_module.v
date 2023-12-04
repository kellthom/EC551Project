`timescale 1ns / 1ps
module top_module(
    input clock,  // Main clock input
    output [3:0] red, 
    output [3:0] green, 
    output [3:0] blue,
    output hsync, 
    output vsync
);

    wire [3:0] ram_data;
    wire [18:0] ram_address;
    reg [18:0] address_counter = 0;

    ram_640x480_init ram_module (
        .clk(clock),
        .address(ram_address),
        .data_out(ram_data)
    );

    VGA vga_module (
        .clock(clock),
        .ram_data(ram_data),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Address generation for RAM
    always @(posedge clock) begin
        if (address_counter < 307199)  // 640x480 - 1
            address_counter <= address_counter + 1;
        else
            address_counter <= 0;
    end

    assign ram_address = address_counter;

endmodule
