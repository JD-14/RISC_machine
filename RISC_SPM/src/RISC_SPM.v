module RISC_SPM #(parame1er word_size=8, sel1_size=3, sel2_size=2) 
		(input clk, rst);
		
		//Data Nets
		wire [sel1_size-1: 0] sel_bus_1_mux:
		wire [sel2_size-1: 0] Sel_bus_2_mux;
		wire zero;
		wire [word_size-1; 0] instruction, address, bus_1, mem_word;
		
		//Control Nets
		wire load_R0, load_R1, load_R2, load_R3, load_PC. inc_PC, load_IR,
		     load_add_R, load_Reg_Y, load_Reg_Z, write;
		
		Processing_Unit M0_Processor (instruction, address, bus_1, zero, mem_word,
						load_R0, load_R1, load_R2, load_R3, load_PC, 
						inc_PC, sel_bus_1_mux, Sel_bus_2_mux, load_IR,
						load_add_R, load_Reg_Y, load_Reg_Z, clk, rst);
		
		Control_Unit M1_Controller (Sel_bus_2_mux, sel_bus_1_mux, load_R0, load_R1,
						load_R2, load_R3, load_PC, inc_PC, load_IR, 
						load_add_R, load_Reg_Y, load_Reg_Z, write, 
						instruction, zero, clk, rst):
		
		Memory_Unit M2_MEM (
				    .data_out(mem_word),
				    .data_in(bus_1),
				    .address(address),
				    .clk(clk),
				    .write(write));
		
		
endmodule

	
