`include "utils.sv"
`timescale 1 ns / 1 ps

// Modules receives kernel and image data from 2 DMA channels and store the kernel / send image data to floating point multipliers
module mult_block #(
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
	input	wire																clk,
	input	wire																rstn,

	// IO from image controller
	input 	wire 	[M_BITS - 1 : 0]											img_data,
	input 	wire 																img_last,
	output 	wire 																img_ready,
	input 	wire 	[1 : 0] [I_BITS - 1 : 0]									img_user,
	input 	wire 																img_valid,

	// IO from kernel controller
	input 	wire 																kernel_valid,
	input 	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0] 			kernel_data,

	// IO from output controller
	output 	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0]			mult_data,
	output 	wire 																mult_last,
	input 	wire 																mult_ready,
	output 	wire 	[1 : 0] [I_BITS - 1 : 0]									mult_user,
	output 	wire																mult_valid
);

	// Internal Circuitry
	wire [K_DIM - 1 : 0] [K_DIM - 1 : 0] 							ready_a;
	wire [K_DIM - 1 : 0] [K_DIM - 1 : 0] 							ready_b;
	wire [K_DIM - 1 : 0] [K_DIM - 1 : 0] [1 : 0] [I_BITS - 1 : 0] 	user;
	wire [K_DIM - 1 : 0] [K_DIM - 1 : 0] 							last;
	wire [K_DIM - 1 : 0] [K_DIM - 1 : 0] 							valid;
	assign img_ready 	= ready_a[0][0];
	assign mult_user 	= user[0][0];
	assign mult_last 	= last[0][0];
	assign mult_valid 	= valid[0][0];

	// Multiplier Block Channel A (Image)
	// valid: pixel data valid
	// last: last pixel data
	// data: pixel data
	// user: pixel coordinates (m, n)

	// Multiplier Block Channel B (Image)
	// valid: kernel data valid
	// data: kernel data
	// user: kernel coordinates (i, j)

	genvar i, j;

	for (i = 0; i < K_DIM; i++) begin
		for (j = 0; j < K_DIM; j++) begin

			mult mult_inst (
				.aclk(clk),
				// Image Controller Interface
				.s_axis_a_tdata(img_data),
				.s_axis_a_tlast(img_last),
				.s_axis_a_tready(ready_a[i][j]),
				.s_axis_a_tuser(img_user),
				.s_axis_a_tvalid(img_valid),

				// Kernel Controller Interface
				.s_axis_b_tdata(kernel_data[i][j]),
				.s_axis_b_tready(ready_b[i][j]),
				.s_axis_b_tvalid(kernel_valid),

				// Output Controller Interface
				.m_axis_result_tdata(mult_data[i][j]),
				.m_axis_result_tready(mult_ready),
				.m_axis_result_tuser(user[i][j]),
				.m_axis_result_tvalid(valid[i][j]),
				.m_axis_result_tlast(last[i][j])
			);

		end
	end


endmodule