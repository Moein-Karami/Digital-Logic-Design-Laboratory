module Divider(input clk, rst, input [7 : 0] SW, output reg psi);
	reg [7 : 0]cnt;
	wire co;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			cnt = SW;
		else
		begin
			if (&cnt)
				cnt = SW;
			else
				cnt = cnt + 1;
		end
	end
	assign co = &(cnt);
	always @(posedge co, posedge rst)
	begin
		if(rst)
			psi = 0;
		else
			psi = ~psi;
	end
endmodule

module DividerCounter(input clk, rst, ld,input [3 : 0]parallel, output co);
	reg [3 : 0] cnt;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			cnt = parallel;
		else
		begin
			if (ld)
				cnt = parallel;
			else
				cnt = cnt + 1;
		end
	end
	assign co = &(cnt);
endmodule

module MY_TFF(input rst, in, output reg out);
	always @(posedge rst, posedge in)
	begin
		if(rst)
			out = 0;
		else
			out = ~out;
	end
endmodule
