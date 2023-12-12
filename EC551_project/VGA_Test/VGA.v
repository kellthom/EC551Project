`timescale 1ns / 1ps
module VGA(
    input clk,
    input transmit_valid, // Ready signal for the input stream
    input [7:0] Braminput, // 4-bit input stream
    input sobelready, // Ready signal from sobel module
    output reg [3:0] red, 
    output reg [3:0] green, 
    output reg [3:0] blue,
    output reg hsync, 
    output reg vsync
);

// VGA standard dimensions and timing
integer i=0, j=0;
reg clock_50, clock_25;
reg [9:0] hcount = 0;
reg [9:0] vcount = 0;
//    assign read_H_vga = hcount;
//    assign read_W_vga = vcount;
//reg buffer_valid;
//reg image_buffer[0:64][0:48];


wire [7:0] temp=0;
wire [7:0] out;
BRAM_wrapper Bram
   (.BRAM_PORTA_0_addr(vcount*640+hcount),
    .BRAM_PORTA_0_clk(clk),
    .BRAM_PORTA_0_din(temp),
    .BRAM_PORTA_0_dout(out),
    .BRAM_PORTA_0_we(1'b0));


  
    // Horizontal and Vertical sync logic
    always @ (posedge clk) begin
        clock_50 = !clock_50;
    end

    always @ (posedge clock_50) begin
        clock_25 = !clock_25;
    end
    
//    always @(posedge clk) begin
//        if (transmit_valid && !buffer_valid) begin
//            //image_buffer[i][j] <= stream_in[7];
//            image_buffer[i][j] <= 1'b1;
//            if (i == 64 && j == 48) begin
//                buffer_valid <= 1; // Buffer is full
//            end else if (i <= 63) begin
//                i <= i + 1;
//            end else begin
//                i <= 0;
//                j <= j + 1;
//            end
//        end
//    end
    
    // Sync and display logic(CAN'T CHANGE THE CLOCK!!!!!!!!!!!)
    always @(posedge clock_25) begin
            $display("hcount=%h",hcount);
            $display("vcount=%h",vcount);
            $display("out=%h",out);
            if(hcount == 799) begin 
                hcount <= 0;
                if(vcount == 524)
                    vcount <= 0;
                else 
                    vcount <= vcount + 1'b1;
            end else
                hcount <= hcount + 1'b1;

            // Sync signals
            if (vcount >= 490 && vcount < 492) 
                vsync <= 0;
            else
                vsync <= 1;

            if (hcount >= 656 && hcount < 752) 
                hsync <= 0;
            else
                hsync <= 1;
            
            // Color assignment
            if (hcount < 640 && vcount < 480) begin
                red[3:0]   <= out[7:4];
//                red[2:0] <= 3'b000;
                green[3:0] <= out[7:4];
//                green[2:0] <= 3'b000;
                blue[3:0]  <= out[7:4];
//                blue[2:0] <= 3'b000;
            end else begin
                red   <= 4'b0000;
                green <= 4'b0000;
                blue  <= 4'b0000;
            end
        
    end

endmodule