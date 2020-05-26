-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Mon May 25 03:04:41 2020
-- Host        : Peter-XPS running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/Peter/Desktop/Projects/FPGA/pynq/pynq.srcs/sources_1/bd/main/ip/main_conv_accel_0_2/main_conv_accel_0_2_stub.vhdl
-- Design      : main_conv_accel_0_2
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_conv_accel_0_2 is
  Port ( 
    clk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    slv_ready : out STD_LOGIC;
    slv_data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    slv_last : in STD_LOGIC;
    slv_valid : in STD_LOGIC;
    mst_ready : in STD_LOGIC;
    mst_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mst_last : out STD_LOGIC;
    mst_valid : out STD_LOGIC
  );

end main_conv_accel_0_2;

architecture stub of main_conv_accel_0_2 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,aresetn,slv_ready,slv_data[63:0],slv_last,slv_valid,mst_ready,mst_data[31:0],mst_last,mst_valid";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "conv_wrapper,Vivado 2019.2";
begin
end;
