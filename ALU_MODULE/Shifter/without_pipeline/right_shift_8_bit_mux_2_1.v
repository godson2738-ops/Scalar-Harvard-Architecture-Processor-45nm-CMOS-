module mux(y,in1,in0,sel);
input sel,in1,in0;
output y;
assign y = ((~sel) & in0) | ((sel) & in1);
endmodule

module right_shift_8_bit(in,out,s);
input [7:0]in;
output [7:0]out;
input [2:0]s;

wire w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;

mux m0(w0,in[1],in[0],s[0]);
mux m1(w1,in[2],in[1],s[0]);
mux m2(w2,in[3],in[2],s[0]);
mux m3(w3,in[4],in[3],s[0]);
mux m4(w4,in[5],in[4],s[0]);
mux m5(w5,in[6],in[5],s[0]);
mux m6(w6,in[7],in[6],s[0]);
mux m7(w7,1'b0,in[7],s[0]);


mux m8(w8,w2,w0,s[1]);
mux m9(w9,w3,w1,s[1]);
mux m10(w10,w4,w2,s[1]);
mux m11(w11,w5,w3,s[1]);
mux m12(w12,w6,w4,s[1]);
mux m13(w13,w7,w5,s[1]);
mux m14(w14,1'b0,w6,s[1]);
mux m15(w15,1'b0,w7,s[1]);


mux m16(out[0],w12,w8,s[2]);
mux m17(out[1],w13,w9,s[2]);
mux m18(out[2],w14,w10,s[2]);
mux m19(out[3],w15,w11,s[2]);
mux m20(out[4],1'b0,w12,s[2]);
mux m21(out[5],1'b0,w13,s[2]);
mux m22(out[6],1'b0,w14,s[2]);
mux m23(out[7],1'b0,w15,s[2]);

endmodule
