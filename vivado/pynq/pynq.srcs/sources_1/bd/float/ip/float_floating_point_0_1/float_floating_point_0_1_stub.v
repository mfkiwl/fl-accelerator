// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed May 27 01:33:40 2020
// Host        : Peter-XPS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top float_floating_point_0_1 -prefix
//               float_floating_point_0_1_ float_floating_point_0_0_stub.v
// Design      : float_floating_point_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_9,Vivado 2019.2" *)
module float_floating_point_0_1(aclk, s_axis_a_tvalid, s_axis_a_tready, 
  s_axis_a_tdata, s_axis_a_tlast, s_axis_b_tvalid, s_axis_b_tready, s_axis_b_tdata, 
  s_axis_b_tlast, m_axis_result_tvalid, m_axis_result_tready, m_axis_result_tdata, 
  m_axis_result_tlast)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],s_axis_a_tlast,s_axis_b_tvalid,s_axis_b_tready,s_axis_b_tdata[31:0],s_axis_b_tlast,m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0],m_axis_result_tlast" */;
  input aclk;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [31:0]s_axis_b_tdata;
  input s_axis_b_tlast;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
  output m_axis_result_tlast;
endmodule
