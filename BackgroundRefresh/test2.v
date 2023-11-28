module controlCharacter(iColour, iResetn, iClock, oX, oY, oColour, oPlot, oNewFrame, switches);
   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   input [9:0] switches;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable
   output wire       oNewFrame;

   wire frameClock, second;

   RateDivider60to1 marcus(iClock, iResetn, frameClock);
   halfSecond marcus2  (iClock, second);

   character mike(.frameClock(second), .iResetn(iResetn), .iForwardX(switches[0]), .iBackX(switches[1]), 
                .iForwardY(switches[8]), .iBackY(switches[9]), .oXcoord(oX), .oYcoord(oY));

   assign oPlot = second;
   assign oNewFrame = frameClock;
   assign oColour = 3'b100;


endmodule

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
                    CoordinatesX <= 8'd50;
                    CoordinatesY <= 7'd50;
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

    assign Enable = (RateDividerCount == 31'b0)? 1'b1: 1'b0;
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