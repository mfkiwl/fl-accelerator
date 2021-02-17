// ModelSim testbench for input_ctrl module

`include "utils.sv"
`timescale 1ns / 1ps

module kernel_ctrl_tb ();

	localparam integer K_DIM	= 3;						// Kernel Dimensions
	localparam integer I_DIM	= 8;						// Image Cache Dimensions
	localparam integer M_BITS	= 16;						// Multiplier Precision (Floating Point Bits)
	localparam integer M_CNT	= 16;						// Number of Multiplier Blocks
	localparam integer K_SIZE	= sq(K_DIM);				// Kernel Size
	localparam integer K_BITS	= nbits(K_DIM);				// Kernel Dimension Bits
	localparam integer I_SIZE	= sq(I_DIM);				// Image Size
	localparam integer I_BITS	= nbits(I_DIM);				// Image Dimension Bits
	localparam integer O_DIM	= K_DIM + I_DIM - 1;		// Output Dimension
	localparam integer O_SIZE	= sq(O_DIM);				// Output Size
	localparam integer O_BITS	= nbits(O_DIM);				// Output Dimension Bits

	// Clock and Reset
	reg 														clk, rstn;

	// Kernel AXI Stream Slave Channel
	wire 														kernel_ready;
	reg 	[K_DIM - 1 : 0] [M_BITS - 1 : 0]					kernel_data;
	reg 														kernel_last;
	reg 														kernel_valid;
	
	// IO from Image Controller
	wire 														kernel_out_valid;
	wire 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0] 	kernel_out_data;
	
	
	// Generate Clock and Reset Signals
	initial begin
		rstn <= 1'b0;
		clk <= 1'b0;
		#10;
		rstn <= 1'b1;
	end
	
	always #5 clk <= ~clk;
	
	
	// Initiatlize Agents
	initial begin
		// Set Timeformat
		$timeformat(-8, 1, " cycle", 1);

		kernel_last 	<= 1'b0;
		
		kernel_valid 	<= 1'b0;
		
		#26

		send_kernel();

		#10

		send_kernel2();
	end

	// Send a kernel column
	task send_kernel_col(
		input [M_BITS - 1 : 0] 	data,
		input 					last
	);
		kernel_valid 		<= 1'b1;
		kernel_last 		<= last;

		// Sets data for each kernel row
		for (int i=0; i<K_DIM; i++) begin
			kernel_data[i] 	<= unsigned' (data + i);
		end
	endtask: send_kernel_col

	// Send a kernel matrix
	task send_kernel();
		// Loop over each kernel column
		for (int i=0; i<K_DIM; i++) begin
			send_kernel_col(
				i * 10, 
				(i == K_DIM - 1)
			);
			#10;
		end
		kernel_valid 		<= 1'b0;
		kernel_last 		<= 1'b0;
	endtask: send_kernel

	// Send a different kernel matrix
	task send_kernel2();
		// Loop over each kernel column
		for (int i=K_DIM; i>0; i--) begin
			send_kernel_col(
				i * 10, 
				(i == 1)
			);
			#10;
		end
		kernel_valid 		<= 1'b0;
		kernel_last 		<= 1'b0;
	endtask: send_kernel2

kernel_ctrl #(
	.K_DIM(K_DIM),
	.I_DIM(I_DIM),
	.M_BITS(M_BITS),
	.M_CNT(M_CNT),
	.K_SIZE(K_SIZE),
	.K_BITS(K_BITS),
	.I_SIZE(I_SIZE),
	.I_BITS(I_BITS),
	.O_DIM(O_DIM),
	.O_SIZE(O_SIZE),
	.O_BITS(O_BITS)
) kernel_ctrl_inst (
	.clk(clk),
	.rstn(rstn),
	.in_ready(kernel_ready),
	.in_data(kernel_data),
	.in_last(kernel_last),
	.in_valid(kernel_valid),
	.out_valid(kernel_out_valid),
	.out_data(kernel_out_data) 
);

endmodule
