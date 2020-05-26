`timescale 1 ns / 1 ps

module conv_wrapper #(parameter integer WIDTH = 32,
                      parameter integer CONV_SIZE = 8,
                      parameter integer KERNEL_SIZE	 = 3)
                     (input wire clk,
                      input wire aresetn,
                      output wire slv_ready,               // AXIS Slave Interface
                      input wire [WIDTH*2-1 : 0] slv_data,
                      input wire slv_last,
                      input wire slv_valid,
                      input wire mst_ready,                // AXIS Master Interface
                      output wire [WIDTH-1 : 0] mst_data,
                      output wire mst_last,
                      output wire mst_valid);
    // Instantiation of Axi Bus Interface S00_AXIS_input
    
    wire                mult_slv_valid;
    wire [1:0]          mult_slv_ready;
    wire [WIDTH-1:0]    mult_slv_data_a;
    wire [WIDTH-1:0]    mult_slv_data_b;
    wire                mult_slv_last;
    wire                mult_mst_valid;
    wire                mult_mst_ready;
    wire [WIDTH-1:0]    mult_mst_data;
    wire                mult_mst_last;
    
    mult mult_inst (
    .aclk(clk),
    .s_axis_a_tvalid(mult_slv_valid),
    .s_axis_a_tready(mult_slv_ready[0]),
    .s_axis_a_tdata(mult_slv_data_a),
    .s_axis_a_tlast(mult_slv_last),
    .s_axis_b_tvalid(mult_slv_valid),
    .s_axis_b_tready(mult_slv_ready[1]),
    .s_axis_b_tdata(mult_slv_data_b),
    .s_axis_b_tlast(mult_slv_last),
    .m_axis_result_tvalid(mult_mst_valid),
    .m_axis_result_tready(mult_mst_ready),
    .m_axis_result_tdata(mult_mst_data),
    .m_axis_result_tlast(mult_mst_last)
    );
    
    conv_input #(
    .WIDTH(WIDTH),
    .CONV_SIZE(CONV_SIZE),
    .KERNEL_SIZE(KERNEL_SIZE)
    ) conv_input_inst (
    .clk(clk),
    .rstn(aresetn),
    .ready(slv_ready),
    .data(slv_data),
    .last(slv_last),
    .valid(slv_valid),
    .mult_valid(mult_slv_valid),
    .mult_ready(mult_slv_ready),
    .mult_data({mult_slv_data_a, mult_slv_data_b}),
    .mult_last(mult_slv_last)
    );
    
    // Instantiation of Axi Bus Interface M00_AXIS_output
    conv_output #(
    .WIDTH(WIDTH),
    .CONV_SIZE(CONV_SIZE),
    .KERNEL_SIZE(KERNEL_SIZE)
    ) conv_output_inst (
    .clk(clk),
    .rstn(aresetn),
    .valid(mst_valid),
    .data(mst_data),
    .last(mst_last),
    .ready(mst_ready),
    .mult_valid(mult_mst_valid),
    .mult_ready(mult_mst_ready),
    .mult_data(mult_mst_data),
    .mult_last(mult_mst_last)
    );
    
endmodule
