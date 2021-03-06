module DataPath(input InFreq, ref_f, rst, en, init, ld, input [3 : 0]n, output outFreq);
	wire [12 : 0]counter_out;
	wire [12 : 0]k;

	Counter counter(InFreq, ref_f, rst, en, init, counter_out);
	Shifter1 shifter(counter_out, n, k);
	Divider divider(ref_f, rst, ld, ~(k), outFreq);
endmodule

module Counter(input InFreq, ref_f, rst, en, init, output reg [12 : 0]out);
	always @(posedge ref_f, posedge rst)
	begin
		if (rst)
			out = 0;
		else
		begin
			if (init)
				out = 0;
			else if(en & InFreq)
				out = out + 1;
		end
	end
endmodule

module Shifter1(input [12 : 0] in, input [3 : 0]n, output reg [12 : 0] out);
	always @(in, n)
	begin
		case (n)
		4'b0001: out <= {1'b0, in[12 : 1]};
		4'b0010: out <= {1'b00, in[12 : 2]};
		4'b0011: out <= {1'b000, in[12 : 3]};
		4'b0100: out <= {1'b0000, in[12 : 4]};
		4'b0101: out <= {1'b00000, in[12 : 5]};
		4'b0110: out <= {1'b000000, in[12 : 6]};
		4'b0111: out <= {1'b0000000, in[12 : 7]};
		4'b1000: out <= {1'b00000000, in[12 : 8]};
		4'b1001: out <= {1'b000000000, in[12 : 9]};
		default: out <= in;
		endcase
	end
endmodule

module Divider(input ref_f, rst, ld, input [12 : 0]in, output reg outFreq);
	reg [12 : 0] cnt;
	wire [12 : 0] register;
	wire co;
	Register1 my_reg(ref_f, rst, ld, in, register);

	always @(posedge rst, posedge ref_f)
	begin
		if (rst)
		  	cnt = 13'b1111111111111;
		else if (ld)
			cnt = register;
		else if (co)
			cnt = register;
		else
			cnt = cnt + 1;
	end
	assign co = &(cnt);

	always @(posedge rst, posedge co)
	begin
		if (rst)
			outFreq = 0;
		else
			outFreq = ~outFreq;
	end
endmodule

module Register1(input clk, rst, ld, input[12 : 0]in, output reg [12 :0]out);
	always @(posedge clk, posedge rst) begin
		if (rst)
			out = 13'b1111111111111;
		else if (ld)
			out = in;
	end
endmodule