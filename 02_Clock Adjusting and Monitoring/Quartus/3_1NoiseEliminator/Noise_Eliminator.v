module Noise_Eliminator(input clk, internal_ro, rst, output noise_less_ro);
	parameter Waitfor1 = 0;
	parameter Noisechk1 = 1;
	parameter Stable1 = 2;
	parameter Noisechk0 = 3;

	reg[1 : 0]ns;
	reg[1 : 0]ps;
	always @(posedge clk)
	begin
		case (ps)
			Waitfor1: ns = internal_ro ? Noisechk1 : Waitfor1;
			Noisechk1: ns = internal_ro ? Stable1 : Waitfor1;
			Stable1: ns = internal_ro ? Stable1 : Noisechk0;
			Noisechk0: ns = internal_ro? Stable1 : Waitfor1;
			default: ns = 0;
		endcase
	end
	
	assign noise_less_ro = (ps == Stable1) | (ps == Noisechk0);
	
	always @(posedge clk, posedge rst)
	begin
		if(rst)
			ps = 0;
		else
			ps = ns;
	end
	
endmodule

module Mux(input Fail, Power, PSI, external_ro, output Main_Clock);
	wire s = Fail|Power;
	assign Main_Clock = s ? PSI : external_ro;
endmodule 