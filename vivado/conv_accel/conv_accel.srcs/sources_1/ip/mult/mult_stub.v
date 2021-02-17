// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Fri Jul 10 21:51:40 2020
// Host        : DESKTOP-BU03M0S running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/peter/Desktop/Projects/FPGA/vivado/conv_accel/conv_accel.srcs/sources_1/ip/mult/mult_stub.v
// Design      : mult
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_10,Vivado 2020.1" *)
module mult(aclk, s_axis_a_tvalid, s_axis_a_tready, 
  s_axis_a_tdata, s_axis_a_tuser, s_axis_a_tlast, s_axis_b_tvalid, s_axis_b_tready, 
  s_axis_b_tdata, m_axis_result_tvalid, m_axis_result_tready, m_axis_result_tdata, 
  m_axis_result_tuser, m_axis_result_tlast)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[15:0],s_axis_a_tuser[5:0],s_axis_a_tlast,s_axis_b_tvalid,s_axis_b_tready,s_axis_b_tdata[15:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[15:0],m_axis_result_tuser[5:0],m_axis_result_tlast" */;
  input aclk;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [15:0]s_axis_a_tdata;
  input [5:0]s_axis_a_tuser;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [15:0]s_axis_b_tdata;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [15:0]m_axis_result_tdata;
  output [5:0]m_axis_result_tuser;
  output m_axis_result_tlast;
endmodule
