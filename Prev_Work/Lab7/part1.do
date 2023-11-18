# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#load simulation 
#vsim part1
vsim -L altera_mf_ver part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#module part1 (
#	address,
#	clock,
#	data,
#	wren,
#	q);


force {clock} 0 0ns , 1 {5ns} -r 10ns
force {wren} 0
force {address} 2'd0
force {data} 2'd0

run 3 ns

force {wren} 1
force {data} 2'd4

run 10 ns

force {clock} 0 0ns , 1 {5ns} -r 10ns
force {wren} 0
force {address} 2'd1
force {data} 2'd5

run 10 ns

force {address} 1'd0

run 10 ns