`timescale 1ns/1ps

module MonitorTB2();
	wire internal_ro, external_ro;
	reg ring_on, rst, clk_50MHz;
	reg [7 : 0]Fro_min;
	reg [7 : 0]PSI_min;
	reg [7 : 0]PSI_max;
	reg [7 : 0]PSI_set;
	wire [3 : 0] multiple_extrenal_ro;
	wire Fail;
	wire PSI;
	reg [1:0]s;

	RingOscillator #(5, 5) internal(ring_on, internal_ro);
	RingOscillator #(5, 600) external1(ring_on, multiple_extrenal_ro[0]);
	RingOscillator #(5, 500) external2(ring_on, multiple_extrenal_ro[1]);
	RingOscillator #(5, 10) external3(ring_on, multiple_extrenal_ro[2]);
	RingOscillator #(5, 5) external4(ring_on, multiple_extrenal_ro[3]);
	Mux mux(s, multiple_extrenal_ro, external_ro);
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
		Fro_min = 20;
		PSI_set = 125;
		#3000;
		rst = 0;
		ring_on = 1;
		#20;
		s = 0;
		#10000;
		s = 1;
		#10000;
		s = 2;
		#10000;
		s = 3;
		#10000;
		$stop;
	end
endmodule

module Mux(input [1 : 0]s, input[3 : 0]in, output out);
	assign out = in[s];
endmodule