`timescale 1ns / 1ps

module MultiPortROM
                    (input [15:0] read_H,
                     input [15:0] read_W,
                     input [15:0] write_H,
                     input [15:0] write_W,
                     input ready,
                     input clk,
                     input [7:0] write_data,
                     output reg [7:0] data0,
                     output reg [7:0] data1,
                     output reg [7:0] data2,
                     output reg [7:0] data3,
                     output reg [7:0] data4,
                     output reg [7:0] data5,
                     output reg [7:0] data6,
                     output reg [7:0] data7,
                     output reg [7:0] data8,
                     input [15:0] H,
   					 input [15:0] W);
                     
    reg MEM_SIZE = H * W;                 
	reg [7:0] rom_memory [0:1000][0:1000];

    always @(posedge clk) begin
        if (!ready) begin
            rom_memory[write_H][write_W] <= write_data;
        end
        else
        begin
        if (ready) begin
     data0 <= rom_memory [read_H][read_W];
     data1 <= rom_memory [read_H][read_W+1];
     data2 <= rom_memory [read_H][read_W+2];
     data3 <= rom_memory [read_H+1][read_W];
     data4 <= rom_memory [read_H+1][read_W+1];
     data5 <= rom_memory [read_H+1][read_W+2];
     data6 <= rom_memory [read_H+2][read_W];
     data7 <= rom_memory [read_H+2][read_W+1];
     data8 <= rom_memory [read_H+2][read_W+2];
     end
        end
    end

endmodule
