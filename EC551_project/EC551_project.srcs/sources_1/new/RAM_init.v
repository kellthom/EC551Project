`timescale 1ns / 1ps
module ram_640x480_init (
    input wire clk,
    input wire [18:0] address,
    output reg [3:0] data_out
);

    // Total size for 640x480 elements, each 4 bits
    reg [3:0] ram [307199:0];

    integer i;
    initial begin
        for (i = 0; i < 307200; i = i + 1) begin
            if (i % 2 == 0) begin
                ram[i] = 4'hF;
            end else begin
                ram[i] = 4'h0;
            end
        end
    end

    // Reading data from RAM
    always @(posedge clk) begin
        data_out <= ram[address];
    end

endmodule
