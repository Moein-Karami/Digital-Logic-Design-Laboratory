`timescale 1ns/1ps

module CounterTB();
	reg en, preset;
	reg [7 : 0]b;
	wire co;
	Counter cnt(.clk(ring), .preset(preset), .co(co), .b0(b[0]), .b1(b[1]), .b2(b[2]), .b3(b[3]), .b4(b[4]), .b5(b[5]),
			.b6(b[6]), .b7(b[7]));
	RingOscillator ring_osc(.en(en), .clk(ring));

	initial begin
		b = 8'b10001111;
		en = 0;
		preset = 0;
		#100;
		en = 1;
		preset = 1;
		#100000;
		$stop;
	end
endmodule