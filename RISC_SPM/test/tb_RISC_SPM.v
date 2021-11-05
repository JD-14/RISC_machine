`timescale 1ns/1ps
module tb_RISC_SPM;
        //reg reset, clk;
        //reg ;
        //wire ;

        //RISC_SPM module1();
        initial begin
               $dumpfile("tb_RISC_SPM.vcd");
               $dumpvars(0, tb_RISC_SPM);
               #100 $finish;
        end

endmodule
	
