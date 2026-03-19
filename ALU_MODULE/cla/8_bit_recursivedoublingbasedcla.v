`include "four_1_mux.v"
module eight_bit_recursivedoublingbasedcla(A,B,out);
input [7:0]A,B;
output reg[8:0]out;
wire [17:0]kgp;
wire [15:0]kgp1,kgp2,kgp3;
wire [7:0]kgp4;
 
assign kgp[1:0] = 2'b00;
assign kgp[3:2] = {B[0],A[0]};
assign kgp[5:4] = {B[1],A[1]};
assign kgp[7:6] = {B[2],A[2]};
assign kgp[9:8] = {B[3],A[3]};
assign kgp[11:10] = {B[4],A[4]};
assign kgp[13:12] = {B[5],A[5]};
assign kgp[15:14] = {B[6],A[6]};
assign kgp[17:16] = {B[7],A[7]};
//stage-1
assign kgp1[1:0] = kgp[1:0];  
four_1_mux m1(kgp[1:0],kgp1[3:2],kgp[3:2]);
four_1_mux m2(kgp[3:2],kgp1[5:4],kgp[5:4]);
four_1_mux m3(kgp[5:4],kgp1[7:6],kgp[7:6]);
four_1_mux m4(kgp[7:6],kgp1[9:8],kgp[9:8]);
four_1_mux m5(kgp[9:8],kgp1[11:10],kgp[11:10]);
four_1_mux m6(kgp[11:10],kgp1[13:12],kgp[13:12]);
four_1_mux m7(kgp[13:12],kgp1[15:14],kgp[15:14]);
//stage-2
assign kgp2[1:0] = kgp1[1:0];
assign kgp2[3:2] = kgp1[3:2];
four_1_mux u1(kgp1[1:0],kgp2[5:4],kgp1[5:4]);
four_1_mux u2(kgp1[3:2],kgp2[7:6],kgp1[7:6]);
four_1_mux u3(kgp1[5:4],kgp2[9:8],kgp1[9:8]);
four_1_mux u4(kgp1[7:6],kgp2[11:10],kgp1[11:10]);
four_1_mux u5(kgp1[9:8],kgp2[13:12],kgp1[13:12]);
four_1_mux u6(kgp1[11:10],kgp2[15:14],kgp1[15:14]);
//stage-3
assign kgp3[1:0] = kgp2[1:0];
assign kgp3[3:2] = kgp2[3:2];
assign kgp3[5:4] = kgp2[5:4];
assign kgp3[7:6] = kgp2[7:6];
four_1_mux w1(kgp2[1:0],kgp3[9:8],kgp2[9:8]);
four_1_mux w2(kgp2[3:2],kgp3[11:10],kgp2[11:10]);
four_1_mux w3(kgp2[5:4],kgp3[13:12],kgp2[13:12]);
four_1_mux w4(kgp2[7:6],kgp3[15:14],kgp2[15:14]);
//stage-4
assign kgp4[0] = kgp3[0];
assign kgp4[1] = kgp3[2];
assign kgp4[2] = kgp3[4];
assign kgp4[3] = kgp3[6];
assign kgp4[4] = kgp3[8];
assign kgp4[5] = kgp3[10];
assign kgp4[6] = kgp3[12];
assign kgp4[7] = kgp3[14];
//xor 

//carry
always @(*) begin
 out[0] = (A[0])^(B[0])^(kgp4[0]);
 out[1] = (A[1])^(B[1])^(kgp4[1]);
 out[2] = (A[2])^(B[2])^(kgp4[2]);
 out[3] = (A[3])^(B[3])^(kgp4[3]);
 out[4] = (A[4])^(B[4])^(kgp4[4]);
 out[5] = (A[5])^(B[5])^(kgp4[5]);
 out[6] = (A[6])^(B[6])^(kgp4[6]);
 out[7] = (A[7])^(B[7])^(kgp4[7]);
   
    if (kgp[17:16] == 2'b00) begin
        out[8] = 0;
    end
    if (kgp[17:16] == 2'b11) begin
         out[8] = 1;
    end
    if (kgp[17:16] == 2'b01) begin
         out[8] = kgp4[7];
    end
    if (kgp[17:16] == 2'b10) begin
         out[8] = kgp4[7];
        
    end
end





endmodule
