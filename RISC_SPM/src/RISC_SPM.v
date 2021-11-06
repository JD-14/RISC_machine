module RISC_SPM #(parameter word_size=8, sel1_size=3, sel2_size=2) 
		(input clk, rst);
		
		//Data Nets
		wire [sel1_size-1: 0] sel_bus_1_mux;
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
						instruction, zero, clk, rst);
		
		Memory_Unit M2_MEM (
				    .data_out(mem_word),
				    .data_in(bus_1),
				    .address(address),
				    .clk(clk),
				    .write(write));
endmodule



module Processing_Unit #(parameter word_size=8, op_size=4, sel1_size=3, sel2_size=2)
	(output [word_size-1: 0] instruction, address, bus_1,
	 output zflag,
	 input [word_size-1: 0] mem_word,
	 input load_R0, load_R1, load_R2, load_R3, load_PC, inc_PC,
	 input [sel1_size-1: 0] sel_bus_1_mux,
	 input (sel1_size-1: 0] Sel_bus_2_mux,
	 input load_IR, load_add_R, load_Reg_Y, load_Reg_Z, 
	 input clk, rst);
	
	wire [word_size-1: 0] bus_2;
	wire [word_size-1: 0] R0_out, R1_out, R2_out, R3_out;
	wire [word_size-1: 0] PC_count, Y_value, alu_out;
	wire alu_zero_flag;
	wire [op_size-1: 0] opcode = instruction [word_size-1: word_size-op_size];
	
	Register_Unit        R0    (R0_out, bus_2, load_R0, clk, rst);
	Register_Unit        R1    (R1_out, bus_2, load_R1, clk, rst);
	Register_Unit        R2    (R2_out, bus_2, load_R2, clk, rst);
	Register_Unit        R3    (R3_out, bus_2, load_R3, clk, rst);
	Register_Unit        Reg_Y (Y_value, bus_2, load_Reg_Y, clk, rst);
	D_flop               Reg_Z (zflag, alu_zero_flag, load_Reg_Z, clk, rst);
	Address_Register     Add_R (address, bus_2, load_add_R, clk, rst);
	Instruction_Register IR    (instruction, bus_2, load_PC, inc_PC, clk rst);
	Program_Counter      PC    (PC_count, bus_2, load_pc, inc_pc, clk, rst);
	Multiplexer_5ch      Mux_1 (bus_1, R0_out, R1_out, R2_out, R3_out, PC_count);
	Multiplexer_3ch      Mux_2 (bus_2, alu_out, bus_1, mem_word, sel_bus_2_muX);
	Alu_RISC             ALU   (alu_out, alu_zero_flag, Y_value, bus_1, opcode);
endmodule



