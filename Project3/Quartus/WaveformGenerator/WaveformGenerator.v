module WaveformGeneratorProcessor(input clk, rst, input[2 : 0]SW, output reg[7 : 0]generated_wave);
	wire [7 : 0] cnt;
	wire [7 : 0] rhomboid;
	wire [7 : 0] square;
	wire [7 : 0] reciprocal;
	wire [7 : 0] triangle;
	wire [7 : 0] sine;
	wire [7 : 0] full_wave_rectified;
	wire [7 : 0] half_wave_rectified;
	wire [7 : 0] sinusoidally;
	
	Counter counter(clk, rst, cnt);
	Rhomboid rhomboid_mod(clk, rst, cnt, rhomboid);
	Square square_mod(clk, rst, cnt, square);
	Reciprocal rexiprocal_mod(clk, rst, cnt, reciprocal);
	Triangle triangle_mod(clk, rst, cnt, triangle);
	Sine sine_mod(clk, rst, cnt, sine);
	FullwaveRectified full_wave_revitified_mod(clk, rst, sine, full_wave_rectified);
	HalfwaveRectified half_wave_revitified_mod(clk, rst, sine, half_wave_rectified);
	Sinusoidally sinusoidally_mod(clk, rst, sine, sinusoidally);
	
	always @(posedge clk)
	begin
		case (SW)
			3'b000: generated_wave = rhomboid;
			3'b001: generated_wave = square;
			3'b010: generated_wave = reciprocal;
			3'b011: generated_wave = triangle;
			3'b100: generated_wave = full_wave_rectified;
			3'b101: generated_wave = half_wave_rectified;
			3'b110: generated_wave = sinusoidally;
			default: generated_wave = 0;
		endcase
	end
endmodule

module Counter(input clk, rst, output reg [7 : 0]out);
	
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			out = 0;
		else
			out = out + 1;
	end
endmodule


module Rhomboid(input clk, rst, input [7 : 0] cnt, output reg [7 : 0] rhomboid);
	reg mode;
	
	always @(posedge rst, posedge clk)
	begin
		if (rst)
		begin
			mode = 0;
			rhomboid = 0;
		end
		else
		begin
			if (mode)
				rhomboid = cnt;
			else
				rhomboid = ~(cnt);
				
			if (rhomboid[0])
				rhomboid = 256 - rhomboid;
		
			
			if (&(cnt))
				mode = ~mode;
		end
	end
endmodule

module Square(input clk, rst, input [7 : 0] cnt, output reg [7 : 0] square);

	always @(posedge rst, posedge clk)
	begin
		if(rst)
			square = 0;
		else
		begin
			if (cnt >= 8'b10000000)
				square = 8'b11111111;
			else
				square = 8'b00000000;
		end
	end
endmodule

module Reciprocal(input clk, rst, input [7 : 0] cnt, output reg [7 : 0] reciprocal);

	always @(posedge rst, posedge clk)
	begin
		if(rst)
			reciprocal = 0;
		else
			reciprocal = 256 / (256 - cnt);
	end
endmodule

module Triangle(input clk, rst, input [7 : 0] cnt, output reg [7 : 0] triangle);
	reg mode;
	
	always @(posedge rst, posedge clk)
	begin
		if (rst)
		begin
			mode = 1;
			triangle = 0;
		end
		else
		begin
			if (mode)
				triangle = cnt;
			else
				triangle = ~(cnt);
		
			
			if (&(cnt))
				mode = ~mode;
		end
	end
endmodule

module Sine(input clk, rst, input [7 : 0]cnt, output [7 : 0] out);
	reg [15 : 0]sin;
	reg [15 : 0]cos;
	reg [15 : 0] last_sin;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
		begin
			sin = 0;
			cos = 30000;
		end
		else
		begin
				if (cos[15])
					sin = sin + {6'b111111, cos[15 : 6]};
				else
					sin = sin + {6'b000000, cos[15 : 6]};
				
				if (sin[15])
					cos = cos - {6'b111111, sin[15 : 6]};
				else
					cos = cos - {6'b000000, sin[15 : 6]};
		end
	end
	assign out = 127 + sin[15 : 8];
endmodule

module FullwaveRectified(input clk, rst, input [7 : 0]sine, output reg [7 : 0] full_wave_rectified);
	
	always @(posedge rst, posedge clk)
	begin
		if (rst)
			full_wave_rectified = 0;
		else
		begin
			if (sine >= 128)
				full_wave_rectified = sine;
			else
				full_wave_rectified = 256 - sine;
		end
	end
endmodule

module HalfwaveRectified(input clk, rst, input [7 : 0]sine, output reg [7 : 0] half_wave_rectified);
	
	always @(posedge rst, posedge clk)
	begin
		if (rst)
			half_wave_rectified = 0;
		else
		begin
			if (sine >= 128)
				half_wave_rectified = sine;
			else
				half_wave_rectified = 128;
		end
	end
endmodule

module Sinusoidally(input clk, rst, input[7 : 0]sine, output reg [7: 0]sinusoidally);

	reg mode;
	
	always @(posedge rst, posedge clk)
	begin
		if (rst)
		begin
			sinusoidally = 0;
			mode = 0;
		end
		else
		begin
			if (mode)
				sinusoidally = sine;
			else
				sinusoidally = 255 - sine;
			mode = ~mode;
		end
	end
endmodule

module Adder(input [7 : 0]a, input [7 : 0]b, output [7 : 0]out);
	assign out = a + b;
endmodule

module Register(input clk, rst, input[7 : 0]in, output reg[7 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out = 0;
		else
			out = in;
	end
endmodule
