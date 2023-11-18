# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog TEST.v

#load simulation 
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {ClockIn} 0 0ns , 1 {5ns} -r 10ns

force {Reset} 1
force {Speed[0]} 0
force {Speed[1]} 0

run 10 ns

force {Reset} 0

run 500ns

force {Speed[0]} 0
force {Speed[1]} 1

run 5000ns