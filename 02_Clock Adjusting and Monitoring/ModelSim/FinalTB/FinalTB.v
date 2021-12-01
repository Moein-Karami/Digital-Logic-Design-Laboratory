`timescale 1ns/1ps

module FullTB();
	wire internal_ro, external_ro;
	reg ring_on, rst, clk_50MHz;
	reg [7 : 0]Fro_min;
	reg [7 : 0]PSI_min;
	reg [7 : 0]PSI_max;
	reg [7 : 0]PSI_set;
	wire main_clk;
	reg power_mode;

	RingOscillator #(5, 20) internal(ring_on, internal_ro);
	RingOscillator #(5, 4.166) external(ring_on, external_ro);
	always #10 assign clk_50MHz = ~clk_50MHz;

	FullDesign full(.Main_Clock(main_clk), .clk_50MHz(clk_50MHz), .rst(rst), .external_ro(external_ro), .Fro_min(Fro_min),
			.PSI_max(PSI_max), .PSI_min(PSI_min), .PSI_set(PSI_set), .Power_Mode(power_mode), .internal_ro(internal_ro));

	initial
	begin
		clk_50MHz = 0;
		rst = 1;
		ring_on = 0;
		Fro_min = 20;
		PSI_min = 160;
		PSI_max = 90;
		PSI_set = 125;
		power_mode = 0;
		#1000;
		rst = 0;
		ring_on = 1;
		#10000;
		power_mode = 1;
		#10000;
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