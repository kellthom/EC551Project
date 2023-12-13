`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 12:57:35 PM
// Design Name: 
// Module Name: block_ram
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


module block_ram(
    output reg all_loaded,
    input [7:0]graypixel,
    input data_valid,
                     input [15:0] read_H,
                     input [15:0] read_W,
                     input [15:0] VGA_Hread,
                     input [15:0] VGA_Wread,
                     input [15:0] counter_H,
                     input [15:0] counter_W,
                     input reset,
                     input [15:0] H,
                     input [15:0] W,
                     input clk,
                     input sobel_ready,
                     input transmit_valid,
                     input [7:0] write_data,
                     output [7:0] data_out,
                     output reg write_en

    );
    
    
wire [18:0]BRAM_PORTA_0_addr;
wire BRAM_PORTA_0_clk;
wire [7:0]BRAM_PORTA_0_din;
wire [0:0]BRAM_PORTA_0_we;
wire [18:0]BRAM_PORTB_0_addr;
wire BRAM_PORTB_0_clk;
wire [7:0]BRAM_PORTB_0_dout;

reg[18:0]read_address;
reg[18:0]write_address;
reg [20:0]count=0;
reg [20:0]count2=0;
reg [20:0]gray_count=0;       
assign BRAM_PORTA_0_addr = write_address;
assign BRAM_PORTA_0_din = all_loaded?write_data:graypixel;
//assign BRAM_PORTA_0_din = write_data;
assign BRAM_PORTA_0_clk =clk;
assign BRAM_PORTA_0_we = write_en;
assign BRAM_PORTB_0_addr = read_address;
assign BRAM_PORTB_0_clk =clk;
assign data_out = BRAM_PORTB_0_dout;
        
        
BRAM1 BRAM
   (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
    .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
    .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
    .BRAM_PORTA_0_we(BRAM_PORTA_0_we),
    .BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
    .BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
    .BRAM_PORTB_0_dout(data_out));
    
    
    
 reg [0:15] write_H, write_W;
      
    always @(posedge clk) begin
//         count = count+1;
//         read_address = count;
////         count = count +1;
////         $display("count =%h "count);
//         $display("data_out=%h",data_out);

//         if(count==30)begin
//         $stop;
//         end
        if(reset)begin
         write_en =0;
         all_loaded=0;
        end else begin
        if(!all_loaded)begin
            if(data_valid)begin
                write_en = 1;
                write_address = gray_count;
                gray_count = gray_count +1;
                if(gray_count>680*100)begin
                    all_loaded =1;
                end
            end
        end else begin
            if (!sobel_ready) 
            begin
//                $display("counter_H",counter_H);
//                $display("counter_W",counter_W);
//                $display("read_address=%b",read_address);
//                if(counter_W==2)begin 
//                $stop;
//                end
                read_address = read_H*W + read_W;
                if(transmit_valid==1)
                    begin
                    write_en = 1;
                    count2 = count2 +1;
                    if(counter_W != 0)begin
                    write_address = counter_H*W+ counter_W-1;
//                    if(counter_W<5 & counter_H<5) begin
//                    $display("write_address=%d",write_address);
//                    $display("write_en=&d",BRAM_PORTA_0_we);
//                    $display("datain=%h",BRAM_PORTA_0_din);
//                    end
//                    $display("counter_H=%d",counter_H);
//                    $display("counter_W=%d",counter_W);
                    end
                    else begin
                    write_address = (counter_H-1)*W+ W-1-2;
//                    $display("counter_H=%d",counter_H);
//                    $display("counter_W=%d",counter_W);
                    end
                    
                    end
//                    if(counter_W==5&counter_H==5)begin
//                    $stop;
//                    end
                else 
                    begin
                    write_en = 0;
                    end
            end
            else 
            begin
//                $display("Hcount=%d",counter_H);
//                $display("Wcount=%d",counter_W);
//                $display("count2=%d",count2);
//                $stop;
                count = count + 1;
                
//    //            if(count<640*480)
//    //            begin
//                if(count==count2) 
//                    begin
//                    $stop;
//                    end
//                read_address = count;
//                $display("outsobel=%h",data_out);
//                if(read_address==20-1)begin
//                $stop;
//                end
    //                $display("count=%d ",count);
    //                $display("out=%h ",data_out);
    //                $display("---------------------------------");
    //            end
              write_en = 0;
//              read_address = count;
//              if(count==count2) 
//                    begin
//                    $stop;
//                    end
              read_address = VGA_Hread*W + VGA_Wread;
            end
        end
        end
        end
endmodule
