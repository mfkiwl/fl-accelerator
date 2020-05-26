// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: peteryuen:fl:conv_accel:1.0
// IP Revision: 4

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module main_conv_accel_0_2 (
  clk,
  aresetn,
  slv_ready,
  slv_data,
  slv_last,
  slv_valid,
  mst_ready,
  mst_data,
  mst_last,
  mst_valid
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF AXIS_SLV:AXIS_MST, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN main_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_SLV TREADY" *)
output wire slv_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_SLV TDATA" *)
input wire [63 : 0] slv_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_SLV TLAST" *)
input wire slv_last;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AXIS_SLV, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN main_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_SLV TVALID" *)
input wire slv_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_MST TREADY" *)
input wire mst_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_MST TDATA" *)
output wire [31 : 0] mst_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_MST TLAST" *)
output wire mst_last;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AXIS_MST, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN main_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 AXIS_MST TVALID" *)
output wire mst_valid;

  conv_wrapper #(
    .WIDTH(32),
    .CONV_SIZE(8),
    .KERNEL_SIZE(3)
  ) inst (
    .clk(clk),
    .aresetn(aresetn),
    .slv_ready(slv_ready),
    .slv_data(slv_data),
    .slv_last(slv_last),
    .slv_valid(slv_valid),
    .mst_ready(mst_ready),
    .mst_data(mst_data),
    .mst_last(mst_last),
    .mst_valid(mst_valid)
  );
endmodule
