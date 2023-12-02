
// top module with instantiations for ps2 keyboard and audio
// all given libraries are included

module controlModule(
    input CLOCK_50,           // 50 MHz clock
    input PS2_CLK,            // PS2 clock
    input PS2_DAT,            // PS2 data
    input AUD_ADCDAT,         // Audio input
    output AUD_XCK,           // Audio clock
    output AUD_DACDAT,        // Audio output
	 output FPGA_I2C_SCLK,     // FPGA clock
	 inout FPGA_I2C_SDAT,      // FPGA data
    inout AUD_BCLK,           // Audio bit clock
    inout AUD_ADCLRCK,        // Audio ADC LR Clock
    inout AUD_DACLRCK,        // Audio DAC LR Clock
	 input [3:0] KEY,			   // Key input
	 output [9:0] SW,		      // Switch output
	 output reg [9:0] LEDR     // LEDs for PS2 keys
);

    // PS2 controller instantiation
    wire [7:0] received_data;
    wire received_data_en;
    wire command_was_sent;
    wire error_communication_timed_out;

    PS2_Controller ps2(
        .CLOCK_50(CLOCK_50),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .received_data(received_data),
        .received_data_en(received_data_en),
        .command_was_sent(command_was_sent),
        .error_communication_timed_out(error_communication_timed_out)
    );

    // Logic for PS2 key detection & LED connection
    reg keyR, keyL, keyUp, keyDown, keySpace;
    always @(posedge received_data_en) begin
        if (received_data == 8'hF0) begin
		  // if ((received_data == 8'hF0) && (keyR || keyL || keyUp || keyDown || keySpace)) begin
            keyR <= 0;
            keyL <= 0;
            keyUp <= 0;
            keyDown <= 0;
            keySpace <= 0;
        end else begin
            case (received_data)
                8'h75: keyUp <= 1;
                8'h72: keyDown <= 1;
                8'h6B: keyL <= 1;
                8'h74: keyR <= 1;
                8'h29: keySpace <= 1;
            endcase
        end
		  
		  LEDR[0] <= keyUp;
		  LEDR[1] <= keyDown;
		  LEDR[2] <= keyR;
		  LEDR[3] <= keyL;
		  LEDR[4] <= keySpace;
    end
	 
	 // Generating frequencies when a key is pressed
	 localparam FREQ_UP = 32'd440;
    localparam FREQ_DOWN = 32'd490;
    localparam FREQ_LEFT = 32'd624;
    localparam FREQ_RIGHT = 32'd580;
    localparam FREQ_SPACE = 32'd669;
	 
	 reg [31:0] current_frequency;
    always @(posedge CLOCK_50) begin
		  if (keyR || keyL || keyUp || keyDown || keySpace) begin
			  case ({keyUp, keyDown, keyL, keyR, keySpace})
					5'b10000: current_frequency <= FREQ_UP;
					5'b01000: current_frequency <= FREQ_DOWN;
					5'b00100: current_frequency <= FREQ_LEFT;
					5'b00010: current_frequency <= FREQ_RIGHT;
					5'b00001: current_frequency <= FREQ_SPACE;
					// default: current_frequency <= 32'd0;
			  endcase
		  end else begin
				   current_frequency <= 32'd0;
		  end		
    end

    // Audio functionality
    wire audio_in_available;
    wire [31:0] left_channel_audio_in;
    wire [31:0] right_channel_audio_in;
    wire audio_out_allowed;
    wire [31:0] left_channel_audio_out;
    wire [31:0] right_channel_audio_out;
    wire read_audio_in;
    wire write_audio_out;

    Audio_Controller Audio_Controller (
        .CLOCK_50(CLOCK_50),
        .reset(~KEY[0]),
        .clear_audio_in_memory(),
        .read_audio_in(read_audio_in),
        .clear_audio_out_memory(),
        .left_channel_audio_out(left_channel_audio_out),
        .right_channel_audio_out(right_channel_audio_out),
        .write_audio_out(write_audio_out),
        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_BCLK(AUD_BCLK),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_DACLRCK(AUD_DACLRCK),
        .audio_in_available(audio_in_available),
        .left_channel_audio_in(left_channel_audio_in),
        .right_channel_audio_in(right_channel_audio_in),
        .audio_out_allowed(audio_out_allowed),
        .AUD_XCK(AUD_XCK),
        .AUD_DACDAT(AUD_DACDAT)
    );

    // Additional audio configurations
    avconf #(.USE_MIC_INPUT(1)) u1 (
        .FPGA_I2C_SCLK(FPGA_I2C_SCLK),
        .FPGA_I2C_SDAT(FPGA_I2C_SDAT),
        .CLOCK_50(CLOCK_50),
        .reset(~KEY[0])
    );
	 
	 // Generating audio waveform
	reg [31:0] wave_counter = 0;
	reg audio_signal = 0;
	
	// add internal wire

	always @(posedge CLOCK_50) begin
		 // Generate waveform if any key is pressed
		 if (|LEDR) begin
			 if (keyR || keyL || keyUp || keyDown || keySpace) begin
				  if (wave_counter >= (50000000 / (current_frequency * 2)) - 1) begin
						wave_counter <= 0;
						audio_signal <= ~audio_signal;
				  end else begin
						wave_counter <= wave_counter + 1;
				  end
			 end
		 end else begin
			  wave_counter <= 0;
			  audio_signal <= 0;
		 end
	end	

    // Assigning the generated audio signal to DAC output
    assign left_channel_audio_out = audio_signal ? 32'd100000000 : -32'd100000000;
    assign right_channel_audio_out = left_channel_audio_out;
    assign write_audio_out = audio_in_available & audio_out_allowed;

endmodule
