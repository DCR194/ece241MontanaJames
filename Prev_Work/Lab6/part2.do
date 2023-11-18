# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part2.v

#load simulation 
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#module part2(Clock, Reset, Go, DataIn, DataResult, ResultValid);
#    input Clock;
#    input Reset;
#    input Go;
#    input [7:0] DataIn;
#    output [7:0] DataResult;
#    output ResultValid;

force {Clock} 0 0ns , 1 {5ns} -r 10ns

force {Reset} 1
force {Go} 0

run 13 ns

force {Reset} 0
force DataIn 1'd2
force {Go} 1

run 10 ns

force {Go} 0

run 10 ns


force DataIn 1'd4
force {Go} 1
run 10 ns

force {Go} 0

run 10ns

force DataIn 1'd3
force {Go} 1

run 10 ns

force {Go} 0

run 10ns

force DataIn 1'd2
force {Go} 1

run 10 ns

force {Go} 0

run 10ns

force {Go} 1

run 10ns


run 50ns
