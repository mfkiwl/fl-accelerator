`include "utils.sv"
`timescale 1 ns / 1 ps

// Modules receives kernel and image data from 2 DMA channels and store the kernel / send image data to floating point multipliers
module kernel_ctrl #(
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
	input	wire														clk,
	input	wire														rstn,

	// Kernel AXI Stream Slave Channel
	input 	wire 	[K_DIM - 1 : 0] [M_BITS - 1 : 0]					in_data,
	input 	wire 														in_last,
	output 	reg 														in_ready,
	input 	wire 														in_valid,

	// IO from Image Controller
	output	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0] 	out_data,
	output	reg 														out_valid
);

	// State variables
	enum reg [1:0] {
		IDLE 		= 2'b00,													// Startup
		SET_KERNEL 	= 2'b01,													// Setting Kernel
		READY 		= 2'b10														// Kernel Ready
	} 									state, next_state;
	reg [K_BITS - 1 : 0]				row, row_next;							// Kernel row index (iterate through kernel_val rows)
	reg [M_BITS - 1 : 0] 				k_val [K_DIM - 1 : 0] [K_DIM - 1 : 0]; 	// Kernel Values

	// Intermediate Logic
	wire ready 		= in_valid && in_ready;
	wire last_row 	= row == K_DIM - 1;

	genvar i, j;
	for (i = 0; i < K_DIM; i++) begin: output_k_val
		for (j = 0; j < K_DIM; j++) begin
			assign out_data[i][j] = k_val[i][j];
		end
	end: output_k_val

	// Reset Kernel Values
	task reset_k_val();
		for (int i = 0; i < K_DIM; i++) begin
			for (int j = 0; j < K_DIM; j++) begin
				k_val[i][j] <= '0;
			end
		end
	endtask: reset_k_val

	// Set Kernel Values
	task set_k_val();
		for (int j = 0; j < K_DIM; j++) begin
			k_val[row][j] <= in_data[j];
		end
	endtask: set_k_val

	always @(*) begin: COMB
		case (state)
			IDLE: begin
				if (ready) begin
					// IDLE => SET_KERNEL
					next_state		= SET_KERNEL;
					row_next 		= 1'b1;
				end
				else begin
					// IDLE => IDLE
					next_state 		= IDLE;
					row_next 		= '0;
				end
			end

			SET_KERNEL: begin
				if (ready) begin
					if (in_last) begin
						// SET_KERNEL => READY
						next_state 			= READY;
						row_next 			= '0;
					end
					else begin
						// SET_KERNEL => SET_KERNEL
						next_state 		= SET_KERNEL;
						row_next 		= last_row ? row : row + 1'b1;
					end
				end
				else begin
					// SET_KERNEL => SET_KERNEL
					next_state 				= SET_KERNEL;
					row_next 				= row;
				end
			end

			READY: begin
				if (ready) begin
					// READY => SET_KERNEL
					next_state		= SET_KERNEL;
					row_next 		= 1'b1;
				end
				else begin
					// READY => READY
					next_state 		= READY;
					row_next 		= '0;
				end
			end
		endcase
	end: COMB

	// State Transitions
	always @(posedge clk or negedge rstn) begin: FSM
		if (!rstn) begin
			state 		<= IDLE;
			row 		<= '0;
			reset_k_val();
		end
		else begin
			state 		<= next_state;
			row 		<= row_next;
			if(ready) begin
				set_k_val();
			end
		end
	end : FSM


	always @(posedge clk or negedge rstn) begin: OUT
		if (!rstn) begin
			in_ready 	<= '0;
			out_valid 	<= '0;
		end
		else begin
			case (next_state)
				IDLE: begin
					in_ready 	<= '1;
					out_valid 	<= '0;
				end

				SET_KERNEL: begin
					in_ready 	<= '1;
					out_valid 	<= '0;
				end

				READY: begin
					in_ready 	<= '1;
					out_valid 	<= '1;
				end

			endcase
		end
		
	end: OUT


endmodule
