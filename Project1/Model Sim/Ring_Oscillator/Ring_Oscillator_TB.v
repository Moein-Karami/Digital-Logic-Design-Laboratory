`timescale 1ns/1ps

module RingOscillatorTB();
	wire clk;
	reg en;
	RingOscillator #(5, 1.867) RO(en, clk);
	initial begin
		en = 0;
		#100;
		en = 1;
		#1000000;
		$stop;
	end
endmodule