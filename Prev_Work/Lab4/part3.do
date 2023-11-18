# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part3.v

#load simulation using mux as the top level simulation module
vsim part3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
# Reset and load in the data
force {Data_IN[0]} 1
force {Data_IN[1]} 1
force {Data_IN[2]} 0
force {Data_IN[3]} 1

force {clock} 0
force {reset} 1

run 5ns

force {clock} 1
run 5ns

force {reset} 0
force {ParallelLoadn} 0
force {clock} 0

run 5ns

force {clock} 1

run 5ns
# ROTATE LEFT

force {ASRight} 0
force {RotateRight} 0
force {ParallelLoadn} 1

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns

# ROTATE LEFT AGAIN

force {RotateRight} 0

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns


# ROTATE RIGHT

force {RotateRight} 1

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns

# ROTATE RIGHT ARITHMETIC

force {RotateRight} 1 
force {ASRight} 1

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns

# ROTATE RIGHT ARITHMETIC AGAIN

force {RotateRight} 1 
force {ASRight} 1

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns

# ROTATE RIGHT ARITHMETIC AGAIN AGAIN

force {RotateRight} 1 
force {ASRight} 1

run 5ns

force {clock} 0

run 5ns

force {clock} 1

run 5ns
