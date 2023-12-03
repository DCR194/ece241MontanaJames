
module character(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);
    input frameClock, iResetn, iForwardX, iBackX, iBackY, iForwardY;
    output wire [7:0] oXcoord;
    output wire [6:0] oYcoord;

    reg [7:0] CoordinatesX;
    reg [6:0] CoordinatesY;



    always @(posedge frameClock)
        begin
            if(!iResetn)
                begin
                    CoordinatesX <= 8'd75;
                    CoordinatesY <= 7'd55;
                end
            else
                begin

                    if(iForwardX)
                        begin
							if(CoordinatesX > 154) CoordinatesX <= CoordinatesX - 1;
							else CoordinatesX <= CoordinatesX + 1;
                        end
                    if(iBackX)
                        begin
							if(CoordinatesX == 0) CoordinatesX <= CoordinatesX +1;
                            else CoordinatesX <= CoordinatesX - 1;
                        end
                    if(iForwardY)
                        begin
							if(CoordinatesY > 116) CoordinatesY <= CoordinatesY - 1;
                            else CoordinatesY <= CoordinatesY + 1;
                        end
                    if(iBackY)
                        begin
							if(CoordinatesY == 0) CoordinatesY <= CoordinatesY + 1;
                            else CoordinatesY <= CoordinatesY - 1;
                        end
                end
        end

    assign oXcoord = CoordinatesX;
    assign oYcoord = CoordinatesY;

endmodule


module myDarts1(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);
    input frameClock, iResetn, iForwardX, iBackX, iBackY, iForwardY;
    output wire [7:0] oXcoord;
    output wire [6:0] oYcoord;

    reg [7:0] CoordinatesX;
    reg [6:0] CoordinatesY;



    always @(posedge frameClock)
        begin
            if(!iResetn)
                begin
                    CoordinatesX <= 8'd0;
                    CoordinatesY <= 7'd0;
                end
            else
                begin
							if(CoordinatesX > 164)// SHOULD BE 164
								begin
									//CoordinatesY <= CoordinatesX % 120;
									if(iForwardX)	CoordinatesX <= 0;
									else if(iBackX) CoordinatesX <= 160;
								end
							if(CoordinatesY > 124)
								begin
									//CoordinatesX <= {CoordinatesY[6] , CoordinatesY} % 160;
									if(iForwardY) CoordinatesY <= 0;
									else if(iBackY) CoordinatesY <= 120;
								end
								
                    if(iForwardX)
                        begin
                            CoordinatesX <= CoordinatesX + 1;
                        end
                    if(iBackX)
                        begin
                            CoordinatesX <= CoordinatesX - 1;
                        end
                    if(iForwardY)
                        begin
                            CoordinatesY <= CoordinatesY + 1;
                        end
                    if(iBackY)
                        begin
                            CoordinatesY <= CoordinatesY - 1;
                        end
                end
        end

    assign oXcoord = CoordinatesX;
    assign oYcoord = CoordinatesY;

endmodule

// ONLY DIFFERENCE BETWEEN DARTS 1 and DARTS 2 IS THE STARTING POSITION

module myDarts2(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);
    input frameClock, iResetn, iForwardX, iBackX, iBackY, iForwardY;
    output wire [7:0] oXcoord;
    output wire [6:0] oYcoord;

    reg [7:0] CoordinatesX;
    reg [6:0] CoordinatesY;



    always @(posedge frameClock)
        begin
            if(!iResetn)
                begin
                    CoordinatesX <= 8'd160;
                    CoordinatesY <= 7'd60;
                end
            else
                begin
						  if(CoordinatesX > 164)
								begin
									//CoordinatesY <= CoordinatesX % 120;
									if(iForwardX)	CoordinatesX <= 0;
									else if(iBackX) CoordinatesX <= 160;
								end
							if(CoordinatesY > 124)
								begin
									//CoordinatesX <= {CoordinatesY[6] , CoordinatesY} % 160;
									if(iForwardY) CoordinatesY <= 0;
									else if(iBackY)CoordinatesY <= 120;
								end
                    if(iForwardX)
                        begin
                            CoordinatesX <= CoordinatesX + 1;
                        end
                    if(iBackX)
                        begin
                            CoordinatesX <= CoordinatesX - 1;
                        end
                    if(iForwardY)
                        begin
                            CoordinatesY <= CoordinatesY + 1;
                        end
                    if(iBackY)
                        begin
                            CoordinatesY <= CoordinatesY - 1;
                        end
                end
        end

    assign oXcoord = CoordinatesX;
    assign oYcoord = CoordinatesY;

