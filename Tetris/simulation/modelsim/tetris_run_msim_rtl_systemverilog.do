transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib tetris_soc
vmap tetris_soc tetris_soc
vlog -sv -work tetris_soc +incdir+C:/ECE_385/Tetris/tetris_soc/synthesis/submodules {C:/ECE_385/Tetris/tetris_soc/synthesis/submodules/avalon_tetris_interface.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/Color_Mapper.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/Random.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/move.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/moving.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/current_blocks.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/init.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/update.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/tetromino_color.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/score_board.sv}
vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/Sprite.sv}

vlog -sv -work work +incdir+C:/ECE_385/Tetris {C:/ECE_385/Tetris/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -L tetris_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
