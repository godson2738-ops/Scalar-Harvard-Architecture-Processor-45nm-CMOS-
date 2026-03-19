module mux_2_1(y,in0,in1,sel);
input in1,in0,sel;
output y;
assign y = ((~sel)&(in0)) |((sel)& (in1));

endmodule



module left_shift_8_bit(in,out,s);
input [7:0] in;
input [2:0] s;
output [7:0] out;
wire w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
mux_2_1 m0(w0,in[0],1'b0,s[0]);

mux_2_1 m1(w1,in[1],in[0],s[0]);

mux_2_1 m2(w2,in[2],in[1],s[0]);

mux_2_1 m3(w3,in[3],in[2],s[0]);

mux_2_1 m4(w4,in[4],in[3],s[0]);

mux_2_1 m5(w5,in[5],in[4],s[0]);

mux_2_1 m6(w6,in[6],in[5],s[0]);

mux_2_1 m7(w7,in[7],in[6],s[0]);

mux_2_1 m8(w8,w0,1'b0,s[1]);

mux_2_1 m9(w9,w1,1'b0,s[1]);

mux_2_1 m10(w10,w2,w0,s[1]);

mux_2_1 m11(w11,w3,w1,s[1]);

mux_2_1 m12(w12,w4,w2,s[1]);

mux_2_1 m13(w13,w5,w3,s[1]);

mux_2_1 m14(w14,w6,w4,s[1]);

mux_2_1 m15(w15,w7,w5,s[1]);

mux_2_1 m16(out[0],w8,1'b0,s[2]);

mux_2_1 m17(out[1],w9,1'b0,s[2]);

mux_2_1 m18(out[2],w10,1'b0,s[2]);

mux_2_1 m19(out[3],w11,1'b0,s[2]);

mux_2_1 m20(out[4],w12,w8,s[2]);

mux_2_1 m21(out[5],w13,w9,s[2]);

mux_2_1 m22(out[6],w14,w10,s[2]);

mux_2_1 m23(out[7],w15,w11,s[2]);


endmodule
