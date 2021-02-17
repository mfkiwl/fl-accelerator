`include "utils.sv"
`timescale 1 ns / 1 ps

module output_ctrl #(
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

	// Multiplier AXI Stream Slave / Output Interfaces (no. of multiplier units = no. of kernel elements)
	output 	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0]			mult_data,
	input 	wire 																mult_last,
	output 	reg																	mult_ready,
	input 	wire 	[1 : 0] [I_BITS - 1 : 0]									mult_user,
	input	wire 																mult_valid,

	// Image AXI Stream Slave Channel
	output 	wire 	[M_BITS - 1 : 0]											out_data,
	output 	reg 																out_last,
	input 	wire 																out_ready,
	output 	reg 																out_valid
);

	// State variables
	enum reg [1:0] {
		IDLE 		= 2'b00,
		CONV 		= 2'b01,
		OUTPUT 		= 2'b10
	} state, next_state;
	reg [O_BITS - 1 : 0] 	out_row, out_col, out_row_next, out_col_next;
	
	// Intermediate Logic
	reg		[M_BITS - 1 : 0] o_val [O_DIM - 1 : 0] [O_DIM - 1 : 0];
	wire 	[I_BITS - 1 : 0] i, j;
	assign i 		= mult_user[1];
	assign j 		= mult_user[0];
	wire ready 		= mult_valid && out_ready;
	wire last_col 	= out_col == O_DIM - 1;
	wire last_row 	= out_row == O_DIM - 1;

	// Combinatorics Outputs
	assign out_data 		= o_val[out_row][out_col];
	assign out_last 	= last_col && last_row;
	assign out_valid 	= (state != IDLE);
	assign mult_ready 	= out_ready && state != OUTPUT;

	task set_o_val();
		for (int m = 0; m < K_DIM; m++) begin
			for (int n = 0; n < K_DIM; n++) begin
				o_val[i + K_DIM - m -1][j + K_DIM - n -1] <= o_val[i + K_DIM - m -1][j + K_DIM - n -1] + mult_data[m][n];
			end
		end
	endtask: set_o_val

	task reset_o_val();
		for (int i = 0; i < O_DIM; i++) begin
			for (int j = 0; j < O_DIM; j++) begin
				o_val[i][j] = '0;
			end
		end
	endtask: reset_o_val

	always @(*) begin: COMB
		case (state)
			IDLE: begin
				if (ready) begin
					next_state		= CONV;
					out_row_next 	= '0;
					out_col_next 	= '0;
				end
				else begin
					next_state 		= IDLE;
					out_row_next 	= '0;
					out_col_next 	= '0;
				end
			end

			CONV: begin
				if (ready) begin
					if (last_col) begin
						next_state 			= mult_last ? OUTPUT : CONV;
						out_row_next 		= out_row + 1'b1;
						out_col_next 		= '0;
					end
					else begin
						next_state 				= mult_last ? OUTPUT : CONV;
						out_row_next 			= out_row;
						out_col_next 			= out_col + 1'b1;
					end
				end
				else begin
					next_state 				= CONV;
					out_row_next 			= out_row;
					out_col_next 			= out_col;
				end
			end

			OUTPUT: begin
				if (last_col) begin
					if (last_row) begin
						next_state 			= IDLE;
						out_row_next 		= '0;
						out_col_next 		= '0;
					end
					else begin
						next_state 			= OUTPUT;
						out_row_next 		= out_row + 1'b1;
						out_col_next 		= '0;
					end
				end
				else begin
					next_state 				= OUTPUT;
					out_row_next 			= out_row;
					out_col_next 			= out_col + 1'b1;
				end
			end
		endcase
	end: COMB

	// State Transitions
	always @(posedge clk) begin: FSM
		if (!rstn) begin
			state 		<= IDLE;
			out_row 	<= '0;
			out_col		<= '0;
			reset_o_val();
		end
		else begin
			state 		<= next_state;
			out_row 	<= out_row_next;
			out_col 	<= out_col_next;
			if(ready) begin
				set_o_val();
			end
			if(next_state == IDLE) begin
				reset_o_val();
			end
		end
	end : FSM

	// Kernel Registers
	// always @(posedge clk) begin: SEQ
	// 	if (!rstn) begin
	// 		reset_o_val();
	// 	end
	// 	else begin
	// 		case (state)
	// 			IDLE: begin
	// 			end

	// 			CONV: begin
	// 			end

	// 			OUTPUT: begin
	// 			end
	// 		endcase
	// 	end
	// end: SEQ

	
endmodule