endmodule

module darts(frameClock, 
			iResetn, 
			iForwardX, 
			iBackX, 
			iForwardY, 
			iBackY, 
			oYX1,
			oYX2,
			oYX3,
			oYX4);

    input frameClock, iResetn, iForwardX, iBackX, iBackY, iForwardY;
    wire [7:0] oXcoord; 
    wire [6:0] oYcoord;
	output wire [14:0] oYX1, oYX2, oYX3, oYX4;
	
	wire [7:0] oX1, oX2, oX3, oX4;
	wire [6:0] oY1, oY2, oY3, oY4;

	myDarts1 justin(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);


		
				
	assign oX2 = oXcoord - iForwardX + iBackX;
	assign oX3 = oX2 - iForwardX + iBackX;
	assign oX4 = oX3 - iForwardX + iBackX;
	
	assign oY2 = oYcoord - iForwardY + iBackY;
	assign oY3 = oY2 - iForwardY + iBackY;
	assign oY4 = oY3 - iForwardY + iBackY;
	
	assign oYX1 = {oYcoord, oXcoord};
	assign oYX2 = {oY2, oX2};
	assign oYX3 = {oY3, oX3};
	assign oYX4 = {oY4, oX4};
	
endmodule


module RateDivider60to1
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
input iResetn,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn, negedge iResetn)
        begin
            if(~iResetn)
                begin
                    RateDividerCount = (CLOCK_FREQUENCY / 60) - 1;
                end
            
            else if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY / 60) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)? 1'b1: 1'b0;
endmodule

module darts2(frameClock, 
			iResetn, 
			iForwardX, 
			iBackX, 
			iForwardY, 
			iBackY, 
			oYX1,
			oYX2,
			oYX3,
			oYX4);

    input frameClock, iResetn, iForwardX, iBackX, iBackY, iForwardY;
    wire [7:0] oXcoord; 
    wire [6:0] oYcoord;
	output wire [14:0] oYX1, oYX2, oYX3, oYX4;
	
	wire [7:0] oX1, oX2, oX3, oX4;
	wire [6:0] oY1, oY2, oY3, oY4;

	myDarts2 justin(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);
		
				
	assign oX2 = oXcoord - iForwardX + iBackX;
	assign oX3 = oX2 - iForwardX + iBackX;
	assign oX4 = oX3 - iForwardX + iBackX;
	
	assign oY2 = oYcoord - iForwardY + iBackY;
	assign oY3 = oY2 - iForwardY + iBackY;
	assign oY4 = oY3 - iForwardY + iBackY;
	
	assign oYX1 = {oYcoord, oXcoord};
	assign oYX2 = {oY2, oX2};
	assign oYX3 = {oY3, oX3};
	assign oYX4 = {oY4, oX4};
	
endmodule

module halfSecond
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn)
        begin
            if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY / 2) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)? 1'b1: 1'b0;
	 
endmodule

module quarterSecond
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn)
        begin
            if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY / 12) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)? 1'b1: 1'b0;
	 
endmodule

module thirdSecond
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn)
        begin
            if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY / 6) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)? 1'b1: 1'b0;
	 
endmodule



