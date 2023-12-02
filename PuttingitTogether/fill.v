// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		SW,
		LEDR,
		HEX0,
		HEX1,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		PS2_CLK,
		PS2_DAT,
		AUD_ADCDAT,
		AUD_XCK,
		AUD_DACDAT,
		FPGA_I2C_SCLK,
		FPGA_I2C_SDAT,
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					
	// Declare your inputs and outputs here
	input [9:0] SW;
	
	
	
	output [6:0] HEX0, HEX1;
	output [9:0] LEDR;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	//INPUTS/OUTPUTS FOR KEYBOARD
	 //  input CLOCK_50,           // 50 MHz clock
    input PS2_CLK;            // PS2 clock
    input PS2_DAT;            // PS2 data
    input AUD_ADCDAT;         // Audio input
    output AUD_XCK;           // Audio clock
    output AUD_DACDAT;        // Audio output
	 output FPGA_I2C_SCLK;     // FPGA clock
	 inout FPGA_I2C_SDAT;      // FPGA data
    inout AUD_BCLK;           // Audio bit clock
    inout AUD_ADCLRCK;        // Audio ADC LR Clock
    inout AUD_DACLRCK;       // Audio DAC LR Clock
	 //input [3:0] KEY;			   // Key input
	 //output [9:0] SW,		      // Switch output
	 //output reg [4:0] LEDR  
	//
	
	wire resetn;
	wire [9:0] control;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire [7:0] xcoords;
	wire [6:0] ycoords;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
	
 controlModule feces(
    CLOCK_50,           // 50 MHz clock
    PS2_CLK,            // PS2 clock
    PS2_DAT,            // PS2 data
    AUD_ADCDAT,         // Audio input
    AUD_XCK,           // Audio clock
    AUD_DACDAT,        // Audio output
	 FPGA_I2C_SCLK,     // FPGA clock
	 FPGA_I2C_SDAT,      // FPGA data
    AUD_BCLK,           // Audio bit clock
    AUD_ADCLRCK,        // Audio ADC LR Clock
    AUD_DACLRCK,        // Audio DAC LR Clock
	 KEY,			   // Key input
	 SW,		      // Switch output
	 LEDR[4:0]     // LEDs for PS2 keys
);
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	assign HEX0 = xcoords[6:0];
	assign HEX1 = ycoords[6:0];
	assign control[0] = LEDR[2];
	assign control[1] = LEDR[3];
	assign control[8] = LEDR[1];
	assign control[9] = LEDR[4];
	// assign LEDR = SW;
	screen poop(.iResetn(resetn), .iClock(CLOCK_50), .oX(x), 
	.oY(y), .oColour(colour), .oPlot(writeEn), .switches(control), .xcoords(xcoords), .ycoords(ycoords));
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule
