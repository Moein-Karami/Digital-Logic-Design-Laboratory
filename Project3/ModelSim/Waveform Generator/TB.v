`timescale 1ns/1ns

module TB();
	reg clk, rst;
	wire [12 : 0] SW;
	reg [10 : 8] mode;
	reg [7 : 0]parallel;
	reg [1 : 0] amp;
	assign SW = {amp, mode, parallel};
	reg [7 : 0] Phase_cntrl;
	wire [7 : 0] wave;
	always #10 clk = ~clk;
	always #1000000 mode = mode + 1;
	always #200000 amp = amp + 1;
	WaveformGenerator waveform_generator(.clk(clk), .rst(rst), .SW(SW), .Phase_cntrl(Phase_cntrl), .wave(wave));

	initial
	begin
		parallel = 254;
		mode = 0;
		clk = 0;
		rst = 1;
		Phase_cntrl = 1;
		amp = 0;
		# 100;
		rst = 0;
		#8000000;
		$stop;
	end
endmodule 