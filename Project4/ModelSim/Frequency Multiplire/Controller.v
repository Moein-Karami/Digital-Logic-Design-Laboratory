module Controller(input InFreq, ref_f, adjust, rst, output valid, init, en, ld);
	reg [2 : 0]ps;
	reg [2 : 0]ns;

	always @(InFreq, adjust)
	begin
		case(ps)
			3'b000: ns = adjust ? 3'b001 : 3'b000;
			3'b001: ns = adjust ? 3'b001 : 3'b010;
			3'b010: ns = InFreq ? 3'b010 : 3'b011;
			3'b011: ns = InFreq ? 3'b011 : 3'b100;
			3'b100: ns = 3'b000;
			default: ns = 3'b00;
		endcase
	end

	assign valid = (ps == 3'b000);
	assign init = (ps == 3'b001);
	assign en = (ps == 3'b011);
	assign ld = (ps == 3'b100);

	always @(posedge rst, posedge ref_f)
	begin
		if (rst)
			ps = 0;
		else
			ps = ns;
	end
endmodule