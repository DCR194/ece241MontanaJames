module part3
#(parameter CLOCK_FREQUENCY=50000000)(
input wire ClockIn,
input wire Reset,
input wire Start,
input wire [2:0] Letter,
output wire DotDashOut,
output wire NewBitOut
);

endmodule
// We need something to change the bits by one and something to read them out

module shiftReg12Bits(clock, parallelLoad, enable, out);
    input clock, enable;
    input [11:0] parallelLoad;
    output out;

    reg [11:0] Q;

    always @ (posedge clock)
        begin
            if(enable)
                begin
                    Q << 1;
                end
            else
                begin
                    Q <= parallelLoad;
                end
        end

    assign out = Q[11];

endmodule



module RateDivider500ms
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
input Reset,
input [1:0] Speed,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn, posedge Reset)
        begin
            if(Reset)
                begin
                    RateDividerCount = (CLOCK_FREQUENCY > 1) - 1;
                    RateDividerCount = 0;
                    endcase
                end
            
            else if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY > 1) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)?'1:'0;
endmodule


module RateDivider6s
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
input Reset,
input [1:0] Speed,
output Enable
);

    reg [30:0] RateDividerCount;

    always@(posedge ClockIn, posedge Reset)
        begin
            if(Reset)
                begin
                    RateDividerCount = (CLOCK_FREQUENCY * 6) - 1;
                    RateDividerCount = 0;
                    endcase
                end
            
            else if(RateDividerCount != 31'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    RateDividerCount = (CLOCK_FREQUENCY * 6) - 1;
                end
        end

    assign Enable = (RateDividerCount == 31'b0)?'1:'0;
endmodule

module letterSelector(letterBin, morseCode);
    input[2:0] letterBin;
    output [11:0] morseCode;

    reg [11:0] decoded;

    always @(*)
        begin
            case(letterBin)
            3'b000: decoded = 12'b101110000000 //a
            3'b001: decoded = 12'b111010101000 //b
            3'b010: decoded = 12'b111010111010 //c
            3'b011: decoded = 12'b111010100000 //d
            3'b100: decoded = 12'b100000000000 //e
            3'b101: decoded = 12'b101011101000 //f
            3'b110: decoded = 12'b111011101000 //g
            3'b111: decoded = 12'b101010100000 //h
            default: 12'b000000000000
        end

    assign morseCode = decoded;


endmodule

module T_flip_flop(clk, reset, in, q);
    input clk, reset, in;
    output q;
    wire dout;
    wire txor;

    assign txor = in ^ dout;

    D_flip_flop d1(clk, reset, txor, dout);

    assign q = dout;

endmodule


module D_flip_flop(
input wire clk ,
input wire reset_b ,
input wire d,
output reg q
);
    always@(posedge clk)
        begin
            if (reset_b) q <= 1'b0;
            else q <= d;
        end
endmodule


/*
A • —
B — • • •
C — • — •
D — • •
E •
F • • — •
G — — •
H • • • •
*/