`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 09:13:03 PM
// Design Name: 
// Module Name: uart_transmitter
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


module uart_transmitter#(parameter BAUD_VAL = 87)
    (
    input clk,
    input data_valid,						//Data Valid
    input reset,
    input [7:0] data_in,				//Parallel Data
    output reg tx,				//Serial Data
    output reg tx_active,					//Information for TRANSMITTER being active
    output reg tx_done					//Information for Transmitting process being done
    );
    
    localparam [2:0] IDLE = 3'd0, START = 3'd1, TXDATA = 3'd2, STOP = 3'd3, CLEANUP = 3'd4;

    reg [2:0] current_state = 0, next_state = 0;
    reg [31:0] clk_counter = 32'b0;			//Counter for sampling data
    reg [2:0] bit_index = 3'b0;				//Index counter variable for receiving data
    reg [7:0] tx_byte = 8'b0;				//Variable which will be transmitted data as byte domain
    
    //Opposite algorithm of UART Receiver
    
    always@(posedge clk) begin
        if(reset) begin
            current_state = IDLE;
            next_state = IDLE;
            clk_counter = 0;
            bit_index = 0;
            tx = 1'b1;
            tx_active = 1'b0;
            tx_done = 1'b0;
        end else begin
            
            case(current_state)
                IDLE:
                    begin
                        clk_counter = 0;
                        bit_index = 0;
                        tx_done = 1'b0;
                        tx = 1'b1;
                        
                        if(data_valid == 1'b1)
                            begin
                                tx_active = 1'b1;
                                tx_byte = data_in;
                                next_state = START;
                            end
                        else
                            next_state = IDLE;
                    end
                START:
                    begin
                        tx = 1'b0;
                        
                        if(clk_counter < BAUD_VAL -1)
                            begin
                                clk_counter = clk_counter + 1;
                                next_state = START;	
                            end
                        else
                            begin
                                clk_counter = 0;
                                next_state = TXDATA;
                            end
                    end
                TXDATA:
                    begin
                        tx = tx_byte[bit_index];
                        
                        if(clk_counter < BAUD_VAL -1)
                            begin
                                clk_counter = clk_counter + 1;
                                next_state = TXDATA;
                            end
                        else
                            begin
                                clk_counter = 0;
                                if(bit_index < 7)
                                    begin
                                        bit_index = bit_index + 1;
                                        next_state = TXDATA;
                                    end
                                else
                                    begin
                                        bit_index = 0;
                                        next_state = STOP;
                                    end
                            end
                    end
                STOP:
                    begin
                        tx = 1'b1;
                            if(clk_counter < BAUD_VAL -1)
                                begin
                                    clk_counter = clk_counter + 1;
                                    next_state = STOP;
                                end
                            else
                                begin
                                    clk_counter = 0;
                                    next_state = CLEANUP;
                                    tx_done = 1'b1;
                                    tx_active = 1'b0;
                                end
                    end
                CLEANUP:
                    begin
                        next_state = IDLE;
                        tx_done = 1'b1;
                    end
                default:
                    next_state = IDLE;
            endcase
            current_state = next_state;
        end
    end

    
endmodule