module screen(iColour, iResetn, iClock, oX, oY, oColour, oPlot, oNewFrame, switches, xcoords, ycoords, collide);

   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   input [9:0] switches;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable
   output wire       oNewFrame;
	output wire [7:0] xcoords;
	output wire [6:0] ycoords;
   output wire collide;

   	wire frameClock, second, third, quarter;
	
	wire enable, done, wren, blackout, plot;	
	
	
	wire [7:0] xchar;
	
	wire [6:0] ychar;
	
	reg [2:0] tempcolor;
	
	wire [2:0] coolor;
	
	wire [14:0] charcoords, coords,
	d1oYX1, d1oYX2, d1oYX3, d1oYX4,
	d2oYX1, d2oYX2, d2oYX3, d2oYX4,
	d3oYX1, d3oYX2, d3oYX3, d3oYX4,
	d4oYX1, d4oYX2, d4oYX3, d4oYX4,
	d5oYX1, d5oYX2, d5oYX3, d5oYX4,
	d6oYX1, d6oYX2, d6oYX3, d6oYX4,
	d7oYX1, d7oYX2, d7oYX3, d7oYX4,
	d8oYX1, d8oYX2, d8oYX3, d8oYX4;
	
	assign xcoords = ychar;
	assign ycoords = xchar;
	
	assign charcoords = {ychar, xchar};
	
	always @(*)
		begin
			//if //(charcoords == coords) tempcolor = 4;
			// DRAW CHARACTER
			
				//begin
					if(coords == d1oYX1) tempcolor = 0; // put this before james
					else if((coords == d1oYX2) || (coords == d1oYX3) || (coords == d1oYX4)) tempcolor = 2; //also this
					
					else if(coords == d2oYX1) tempcolor = 0;
					else if((coords == d2oYX2) || (coords == d2oYX3) || (coords == d2oYX4)) tempcolor = 2;
					
					else if(coords == d3oYX1) tempcolor = 0;
					else if((coords == d3oYX2) || (coords == d3oYX3) || (coords == d3oYX4)) tempcolor = 2;
					
					else if(coords == d4oYX1) tempcolor = 0;
					else if((coords == d4oYX2) || (coords == d4oYX3) || (coords == d4oYX4)) tempcolor = 2;

					else if(coords == d5oYX1) tempcolor = 0; // put this before james
					else if((coords == d5oYX2) || (coords == d5oYX3) || (coords == d5oYX4)) tempcolor = 2; //also this
					
					else if(coords == d6oYX1) tempcolor = 0;
					else if((coords == d6oYX2) || (coords == d6oYX3) || (coords == d6oYX4)) tempcolor = 2;
					
					else if(coords == d7oYX1) tempcolor = 0;
					else if((coords == d7oYX2) || (coords == d7oYX3) || (coords == d7oYX4)) tempcolor = 2;
					
					else if(coords == d8oYX1) tempcolor = 0;
					else if((coords == d8oYX2) || (coords == d8oYX3) || (coords == d8oYX4)) tempcolor = 2;

					// also Amanda is really pretty :D
					else if(oY == ychar)
						begin
							if((oX >= xchar + 1) & (oX <= xchar + 4)) tempcolor = 4;
							else if(oX == xchar + 6) tempcolor = 5;
							else tempcolor = 7;
						end
					else if(oY == ychar + 1)
						begin
							if((oX >= xchar) & (oX <= xchar + 5)) tempcolor = 4;
							else if(oX == xchar+6) tempcolor = 5;
							else tempcolor = 7;
						end
					else if(oY == ychar + 2)
						begin
							if((oX == xchar + 1) | (oX == xchar + 3)) tempcolor = 2;
							else if((oX == xchar + 2) | (oX == xchar + 4)) tempcolor = 0;
							else if(oX == xchar + 6) tempcolor = 5;
							else tempcolor = 7;
						end
					else if(oY == ychar + 3)
						begin
							if((oX == xchar + 1) | (oX == xchar + 2) | (oX == xchar + 4)) tempcolor = 2;
							else if(oX == xchar + 3) tempcolor = 4;
							else if(oX == xchar + 6) tempcolor = 5;
							else tempcolor = 7;
						end
					else if(oY == ychar + 4)
						begin
							if((oX >= xchar) & (oX <= xchar + 5)) tempcolor = 3;
							else if(oX == xchar + 6) tempcolor = 5;
							else tempcolor = 7;
						end
					else if(oY == ychar + 5)
						begin
							if ((oX >= xchar + 1) & (oX <= xchar + 4)) tempcolor = 3;
							else tempcolor = 7;
						end
					else if(oY == ychar + 6)
						begin
							if ((oX >= xchar + 1) & (oX <= xchar + 4)) tempcolor = 1;
							else tempcolor = 7;
						end
					else if(oY == ychar + 7)
						begin
							if ((oX == xchar + 1) | (oX == xchar + 4)) tempcolor = 0;
							else tempcolor = 7;
						end
					else tempcolor = 7;
				//end
				
		end
		

   RateDivider60to1 marcus(iClock, iResetn, frameClock);
   halfSecond marcus2  (iClock, second);
   thirdSecond marcus3 (iClock, third);
   quarterSecond marcus4(iClock, quarter);
	
	//STARTING TO  TEST THINGS OUT
	screenBuffer no(iClock,
							enable, 
							done, 
							//output reg inProgress,  
							coords);
							
	controlRam man(iClock, 
						frameClock, // change into frameClock
						done,
						//input inProgress,
						enable,
						wren,
						blackout,
						plot);
						
	colorRam please(
	coords,
	iClock,
	tempcolor,
	wren,
	oColour);

   character mike(.frameClock(third), .iResetn(iResetn), .iForwardX(switches[0]), .iBackX(switches[1]), 
                .iForwardY(switches[8]), .iBackY(switches[9]), .oXcoord(xchar), .oYcoord(ychar));
					 
	wire on, off;
					 
	assign on = 1'b1;
	assign off = 1'b0;
	
	darts d1(.frameClock(quarter), .iResetn(iResetn), .iForwardX(on), .iBackX(off), 
                .iForwardY(on), .iBackY(off), .oYX1(d1oYX1), .oYX2(d1oYX2), .oYX3(d1oYX3), .oYX4(d1oYX4));
	darts d2(.frameClock(quarter), .iResetn(iResetn), .iForwardX(on), .iBackX(off), 
                .iForwardY(off), .iBackY(on), .oYX1(d2oYX1), .oYX2(d2oYX2), .oYX3(d2oYX3), .oYX4(d2oYX4));
	darts d3(.frameClock(quarter), .iResetn(iResetn), .iForwardX(off), .iBackX(on), 
                .iForwardY(on), .iBackY(off), .oYX1(d3oYX1), .oYX2(d3oYX2), .oYX3(d3oYX3), .oYX4(d3oYX4));
	darts d4(.frameClock(quarter), .iResetn(iResetn), .iForwardX(off), .iBackX(on), 
                .iForwardY(off), .iBackY(on), .oYX1(d4oYX1), .oYX2(d4oYX2), .oYX3(d4oYX3), .oYX4(d4oYX4));
	
	darts2 d5(.frameClock(quarter), .iResetn(iResetn), .iForwardX(on), .iBackX(off), 
                .iForwardY(on), .iBackY(off), .oYX1(d5oYX1), .oYX2(d5oYX2), .oYX3(d5oYX3), .oYX4(d5oYX4));
	darts2 d6(.frameClock(quarter), .iResetn(iResetn), .iForwardX(on), .iBackX(off), 
                .iForwardY(off), .iBackY(on), .oYX1(d6oYX1), .oYX2(d6oYX2), .oYX3(d6oYX3), .oYX4(d6oYX4));
	darts2 d7(.frameClock(quarter), .iResetn(iResetn), .iForwardX(off), .iBackX(on), 
                .iForwardY(on), .iBackY(off), .oYX1(d7oYX1), .oYX2(d7oYX2), .oYX3(d7oYX3), .oYX4(d7oYX4));
	darts2 d8(.frameClock(quarter), .iResetn(iResetn), .iForwardX(off), .iBackX(on), 
                .iForwardY(off), .iBackY(on), .oYX1(d8oYX1), .oYX2(d8oYX2), .oYX3(d8oYX3), .oYX4(d8oYX4));

	multipleCollisionDetect detect(charcoords,
	d1oYX1, d2oYX2, d3oYX1, d4oYX1, d5oYX1, d6oYX1, d7oYX1, d8oYX1, collide);
					 
	assign oPlot = plot;
					 
	assign oX = coords[7:0];
	assign oY = coords[14:8];
	
