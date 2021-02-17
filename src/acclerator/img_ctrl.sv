`include "utils.sv"
`timescale 1 ns / 1 ps

// Modules receives kernel and image data from 2 DMA channels and store the kernel / send image data to floating point multipliers
module img_ctrl #(
	parameter integer K_DIM		= 3,						// Kernel Dimensions
	parameter integer I_DIM		= 8,						// Image Cache Dimensions
	parameter integer M_BITS	= 16,						// Multiplier Precision (Floating Point Bits)
	parameter integer M_CNT		= 16,						// Number of Multiplier Blocks
	parameter integer K_SIZE	= sq(K_DIM),				// Kernel Size
	parameter integer K_BITS	= nbits(K_DIM),				// Kernel Dimension Bits
	parameter integer I_SIZE	= sq(I_DIM),				// Image Size
	parameter integer I_BITS	= nbits(I_DIM),				// Image Dimension Bits
	parameter integer O_DIM		= K_DIM + I_DIM - 1,		// Output Dimension
	parameter integer O_SIZE	= sq(O_DIM),				// Output Size
	parameter integer O_BITS	= nbits(O_DIM)				// Output Dimension Bits
) (
	input  wire																	clk,
	input  wire																	rstn,

	// Image AXI Stream Slave Channel
	input 	wire 	[M_BITS - 1 : 0]											in_data,
	input 	wire 																in_last,
	output 	wire 																in_ready,
	input 	wire 																in_valid,

	// IO from image controller
	output 	wire 	[M_BITS - 1 : 0]											out_data,
	output 	wire 																out_last,
	input 	wire 																out_ready,
	output 	wire 	[1 : 0] [I_BITS - 1 : 0]									out_user,
	output 	wire 																out_valid
);

	// State variables
	enum reg [1:0] {
		IDLE 		= 2'b00,
		CONV 		= 2'b01,
		WAIT 		= 2'b10
	} 						state, next_state;
	reg [I_BITS - 1 : 0] 	img_row, img_col, img_row_next, img_col_next;

	// Intermediate Logic
	wire last_col 	= img_col == I_DIM - 1;
	wire last_row 	= img_row == I_DIM - 1;
	wire ready 		= in_valid && out_ready;

	// Combinatorics Outputs
	assign out_data = in_data;
	assign out_last = last_col && last_row;
	assign out_user = {img_row, img_col};
	assign out_valid = state == CONV || (state == IDLE && ready && !in_last) ;
	assign in_ready = out_ready;

	always @(*) begin: COMB
		case (state)
			IDLE: begin
				if (ready) begin
					// IDLE => CONV
					next_state 		= CONV;
					img_row_next	= '0;
					img_col_next	= 1'b1;
				end
				else begin
					// IDLE => IDLE
					next_state 		= IDLE;
					img_row_next	= '0;
					img_col_next	= '0;
				end
			end
				
			CONV: begin
				if (ready) begin
					if (last_col) begin
						if (last_row) begin
							next_state 			= in_last ? IDLE : WAIT;
							img_row_next 		= '0;
							img_col_next 		= '0;
						end
						else begin
							next_state 			= CONV;
							img_row_next 		= img_row + 1'b1;
							img_col_next 		= '0;
						end
					end
					else begin
						next_state 				= CONV;
						img_row_next 			= img_row;
						img_col_next 			= img_col + 1'b1;
					end
				end
				else begin
					next_state 				= CONV;
					img_row_next 			= img_row;
					img_col_next 			= img_col;
				end
			end	

			WAIT: begin
				if (ready && in_last) begin
					next_state 			= IDLE;
					img_row_next 		= '0;
					img_col_next 		= '0;
				end
				else begin
					next_state 				= WAIT;
					img_row_next 			= img_row;
					img_col_next 			= img_col;
				end
			end

		endcase
	end: COMB

	// State Transitions
	always @(posedge clk or negedge rstn) begin: FSM
		if (!rstn) begin
			state 		<= IDLE;
			img_row 	<= '0;
			img_col		<= '0;
		end
		else begin
			state 		<= next_state;
			img_row 	<= img_row_next;
			img_col 	<= img_col_next;
		end
	end : FSM

endmodule
