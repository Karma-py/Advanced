module DFF(D,Q,CLK);//general D Flip Flop
	parameter n = 6;//default value is 6 bit
	input [n-1:0] D;
	input CLK;
	output reg [n-1:0] Q;
	always @(posedge CLK)
			Q = D;
endmodule