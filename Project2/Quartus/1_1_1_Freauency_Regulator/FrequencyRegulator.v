module FrequencyRegulator(input clk, rst, PSI, input [7 : 0]setPeriod, output [7 : 0]adjustDiv, output reg inc, dec, output reg [7 : 0]duration);
	reg [7 : 0]div;
	reg old_psi;
	reg neg_psi;

	always @(posedge clk, posedge rst)
	begin : decide_when_to_count
		if (rst)
		begin
			duration = 0;
			old_psi = 0;
			neg_psi <= 0;
		end
		else
		begin
			neg_psi <= 0;
			case ({old_psi, PSI})
				{1'b1, 1'b1} : duration = duration + 1;
				{1'b0, 1'b1} : duration = 0;
				{1'b1, 1'b0} : neg_psi <= 1;
			endcase
			old_psi = PSI;
		end
	end

	always @(duration, setPeriod)
	begin : comparison
		inc <= 0;
		dec <= 0;
		if (duration > setPeriod)
			dec <= 1;
		else if (duration < setPeriod)
			inc <= 1;
	end

	always @(posedge clk, posedge rst)
	begin : increment_decrement
		if (rst)
			div = 1;
		else if(neg_psi)
		begin
			if (inc)
				div = div + 1;
			else if (dec)
				div = div - 1;
		end
	end

	assign adjustDiv = ~(div);

endmodule