`timescale 1ns / 1ns

module part1(a, b, c_in, s, c_out);
    input [3:0] a, b;
    output [3:0] s, c_out;
    input c_in;


    fullAdder FA0(.a(a[0]), .b(b[0]), .cin(c_in), .cout(c_out[0]), .s(s[0]));
    fullAdder FA1(.a(a[1]), .b(b[1]), .cin(c_out[0]), .cout(c_out[1]), .s(s[1]));
    fullAdder FA2(.a(a[2]), .b(b[2]), .cin(c_out[1]), .cout(c_out[2]), .s(s[2]));
    fullAdder FA3(.a(a[3]), .b(b[3]), .cin(c_out[2]), .cout(c_out[3]), .s(s[3]));

endmodule

module fullAdder(a, b, cin, cout, s);
    input a, b, cin;
    output cout, s;
    wire line1;

    assign line1 = a ^ b;
    assign s = line1 ^ cin;
    mux2to1 riya(.x(b), .y(cin), .s(line1), .m(cout));

endmodule

module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule