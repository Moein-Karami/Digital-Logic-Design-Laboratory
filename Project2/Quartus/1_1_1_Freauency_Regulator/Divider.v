module Divider(input clk, rst, input [7 : 0]in, output PSI);
	wire co;
	MyCounter cnt(clk, rst, in, co);
	TFlipFlop tff(co, rst, PSI);
endmodule

module MyCounter(input clk, rst, input [7 : 0]in, output co);
	reg [7 : 0] cnt;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			cnt = in;
		else if(co)
			cnt = in;
		else
			cnt = cnt + 1;
	end
	assign co = &(cnt);
	
endmodule

module TFlipFlop(input clk, rst, output reg out);
		always @(posedge clk, posedge rst)
		begin
			if (rst)
				out = 0;
			else
				out = ~out;
		end
endmodule