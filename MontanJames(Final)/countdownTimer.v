module timer (
    HEX0, HEX1, HEX2, CLOCK_50, timer_enable, done
);
    input CLOCK_50;
    output [6:0] HEX0;
    output [6:0] HEX1;
	 output [6:0] HEX2;
    wire [3:0] hundreds, tens, ones;
    wire enable;
    wire [25:0] counter;
    input timer_enable;
	 output done;

    wire [25:0] upperBound;
	 // Assuming CLOCK_50 is 50 MHz, this will create a 1-second pulse
    assign upperBound = 26'd50000000;
	 
	 assign done = (hundreds == 0) && (tens == 0) && (ones == 0);

    rateDividerForTime r(CLOCK_50, upperBound, enable, counter);
    fourbitcounter c(enable, timer_enable, CLOCK_50, hundreds, tens, ones);

    hex_decoder H0(ones, HEX0);
    hex_decoder H1(tens, HEX1);
	 hex_decoder H2(hundreds, HEX2);
endmodule

module rateDividerForTime(
    input clock,
    input [25:0] upperBound,
    output reg enable,
    output reg [25:0] counter
);
    always @(posedge clock) begin
        if (counter == 26'bx) begin
            counter <= 26'b0;
        end else if (counter == upperBound) begin
            enable = 1'b1;
            counter <= 26'b0;
        end else begin
            enable = 1'b0;
            counter <= counter + 1;
        end
    end
endmodule

module fourbitcounter(
    input enable,
    input timer_enable,
    input clock,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    initial begin
        hundreds = 1; // For 100 seconds
        tens = 0;
        ones = 0;
    end

     always @(posedge clock) begin
        if (timer_enable == 1'b1 && enable == 1'b1) begin
            if (hundreds == 0 && tens == 0 && ones == 0) begin
                // Timer reached 0, do nothing
            end else if (ones == 0) begin
                ones <= 9; // Reset ones to 9
                if (tens == 0) begin
                    tens <= 9; // Reset tens to 9
                    if (hundreds != 0) begin
                        hundreds <= hundreds - 1; // Decrement hundreds
                    end
                end else begin
                    tens <= tens - 1; // Decrement tens
                end
            end else begin
                ones <= ones - 1; // Decrement ones
            end
        end else if (timer_enable == 1'b0) begin
            hundreds <= 1; // Reset to 100 seconds
            tens <= 0;
            ones <= 0;
        end
    end
endmodule

/*
module fourbitcounter(
    input enable,
    input timer_enable,
    input clock,
    output reg [3:0] seconds,
    output reg [3:0] seconds2
);
    initial begin
        seconds = 10; // Representing 100 seconds
        seconds2 = 0;
    end

    always @(posedge clock) begin
        if (timer_enable == 1'b1 && enable == 1'b1) begin
            if (seconds == 0 && seconds2 == 0) begin
                // Timer reached 0, do nothing
            end else if (seconds2 == 0) begin
                seconds <= seconds - 1;
                seconds2 <= 9;
            end else begin
                seconds2 <= seconds2 - 1;
            end
        end else if (timer_enable == 1'b0) begin
            seconds <= 10;
            seconds2 <= 0;
        end
    end
endmodule
*/

module hex_decoder(c, display);
   input [3:0] c;
	output [6:0] display;
	
	// s_0 eqn
	assign display[0] = ~(
	(~c[0] | c[1] | c[2] | c[3]) & 
	(~c[2] | c[0] | c[1] | c[3]) & 
	(~c[0] | ~c[1] | ~c[3] | c[2]) &
	(~c[0] | ~c[2] | ~c[3] | c[1])
	);
	
	// s_1 eqn
	assign display[1] = ~(
	(~c[0] | ~c[2] | c[1] | c[3]) & 
	(~c[1] | ~c[2] | c[0] | c[3]) & 
	(~c[0] | ~c[2] | c[1] | c[3]) & 
	(~c[0] | ~c[1] | ~c[3] | c[2]) & 
	(~c[2] | ~c[3] | c[0] | c[1]) & 
	(~c[1] | ~c[2] | ~c[3] | c[0]) & 
	(~c[0] | ~c[1] | ~c[2] | ~c[3])
	);
	
	// s_2 eqn
	assign display[2] = ~(
	(~c[1] | c[0] | c[2] | c[3]) &
	(~c[2] | ~c[3] | c[0] | c[1]) & 
	(~c[1] | ~c[2] | ~c[3] | c[0]) & 
	(~c[0] | ~c[1] | ~c[2] | ~c[3])
	);
	
	// s_3 eqn
	assign display[3] = ~(
	(~c[0] | c[1] | c[2] | c[3]) &
	(~c[2] | c[0] | c[1] | c[3]) &
	(~c[0] | ~c[1] | ~c[2] | c[3]) &
	(~c[0] | ~c[3] | c[1] | c[2]) &
	(~c[1] | ~c[3] | c[0] | c[2]) &
	(~c[0] | ~c[1] | ~c[2] | ~c[3])
	);
	
	// s_4 eqn
	assign display[4] = ~(
	(~c[0] | c[1] | c[2] | c[3]) &
	(~c[0] | ~c[1] | c[2] | c[3]) &
	(~c[2] | c[0] | c[1] | c[3]) &
	(~c[0] | ~c[2] | c[1] | c[3]) &
	(~c[0] | ~c[1] | ~c[2] | c[3]) &
	(~c[0] | ~c[3] | c[1] | c[2])
	);
	
	// s_5 eqn
	assign display[5] = ~(
	(~c[0] | c[1] | c[2] | c[3]) &
	(~c[1] | c[0] | c[2] | c[3]) &
	(~c[0] | ~c[1] | c[2] | c[3]) &
	(~c[0] | ~c[1] | ~c[2] | c[3]) &
	(~c[0] | ~c[2] | ~c[3] | c[1])
	);
	
	// s_6 eqn
	assign display[6] = ~(
	(c[0] | c[1] | c[2] | c[3]) &
	(~c[0] | c[1] | c[2] | c[3]) &
	(~c[0] | ~c[1] | ~c[2] | c[3]) &
	(~c[2] | ~c[3] | c[0] | c[1])
	);

endmodule