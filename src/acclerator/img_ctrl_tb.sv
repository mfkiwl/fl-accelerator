// ModelSim testbench for input_ctrl module

`include "utils.sv"
`timescale 1ns / 1ps

module img_ctrl_tb ();

	parameter integer K_DIM		= 3;						// Kernel Dimensions
	parameter integer I_DIM		= 8;						// Image Cache Dimensions
	parameter integer M_BITS	= 16;						// Multiplier Precision (Floating Point Bits)
	parameter integer M_CNT		= 16;						// Number of Multiplier Blocks
	parameter integer K_SIZE	= sq(K_DIM);				// Kernel Size
	parameter integer K_BITS	= nbits(K_DIM);				// Kernel Dimension Bits
	parameter integer I_SIZE	= sq(I_DIM);				// Image Size
	parameter integer I_BITS	= nbits(I_DIM);				// Image Dimension Bits
	parameter integer O_DIM		= K_DIM + I_DIM - 1;		// Output Dimension
	parameter integer O_SIZE	= sq(O_DIM);				// Output Size
	parameter integer O_BITS	= nbits(O_DIM);				// Output Dimension Bits

	// Clock and Reset
	reg clk, rstn;

	// Image AXI Stream Slave Channel
	reg 	[M_BITS - 1 : 0]			img_data;
	reg 								img_last;
	wire 								img_ready;
	reg 								img_valid;

	// Multiplier AXI Stream Interface

	// IO from image controller
	wire 	[M_BITS - 1 : 0]			mult_data;
	wire 								mult_last;
	reg 								mult_ready;
	wire 	[1 : 0] [I_BITS - 1 : 0]	mult_user;
	wire 								mult_valid;
	
	
	// Generate Clock and Reset Signals
	initial begin
		rstn 	<= '0;
		clk 	<= '0;
		#10;
		rstn 	<= '1;
	end
	
	always #5 clk <= ~clk;
	
	
	// Initiatlize Agents
	initial begin
		// Set Timeformat
		$timeformat(-8, 1, " cycle", 1);

		img_last 		<= '0;
		img_valid 		<= '0;	
		mult_ready 		<= '1;

		#26

		send_img();
	end

	task send_img();
		img_valid 		<= '1;
		img_last 		<= '0;
		for (int i=0; i<I_SIZE + 4; i++) begin
			img_data 	<= unsigned' (i);
			if (i == I_SIZE + 3) begin
				img_last 		<= '1;
			end
			#10;
		end
		img_valid 		<= '0;
		img_last 		<= '0;
	endtask: send_img
	
	img_ctrl img_ctrl_inst (
		.clk(clk),
		.rstn(rstn),

		.in_ready(img_ready),
		.in_data(img_data),
		.in_last(img_last),
		.in_valid(img_valid),

		.out_data(mult_data),
		.out_last(mult_last),
		.out_ready(mult_ready),
		.out_user(mult_user),
		.out_valid(mult_valid)
	);

endmodule
