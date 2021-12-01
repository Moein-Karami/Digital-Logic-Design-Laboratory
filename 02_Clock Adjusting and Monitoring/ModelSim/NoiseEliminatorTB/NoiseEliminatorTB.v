`timescale 1ns/1ps

module NoiseEliminatorTB();
	reg clk;
	wire ro;
	reg ro_on;
	reg rst;
	wire eliminator_input;
	reg s;
	wire noise_less_ro;

	RingOscillator #(5, 50) internal_ro(ro_on, ro);
	NoiseMux mux(s, {ro, ~ro}, eliminator_input);
	Noise_Eliminator ne(clk, eliminator_input, rst, noise_less_ro);

	always #10 clk = ~clk;

	initial
	begin
		clk = 0;
		ro_on = 0;
		rst = 1;
		s = 0;
		#800;
		ro_on = 1;
		rst = 0;
		#800;
		s = 1;
		#3;
		s = 0;
		#500;
		s = 1;
		#2;
		s = 0;
		#1400;
		s = 1;
		#3;
		s = 0;
		#1000;
		s = 1;
		#3;
		s = 0;
		#1000;
		$stop;
	end
endmodule

module RingOscillator #(parameter N, parameter D)(input on, output psi);
	wire [N : 0]w;
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1)
			assign #(D) w[i + 1] = ~w[i];
	endgenerate
	assign w[0] = w[N] & on;
	assign psi = w[N];
endmodule

module NoiseMux(input s, input [1 : 0]in, output out);
	assign out = in[s];
endmodule