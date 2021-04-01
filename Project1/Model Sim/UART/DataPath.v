module DataPath (input BRGCLK, cnt_en, cnt_rst, ld_en, output [7 : 0]N);
	wire [7 : 0] cnt_output;

	SimpleCounter counter(BRGCLK, cnt_en, cnt_rst, cnt_output);
	Register register(BRGCLK, ld_en, cnt_output, N);
endmodule

module SimpleCounter(input clk, en, rst, output reg [7 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			out <= 0;
		else if (en)
			out <= out + 1;
	end
endmodule

module Register(input clk, ld, input [7 : 0]in, output reg [7 : 0] out);
	always @(posedge clk)
	begin
		if (ld)
			out <= in;
	end
endmodule