`timescale 1ns / 1ns

module part3(A, B, Function, ALUout);
    parameter N = 4;
    input [N-1:0] A, B;
    input [1:0] Function;
    output[((2*N)-1):0] ALUout;

    // wire[N-1:0] sum; //Don't need wire anymore

    reg[((2*N)-1):0] outsign;

    always @(*)
        begin
            case(Function)
            2'b00: outsign = {{(N-1){1'b0}}, {A + B}};
            2'b01: outsign = {|{A, B}};
            2'b10: outsign = {&{A, B}};
            2'b11: outsign = {{A}, {B}};
            default: outsign = {N{1'b0}};
            endcase
        end
    
    assign ALUout = outsign;

endmodule