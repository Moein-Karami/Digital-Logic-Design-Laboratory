`timescale 1ns/1ps

module FinalTB();
	wire UxRXIF, BRGout;
	reg ABAUD, UxRX, ring_en, tf_set;
	wire BRGCLK;
	wire clk0, clk1, clk2, clk3;
	reg [1 : 0]k;
	BRGCKT brgckt(.BRGCLK(BRGCLK), .ABAUD(ABAUD), .UxRX(UxRX), .counter_preset(~UxRXIF), .BRGout(BRGout),
			.UxRXIF(UxRXIF));
	RingOscillator ring(ring_en, clk0);
	TFlioFlop t1(1'b1, clk0, tf_set, clk1);
	TFlioFlop t2(1'b1, clk1, tf_set, clk2);
	TFlioFlop t3(1'b1, clk2, tf_set, clk3);
	MUX mux(k, {clk3, clk2, clk1, clk0}, BRGCLK);

	initial begin
		tf_set = 1;
		UxRX = 1;
		ABAUD = 0;
		k = 2'b01;
		ring_en = 0;
		#100;
		ring_en = 1;
		tf_set = 0;
		ABAUD = 1;
		#100;
		UxRX = 0;
		#50;
		UxRX = 1;
		#50;
		UxRX = 0;
		#50;
		UxRX = 1;
		#50;
		UxRX = 0;
		#50;
		UxRX = 1;
		#50;
		UxRX = 0;
		#50;
		UxRX = 1;
		#50;
		UxRX = 0;
		#50;
		UxRX = 1;
		ABAUD = 0;
		#500000;
		$stop;
	end

endmodule

module TFlioFlop(input t, clk, preset, output reg o);
	always @(posedge clk, posedge preset) begin
		if (preset)
			o <= 1;
		else if(t)
			o <= ~o;
	end
endmodule

module MUX(input k, input [3 : 0] in, output out);
	assign out = in[k];
endmodule