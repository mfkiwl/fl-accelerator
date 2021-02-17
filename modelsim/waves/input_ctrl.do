onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/clk
add wave -noupdate -label rstn -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/rstn
add wave -noupdate -label kernel_ready -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/kernel_ready
add wave -noupdate -label kernel_data -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/kernel_data
add wave -noupdate -label kernel_last -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/kernel_last
add wave -noupdate -label kernel_valid -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/kernel_valid
add wave -noupdate -label img_ready -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/img_ready
add wave -noupdate -label img_data -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/img_data
add wave -noupdate -label img_last -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/img_last
add wave -noupdate -label img_valid -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/img_valid
add wave -noupdate -label mult_valid -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_valid
add wave -noupdate -label mult_ready -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_ready
add wave -noupdate -label mult_data_a -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_data_a
add wave -noupdate -label mult_data_b -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_data_b
add wave -noupdate -label mult_user -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_user
add wave -noupdate -label mult_last -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/mult_last
add wave -noupdate -label state -radix symbolic -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/state
add wave -noupdate -label next_state -radix symbolic -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/next_state
add wave -noupdate -label k_row -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/k_row
add wave -noupdate -label k_row_next -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/k_row_next
add wave -noupdate -label m_k_row -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/m_k_row
add wave -noupdate -label m_k_col -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/m_k_col
add wave -noupdate -label m_k_row_next -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/m_k_row_next
add wave -noupdate -label m_k_col_next -radix unsigned -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/m_k_col_next
add wave -noupdate -label all_mult_ready -radix binary -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/all_mult_ready
add wave -noupdate -label k_val -radix hexadecimal -radixshowbase 0 /input_ctrl_tb/input_ctrl_inst/k_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {100656 ps}
