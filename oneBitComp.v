module oneBitComp(A,B,Greater,Equal,Smaller);
	input A,B;
	output Greater , Smaller,Equal;
	wire Bnot,Anot;// Bnot -> ~B , Anot -> ~A
	not #(2)g0(Anot,A);// Anot = ~A
	not #(2)g1(Bnot ,B);// Bnot = ~B
	and #(5)g2(Greater,A,Bnot);//Greater = A & ~B
	and #(5)g3(Smaller,B,Anot);// Smaller = B & ~A
	nor #(4)g4(Equal,Smaller,Greater);// Equal = ~(Smaller | Greater)
endmodule
