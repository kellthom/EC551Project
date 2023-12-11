`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 12:51:44 PM
// Design Name: 
// Module Name: uart_receiver
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


module uart_receiver #(parameter BAUD_VAL = 9)
    (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data,
    output reg data_valid
    );

    // State Definitions
    localparam [2:0] IDLE = 3'd0, START = 3'd1, RXDATA = 3'd2, STOP = 3'd3, CLEANUP = 3'd4;

    reg [2:0] current_state =0, next_state = 0;
    reg [31:0] clk_counter = 32'd0;
    reg [2:0] bit_index = 3'd0;
    

    always @(posedge clk) begin
        if(reset) begin
            current_state <= IDLE;
            next_state <= IDLE;
            clk_counter = 0;
            bit_index <= 0;
            data <= 0;
            data_valid <= 0;
        end else begin
            
            case (current_state)
                IDLE :					// Default State
					begin
						clk_counter= 0;
						bit_index = 0;
						data_valid = 1'b0;
						if(rx == 1'b0)
							next_state = START;
						else
							 begin
							     next_state = IDLE;
							 end
					end
                START: begin
						if(clk_counter == (BAUD_VAL-1)/2)		//We are sampling from the middle of the first bit, just to make sure we are ignoring timing issues.
							begin
								if(rx == 1'b0)
									begin
										clk_counter = 0;
										next_state = RXDATA;
									end
								else
									next_state = IDLE;	
							end
						else
							begin
								clk_counter = clk_counter + 1;
								next_state = START;
							end
					end
                RXDATA: 					
                begin
						if(clk_counter < BAUD_VAL-1)		//We were on the middle of the first bit and now, we are on the middle of the next bit which is the first bit of Data bits.
							begin
								clk_counter = clk_counter + 1;
								next_state = RXDATA;
							end
						else
							begin
								clk_counter = 0;
								data[bit_index] = rx;	//We are creating an output BYTE by writing every index of bit one by one.
								
								if(bit_index <7)
									begin
										bit_index = bit_index + 1;
										next_state = RXDATA;
									end
								else
									begin
										bit_index = 0;
										next_state = STOP;
									end
							end
					end
                STOP: begin
						if(clk_counter < BAUD_VAL-1)
							begin
								clk_counter = clk_counter + 1;
								next_state = STOP;
							end
						else
							begin
								data_valid = 1'b1;
								clk_counter = 0;
								next_state = CLEANUP;
								
							end
					end
				//This is for 1 clock cycle delay and returning to the default flow				
				CLEANUP: begin
						data_valid = 1'b0;
						next_state = IDLE;
					end
				default:
				next_state = IDLE;
            endcase
            current_state = next_state;
		end	
	end
	
endmodule
