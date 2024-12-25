module comp(A,B,S,CLK,Greater,Equal,Smaller);// the comp circuit 
    input [5:0]A;
    input [5:0]B;
    input S,CLK;
    output Greater,Equal,Smaller;
    wire G1,E1,S1;
    wire G0,E0,S0;
    wire G3,E3,S3;
	wire [5:0] a,b;		
	
	DFF #(12)U0({A,B},{a,b},CLK);// we insert the input inside a DFF to fix the glitchs that cused by the delays of the gates 
	
    SignedComp U1(a,b,G1,S1,E1);// calling the Singed Comp module 
    sixbitcomp U2(a, b,G0, S0, E0);// calling the Unsinged Comp module 
    
    mux2to1 U3(G0,G1,S,G3);// sending the values to the mux to chose between the signed and the unsigned comp
    mux2to1 U4(S0,S1,S,S3);// sending the values to the mux to chose between the signed and the unsigned comp
    mux2to1 U5(E0,E1,S,E3);// sending the values to the mux to chose between the signed and the unsigned comp
    
    DFF #(3)U6({G3,S3,E3},{Greater,Smaller,Equal},CLK);// send the result to a DFF to fix the glitchs that cused by the delays of the gates
endmodule											   



module behavioralCOMP(A,B,S,CLK,Greater,Equal,Smaller);// behavioral comp
	input [5:0]A,B;
	input S ,CLK;
	wire signed [5:0] SignedA = A;// signed variable of A
	wire signed [5:0] SignedB = B;// signed variable of B
	output reg Greater,Smaller,Equal;
	always @(A,B,S)begin
		if(S == 1'b0)begin
			if(A > B)begin // if it was unsigned and A greater than B then set the value of the Greater output to one
				Greater = 1'b1;
				Smaller = 1'b0;
				Equal = 1'b0;
			end
			else if (A < B)begin// if it was unsigned and A Less than B then set the value of the Smaller output to one
				Greater = 1'b0;
				Smaller = 1'b1;
				Equal = 1'b0;
			end 
			else if (A == B)begin// if it was unsigned and A Equal B then set the value of the Equal output to one
				Greater = 1'b0;
				Smaller = 1'b0;
				Equal = 1'b1;
			end
		end
		else begin
			if(SignedA > SignedB)begin// if it was signed and A greater than B then set the value of the Greater output to one
				Greater = 1'b1;
				Smaller = 1'b0;
				Equal = 1'b0;
			end	
			else if (SignedA < SignedB)begin// if it was signed and A Less than B then set the value of the Smaller output to one
				Greater = 1'b0;
				Smaller = 1'b1;
				Equal = 1'b0;
			end
			else if (SignedA == SignedB)begin// if it was signed and A Equal B then set the value of the Equal output to one
				Greater = 1'b0;
				Smaller = 1'b0;
				Equal = 1'b1;
			end
		end
	end
endmodule	 



module BehavioralCOMP(A,B,S,CLK,Greater,Equal,Smaller);//Behavioral comp 
	input [5:0] A,B;
    input S,CLK;
    output Greater,Equal,Smaller;
	wire G0,E0,S0;
	wire [5:0] a,b;
	DFF #(12)U0({A,B},{a,b},CLK);// we insert the input inside a DFF to make a balance between the Behavioral comp and the structural comp
	behavioralCOMP U1(a,b,S,CLK,G0,E0,S0);
  	DFF #(3)U2({G0,S0,E0},{Greater,Smaller,Equal},CLK);// send the result to a DFF to make a balance between the Behavioral comp and the structural comp
endmodule	



module Analyzer;// Analyzer to compare between the results of the structural comp and the results of the Behavioral comp
	reg [5:0] A,B;
	reg CLK,S;
	wire Greater , Smaller , Equal;
	wire B_Greater , B_Smaller , B_Equal;
	int Error_Detector = 0;	
	
	comp C(A,B,S,CLK,Greater,Equal,Smaller);// calling the structural comp
	BehavioralCOMP BC(A,B,S,CLK,B_Greater,B_Equal,B_Smaller);// calling the Behavioral comp
	
	initial begin // giving initital values to the inputs
		A = 0;
		B = 0;
		CLK = 0;
		S = 0;
		repeat(4095) begin // change the CLK every 80ps
			#80CLK = ~CLK;	
		end
		if(Error_Detector == 0)begin // if there was no errors print it's correct 
			$display("\n##############################\n the results are correct\n##############################");	
		end
		else if (Error_Detector == 1) begin// if there was an error print the result are not correct
			$display("\n##############################\n the results are not correct\n##############################");
		end
		#1 $finish;	// finish after 1ps delay
	end
	always @(posedge CLK)begin
		#80
		if({Greater,Smaller,Equal} != {B_Greater,B_Smaller,B_Equal})begin // if the result of the Behavioral comp was not Equal the resutl of the structural comp
			Error_Detector = 1;// set the value of the Error_Detector to 1 meaning there is an error here  
			 $display("There is an error here:");// print there is an error 
			 $display("Time: %d,selector: %b, A: %d, B: %d, GT: %b, EQ: %b, LT: %b", $time , S , A, B , B_Greater, B_Equal,B_Smaller);// print where is the error exactly 
       		 $display("Time: %d,selector: %b, A: %d, B: %d, GT: %b, EQ: %b, LT: %b\n####################################", $time , S , A , B , Greater ,Equal , Smaller);// print where is the error exactly 
		end
		else begin
			$display("Time: %d,selector: %b, A: %d, B: %d, GT: %b, EQ: %b, LT: %b", $time , S , A, B , B_Greater, B_Equal,B_Smaller);//print the correct results
        	$display("Time: %d,selector: %b, A: %d, B: %d, GT: %b, EQ: %b, LT: %b\n####################################", $time , S , A , B , Greater ,Equal , Smaller);//print the correct results 
		end
	end	
	
	  always @(negedge CLK) begin
        #1 {A, B, S} = {A, B, S} + 1; // change the vaule of the inputs at every negative edge after 1ps delay 
	  end	
endmodule