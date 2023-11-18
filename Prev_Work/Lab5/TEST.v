module part2
#(parameter CLOCK_FREQUENCY = 50)(
input ClockIn,
input Reset,
input [1:0] Speed,
output [3:0] CounterValue
);
    wire enable;

    RateDivider #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) rD (ClockIn, Reset, Speed, enable);
    DisplayCounter dCount(ClockIn, Reset, enable, CounterValue);

endmodule


module RateDivider
#(parameter CLOCK_FREQUENCY = 50) (
input ClockIn,
input Reset,
input [1:0] Speed,
output Enable
);

    reg [25:0] RateDividerCount;

    always@(posedge ClockIn, posedge Reset)
        begin
            if(Reset)
                begin
                    case(Speed)
                    2'b00: RateDividerCount = 0;
                    2'b01: RateDividerCount = CLOCK_FREQUENCY - 1;
                    2'b10: RateDividerCount = (CLOCK_FREQUENCY * 2) - 1;
                    2'b11: RateDividerCount = (CLOCK_FREQUENCY * 4) - 1;
                    default: RateDividerCount = 0;
                    endcase
                end
            
            else if(RateDividerCount != 26'b0)
                begin
                    RateDividerCount <= RateDividerCount -1;
                end
            
            else 
                begin
                    case(Speed)
                    2'b00: RateDividerCount = 0;
                    2'b01: RateDividerCount = CLOCK_FREQUENCY - 1;
                    2'b10: RateDividerCount = (CLOCK_FREQUENCY * 2) - 1;
                    2'b11: RateDividerCount = (CLOCK_FREQUENCY * 4) - 1;
                    default: RateDividerCount = 0;
                    endcase
                end
        end

    assign Enable = (RateDividerCount == 26'b0)?'1:'0;
endmodule


module DisplayCounter (
input Clock,
input Reset,
input EnableDC,
output [3:0] CounterValue
);

    reg [3:0] CountVal;
    always@(posedge Clock or posedge Reset)
        begin
            if(Reset)
                begin
                    CountVal <= 0;
                end    
            else if(EnableDC)
                begin
                    CountVal <= CountVal + 1;
                end
        end
    assign CounterValue = CountVal;
endmodule