module AmplitudeSelector(input [7 : 0]in_wave, input [1 : 0]SW, output reg[7 : 0] out_wave);
	always @(SW, in_wave)
	begin
		case(SW)
		2'b00: out_wave = in_wave;
		2'b01: out_wave = {1'b0, in_wave[7 : 1]};
		2'b10: out_wave = {2'b00, in_wave[7 : 2]};
		2'b11: out_wave = {3'b000, in_wave[7 : 3]};
		endcase
	end
endmodule	