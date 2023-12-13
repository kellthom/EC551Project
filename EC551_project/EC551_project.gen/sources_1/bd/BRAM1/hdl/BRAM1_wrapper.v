//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Tue Dec 12 15:24:36 2023
//Host        : Adelia-laptop running 64-bit major release  (build 9200)
//Command     : generate_target BRAM1_wrapper.bd
//Design      : BRAM1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM1_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_we,
    BRAM_PORTB_0_addr,
    BRAM_PORTB_0_clk,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_en);
  input [18:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [7:0]BRAM_PORTA_0_din;
  input [0:0]BRAM_PORTA_0_we;
  input [18:0]BRAM_PORTB_0_addr;
  input BRAM_PORTB_0_clk;
  output [7:0]BRAM_PORTB_0_dout;
  input BRAM_PORTB_0_en;

  wire [18:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [7:0]BRAM_PORTA_0_din;
  wire [0:0]BRAM_PORTA_0_we;
  wire [18:0]BRAM_PORTB_0_addr;
  wire BRAM_PORTB_0_clk;
  wire [7:0]BRAM_PORTB_0_dout;
  wire BRAM_PORTB_0_en;

  BRAM1 BRAM1_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we),
        .BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
        .BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
        .BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
        .BRAM_PORTB_0_en(BRAM_PORTB_0_en));
endmodule
