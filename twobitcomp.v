module twobitcomp(A, B, Greater, Smaller, Equal);
    input [1:0] A;
    input [1:0] B;
    output Greater, Smaller, Equal;
    wire nA1, nA0, nB1, nB0;
    wire G1, G0, eq1, eq0;
    wire S1, S0;

    not #(2)g0(nA1, A[1]);// nA1 = ~A[1]
    not #(2)g1(nA0, A[0]);// nA0 = ~A[0] 
    not #(2)g2(nB1, B[1]);// nB1 = ~B[1]
    not #(2)g3(nB0, B[0]);// nB0 = ~B[0]

    and #(5)g4(S1, nA1, B[1]);// S1 = ~A[1] & B[1]
    and #(5)g5(S0, eq1, nA0, B[0]);// S0 = eq1 & ~A[0] & B[0]
    or #(5)g6(Smaller, S1, S0);// Smaller = S1 | S0

    and #(5)g7(G1, A[1], nB1);// G1 = A[1] & ~B[1]
    and #(5)g8(G0, eq1, A[0], nB0);// G0 = eq1 & A[0] & ~B[0]
    or #(5)g9(Greater, G1, G0);// Greater = G1 | G0

    xnor #(7)g10(eq1, A[1], B[1]);// eq1 = A[1] ^ B[1]
    xnor #(7)g11(eq0, A[0], B[0]);// eq0 = A[0]	^ B[0]
    and #(5)g12(Equal, eq1, eq0);// Equal = eq1	& eq0
	
endmodule