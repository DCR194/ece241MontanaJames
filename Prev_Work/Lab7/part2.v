//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   control deavor(iResetn, iPlotBox, iBlack, iColour, iLoadX, iXY_Coord, iClock, oX, oY, oColour, oPlot, oDone);
   //

endmodule // part2

module control(iResetn, iPlotBox, iBlack, iColour, iLoadX, iXY_Coord, iClock, oX, oY, oColour, oPlot, oDone);

    input wire iResetn, iPlotBox, iBlack, iLoadX;
    input wire [2:0] iColour;
    input wire [6:0] iXY_Coord;
    input wire 	    iClock;
    output wire [7:0] oX;         // VGA pixel coordinates
    output wire [6:0] oY;

    output wire [2:0] oColour;     // VGA pixel colour (0-7)
    output wire 	  oPlot;       // Pixel draw enable
    output wire       oDone;       // goes high when finished drawing frame

    reg [5:0] current_state, next_state;
    reg rDone, loadX, loadY, draw;

    wire finish;


    


    // DEFINE STATES
    localparam  LOAD_X          = 5'd0,
                LOAD_X_WAIT     = 5'd1,
                LOAD_Y          = 5'd2, // also loads color
                LOAD_Y_WAIT     = 5'd3,
                DRAW            = 5'd4,
                FINISH          = 5'd5;

    always @(*)
        begin: state_table
            case (current_state)
                LOAD_X: next_state = iLoadX ? LOAD_X_WAIT : LOAD_X;
                LOAD_X_WAIT: next_state = iLoadX ? LOAD_X_WAIT : LOAD_Y;
                LOAD_Y: next_state = iPlotBox ? LOAD_Y_WAIT : LOAD_Y;  // also loads color
                LOAD_Y_WAIT: next_state = iPlotBox ? LOAD_Y_WAIT : DRAW;
                DRAW: next_state = finish ? FINISH : DRAW;
                FINISH: next_state = LOAD_X;
                default: next_state = LOAD_X;

            endcase
        end
    
    always @(*)
        begin
            loadX = 1'b0;
            loadY = 1'b0;
            //draw = 1'b0;
        
            case(current_state)
                LOAD_X: loadX = 1'b1;
                LOAD_X_WAIT: loadX = 1'b1;
                LOAD_Y: loadY = 1'b1;
                LOAD_Y_WAIT: begin
                        rDone = 1'b0;
                        loadY = 1'b1;
                    end
                DRAW: draw = 1'b1;
                FINISH: begin
                        rDone = 1'b1;
                        draw = 1'b0;
                    end // cyclic behaviour
            endcase
        end

    always @(posedge iClock)
        begin
            if(!iResetn)
                begin
                    current_state = LOAD_X;
                    rDone = 1'b0;
                    draw = 1'b0;
                end
            else
                begin
                    current_state = next_state;
                end
        end
        
    assign oDone = rDone;
    datapath commander(iClock, iResetn, iPlotBox, iXY_Coord, iColour, loadX, loadY, oX, oY, oColour, draw, finish, oPlot, iBlack);


endmodule

module datapath(iClock, iResetn, iPlotBox, iXY_Coord, iColour, loadX, loadY, oX, oY, oColour, draw, finish, oPlot, iBlack);
    input iClock, iResetn, iPlotBox, loadX, loadY, draw, iBlack;
    
    input [2:0] iColour;
    input [6:0] iXY_Coord;

    output [7:0] oX;
    output [6:0] oY;
    output [2:0] oColour;
    output oPlot;
    output finish;

    reg [7:0] x;
    reg [6:0] y;
    reg [2:0] color;
    reg [3:0] counter;

    assign oColour[0] = color[0]; // THIS IS WEIRD
    assign oColour[1] = color[1];
    assign oColour[2] = color[2];
    // assign oColour = 3'b100;

    always @ (posedge iClock)
        begin
            if(!iResetn)
                begin
                    x <= 0;
                    y <= 0;
                    color <= 0;
                end
            else
                begin
                    if(loadX) 
                        begin 
                            x <= iXY_Coord;
                        end
                    if(iPlotBox)
                        begin
                            y <= iXY_Coord;
                            color <= iColour;
                        end

                end
        end


    counter16 dracula(.iClock(iClock), .iResetn(iResetn), .draw(draw), .ix(x), .iy(y), .color(oColour), 
                      .ox(oX), .oy(oY), .oPlot(oPlot), .finish(finish), .iBlack(iBlack));
    //blackout pleaseStabMe (.iClock(iClock), .iResetn(iResetn), .draw(draw), .ix(x), .iy(y), .color(oColour), 
    //                  .ox(oX), .oy(oY), .oPlot(oPlot), .finish(finish), .iBlack(iBlack));


