module lab3(SW, KEY, LEDR, HEX0, HEX2, HEX3, HEX4);
    input [7:0] SW;
    input [1:0] KEY;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX2, HEX3, HEX4;

    part2 iLoveYou(.A(SW[7:4]), .B(SW[3:0]), .Function(KEY), .ALUout(LEDR));

    hex_decoder d1(.c(SW[7:4]), .display(HEX0)); //displaying A
    hex_decoder d2(.c(SW[3:0]), .display(HEX2)); //displaying B
    hex_decoder d3(.c(LEDR[7:4]), .display(HEX3)); // displaying four least signif B (in hexadec)
    hex_decoder d4(.c(SW[3:0]), .display(HEX4)); // displaying four most signif for A (in hexadec)

endmodule


// create project with part1, part2, part3 abd this file
// set this one en envidence, compile this file to board (import assignments too!)
// picking functions with keys on the side, 1 when not pressed and 0 when pressed
// from debut, none pressed meaning 11 concact meaning output should be A,B




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