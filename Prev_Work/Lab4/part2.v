`timescale 1ns / 1ns

module part2(Clock, Reset_b, Data, Function, ALUout);
    input [3:0] Data;
    input Clock, Reset_b;
    input [1:0] Function;
    output [7:0] ALUout;

    wire [7:0] preRegALUout, aluPrevVal;
    wire [3:0] b;

    assign b = ALUout[3:0];
    assign aluPrevVal = ALUout;

    ALU myAlu(Data, b, Function, preRegALUout, aluPrevVal);
    D_flip_flop storage(Clock, Reset_b, preRegALUout, ALUout);

endmodule


module D_flip_flop (
    input wire clk ,
    input wire reset_b ,
    input wire [7:0] d ,
    output reg [7:0] q
    ) ;
    always@ ( posedge clk )
        begin
            if ( reset_b ) q <= 8'b00000000 ;
            else q <= d ;
        end
endmodule


module ALU(A, B, Function, ALUout, prevVal);
    input [3:0] A, B;
    input [1:0] Function;
    input [7:0] prevVal;
    output[7:0] ALUout;

    reg[7:0] outsign;

    always @(*)
        begin
            case(Function)
            2'b00: outsign <= A + B;
            2'b01: outsign <= A * B;
            2'b10: outsign <= B << A;
            2'b11: outsign <= prevVal;
            endcase
        end
    
    assign ALUout = outsign;

endmodule