`timescale 1ns/1ns

module TB();
	reg clk, rst, start, rdreq;
	reg [15 : 0] v;
	reg [1 : 0]u;
	wire done, full, empty;
	wire [20 : 0]q;
	wire [1 : 0]usedw;

	Wrapper wrapper(clk, rst, start, rdreq, v, u, done, full, empty, q, usedw);

	always # 5 clk = ~clk;

	initial begin
		clk = 0;
		rst = 1;
		start = 0;
		rdreq = 0;
		u = 0;
		v = 0;
		# 100;
		rst = 0;
		v = 16'b0000010000000000;
		u = 0;
		start = 1;
		# 100;
		start = 0;
		#1000;
		rdreq = 1;
		#1000;
		rdreq = 0;
		#1000;
		rdreq = 1;
		#1000;
		rdreq = 0;
		#1000;
		rdreq = 1;
		#1000;
		$stop;
	end
endmodule