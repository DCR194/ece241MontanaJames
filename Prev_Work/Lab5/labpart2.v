module potato(CLOCK_50, SW, HEX0);

    input CLOCK_50;
    input[9:0] SW;
    output[6:0] HEX0;

    wire[3:0] count;

/*
input ClockIn,
input Reset,
input [1:0] Speed,
output [3:0] CounterValue
);
*/
    part2 zhuli(CLOCK_50, SW[9], SW[1:0], count);

    hex_decoder varrick(count, HEX0)

endmodule


module hex_decoder(c, display);
    input[3:0] c;
    output[6:0] display;

    assign display[0] = ~((c[3] | c[2] | c[1] | ~c[0]) & (c[3] | ~c[2] | c[1] | c[0]) &
                        (~c[3] | c[2] | ~c[1] | ~c[0]) & (~c[3] | ~c[2] | c[1] | ~c[0]));

    assign display[1] = ~((c[3] | ~c[2] | c[1] | ~c[0]) & (c[3] | ~c[2] | ~c[1] | c[0]) &
                        (~c[3] | c[2] | ~c[1] | ~c[0]) & (~c[3] | ~c[2] | c[1] | c[0]) &
                        (~c[3] | ~c[2] | ~c[1] | c[0]) & (~c[3] | ~c[2] | ~c[1] | ~c[0]));
    
    assign display[2] = ~((c[3] | c[2] | ~c[1] | c[0]) & (~c[3] | ~c[2] | c[1] | c[0]) &
                        (~c[3] | ~c[2] | ~c[1] | c[0]) & (~c[3] | ~c[2] | ~c[1] | ~c[0]));
                    
    assign display[3] = ~((c[3] | c[2] | c[1] | ~c[0]) & (c[3] | ~c[2] | c[1] | c[0]) & 
                        (c[3] | ~c[2] | ~c[1] | ~c[0]) & (~c[3] | c[2] | ~c[1] | c[0]) &
                        (~c[3] | ~c[2] | ~c[1] | ~c[0]));

    assign display[4] = ~((c[3] | c[2] | c[1] | ~c[0]) & (c[3] | c[2] | ~c[1] | ~c[0]) &
                        (c[3] | ~c[2] | c[1] | c[0]) & (c[3] | ~c[2] | c[1] | ~c[0]) &
                        (c[3] | ~c[2] | ~c[1] | ~c[0]) & (~c[3] | c[2] | c[1] | ~c[0]));

    assign display[5] = ~((c[3] | c[2] | c[1] | ~c[0]) & (c[3] | c[2] | ~c[1] | c[0]) &
                        (c[3] | c[2] | ~c[1] | ~c[0]) & (c[3] | ~c[2] | ~c[1] | ~c[0]) &
                        (~c[3] | ~c[2] | c[1] | ~c[0]));

    assign display[6] = ~((c[3] | c[2] | c[1] | c[0]) & (c[3] | c[2] | c[1] | ~c[0]) &
                        (c[3] | ~c[2] | ~c[1] | ~c[0]) & (~c[3] | ~c[2] | c[1] | c[0]));
endmodule

// Using f=0
/*
0 = (c[3] | c[2] | c[1] | c[0])
1 = (c[3] | c[2] | c[1] | ~c[0])
2 = (c[3] | c[2] | ~c[1] | c[0])
3 = (c[3] | c[2] | ~c[1] | ~c[0])
4 = (c[3] | ~c[2] | c[1] | c[0])
5 = (c[3] | ~c[2] | c[1] | ~c[0])
6 = (c[3] | ~c[2] | ~c[1] | c[0])
7 = (c[3] | ~c[2] | ~c[1] | ~c[0])
8 = (~c[3] | c[2] | c[1] | c[0])
9 = (~c[3] | c[2] | c[1] | ~c[0])
A = (~c[3] | c[2] | ~c[1] | c[0])
b = (~c[3] | c[2] | ~c[1] | ~c[0])
C = (~c[3] | ~c[2] | c[1] | c[0])
d = (~c[3] | ~c[2] | c[1] | ~c[0])
E = (~c[3] | ~c[2] | ~c[1] | c[0])
F = (~c[3] | ~c[2] | ~c[1] | ~c[0])
*/