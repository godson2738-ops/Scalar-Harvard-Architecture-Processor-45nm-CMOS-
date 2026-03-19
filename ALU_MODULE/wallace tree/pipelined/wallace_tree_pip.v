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

module pipelined_wallace_multiplier(
    input clk,
    input rst,
    input [7:0] A, 
    input [7:0] B,
    output reg [15:0] result
);

   
    reg [7:0] reg_A;
    reg [7:0] reg_B;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_A <= 0;
            reg_B <= 0;
        end else begin
            reg_A <= A;
            reg_B <= B;
        end
    end



    wire [7:0] P0, P1, P2, P3, P4, P5, P6, P7;
    assign P0 = reg_A & {8{reg_B[0]}};
    assign P1 = reg_A & {8{reg_B[1]}};
    assign P2 = reg_A & {8{reg_B[2]}};
    assign P3 = reg_A & {8{reg_B[3]}};
    assign P4 = reg_A & {8{reg_B[4]}};
    assign P5 = reg_A & {8{reg_B[5]}};
    assign P6 = reg_A & {8{reg_B[6]}};
    assign P7 = reg_A & {8{reg_B[7]}};

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

    carry_save_adder_row csa_lvl1_1 (.x(w0), .y(w1), .z(w2), .s(lev1_s1), .c(lev1_c1_raw));
    assign lev1_c1 = lev1_c1_raw << 1;

    carry_save_adder_row csa_lvl1_2 (.x(w3), .y(w4), .z(w5), .s(lev1_s2), .c(lev1_c2_raw));
    assign lev1_c2 = lev1_c2_raw << 1;

    wire [15:0] lev2_s3, lev2_c3_raw, lev2_c3;
    wire [15:0] lev2_s4, lev2_c4_raw, lev2_c4;

    carry_save_adder_row csa_lvl2_1 (.x(lev1_s1), .y(lev1_c1), .z(lev1_s2), .s(lev2_s3), .c(lev2_c3_raw));
    assign lev2_c3 = lev2_c3_raw << 1;

    carry_save_adder_row csa_lvl2_2 (.x(lev1_c2), .y(w6), .z(w7), .s(lev2_s4), .c(lev2_c4_raw));
    assign lev2_c4 = lev2_c4_raw << 1;

    wire [15:0] lev3_s5, lev3_c5_raw, lev3_c5;

    carry_save_adder_row csa_lvl3_1 (.x(lev2_s3), .y(lev2_c3), .z(lev2_s4), .s(lev3_s5), .c(lev3_c5_raw));
    assign lev3_c5 = lev3_c5_raw << 1;

    wire [15:0] lev4_s6, lev4_c6_raw, lev4_c6;

    carry_save_adder_row csa_lvl4_1 (.x(lev3_s5), .y(lev3_c5), .z(lev2_c4), .s(lev4_s6), .c(lev4_c6_raw));
    assign lev4_c6 = lev4_c6_raw << 1;

    reg [15:0] reg_tree_sum;
    reg [15:0] reg_tree_carry;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_tree_sum <= 0;
            reg_tree_carry <= 0;
        end else begin
            reg_tree_sum <= lev4_s6;
            reg_tree_carry <= lev4_c6;
        end
    end


    wire [8:0] sum_lower;
    wire [8:0] sum_upper;

    // Lower CLA
    eight_bit_recursivedoublingbasedcla cla_low (
        .A(reg_tree_sum[7:0]), 
        .B(reg_tree_carry[7:0]), 
        .out(sum_lower)
    );

    // Upper CLA
    eight_bit_recursivedoublingbasedcla cla_high (
        .A(reg_tree_sum[15:8]), 
        .B(reg_tree_carry[15:8]), 
        .out(sum_upper)
    );

    // Combine for final calculation
    wire [15:0] final_calc;
    assign final_calc[7:0] = sum_lower[7:0];
    assign final_calc[15:8] = sum_upper[7:0] + sum_lower[8];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
        end else begin
            result <= final_calc;
        end
    end

endmodule
