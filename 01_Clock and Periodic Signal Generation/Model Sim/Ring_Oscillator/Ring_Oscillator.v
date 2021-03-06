`timescale 1ns/1ps

module RingOscillator #(parameter N = 5, parameter D = 1.867)(input en, output clk);
	wire [0 : N]w ;
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin : XX
			assign #D w[i + 1] = ~w[i];
		end
	endgenerate
	and and1(w[0], en, w[N]);
	assign clk = w[0];
endmodule

