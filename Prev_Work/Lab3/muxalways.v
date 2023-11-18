module reshaping_mux(MuxSelect , MuxIn , Out);
    input wire [6:0] MuxIn;
    input wire [2:0] MuxSelect;
    output reg Out; // signal is set inside the always block
    wire [6:0] ReshapedMuxIn;
    reshape reshapeModuleName (.in(MuxIn) ,.out(ReshapedMuxIn));
    //We instantiate a reshape module and connect wire MuxIn to
    //the input and wire ReshapedMuxIn to the output. All
    //modules need a name so we call it reshapeModuleName
    always@ (*) // declare always block
        begin
            case (MuxSelect) // Construct a Mux
            3'b000: Out = ReshapedMuxIn [0]; // Case 0
            3'b001: Out = ReshapedMuxIn [1]; // Case 1
            3'b010: Out = ReshapedMuxIn [2]; // Case 2
            3'b011: Out = ReshapedMuxIn [3]; // Case 3
            3'b100: Out = ReshapedMuxIn [4]; // Case 4
            3'b101: Out = ReshapedMuxIn [5]; // Case 5
            3'b110: Out = ReshapedMuxIn [6]; // Case 6
            default: Out = 0; // Connect all other mux inputs to 0
            endcase
end
endmodule
module reshape(in, out);
    input wire [6:0] in;
    output reg [6:0] out;
    always@ (*)
        begin
        //Perform the reshaping. Using assign statements and a
        //wire "out" would have been equivalent.
        out [6] = in[0];
        out [5] = in[1];
        out [4] = in[2];
        out [3] = in[3];
        out [2] = in[4];
        out [1] = in[5];
        out [0] = in[6];
        end
endmodule