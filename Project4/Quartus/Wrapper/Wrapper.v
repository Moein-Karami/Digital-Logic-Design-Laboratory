module Wrapper(input clk, rst, start, rdreq, input [15 : 0]v, input [1 : 0]u, output done, full, empty, output [20 : 0]q, output [1 : 0] usedw);
	wire wr_req, sh_en, ld, ui_ld, eng_start, eng_done;
	
	WrapperController controller(clk, rst, start, eng_done, sh_en, ld, ui_ld, wr_req, done, eng_start);
	WrapperDataPath data_path(clk, rst, wr_req, sh_en, ld, ui_ld, eng_start, rdreq, v, u, eng_done, full, empty, q, usedw);
endmodule
	