module Register_Unit #(parameter word_size = 8)
	(output reg (word_size-1: 0] data_out,
	 input [word_size-1: 0] data_in,
	 input load, clk, rst);
	
	always @ (posedge clk, negedge rst)
	   if (rst == 1'b0) data_out <= 0;
	   else if (load) data_out <= data_in;
endmodule



module D_flop (output reg data_out,
		input data_in, load, clk, rst);
	
	always @ (posedge clk, negedge rst)
	   if (rst == 1'b0) data_out <= 0;
	   else if (load == 1'b1) data_out <= data_in;
endmodule



module Address_Register #(parameter word_size=8)
	(output reg [word_size-1: 0] data_out,
	 input [word_size-1: 0] data_in,
	 input load, clk, rst);
	
	always @ (posedge clk, negedge rst)
	   if (rst == 1'b0) data_out <= 0;
	   else if (load == 1'b1) data_out <= data_in;
endmodule 



module Instruction_Reglsler #(parameter word_size=8)
	(output reg [word_size-1: 0] data_out,
	 input [word_size-1: 0] data_in,
	 input load, clk, rst);
	
	always @ (posedge clk, negedge rst)
	   if (rst == 1'b0) data_out <= 0;
	   else if (load == 'b1) data_out <= data_ in;
endmodule



module Program_Counter #(parameter word_size=6)
	(output reg [word_size-1: 0] count,
	 input [word_size-1: 0] data_in,
	 input load_PC, inc_PC,
	 input clk, rst);
	
	always @ (posedge clk, negedge rst)
	   if (rst == 1'b0) count <= 0;
	   else if (load_PC == 1'b0) count <= data_in;
	   else if (inc_PC == 1'b1) count <= count +1;
endmodule 



module Multiplexer_5ch #(parameter word_size=8)
	(output [word_size-1: 0] mux_out,
	 input [word_size-1: 0] data_a, data_b, data_c, data_d, data_e,
	 input [2: 0] sel);
	 
	 assign mux_out = (sel == 0) ? data_a : (sel == 1)
	 			      ? data_b : (sel == 2)
	 			      ? data_c : (sel == 3)
	 			      ? data_d : (sel == 4)
	 			      ? data_e : 'bx; 
endmodule



module Multiplexer_3ch #(parameter word_size=8)
	(output [word_size-1: 0] mux_out,
	 input [word_size-1: 0] data_a, data_b, data_c,
	 input [1: 0] sel);
	
	assign mux_out = (sel == 0) ? data_a : (sel == 1)
				     ? data_b : (sel == 2)
	 			     ? data_c : 'bx;
endmodule

module A1u_RISC #(parameter word_size=8, op_size=4,
	//Opcodes
	NOP = 4'b0000,
	ADD = 4'b0001,
	SUB = 4'b0010,
	AND = 4'b0011,
	NOT = 4'b0100,
	RD  = 4'b0101 ,
	WR  = 4'b0110,
	BR  = 4'b0111 ,
	BRZ = 4'b1000)
	//Ports
	(output reg [word_size-1: 0] alu_out,
	 output alu_zero_flag,
	 input [word_size-1: 0] data_1, data_2,
	 input [op_size-1: 0] sel);
	
	assign alu_zero_flag = ~|alu_out;	//unsure if NOR
	always @(sel, dala_1, data_2)
	   case (sel)
	   	 NOP: alu_out = 0;
	   	 ADD: alu_out = data_1 + data_2; // Reg_Y + Bus_1
	   	 SUB: alu_out = data_2 - data_1;
	   	 AND: alu_oul = data_1 & data_2;
	   	 NOT: alu_out = ~data_2;
	   	 default: alu_out = 0;
	   endcase
endmodule



module Control_Unit #(parameter word_size=8, op_size=4, state_size=4,
		       src_size=2, dest_size=2, sel1_size=3, sel2_size=2)
	(output [sel2_size-1: 0] sel_bus_2_mux,
	 output [sel1_size-1: 0] sel_bus_1_mux,
	 output reg load_RO, load_R1, load_R2, load_R3,load_PC, inc_PC,
	            load_IR, load_add_R, load_Reg_Y, load_Reg_Z. write,
	 input [word_size-1: 0] instruction,
	 input zero, clk, rst);
	
	//State Codes
	  parameter s_idle=0, s_fet1=1, s_fet2=2, s_dec=3, s_ex1=4, s_rd1=5,
	            s_rd2=6, s_wr1=7, s_wr2=8, s_br1=9, s_br2=10, s_halt=11;
	
	//Opcodes
	  parameter NOP=0, ADD=1, SUB=2, AND=3, NOT=4, RD=5, WR=6, BR=7, BRZ=8;
	
	//Source and Destination Codes
	  parameter R0=0, R1=1, R2=2, R3=3;
	  
	  reg [state_size-1: 0] state, next_state;
	  reg sel_ALU, sel_bus_1, sel_Mem;
	  reg sel_R0, sel_R1, sel_R2, sel_R3, sel_PC;
	  reg err_flag;
	  wire [op_size-1: 0] opcode = instruction [word_size-1: word_size - op_size];
	  wire [src_size-1: 0] src = instruction [src_size + dest_size -1: dest_size];
	  wire [dest_size-1: 0] dest = instruction [dest_size-1: 0];
	  
	//Mux selectors
	  assign sel_bus_1_mux[sel1_size-1: 0] = sel_R0 ? 0:
	  					   sel_R1 ? 1:
	  					   sel_R2 ? 2:
	  					   sel_R3 ? 3:
	  					   Sel_PC ? 4: 3'bx; // 3-bits, sized number
	  
	  always @(posedge clk, negedge rst) begin: state_transitions
	     if (rst == 0) state <= s_idle; 
	     else state <= next_state; 
	     end 
	 










	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
