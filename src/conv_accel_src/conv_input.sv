`include "utils.sv"
`timescale 1 ns / 1 ps

module conv_input #(parameter integer WIDTH,
                    parameter integer CONV_SIZE,
                    parameter integer KERNEL_SIZE,
					parameter integer SETUP_CYCLES = 32)
                   (input 	wire 					clk,
                    input 	wire 					rstn,
                    output 	wire 					ready,
					input 	wire 				 	id,
                    input 	wire [WIDTH*2-1 : 0] 	data,
                    input 	wire 					last,
                    input 	wire 					valid,
                    output	wire 					mult_valid,
                    input 	wire [1:0] 				mult_ready,
                    output 	wire [WIDTH*2-1:0] 		mult_data,
                    output 	wire 					mult_last);
	
	// State Machine
	localparam  IDLE 		= 2'b00,
				READ_CONV 	= 2'b01,
				READ_DATA 	= 2'b01
	reg [1:0]   state;

	assign ready      = (&mult_ready) && ((state == IDLE) || (state == READ));
	assign mult_valid = valid && ((state == IDLE) || (state == READ));
	assign mult_data  = data;
	assign mult_last  = last;
	
	always @(posedge clk) begin
		if (!rstn) begin
			state 		<= IDLE;
			setup_count <= 1'b0;
		end
		else begin
			case (state)
				IDLE:
				if (valid && (&mult_ready)) begin
					state <= READ;
				end
				else begin
					state <= IDLE;
				end
				
				READ:
				if (last) begin
					state <= IDLE;
				end
				else begin
					state <= READ;
				end
			endcase
		end
	end
	
endmodule
