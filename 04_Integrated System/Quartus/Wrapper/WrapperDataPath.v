module WrapperDataPath(input clk, rst, we_req, sh_en, ld, ui_ld, eng_start, rdreq, input [15 : 0]v, input [1 : 0]u,
		output eng_done, full, empty, output[20 : 0]q, output[1 : 0]usedw);
	wire [15 : 0]shift_reg_out;
	wire [1 : 0] shift;
	wire [1 : 0] ex_int;
	wire [15 : 0] ex_frac;
	wire [20 : 0]wr_data;
	
	ShiftReg shift_reg(clk, rst, ld, sh_en, v, shift_reg_out);
	Register register(clk, rst, ld, u, shift);
	Shifter shifter(shift, {ex_int, ex_frac}, wr_data);
	exponential ex(clk, rst, eng_start, shift_reg_out, eng_done, ex_int, ex_frac);
	FIFO fifo(clk, wr_data, rdreq, wrreq, empty, full, q, usedw);
endmodule
	
module ShiftReg(input clk, rst, ld, sh_en, input[15 : 0]in, output reg[15 : 0] out);
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			out = 0;
		else
		begin
			if (ld)
				out = in;
			else if (sh_en)
				out = {1'b0, out[15 : 1]};
		end
	end
endmodule	

module Register(input clk, rst, ld, input[1 : 0]in, output reg[1 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			out = 0;
		else if (ld)
			out = in;
	end
endmodule

module Shifter(input [1 : 0]n, input[17 : 0]in, output reg [20 : 0]out);
	always @(n, in)
	begin
		case(n)
			2'b00: out = {3'b000, in};
			2'b01: out = {2'b00, in, 1'b0};
			2'b10: out = {1'b0, in, 2'b00};
			2'b11: out = {in, 3'b000};
			default: out = in;
		endcase
	end
endmodule 