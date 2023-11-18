# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}


#set input values using the force command, signal names need to be in {} brackets

force {Clock} 0
force {Reset_b} 0

force {Data[0]} 1
force {Data[1]} 0
force {Data[2]} 0
force {Data[3]} 0


force {Function[0]} 0
force {Function[1]} 0


run 10ns

force {Reset_b} 1

run 10ns

force {Clock} 1

run 10ns

force {Reset_b} 0



force {Data[0]} 1
force {Data[1]} 0
force {Data[2]} 0
force {Data[3]} 0


force {Clock} 0

#run simulation for a few ns
run 10ns

force {Clock} 1

run 10ns

force {Clock} 0

#run simulation for a few ns
run 10ns

force {Clock} 1

run 10ns