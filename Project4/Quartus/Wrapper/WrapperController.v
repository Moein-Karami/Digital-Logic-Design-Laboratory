module WrapperController(input clk, rst, start, eng_done, output sh_en, ld, ui_ld, wr_req, done, eng_start);
	reg [3 : 0]ps;
	reg [3 : 0]ns;
	always @(start, eng_done)
	begin
		case(ps)
			4'b0000: ns = start ? 4'b0001 : 4'b0000;
			4'b0001: ns = start ? 4'b0001 : 4'b0010;
			4'b0010: ns = 4'b0011;
			4'b0011: ns = eng_done ? 4'b0100 : 4'b0011;
			4'b0100: ns = 4'b0101;
			4'b0101: ns = 4'b0110;
			4'b0110: ns = eng_done ? 4'b0111 : 4'b0110;
			4'b0111: ns = 4'b1000;
			4'b1000: ns = 4'b1001;
			4'b1001: ns = eng_done ? 4'b1010 : 4'b1001;
			4'b1010: ns = 4'b1011;
			4'b1011: ns = 4'b1100;
			4'b1100: ns = eng_done ? 4'b1101 : 4'b1100;
			4'b1101: ns = 4'b0000;
			default : ns = 4'b0000;
		endcase
	end
	
	assign ld = (ps == 4'b0001);
	assign ui_ld = (ps == 4'b0001);
	assign sh_en = (ps == 4'b0100) | (ps == 4'b0111) | (ps == 4'b1010) | (ps == 4'b1101);
	assign wr_req = (ps == 4'b0100) | (ps == 4'b0111) | (ps == 4'b1010) | (ps == 4'b1101);
	assign done = (ps == 4'b0000);
	assign eng_start = (ps == 4'b0010) | (ps == 4'b1011) | (ps == 4'b1001) | (ps == 4'b100);
	
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			ps = 0;
		else
			ps = ns;
	end
endmodule 