endmodule


module controlRam(input iClock, 
						input frameClock,
						input done,
						//input inProgress,
						output reg enable,
						output reg wren,
						output reg blackout,
						output reg plot);
						

	
	localparam STARTDISPLAY = 5'd0,
				  DISPLAY = 5'd1, // PLOT IT OUT
				  STARTCLEAR = 5'd2, 
				  CLEAR = 5'd3, // MAKES EVERYTHING BLACK
				  STARTREAD = 5'd4,
				  READ = 5'd5, // READ INTO RAM
				  WAITNOTFRAME = 5'd6,
				  WAITFRAME = 5'd7;
				  
				  
		reg [5:0] currentState, nextState;
		reg newframeEdge, newFrame;
		
		
		always @(*)
		begin
			case(currentState)
				STARTDISPLAY: nextState = done ? STARTDISPLAY : DISPLAY;
				DISPLAY: nextState = done ? STARTCLEAR : DISPLAY;
				STARTCLEAR: nextState = done ? STARTCLEAR : CLEAR;
				CLEAR: nextState = done ? STARTREAD : CLEAR;
				STARTREAD: nextState = done? STARTREAD : READ;
				READ: nextState = done ? WAITNOTFRAME : READ;
				WAITNOTFRAME: nextState = frameClock? WAITNOTFRAME : WAITFRAME;
				WAITFRAME: nextState = frameClock? STARTDISPLAY : WAITFRAME;
				
				default: nextState = STARTDISPLAY;
			endcase
		end
		
		always @(*)
		begin
			case(currentState)
			STARTDISPLAY: begin
				plot = 1;
				enable = 1;
			end
			DISPLAY: begin
				enable = 0;
			end
			STARTCLEAR: begin
				plot = 0;
				enable = 1;
				blackout = 1;
				wren = 1;
			end
			CLEAR:begin
				enable = 0;
			end
			STARTREAD:begin
				blackout = 0;
				enable = 1;
				wren = 1;
			end
			READ:begin
				wren = 1;
				enable = 0;
			end
			WAITNOTFRAME: begin
				wren = 0;
				enable = 1;// hold it 
				
			end
			WAITFRAME: begin
			end
			endcase
		end
		
		always @(posedge iClock)
			begin
				currentState = nextState;
			end
		
		
	