endmodule

module counter16(iClock, iResetn, draw, ix, iy, color, ox, oy, oPlot, finish, iBlack);
    input iClock, iResetn, draw;
    input [7:0] ix;
    input [6:0] iy;
    input [2:0] color;
    input iBlack;

    output reg [7:0] ox;
    output reg [6:0] oy;
    output reg oPlot;

    output reg finish;
    reg [4:0] count;
    
    wire [1:0] xShift, yShift;


    always @(*)
        begin
            if((count > 16) & (!iBlack))
                begin
                    count <= 0;
                    oPlot <= 1'b0;
                    finish <= 1;
                end
            else if (!iBlack)
                begin
                    ox <= ix + xShift;
                    oy <= iy + yShift; // I DON'T KNOW WHY THIS WORKS
                end
        end

    always @(posedge iClock)
        begin
            if(!iResetn & !iBlack)
                begin
                    finish <= 0;
                    count <= 0;
                    oPlot <= 1'b0;
                    ox <= 0;
                    oy <= 0;
                end
            else if(draw & !finish & !iBlack)
                begin
                    oPlot <= 1'b1;
                    count <= count + 1;
                end
            else if(!iBlack)
                begin
                    oPlot <= 1'b0;
                    count <= 0;

                end
                
        end

    assign xShift[0] = count[0];
    assign xShift[1] = count[1];
    assign yShift[0] = count[2];
    assign yShift[1] = count[3];


endmodule


module blackout(iClock, iResetn, draw, ix, iy, color, ox, oy, oPlot, finish, iBlack);
    input iClock, iResetn, draw, iBlack;
    input [7:0] ix;
    input [6:0] iy;
    input [2:0] color;

    output reg [7:0] ox;
    output reg [6:0] oy;
    output reg oPlot;

    output reg finish;
    reg [10:0] countX;
    reg [10:0] countY;
    
    

    // count in the x direction


    always @(*)
        begin
            if((countY > 121) & (countX > 161) & iBlack)
                begin
                    countY <= 0;
                    countX <= 0;
                    oPlot <= 1'b0;
                    finish <= 1;
                end
            else if(iBlack)
                begin
                    ox <= countX;
                    oy <= countY; 
                end
        end

    // count in x



    always @(posedge iClock)
        begin
            if(!iResetn)
                begin
                    finish <= 0;
                    countY <= 0;
                    countX <= 0;
                    oPlot <= 1'b0;
                    ox <= 0;
                    oy <= 0;
                end
            else if(draw & !finish & iBlack) // count in x and y
                begin
                    oPlot <= 1'b1;
                    if((countX > 161) & iBlack)
                        begin
                            countX <= 0;
                            countY <= countY + 1;
                        end
                    else if (iBlack)
                        begin
                            countX <= countX + 1;
                        end
                end
            else if(iBlack)
                begin
                    oPlot <= 1'b0;
                    countX <= 0;
                    countY <= 0;
                end
                
        end

endmodule

module muxcountblack(iClock, iResetn, draw, ix, iy, color, ox, oy, oPlot, finish, iBlack);
    input iClock, iResetn, draw, iBlack;
    input [7:0] ix;
    input [6:0] iy;
    input [2:0] color;

    output reg [7:0] ox;
    output reg [6:0] oy;
    output reg oPlot;

    output reg finish;

    wire [7:0] Colorox;
    wire [6:0] Coloroy;
    wire ColoroPlot;

    wire Colorfinish;

    wire [7:0] black_ox;
    wire [6:0] black_oy;
    wire black_oPlot;

    wire black_finish;

    

endmodule