`include "8_bit_recursivedoublingbasedcla.v"


module carry_save_adder_row(
    input [15:0] x,
    input [15:0] y,
    input [15:0] z,
    output [15:0] s,
    output [15:0] c
);
    assign s = x ^ y ^ z;
    assign c = (x & y) | (y & z) | (x & z);
endmodule

module wallace_tree_multiplier(A, B, result);
    input [7:0] A, B;
    output [15:0] result;

    
    wire [7:0] P0, P1, P2, P3, P4, P5, P6, P7;

    assign P0 = A & {8{B[0]}};
    assign P1 = A & {8{B[1]}};
    assign P2 = A & {8{B[2]}};
    assign P3 = A & {8{B[3]}};
    assign P4 = A & {8{B[4]}};
    assign P5 = A & {8{B[5]}};
    assign P6 = A & {8{B[6]}};
    assign P7 = A & {8{B[7]}};

  
    wire [15:0] w0, w1, w2, w3, w4, w5, w6, w7;

    assign w0 = {8'b0, P0};
    assign w1 = {7'b0, P1, 1'b0};
    assign w2 = {6'b0, P2, 2'b0};
    assign w3 = {5'b0, P3, 3'b0};
    assign w4 = {4'b0, P4, 4'b0};
    assign w5 = {3'b0, P5, 5'b0};
    assign w6 = {2'b0, P6, 6'b0};
    assign w7 = {1'b0, P7, 7'b0};

   
    wire [15:0] lev1_s1, lev1_c1_raw, lev1_c1;
    wire [15:0] lev1_s2, lev1_c2_raw, lev1_c2;

    carry_save_adder_row csa_lvl1_1 (
        .x(w0), .y(w1), .z(w2), 
        .s(lev1_s1), .c(lev1_c1_raw)
    );
    assign lev1_c1 = lev1_c1_raw << 1; // Left shift carry

    carry_save_adder_row csa_lvl1_2 (
        .x(w3), .y(w4), .z(w5), 
        .s(lev1_s2), .c(lev1_c2_raw)
    );
    assign lev1_c2 = lev1_c2_raw << 1; // Left shift carry

    wire [15:0] lev2_s3, lev2_c3_raw, lev2_c3;
    wire [15:0] lev2_s4, lev2_c4_raw, lev2_c4;

    carry_save_adder_row csa_lvl2_1 (
        .x(lev1_s1), .y(lev1_c1), .z(lev1_s2), 
        .s(lev2_s3), .c(lev2_c3_raw)
    );
    assign lev2_c3 = lev2_c3_raw << 1;

    carry_save_adder_row csa_lvl2_2 (
        .x(lev1_c2), .y(w6), .z(w7), 
        .s(lev2_s4), .c(lev2_c4_raw)
    );
    assign lev2_c4 = lev2_c4_raw << 1;

    wire [15:0] lev3_s5, lev3_c5_raw, lev3_c5;

    carry_save_adder_row csa_lvl3_1 (
        .x(lev2_s3), .y(lev2_c3), .z(lev2_s4), 
        .s(lev3_s5), .c(lev3_c5_raw)
    );
    assign lev3_c5 = lev3_c5_raw << 1;
-
    wire [15:0] lev4_s6, lev4_c6_raw, lev4_c6;

    carry_save_adder_row csa_lvl4_1 (
        .x(lev3_s5), .y(lev3_c5), .z(lev2_c4), 
        .s(lev4_s6), .c(lev4_c6_raw)
    );
    assign lev4_c6 = lev4_c6_raw << 1;

    wire [15:0] final_A = lev4_s6;
    wire [15:0] final_B = lev4_c6;

    wire [8:0] sum_lower; // 9 bits to capture carry out
    wire [8:0] sum_upper;

    // Instantiate Lower 8-bit CLA
    // Assuming module signature: (input [7:0] A, input [7:0] B, output [8:0] out)
    eight_bit_recursivedoublingbasedcla cla_low (
        .A(final_A[7:0]), 
        .B(final_B[7:0]), 
        .out(sum_lower)
    );

    // Instantiate Upper 8-bit CLA
    eight_bit_recursivedoublingbasedcla cla_high (
        .A(final_A[15:8]), 
        .B(final_B[15:8]), 
        .out(sum_upper)
    );

    
    assign result[7:0] = sum_lower[7:0];
    
   
    assign result[15:8] = sum_upper[7:0] + sum_lower[8];

endmodule
