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

# first test case
# test a = {0001} & b = {0001}
#set input values using the force command, signal names need to be in {} brackets

force {A} 0
force {B} 0

force {Function[0]} 0
force {Function[1]} 0

force {A[0]} 1
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0

force {B[0]} 1
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0

#run simulation for a few ns
run 10ns

# second test case
# test a = {0001} & b = {0001}
#set input values using the force command, signal names need to be in {} brackets

force {Function[0]} 0
force {Function[1]} 1

run 10ns


# third test case
# test a = {0001} & b = {0001}

force {Function[0]} 1
force {Function[1]} 0

run 10ns


# fourth test case
# test a = {1111} & b = {1111}
#set input values using the force command, signal names need to be in {} brackets

force {Function[0]} 0
force {Function[1]} 0

force {A[0]} 1
force {A[1]} 1
force {A[2]} 1
force {A[3]} 1

force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1

run 10ns

# fifth test case
# test a = {1111} & b = {1111}

force {Function[0]} 1
force {Function[1]} 0

run 10ns

# sixth test case
# test a = {1111} & b = {1111}

force {Function[0]} 0
force {Function[1]} 1

run 10ns

# seventh test case
# test a = {1111} & b = {1111}

force {Function[0]} 1
force {Function[1]} 1

run 10ns


# seventh test case
# test a = {1111} & b = {1111}

force {A[3]} 0
force {B[1]} 0

run 10ns