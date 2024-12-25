module SignedComp(A,B,Greater,Smaller,Equal);
	input [5:0] A,B;
	output Greater , Smaller , Equal;
	wire G1,E1,S1;
	wire G2,E2,S2;
	wire NG1;
	wire w1,w2;
	oneBitComp U1(A[5],B[5],G1,E1,S1);//to compare between the first two bits if it was one that means it's negative if it's 0 that's mean it's positive	   
	sixbitcomp U2({A[4:0],1'b0}, {B[4:0],1'b0},G2, S2, E2);//comparing the other five bits concatenating with zero
	and #(5)g0(w1,E1,G2);// w1 = E1 & G2
	or #(5)g1(Greater, S1, w1);// Greater = S1 | w1
	and #(5)g2(w2,E1,S2);// W2 = E1 & S2
    or #(5)g3(Smaller, G1, w2);// Smaller = G1 | w2    
    and #(5)g4(Equal, E1, E2);// Equal = E1 & E2
endmodule