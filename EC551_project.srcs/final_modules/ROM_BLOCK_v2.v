`timescale 1ns / 1ps

module MultiPortRAM_v2
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
                     
                     output reg [7:0] addr_written
                    );
                  
                    
  wire [18:0]BRAM_PORTA_0_1_ADDR;
  wire BRAM_PORTA_0_1_CLK;
  wire [7:0]BRAM_PORTA_0_1_DIN;
  wire [7:0]BRAM_PORTA_0_1_DOUT;
  wire [0:0]BRAM_PORTA_0_1_WE;
  reg [18:0]address=0;
  reg [7:0]data_in =0; 
  assign BRAM_PORTA_0_1_ADDR = address;
  assign BRAM_PORTA_0_1_CLK = clk;
  assign BRAM_PORTA_0_1_DIN = data_in;
  assign BRAM_PORTA_0_1_WE = !all_loaded;
//  assign data0 = BRAM_PORTA_0_1_DOUT;
  BRAM blk_mem_gen_0
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_1_ADDR),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_1_CLK),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_1_DIN),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_1_DOUT),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_1_WE));
        
        
//	reg [7:0] rom_memory [0:1000][0:1000];
    reg [15:0] write_H, write_W;


    always @(posedge clk) begin
        if(reset) begin 
            write_H = 16'b0;
            write_W = 16'b0;
            all_loaded = 1'b0;
            addr_written = 8'b11110000;
        end else begin
        
            if (data_valid) begin
                address = write_H*W + write_W;
                data_in = write_data;
    //            addr_written[7:0] = address[7:0];
                addr_written = addr_written + 1'b1;
                write_W = write_W + 1'b1;
                if(write_W >= W) begin
                        write_H = write_H + 1'b1;
                        if (write_H >= H) begin
                            all_loaded = 1'b1;
                        end
                        write_W = 16'b0;
                end
            end else begin
                if (all_loaded) begin
    //                $display("all_loaded");
    //                if(read_H>100&read_H<105 & read_W>100 & read_W<105)begin
    //                $display("read_H=",read_H);
    //                $display("read_W=",read_W);
    //                $display("BRAM_PORTA_0_1_DOUT=",BRAM_PORTA_0_1_DOUT);
    //                end
                    address <= read_H*W + read_W;
                    data0 <= BRAM_PORTA_0_1_DOUT;
    //                data1 <= rom_memory [read_H][read_W+1];
    //                data2 <= rom_memory [read_H][read_W+2];
    //                data3 <= rom_memory [read_H+1][read_W];
    //                data4 <= rom_memory [read_H+1][read_W+1];
    //                data5 <= rom_memory [read_H+1][read_W+2];
    //                data6 <= rom_memory [read_H+2][read_W];
    //                data7 <= rom_memory [read_H+2][read_W+1];
    //                data8 <= rom_memory [read_H+2][read_W+2];
                end
            end
        end
    end

endmodule