endmodule

//module datapathRam()

module multipleCollisionDetect(char, i0, i1, i2, i3, i4, i5, i6, i7, detect);
	input [14:0] char,
	i0, i1, i2, i3, i4, i5, i6, i7;
	output detect;

	wire[7:0] collision;

	singleCollisionDetect collision0(char, i0, collision[0]);
	singleCollisionDetect collision1(char, i1, collision[1]);
	singleCollisionDetect collision2(char, i2, collision[2]);
	singleCollisionDetect collision3(char, i3, collision[3]);
	singleCollisionDetect collision4(char, i4, collision[4]);
	singleCollisionDetect collision5(char, i5, collision[5]);
	singleCollisionDetect collision6(char, i6, collision[6]);
	singleCollisionDetect collision7(char, i7, collision[7]);

	
	assign detect = |collision;


endmodule

module singleCollisionDetect(char, dart, comp);
	input[14:0] char, dart;
	output comp;

	wire compx, compy;
	wire [7:0] xDart, xChar;
	wire [6:0] yDart, yChar;

	assign xDart = dart[7:0];
	assign yDart = dart[14:8];
	
	assign xChar = char[7:0];
	assign yChar = char[14:8];

	assign compx = (xDart >= xChar) & (xDart < xChar + 7);
	assign compy = (yDart >= yChar) & (yDart < yChar + 8);

	assign comp = compx & compy;

endmodule


//LOOPS THROUGH THE SCREEN TO DO STUFFF
module screenBuffer(input iClock, 
							input enable, 
							output reg done, 
							//output reg inProgress,  
							output [14:0] coords);
	
	reg [7:0] x;
	reg [6:0] y;
	
	always @(posedge iClock)
		begin
			if(enable)
				begin
					x <= 0;
					y <= 0;
					done <= 0;
					//inProgress <= 0;
					
				end
			else if((x > 160) & (y > 120))
				begin
					done <= 1;
					//inProgress <= 0;
				end
			else if(x > 160)
				begin
					x <= 0;
					y <= y + 1;
					
					
				end
			else if(y > 120)
				begin
					x <= 0;
					y <= 0;
					done <= 1;
					//inProgress <= 0;
					
				end
			else
				begin
					x = x + 1;
					//done <= 0;
				end
				
		end
		
		assign coords[7:0] = x;
		assign coords[14:8] = y;

endmodule




