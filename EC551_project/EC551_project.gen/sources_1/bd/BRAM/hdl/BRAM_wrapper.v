//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Tue Dec 12 19:05:55 2023
//Host        : Adelia-laptop running 64-bit major release  (build 9200)
//Command     : generate_target BRAM_wrapper.bd
//Design      : BRAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_we);
  input [18:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [7:0]BRAM_PORTA_0_din;
  output [7:0]BRAM_PORTA_0_dout;
  input [0:0]BRAM_PORTA_0_we;

  wire [18:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [7:0]BRAM_PORTA_0_din;
  wire [7:0]BRAM_PORTA_0_dout;
  wire [0:0]BRAM_PORTA_0_we;

  BRAM BRAM_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule
