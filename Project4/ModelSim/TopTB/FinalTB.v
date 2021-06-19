`timescale 1ns/1ps

module FinalTB();
	reg cpu_clk, ref_clk, adjust, start, rst;
	reg [3 : 0]n;
	reg [1 : 0]u;
	reg [15 : 0]v;
	wire done;
	wire [20 : 0]Exp_out;

	always #2500 cpu_clk = ~cpu_clk;
	always #2.5 ref_clk = ~ref_clk;

	TopDesign top_design(cpu_clk, ref_clk, rst, adjust, start, n, u, v, done, Exp_out);

	initial begin
		rst = 1;
		cpu_clk = 0;
		ref_clk = 0;
		adjust = 0;
		start = 0;
		n = 5;
		u = 1;
		v = 16'b1000000000000000;
		#1000;
		rst = 0;
		adjust = 1;
		#10000;
		adjust = 0;
		#50000;
		start = 1;
		#50000;
		start = 0;
		#50000;
		$stop;
	end
endmodule