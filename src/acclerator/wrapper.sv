`timescale 1 ns / 1 ps

module wrapper #(
	parameter integer K_DIM		= 3,						// Kernel Dimensions
	parameter integer I_DIM		= 3,						// Image Cache Dimensions
	parameter integer M_BITS	= 16,						// Multiplier Precision (Floating Point Bits)
	parameter integer M_CNT		= 16,						// Number of Multiplier Blocks
	parameter integer I_BITS	= 3							// Image Dimension Bits
) (
	input 	wire 																clk,
	input 	wire 																rstn,

	// Image AXI Stream Slave Channel
	input 	wire 	[M_BITS - 1 : 0]											img_in_data,
	input 	wire 																img_in_last,
	output 	wire 																img_in_ready,
	input 	wire 																img_in_valid,

	// Kernel AXI Stream Slave Channel
	input 	wire 	[K_DIM - 1 : 0] [M_BITS - 1 : 0]							kernel_in_data,
	input 	wire 																kernel_in_last,
	output 	reg 																kernel_in_ready,
	input 	wire 																kernel_in_valid,

	// Image AXI Stream Slave Channel
	output 	wire 	[M_BITS - 1 : 0]											out_data,
	output 	wire 																out_last,
	input 	wire 																out_ready,
	output 	wire 																out_valid

);

	wire 	[M_BITS - 1 : 0]													img_out_data;
	wire 																		img_out_last;
	wire 																		img_out_ready;
	wire 	[1 : 0] [I_BITS - 1 : 0]											img_out_user;
	wire 																		img_out_valid;
	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0] 					kernel_out_data;
	wire 																		kernel_out_valid;

	// Mult Outputs
	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0]					mult_data;
	wire 																		mult_last;
	wire 																		mult_ready;
	wire 	[1 : 0] [I_BITS - 1 : 0]											mult_user;
	wire																		mult_valid;

img_ctrl #(
	.K_DIM(K_DIM),
	.I_DIM(I_DIM),
	.M_BITS(M_BITS),
	.M_CNT(M_CNT)
) img_ctrl_inst (
	.clk(clk),
	.rstn(rstn),
	.in_data(img_in_data),
	.in_last(img_in_last),
	.in_ready(img_in_ready),
	.in_valid(img_in_valid),
	.out_data(img_out_data),
	.out_last(img_out_last),
	.out_ready(img_out_ready),
	.out_user(img_out_user),
	.out_valid(img_out_valid)
);

kernel_ctrl #(
	.K_DIM(K_DIM),
	.I_DIM(I_DIM),
	.M_BITS(M_BITS),
	.M_CNT(M_CNT)
) kernel_ctrl_inst (
	.clk(clk),
	.rstn(rstn),
	.in_data(kernel_in_data),
	.in_last(kernel_in_last),
	.in_ready(kernel_in_ready),
	.in_valid(kernel_in_valid),
	.out_data(kernel_out_data),
	.out_valid(kernel_out_valid)
);

mult_block #(
	.K_DIM(K_DIM),
	.I_DIM(I_DIM),
	.M_BITS(M_BITS),
	.M_CNT(M_CNT)
) mult_block_inst (
	.clk(clk),
	.rstn(rstn),
	.img_data(img_out_data),
	.img_last(img_out_last),
	.img_ready(img_out_ready),
	.img_user(img_out_user),
	.img_valid(img_out_valid),
	.kernel_valid(kernel_out_valid),
	.kernel_data(kernel_out_data),
	.mult_data(mult_data),
	.mult_last(mult_last),
	.mult_ready(mult_ready),
	.mult_user(mult_user),
	.mult_valid(mult_valid)
);

output_ctrl #(
	.K_DIM(K_DIM),
	.I_DIM(I_DIM),
	.M_BITS(M_BITS),
	.M_CNT(M_CNT)
) output_ctrl_inst (
	.clk(clk),
	.rstn(rstn),
	.mult_data(mult_data),
	.mult_last(mult_last),
	.mult_ready(mult_ready),
	.mult_user(mult_user),
	.mult_valid(mult_valid),
	.out_data(out_data),
	.out_last(out_last),
	.out_ready(out_ready),
	.out_valid(out_valid)
);
	
endmodule
