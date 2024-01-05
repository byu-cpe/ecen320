`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_arithmetic.sv
//
//  Author: Brent Nelson
//
//  Description: Provides a basic testbench for the arithmetic lab.  Is modified
//               version of tb_arithmetic v.
//
//  Version 3.1
//
//  Change Log:
//    v3.1: Replace sign extension with overflow detection. Add only 8 bits.
//    v2.1: Removed btnl and btnr to streamline lab for on-line semesters.
//          Converted to SystemVerilog
//    v1.1: Modified the arithmetic_top to use "port mapping by name" rather than
//          port mapping by order.
//
//////////////////////////////////////////////////////////////////////////////////

module tb_arithmetic();

	logic [15:0] sw;
	logic [8:0] led;

	integer i,errors;
	logic [31:0] rnd;
	logic signed [7:0] A,B;
	logic [8:0] result;

	// Instance the unit under test
	arithmetic_top dut(.sw(sw), .led(led));

	initial begin

		// print time in ns (-9) with the " ns" string
		$timeformat(-9, 0, " ns", 0);
		errors = 0;
		#20
		$display("*** Starting simulation at time %t ***", $time);
		#20

		// Test 256 random cases
		for(i=1; i < 256; i=i+1) begin
			rnd = $random;
			sw[15:0] = rnd[15:0];
			A = sw[15:8];
			B = sw[7:0];
			result[7:0] = A+B; // 8-bit add
			result[8] = (A[7] & B[7] & ~result[7]) | (~A[7] & ~B[7] & result[7]); // overflow
 			#20

			if (result != led) begin
				$display("Error: A=%b,B=%b and result=%b but expecting %b at time %t", A,B,led,result, $time);
				errors = errors + 1;
			end
		end

		#20
		$display("*** Simulation done with %0d errors at time %t ***", errors, $time);
		$finish;

	end // initial

endmodule
