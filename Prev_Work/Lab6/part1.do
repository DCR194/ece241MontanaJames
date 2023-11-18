# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#load simulation using mux as the top level simulation module
vsim part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {Clock} 0 0ns , 1 {5ns} -r 10ns

force {Reset} 0

run 5ns

#module part1(Clock, Reset, w, z, CurState);
#    input Clock;
#    input Reset;
#    input w;
#    output z;
#    output [3:0] CurState;

force {w} 1

run 50 ns
 
force {w} 0

run 15ns

force {w} 1

run 50ns

force {w} 0

run 20ns