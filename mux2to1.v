module mux2to1(x0,x1,S,F);
	input x0,x1,S;// s -> selector
	output F;
	wire nS,w1,w2;// ns -> not s
	not #(2)g0(nS,S);// ns = ~s
	and #(5)g1(w1,nS,x0);// w1 = ~s & x0
	and #(5)g2(w2,S,x1);// w2 = s & x1 
	or #(5)g3(F,w1,w2);// F	= w1 | w2
endmodule
			