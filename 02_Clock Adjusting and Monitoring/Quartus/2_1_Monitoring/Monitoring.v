module Monitoring(input clk, rst, input [7 : 0]Fro_min, input [7 : 0]PSI_min, input [7 : 0]PSI_max, input [7 : 0]PSI_set
		, input RO_external, output reg Fail, output [7 : 0]SetPeriod);
	assign SetPeriod = (PSI_min < PSI_set) ? PSI_min:
			(PSI_max < PSI_set) ? PSI_set : PSI_max;
	
	reg [8 : 0]cnt;
	reg old_ero;
	reg neg_ero;

	always @(posedge clk, posedge rst)
	begin
		if (rst)
		begin
			cnt = 0;
			old_ero = 0;
		end
		else
		begin
			neg_ero = 0;
			case({old_ero, RO_external})
				{1'b0, 1'b1}: cnt = 0;
				{1'b1, 1'b1}: cnt = cnt + 1;
				{1'b1, 1'b0}: neg_ero = 1;
			endcase
			old_ero = RO_external;
		end
	end
	
	always @(posedge neg_ero, posedge rst)
	begin
		if (rst)
			Fail = 0;
		else if (cnt > Fro_min * 6)
			Fail = 1;
		else
			Fail = 0;
	end
endmodule