`timescale 1ns / 1ps

// Import Packages
import axi4stream_vip_pkg::*;
import axis_vip_mst_pkg::*;
import axis_vip_slv_pkg::*;

module accel_tb();
    localparam WIDTH = 32;
    
    // Scoreboard Variables
    xil_axi4stream_uint                         error_count = 0;
    xil_axi4stream_uint                         check_count = 0;
    axi4stream_monitor_transaction              mst_monitor_transaction;
    axi4stream_monitor_transaction              mst_moniter_transaction_queue[$];
    axi4stream_monitor_transaction              mst_scb_transaction;
    axi4stream_monitor_transaction              slv_monitor_transaction;
    axi4stream_monitor_transaction              slv_moniter_transaction_queue[$];
    axi4stream_monitor_transaction              slv_scb_transaction;
    
    // Driver Agents
    axis_vip_mst_mst_t               mst_agent;
    axis_vip_slv_slv_t               slv_agent;
    
    xil_axi4stream_data_byte                    mst_send_data   [0:7];
    xil_axi4stream_data_byte                    mst_data        [0:7];
    xil_axi4stream_data_byte                    slv_data        [0:3];
    
    // Instantiate Modules
    // Shared Signals
    reg clk, rstn;
    // AXIS Master VIP
    wire                        in_valid, in_ready, in_last;
    wire [WIDTH * 2 - 1 : 0]    in_data;
    // AXIS Slave VIP
    wire                        out_valid, out_ready, out_last;
    wire [WIDTH - 1 : 0]        out_data;
    
    conv_wrapper #(
        .WIDTH(WIDTH)
    ) conv_accel (
        .clk(clk),
        .aresetn(rstn),
        .slv_ready(in_ready),
        .slv_data(in_data),
        .slv_last(in_last),
        .slv_valid(in_valid),
        .mst_ready(out_ready),
        .mst_data(out_data),
        .mst_last(out_last),
        .mst_valid(out_valid)
    );

    axis_vip_mst mst (
        .aclk(clk),
        .aresetn(rstn),
        .m_axis_tvalid(in_valid),
        .m_axis_tready(in_ready),
        .m_axis_tdata(in_data),
        .m_axis_tlast(in_last)
    );

    axis_vip_slv slv (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_tvalid(out_valid),
        .s_axis_tready(out_ready),
        .s_axis_tdata(out_data),
        .s_axis_tlast(out_last)
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
                $display("YOYOYO");
                mst_scb_transaction = mst_moniter_transaction_queue.pop_front;
                wait(slv_moniter_transaction_queue.size() > 0) begin
                    slv_scb_transaction = slv_moniter_transaction_queue.pop_front;
                end
            end
        end
    end
endmodule
