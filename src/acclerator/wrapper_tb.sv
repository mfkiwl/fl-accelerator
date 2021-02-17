`timescale 1ns / 1ps

module wrapper_tb();

	// Calculates the number of bits for an unsigned integer
	function integer nbits (input integer num);
		begin
			num = num - 1;
			for(nbits = 0; num > 0; nbits = nbits + 1)
				num = num >> 1;
		end
	endfunction

	// Calculates the square of an integer
	function integer sq (input integer dim);
		begin
			sq = dim ** 2;
		end
	endfunction

	// Calculates the 
	function integer sqbits (input integer dim);
		begin
			sqbits = nbits(dim ** 2);
		end
	endfunction

	// Calculates the 
	function [15:0] tofp16 (input integer number);
		begin
			tofp16[15] = 1'b0;
			tofp16[14:10] = $clog2(number + 1) + 14;
			tofp16[9:0] = number * (2 ** (11 - $clog2(number + 1))) - 2 ** 10;
		end
	endfunction

	localparam integer K_DIM	= 3;						// Kernel Dimensions
	localparam integer I_DIM	= 3;						// Image Cache Dimensions
	localparam integer M_BITS	= 16;						// Multiplier Precision (Floating Point Bits)
	localparam integer M_CNT	= 16;						// Number of Multiplier Blocks
	localparam integer K_SIZE	= sq(K_DIM);				// Kernel Size
	localparam integer K_BITS	= nbits(K_DIM);				// Kernel Dimension Bits
	localparam integer I_SIZE	= sq(I_DIM);				// Image Size
	localparam integer I_BITS	= nbits(I_DIM);				// Image Dimension Bits
	localparam integer O_DIM	= K_DIM + I_DIM - 1;		// Output Dimension
	localparam integer O_SIZE	= sq(O_DIM);				// Output Size
	localparam integer O_BITS	= nbits(O_DIM);				// Output Dimension Bits

	reg 																clk, rstn;

	// Image AXIS
	reg 	[M_BITS - 1 : 0]											img_in_data;
	reg 																img_in_last;
	wire 																img_in_ready;
	reg 																img_in_valid;

	// Kernel AXIS
	wire 																kernel_in_ready;
	reg 	[K_DIM - 1 : 0] [M_BITS - 1 : 0]							kernel_in_data;
	reg 																kernel_in_last;
	reg 																kernel_in_valid;


	// Image AXI Stream Slave Channel
	wire 	[M_BITS - 1 : 0]											out_data;
	wire 																out_last;
	reg 																out_ready;
	wire 																out_valid;
	
	wrapper wrapper_inst (
		.clk(clk),
		.rstn(rstn),
		.img_in_data(img_in_data),
		.img_in_last(img_in_last),
		.img_in_ready(img_in_ready),
		.img_in_valid(img_in_valid),
		.kernel_in_data(kernel_in_data),
		.kernel_in_last(kernel_in_last),
		.kernel_in_ready(kernel_in_ready),
		.kernel_in_valid(kernel_in_valid),
		.out_data(out_data),
		.out_last(out_last),
		.out_ready(out_ready),
		.out_valid(out_valid)
	);
	
	// Generate Clock Signals
	initial begin
		rstn <= 1'b0;
		clk <= 1'b0;
		#10;
		rstn <= 1'b1;
	end
	
	always #5 clk <= ~clk;

	// Send a kernel matrix
	task send_kernel();
		// Loop over each kernel column
		for (int i=0; i<K_DIM; i++) begin
			for (int j=0; j<K_DIM; j++) begin
				kernel_in_data[j] 	<= tofp16(i * K_DIM + j + 1);
				kernel_in_last 		<= i == K_DIM - 1;
				kernel_in_valid 	<= '1;
			end
			#10;
		end
		
		kernel_in_data 		<= '0;
		kernel_in_valid 	<= '0;
		kernel_in_last 		<= '0;
	endtask: send_kernel

	task send_img();
		for (int i=0; i<I_SIZE + 4; i++) begin
			img_in_data 		<= tofp16(i + 5);
			img_in_last 		<= i == I_SIZE + 3;
			img_in_valid 		<= '1;
			#10;
		end

		img_in_data 		<= '0;
		img_in_valid 		<= '0;
		img_in_last 		<= '0;
	endtask: send_img
	
	// Initiatlize Agents
	initial begin
		// Set Timeformat
		$timeformat(-8, 1, " cycle", 1);

		kernel_in_data 		<= '0;
		kernel_in_last 		<= '0;
		kernel_in_valid 	<= '0;

		img_in_data			<= '0;
		img_in_last			<= '0;
		img_in_valid		<= '0;

		out_ready 			<= '1;
		
		#26;

		send_kernel();

		#10;

		send_img();

	end
	
endmodule
