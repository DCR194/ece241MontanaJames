
module animate(iResetn,
iClock,
iForwardX,
iBackX,
iForwardY,
iBackY,
oX,
oY,
oColour,
oPlot,
oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iClock, iForwardX, iBackX, iForwardY, iBackY;

   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here // WRITE CONTROL PATH
   controlCharacter contr(iResetn, iClock, iForwardX, iBackX, iForwardY, iBackY, oX, oY, oColour, oPlot, oDone);
   //

endmodule // part2

module controlCharacter(iResetn,
    iClock,
    iForwardX,
    iBackX
    iForwardY,
    iBackY,
    oX,
    oY,
    oColour,
    oPlot,
    oDone);

    input iResetn, iClock, iForwardX, iBackX, iForwardY, iBackY;

    output wire [7:0] oX;
    output wire [6:0] oY;

    output wire [2:0] oColour;     // VGA pixel colour (0-7)
    output wire 	    oPlot;       // Pixel draw enable
    output wire         oDone; 


    reg [5:0] current_state, next_state;
    reg rDone, draw;

    wire finish;

    wire frameClock;

    wire [7:0] xCoord;
    wire [6:0] yCoord;

    RateDivider60to1 yes (iClock, iResetn, frameClock);

    character MontanaJames(.frameClock(frameClock), .iResetn(iResetn), .iForwardX(iForwardX), .iBackX(iBackX), 
    .iForwardY(iForwardY), .iBackY(iBackY), .oXcoord(xCoord), .oYcoord(yCoord));

    counter16 louis(.iClock(iClock), .iResetn(iResetn), .draw(draw), .ix(xCoord), .iy(yCoord), .ox(oX), .oy(oY), .oPlot(oPlot), .finish(finish));
    


    // DEFINE STATES
    localparam  SETMIDDLE       = 5'd0,
                STARTDRAW       = 5'd1,
                DRAWFRAME       = 5'd2, // also loads color
                //LOAD_Y_WAIT     = 5'd3,
                //DRAW            = 5'd4,
                FINISH          = 5'd5;

    always @(*)
        begin: state_table
            case (current_state)
                SETMIDDLE: next_state = DRAWFRAME;
                STARTDRAW: next_state = DRAWFRAME;
                DRAWFRAME: next_state = finished? FINISH : DRAWFRAME;
                FINISH: next_state = frameClock? STARTDRAW: FINISH; 

                default: next_state = SETMIDDLE;

            endcase
        end
    
    always @(*)
        begin

            case(current_state)
            STARTDRAW: rDone = 0;
            DRAWFRAME: draw = 1;
            FINISH: draw = 0;
            
            default: 
            endcase
        end

    always @(posedge iClock)
        begin
            if(!iResetn)
                begin
                    rDone = 0;
                    rDraw = 0;
                end
            else
                begin
                    current_state = next_state;
                end
        end
        
    assign oDone = rDone;



endmodule

//module datapath(iClock, frameClock, iResetn, draw, iX, iY, oX, oY, oColour, oPlot, finish);
//    input iClock, frameClock, iResetn, draw;
//    
//    input [2:0] iColour;
//    input [6:0] iXY_Coord;
//
//    output [7:0] oX;
//    output [6:0] oY;
//    output [2:0] oColour;
//    output oPlot;
//    output finish;
//
//    wire [7:0] x;
//    wire [6:0] y;
//    reg [2:0] color;
//    reg [3:0] counter;
//
//    assign oColour[0] = 0; // THIS IS WEIRD
//    assign oColour[1] = 0;
//    assign oColour[2] = 1;
//    // assign oColour = 3'b100;
//
//    
//
//    counter16 dracula(.iClock(iClock), .iResetn(iResetn), .draw(draw), .ix(x), .iy(y), .color(oColour), 
//                      .ox(oX), .oy(oY), .oPlot(oPlot), .finish(finish));
//
//
//endmodule


module counter16(iClock, iResetn, draw, ix, iy, ox, oy, oPlot, finish);
    input iClock, iResetn, draw;
    input [7:0] ix;
    input [6:0] iy;
    input iBlack;

    output reg [7:0] ox;
    output reg [6:0] oy;
    output reg oPlot;
    

    output reg finish;
    reg [4:0] count;
    
    wire [1:0] xShift, yShift;

    always @(posedge iClock)
        finish <= 0;
        begin
            if(!iResetn)
                begin
                    finish <= 0;
                    count <= 0;
                    oPlot <= 1'b0;
                    ox <= 0;
                    oy <= 0;
                end
            else if(draw & !finish)
                begin
                    oPlot <= 1'b1;
                    count <= count + 1;
                end
            else
                begin
                    oPlot <= 1'b0;
                    count <= 0;

                end
            if((count > 16))
                begin
                    count <= 0;
                    oPlot <= 1'b0;
                    finish <= 1;
                end
            else
                begin
                    ox <= ix + xShift;
                    oy <= iy + yShift; // I DON'T KNOW WHY THIS WORKS
                end
                
        end

    assign xShift[0] = count[0];
    assign xShift[1] = count[1];
    assign yShift[0] = count[2];
    assign yShift[1] = count[3];


endmodule

module character(frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY, oXcoord, oYcoord);
    input frameClock, iResetn, iForwardX, iBackX, iForwardY, iBackY.
    output wire [7:0] oXcoord;         
    output wire [6:0] oYcoord;

    reg [7:0] CoordinatesX;
    reg [6:0] CoordinatesY;



    always @(posedge frameClock)
        begin
            if(!iResetn)
                begin
                    CoordinatesX <= 50;
                    CoordinatesY <= 50;
                end
            else
                begin
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

    assign Enable = (RateDividerCount == 31'b0)?'1:'0;
endmodule
