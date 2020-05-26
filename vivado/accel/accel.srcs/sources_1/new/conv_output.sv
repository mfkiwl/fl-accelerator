`include "utils.sv"
`timescale 1 ns / 1 ps

module conv_output #(parameter integer WIDTH,
                     parameter integer CONV_SIZE,
                     parameter integer KERNEL_SIZE)
                    (input wire	clk,
                     input wire	rstn,
                     output wire valid,
                     output wire [WIDTH-1 : 0] data,
                     output wire last,
                     input wire	ready,
                     input wire mult_valid,
                     output wire mult_ready,
                     input wire [WIDTH-1:0] mult_data,
                     input wire mult_last);
    
    
    // I/O Connections assignments
    assign valid	     = mult_valid;
    assign mult_ready = ready;
    assign data		     = mult_data;
    assign last		     = mult_last;
    
endmodule
