
`timescale 1 ns / 1 ps

module conv_accel_v1_0 #(parameter integer C_S00_AXIS_input_TDATA_WIDTH	 = 64,
                         parameter integer C_M00_AXIS_output_TDATA_WIDTH = 32,
                         parameter integer CONV_SIZE    = 8,
                         parameter integer KERNEL_SIZE	= 3)
                        (input wire s00_axis_input_aclk, 
                         input wire s00_axis_input_aresetn, 
                         output wire s00_axis_input_tready, 
                         input wire [C_S00_AXIS_input_TDATA_WIDTH-1 : 0] s00_axis_input_tdata, 
                         input wire [(C_S00_AXIS_input_TDATA_WIDTH/8)-1 : 0] s00_axis_input_tstrb, 
                         input wire s00_axis_input_tlast, 
                         input wire s00_axis_input_tvalid, 
                         input wire m00_axis_output_aclk, 
                         input wire m00_axis_output_aresetn, 
                         output wire m00_axis_output_tvalid, 
                         output wire [C_M00_AXIS_output_TDATA_WIDTH-1 : 0] m00_axis_output_tdata, 
                         output wire [(C_M00_AXIS_output_TDATA_WIDTH/8)-1 : 0] m00_axis_output_tstrb, 
                         output wire m00_axis_output_tlast, 
                         input wire m00_axis_output_tready,
                         input wire float_clk);
// Instantiation of Axi Bus Interface S00_AXIS_input

wire [1:0]  float_in_valid;
wire [1:0]  float_in_ready;
wire [63:0] float_in_data;
wire        float_in_last;
wire        float_out_valid;
wire        float_out_ready;
wire [31:0] float_out_data;
wire        float_out_last;

float_mult float_mult_inst (
.aclk(float_clk),
.s_axis_a_tvalid(float_in_valid[0]),
.s_axis_a_tready(float_in_ready[0]),
.s_axis_a_tdata(float_in_data[31:0]),
.s_axis_a_tlast(float_in_last),
.s_axis_b_tvalid(float_in_valid[1]),
.s_axis_b_tready(float_in_ready[1]),
.s_axis_b_tdata(float_in_data[63:32]),
.s_axis_b_tlast(float_in_last),
.m_axis_result_tvalid(float_out_valid),
.m_axis_result_tready(float_out_ready),
.m_axis_result_tdata(float_out_data),
.m_axis_result_tlast(float_out_last)
);

conv_input #(
.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_input_TDATA_WIDTH),
.CONV_SIZE(CONV_SIZE),
.KERNEL_SIZE(KERNEL_SIZE)
) conv_input_inst (
.S_AXIS_ACLK(s00_axis_input_aclk),
.S_AXIS_ARESETN(s00_axis_input_aresetn),
.S_AXIS_TREADY(s00_axis_input_tready),
.S_AXIS_TDATA(s00_axis_input_tdata),
.S_AXIS_TLAST(s00_axis_input_tlast),
.S_AXIS_TVALID(s00_axis_input_tvalid),
.mult_valid(float_in_valid),
.mult_ready(float_in_ready),
.mult_data(float_in_data),
.mult_last(float_in_last)
);

// Instantiation of Axi Bus Interface M00_AXIS_output
conv_output #(
.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_output_TDATA_WIDTH),
.CONV_SIZE(CONV_SIZE),
.KERNEL_SIZE(KERNEL_SIZE)
) conv_output_inst (
.M_AXIS_ACLK(m00_axis_output_aclk),
.M_AXIS_ARESETN(m00_axis_output_aresetn),
.M_AXIS_TVALID(m00_axis_output_tvalid),
.M_AXIS_TDATA(m00_axis_output_tdata),
.M_AXIS_TSTRB(m00_axis_output_tstrb),
.M_AXIS_TLAST(m00_axis_output_tlast),
.M_AXIS_TREADY(m00_axis_output_tready),
.mult_valid(float_out_valid),
.mult_ready(float_out_ready),
.mult_data(float_out_data),
.mult_last(float_out_last)
);

endmodule
