module part1 (
input Clock,
input Enable,
input Reset,
output [7:0] CounterValue
);

    wire [7:0] Qint;
    assign Qint[0] = Enable;
    assign Qint[1] = CounterValue[0] & Qint[0];
    assign Qint[2] = CounterValue[1] & Qint[1];
    assign Qint[3] = CounterValue[2] & Qint[2];
    assign Qint[4] = CounterValue[3] & Qint[3];
    assign Qint[5] = CounterValue[4] & Qint[4];
    assign Qint[6] = CounterValue[5] & Qint[5];
    assign Qint[7] = CounterValue[6] & Qint[6];

    T_flip_flop b0(Clock, Reset, Qint[0], CounterValue[0]);
    T_flip_flop b1(Clock, Reset, Qint[1], CounterValue[1]);
    T_flip_flop b2(Clock, Reset, Qint[2], CounterValue[2]);
    T_flip_flop b3(Clock, Reset, Qint[3], CounterValue[3]);
    T_flip_flop b4(Clock, Reset, Qint[4], CounterValue[4]);
    T_flip_flop b5(Clock, Reset, Qint[5], CounterValue[5]);
    T_flip_flop b6(Clock, Reset, Qint[6], CounterValue[6]);
    T_flip_flop b7(Clock, Reset, Qint[7], CounterValue[7]);

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