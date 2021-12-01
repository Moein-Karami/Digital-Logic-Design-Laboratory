`timescale 1ns/1ps

module MonitorTB();
	wire internal_ro, external_ro;
	reg ring_on, rst, clk_50MHz;
	reg [7 : 0]Fro_min;
	reg [7 : 0]PSI_min;
	reg [7 : 0]PSI_max;
	reg [7 : 0]PSI_set;
	wire Fail;
	wire PSI;

	RingOscillator #(5, 5) internal(ring_on, internal_ro);
	RingOscillator #(5, 4.166) external(ring_on, external_ro);
	always #10 assign clk_50MHz = ~clk_50MHz;

	Monitor_And_Regulator MAR(.Fail(Fail), .clk_50MHz(clk_50MHz), .rst(rst), .RO_external(external_ro), .Fro_min(Fro_min),
			.PSI_max(PSI_max), .PSI_min(PSI_min), .PSI_set(PSI_set), .PSI(PSI), .RO_internal(internal_ro));

	initial
	begin
		clk_50MHz = 0;
		rst = 1;
		ring_on = 0;
		PSI_min = 160;
		PSI_max = 90;
		#100;
		rst = 0;
		ring_on = 1;
		#20;
		PSI_set = 70;
		#200005;
		PSI_set = 125;
		#200005;
		PSI_set = 180;
		#200005;
		$stop;
	end
endmodule

module RingOscillator #(parameter N, parameter D)(input on, output psi);
	wire [N : 0]w;
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1)
			assign #(D) w[i + 1] = ~w[i];
	endgenerate
	assign w[0] = w[N] & on;
	assign psi = w[N];
endmodule

module Mux(input s, a, b, output out);
	begin
		assign out = s ? b : a;
	end
endmodule