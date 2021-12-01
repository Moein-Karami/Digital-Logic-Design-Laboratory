module FrequencyMultiplier(input InFreq, ref_f, rst, adjust, input [3 : 0]n, output outFreq, valid);
	wire en, ld, init;

	Controller controller(InFreq, ref_f, adjust, rst, valid, init, en, ld);
	DataPath data_path(InFreq, ref_f, rst, en, init, ld, n, outFreq);

	
endmodule