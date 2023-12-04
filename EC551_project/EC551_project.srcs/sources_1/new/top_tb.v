`timescale 1ns / 1ps

module top_module_tb;

    // Inputs
    reg clock;

    // Outputs
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    wire hsync;
    wire vsync;

    top_module uut (
        .clock(clock),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync)
    );

    initial begin
        clock = 0;
        forever #1 clock = ~clock;
    end

    // Add additional test logic here if necessary
    // For example, you could monitor the output signals and verify their behavior

    initial begin
        #800000;
        $finish;
    end

endmodule
