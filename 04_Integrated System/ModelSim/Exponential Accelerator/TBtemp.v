`timescale 1ns/1ps

module TBtemp();
	reg clk, rst, start;
	reg [15 : 0]x;
	wire done;
	wire [1 : 0]intpart;
	wire [15 : 0]fracpart;

	exponential ex(clk, rst, start, x, done, intpart, fracpart);
	always #10 clk = ~clk;

	initial
	begin
		clk = 0;
		rst = 1;
		start = 0;
		#1000;
		rst = 0;
		start = 1;
		x = 0;
		#1000;
		start = 0;
		#1000;
		x= 16'b1111111111111111;
		start = 1;
		# 1000;
		start = 0;
		#1000;
		start = 1;
		x = 16'b1000000000000000;
		#1000;
		start = 0;
		#1000;
		$stop;
	end
endmodule

