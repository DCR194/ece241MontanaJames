`timescale 1ns / 1ns

module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
    input clock, reset, ParallelLoadn, RotateRight, ASRight;
    input [3:0] Data_IN;
    output reg[3:0] Q;

    always @ (posedge clock)
        begin
            if (reset)
                begin
                    Q <= {4'b0000};
                end

            else if (!ParallelLoadn)
                begin
                    Q[3] <= Data_IN[3];
                    Q[2] <= Data_IN[2];
                    Q[1] <= Data_IN[1];
                    Q[0] <= Data_IN[0];
                end
            else if(!RotateRight)
            //SHIFT LEFT
                begin
                    Q[3] <= Q[2];
                    Q[2] <= Q[1];
                    Q[1] <= Q[0];
                    Q[0] <= Q[3];
                end
            else if(ASRight)
                begin
                    Q[2] <= Q[3];
                    Q[1] <= Q[2];
                    Q[0] <= Q[1];
                end
            else if(RotateRight)
               begin
                    Q[3] <= Q[0];
                    Q[2] <= Q[3];
                    Q[1] <= Q[2];
                    Q[0] <= Q[1];
                end
        end

endmodule