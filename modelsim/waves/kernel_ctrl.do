onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/clk
add wave -noupdate -label rstn -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/rstn
add wave -noupdate -label in_ready -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/in_ready
add wave -noupdate -label in_data -radix unsigned -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/in_data
add wave -noupdate -label in_last -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/in_last
add wave -noupdate -label in_valid -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/in_valid
add wave -noupdate -label out_valid -radix binary -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/out_valid
add wave -noupdate -label out_data -radix unsigned -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/out_data
add wave -noupdate -label state -radix symbolic -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/state
add wave -noupdate -label next_state -radix symbolic -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/next_state
add wave -noupdate -label row -radix unsigned -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/row
add wave -noupdate -label row_next -radix unsigned -radixshowbase 0 /kernel_ctrl_tb/kernel_ctrl_inst/row_next
add wave -noupdate -label k_val -radix unsigned -childformat {{{/kernel_ctrl_tb/kernel_ctrl_inst/k_val[2]} -radix unsigned} {{/kernel_ctrl_tb/kernel_ctrl_inst/k_val[1]} -radix unsigned} {{/kernel_ctrl_tb/kernel_ctrl_inst/k_val[0]} -radix unsigned}} -radixshowbase 0 -expand -subitemconfig {{/kernel_ctrl_tb/kernel_ctrl_inst/k_val[2]} {-radix unsigned -radixshowbase 0} {/kernel_ctrl_tb/kernel_ctrl_inst/k_val[1]} {-radix unsigned -radixshowbase 0} {/kernel_ctrl_tb/kernel_ctrl_inst/k_val[0]} {-radix unsigned -radixshowbase 0}} /kernel_ctrl_tb/kernel_ctrl_inst/k_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {165096 ps}
