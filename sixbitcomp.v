module sixbitcomp(A, B,Greater, Smaller, Equal);
    input [5:0] A;        
    input [5:0] B;
    output Greater;      
    output Smaller;        
    output Equal;         

    wire G1, G2, G3;      
    wire S1, S2, S3;       
    wire Eq1, Eq2, Eq3;
	wire GRE1 ,GRE2;
	wire SM1, SM2;
	wire GF,SF,EqF;
	
    twobitcomp U1 (A[5:4], B[5:4], G1, S1, Eq1);//CHECKIN IF THE FIRST TWO BITS GREATER OR SMALLER OR EQUAL 
    twobitcomp U2 (A[3:2], B[3:2], G2, S2, Eq2);//CHECKIN IF THE SECOND TWO BITS GREATER OR SMALLER OR EQUAL 
    twobitcomp U3 (A[1:0], B[1:0], G3, S3, Eq3);//CHECKIN IF THE THIRD TWO BITS GREATER OR SMALLER OR EQUAL
	
	and #(5)g0(GRE1,Eq1,G2);//A[5:4] == B[5:4] && A[3:2]>B[3:2]
	and	#(5)g1(GRE2,Eq1,Eq2,G3);//A[5:4] == B[5:4] && A[3:2]==B[3:2] && A[1:0]>B[1:0]
	
	and #(5)g2(SM1,Eq1,S2);//A[5:4] == B[5:4] && A[3:2]<B[3:2]
	and #(5)g3(SM2,Eq1,Eq2,S3);//A[5:4] == B[5:4] && A[3:2]==B[3:2] && A[1:0]<B[1:0]
	
    or #(5)g4(Greater, G1, GRE1, GRE2);//A[5:4]>B[5:4] OR (A[5:4] == B[5:4] && A[3:2]>B[3:2]) OR (A[5:4] == B[5:4] && A[3:2]==B[3:2] && A[1:0]>B[1:0])  
    or #(5)g5(Smaller, S1, SM1, SM2);//A[5:4]<B[5:4] OR (A[5:4] == B[5:4] && A[3:2]<B[3:2]) OR (A[5:4] == B[5:4] && A[3:2]==B[3:2] && A[1:0]<B[1:0])         
    and #(5)g6(Equal, Eq1, Eq2, Eq3);//(A[5:4]==B[5:4] && A[3:2]==B[3:2] && A[1:0]==B[1:0]) 
endmodule