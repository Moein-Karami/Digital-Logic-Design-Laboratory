`timescale 1ns/1ps

module AdjustingTB();
	reg ro_on;
	reg rst;
	wire ro_output, ro1_output, ro2_output;
	reg clk;
	reg choose;
	wire PSI;
	reg [7 : 0]setPeriod;

	RingOscillator #(5, 5) ro1(ro_on, ro1_output);
	RingOscillator #(5, 6) ro2(ro_on, ro2_output);
	Mux mux(choose, ro1_output, ro2_output, ro_output);

	FrequencyRegulatorAndDivider REG(.clk_50M(clk), .rst(rst), .setPeriod(setPeriod), .PSI(PSI), .clk(ro_output));

	always #10 assign clk = ~clk;

	initial begin
		clk = 0;
		ro_on = 0;
		setPeriod = 8'd125;
		choose = 0;
		rst = 1;
		#95;
		ro_on = 1;
		rst = 0;
		#200005;
		choose = 1;
		#200000;
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

module Mux(input s, a, b, output out);
	begin
		assign out = s ? b : a;
	end
endmodule