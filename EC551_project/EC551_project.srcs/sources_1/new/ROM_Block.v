`timescale 1ns / 1ps

module MultiPortRAM
                    (input [15:0] read_H,
                     input [15:0] read_W,
                     input reset,
                     input [15:0] H,
                     input [15:0] W,
                     input data_valid,
                     input clk,
                     input [7:0] write_data,
                     output reg all_loaded,
                     output reg [7:0] data0,
                     output reg [7:0] data1,
                     output reg [7:0] data2,
                     output reg [7:0] data3,
                     output reg [7:0] data4,
                     output reg [7:0] data5,
                     output reg [7:0] data6,
                     output reg [7:0] data7,
                     output reg [7:0] data8
                     );
                     
	reg [7:0] rom_memory [0:1000][0:1000];
    reg [0:15] write_H, write_W;
    
    always @ (reset) begin
        write_H = 16'b0;
        write_W = 16'b0;
        all_loaded = 1'b0;
    end
    

    always @(posedge clk) begin
        if (data_valid) begin
            rom_memory[write_H][write_W] <= write_data;
            write_W = write_W + 1'b1;
            if(write_W >= W) begin
            write_H = write_H + 1'b1;
                if (write_H >= H)begin
                    all_loaded = 1'b1;
                end else begin
                    write_W = 16'b0;
                    
                end
            end
        end
        
        else
            begin
                if (all_loaded) begin
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
