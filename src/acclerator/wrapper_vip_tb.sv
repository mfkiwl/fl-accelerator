`timescale 1ns / 1ps

// Import Packages
import axi4stream_vip_pkg::*;
import axis_vip_mst_pkg::*;
import axis_vip_slv_pkg::*;

module wrapper_tb();
	localparam WIDTH = 32;
	
	// Scoreboard Variables
	xil_axi4stream_uint						 	error_count = 0;
	xil_axi4stream_uint						 	check_count = 0;
	axi4stream_monitor_transaction			  	mst_monitor_transaction;
	axi4stream_monitor_transaction			  	mst_moniter_transaction_queue[$];
	axi4stream_monitor_transaction			  	mst_scb_transaction;
	axi4stream_monitor_transaction			  	slv_monitor_transaction;
	axi4stream_monitor_transaction			  	slv_moniter_transaction_queue[$];
	axi4stream_monitor_transaction			  	slv_scb_transaction;
	
	// Driver Agents
	axis_vip_mst_mst_t			   mst_agent;
	axis_vip_slv_slv_t			   slv_agent;
	
	xil_axi4stream_data_byte					mst_send_data   [0:7];
	xil_axi4stream_data_byte					mst_data		[0:7];
	xil_axi4stream_data_byte					slv_data		[0:3];
	
	// Instantiate Modules
	// Shared Signals
	reg 	clk, rstn;
	reg 	[M_BITS - 1 : 0]											img_in_data;
	reg 																img_in_last;
	reg 																img_in_ready;
	reg 																img_in_valid;
	reg 																kernel_in_ready;
	reg 	[K_DIM - 1 : 0] [M_BITS - 1 : 0]							kernel_in_data;
	reg 																kernel_in_last;
	reg 																kernel_in_valid;
	reg 	[K_DIM - 1 : 0] [K_DIM - 1 : 0] [M_BITS - 1 : 0]			mult_data;
	reg 																mult_last;
	reg 																mult_ready;
	reg 	[1 : 0] [I_BITS - 1 : 0]									mult_user;
	reg 																mult_valid;
	
	wrapper wrapper_inst (
		.clk(clk),
		.aresetn(rstn),
		.img_in_data(img_in_data),
		.img_in_last(img_in_last),
		.img_in_ready(img_in_ready),
		.img_in_valid(img_in_valid),
		.kernel_in_data(kernel_in_data),
		.kernel_in_last(kernel_in_last),
		.kernel_in_ready(kernel_in_ready),
		.kernel_in_valid(kernel_in_valid),
		.mult_data(mult_data),
		.mult_last(mult_last),
		.mult_ready(mult_ready),
		.mult_user(mult_user),
		.mult_valid(mult_valid)
	);

	axis_vip_mst img_mst (
		.aclk(clk),
		.aresetn(rstn),
		.m_axis_tdata(img_in_data),
		.m_axis_tlast(img_in_last),
		.m_axis_tready(img_in_ready),
		.m_axis_tvalid(img_in_valid)
	);

	axis_vip_mst kernel_mst (
		.aclk(clk),
		.aresetn(rstn),
		.m_axis_tdata(kernel_in_data),
		.m_axis_tlast(kernel_in_last),
		.m_axis_tready(kernel_in_ready),
		.m_axis_tvalid(kernel_in_valid)
	);

	axis_vip_slv slv (
		.aclk(clk),
		.aresetn(rstn),
		.s_axis_tdata(mult_data),
		.s_axis_tlast(mult_last),
		.s_axis_tready(mult_ready),
		.s_axis_tuser(mult_user),
		.s_axis_tvalid(mult_valid)
	);
	
	
	// Generate Clock Signals
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
		
		// Create Agents
		mst_agent = new ("master agent", mst.inst.IF);
		slv_agent = new ("slave agent", slv.inst.IF);
		mst_agent.set_agent_tag("master");
		slv_agent.set_agent_tag("slave");
		mst_agent.set_verbosity(0);
		slv_agent.set_verbosity(0);
		
		// Drive Idle Bus Low
		mst_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
		slv_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
		
		// Start Agents
		mst_agent.start_master();
		slv_agent.start_slave();

		#10;
		
		fork
			begin
				{mst_send_data[7], mst_send_data[6], mst_send_data[5], mst_send_data[4]} = 32'h41C00000;
				{mst_send_data[3], mst_send_data[2], mst_send_data[1], mst_send_data[0]} = 32'h424C0000;
				mst_gen_transaction(1'b1);
			end
			begin
				slv_gen_tready();
			end
		join_any
	end
	
	
	task slv_gen_tready();
		axi4stream_ready_gen ready_gen;
		ready_gen = slv_agent.driver.create_ready("ready_gen");
		ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
		ready_gen.set_low_time(2);
		ready_gen.set_high_time(6);
		slv_agent.driver.send_tready(ready_gen);
	endtask :slv_gen_tready
		
		
	// Master Generates Transaction
	task mst_gen_transaction(
		input last
	);
		axi4stream_transaction wr_transaction;
		wr_transaction = mst_agent.driver.create_transaction("Master VIP write transaction");
		WR_TRANSACTION_FAIL_1b: assert(wr_transaction.randomize());
		wr_transaction.set_data(mst_send_data);
		wr_transaction.set_last(last);
		$display("%t - Master sent data %s", $time, wr_transaction.convert2string());
		mst_agent.driver.send(wr_transaction);
	endtask: mst_gen_transaction
			
		// Add transactions to queue
	initial begin
		forever begin
			mst_agent.monitor.item_collected_port.get(mst_monitor_transaction);
			mst_monitor_transaction.get_data(mst_data);
			$display("%t - Master sent data %f %f", $time, $bitstoshortreal({mst_data[7],mst_data[6],mst_data[5],mst_data[4]}), $bitstoshortreal({mst_data[3],mst_data[2],mst_data[1],mst_data[0]}));
			mst_moniter_transaction_queue.push_back(mst_monitor_transaction);
		end
	end
			
	initial begin
		forever begin
			slv_agent.monitor.item_collected_port.get(slv_monitor_transaction);
			slv_monitor_transaction.get_data(slv_data);
			$display("%t - Slave received data %f", $time, $bitstoshortreal({slv_data[3],slv_data[2],slv_data[1],slv_data[0]}));
			slv_moniter_transaction_queue.push_back(slv_monitor_transaction);
		end
	end
			
			
	initial begin
		forever begin
			wait (mst_moniter_transaction_queue.size() > 0) begin
				mst_scb_transaction = mst_moniter_transaction_queue.pop_front;
				wait(slv_moniter_transaction_queue.size() > 0) begin
					slv_scb_transaction = slv_moniter_transaction_queue.pop_front;
				end
			end
		end
	end
endmodule
