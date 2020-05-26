// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Mon May 25 03:04:41 2020
// Host        : Peter-XPS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Peter/Desktop/Projects/FPGA/pynq/pynq.srcs/sources_1/bd/main/ip/main_conv_accel_0_2/main_conv_accel_0_2_stub.v
// Design      : main_conv_accel_0_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "conv_wrapper,Vivado 2019.2" *)
module main_conv_accel_0_2(clk, aresetn, slv_ready, slv_data, slv_last, 
  slv_valid, mst_ready, mst_data, mst_last, mst_valid)
/* synthesis syn_black_box black_box_pad_pin="clk,aresetn,slv_ready,slv_data[63:0],slv_last,slv_valid,mst_ready,mst_data[31:0],mst_last,mst_valid" */;
  input clk;
  input aresetn;
  output slv_ready;
  input [63:0]slv_data;
  input slv_last;
  input slv_valid;
  input mst_ready;
  output [31:0]mst_data;
  output mst_last;
  output mst_valid;
endmodule
