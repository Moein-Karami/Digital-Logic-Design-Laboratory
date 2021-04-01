module Controller(input ABAUD, UxRX, BRGCLK, output UxRXIF, ld_en, cnt_rst, cnt_en);
	reg [3 : 0] ps;
	reg [3 : 0] ns;

	always @(ps, ABAUD, UxRX)
	begin
		ns = 0;
		case (ps)
			4'b0 : ns = ABAUD ? 4'b0001 : 4'b0;
			4'b0001 : ns = UxRX ? 4'b0001 : 4'b0010;
			4'b0010 : ns = UxRX ? 4'b0011 : 4'b0010;
			4'b0011 : ns = UxRX ? 4'b0011 : 4'b0100;
			4'b0100 : ns = UxRX ? 4'b0101 : 4'b0100;
			4'b0101 : ns = UxRX ? 4'b0101 : 4'b0111;
			4'b0110 : ns = UxRX ? 4'b0111 : 4'b0110;
			4'b0111 : ns = UxRX ? 4'b0111 : 4'b1000;
			4'b1000 : ns = UxRX ? 4'b1001 : 4'b1000;
			4'b1001 : ns = UxRX ? 4'b1001 : 4'b1010;
			4'b1010 : ns = UxRX ? 4'b1011 : 4'b1010;
			4'b1011 : ns = 4'b0;
			default : ns = 4'b0;
		endcase
	end

	assign cnt_rst = (ps == 4'b0001);
	assign UxRXIF = (ps == 4'b1011);
	assign ld_en = (ps == 4'b1011);
	assign cnt_en = (ps == 4'b0011) | (ps == 4'b0100) | (ps == 4'b0101) | (ps == 4'b0110) | (ps == 4'b0111) |
			(ps == 4'b1000) | (ps == 4'b1001) | (ps == 4'b1010);

	always @(posedge BRGCLK) begin
		ps <= ns;
	end
endmodule