onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/clk
add wave -noupdate -label rstn -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/rstn
add wave -noupdate -expand -group {Input AXIS} -label in_ready -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/in_ready
add wave -noupdate -expand -group {Input AXIS} -label in_data -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/in_data
add wave -noupdate -expand -group {Input AXIS} -label in_last -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/in_last
add wave -noupdate -expand -group {Input AXIS} -label in_valid -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/in_valid
add wave -noupdate -expand -group {Output AXIS} -label out_data -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/out_data
add wave -noupdate -expand -group {Output AXIS} -label out_last -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/out_last
add wave -noupdate -expand -group {Output AXIS} -label out_ready -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/out_ready
add wave -noupdate -expand -group {Output AXIS} -label out_user -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/out_user
add wave -noupdate -expand -group {Output AXIS} -label out_valid -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/out_valid
add wave -noupdate -expand -group {State Variables} -label state -radix symbolic -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/state
add wave -noupdate -expand -group {State Variables} -label next_state -radix symbolic -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/next_state
add wave -noupdate -expand -group {State Variables} -label img_row -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/img_row
add wave -noupdate -expand -group {State Variables} -label img_col -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/img_col
add wave -noupdate -expand -group {State Variables} -label img_row_next -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/img_row_next
add wave -noupdate -expand -group {State Variables} -label img_col_next -radix unsigned -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/img_col_next
add wave -noupdate -group Signals -label last_col -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/last_col
add wave -noupdate -group Signals -label last_row -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/last_row
add wave -noupdate -group Signals -label ready -radix binary -radixshowbase 0 /img_ctrl_tb/img_ctrl_inst/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {462072 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
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
WaveRestoreZoom {434872 ps} {758779 ps}
