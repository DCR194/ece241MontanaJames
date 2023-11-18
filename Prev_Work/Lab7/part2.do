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

# iResetn,
# iPlotBox,
# iBlack,
# iColour,
# iLoadX,
# iXY_Coord,
# iClock,

force {iClock} 0 0ns , 1 {5ns} -r 10ns
force {iXY_Coord} 7'd4
force {iResetn} 0
force {iLoadX} 0
force {iPlotBox} 0
force {iBlack} 0

run 13 ns

force {iResetn} 1
force {iLoadX} 1

run 20ns


force {iLoadX} 0

run 10 ns


force {iColour} 3'd6
force {iXY_Coord} 7'd1

run 10 ns

force {iPlotBox} 1

run 20 ns

force {iPlotBox} 0

run 300 ns


# CASE 2


force {iClock} 0 0ns , 1 {5ns} -r 10ns
force {iXY_Coord} 7'd1
force {iResetn} 0
force {iLoadX} 0
force {iPlotBox} 0
force {iBlack} 0

run 13 ns

force {iResetn} 1
force {iLoadX} 1

run 20ns


force {iLoadX} 0

run 10 ns


force {iColour} 3'd2
force {iXY_Coord} 7'd5

run 10 ns

force {iPlotBox} 1

run 20 ns

force {iPlotBox} 0

run 300 ns
