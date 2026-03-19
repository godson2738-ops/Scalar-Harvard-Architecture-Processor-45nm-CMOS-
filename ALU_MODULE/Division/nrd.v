module nonrestoringdivision(
    input [7:0] Q,
    input [7:0] M,
    input clk, rst,
    output reg [7:0] out,
    output reg [7:0] remainder
);

    reg [7:0] A0, A1, A2, A3, A4, A5, A6, A7;
    reg [7:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
    reg [7:0] M0, M1, M2, M3, M4, M5, M6, M7;

    wire [7:0] s0_sub = {7'b0, Q[7]} - M;

    always @(posedge clk) begin
        if (rst) begin
            A0 <= 0; Q0 <= 0; M0 <= 0;
        end else begin
            A0 <= s0_sub;
 
            Q0 <= {Q[6:0], ~s0_sub[7]}; 
            M0 <= M;
        end
    end

    wire [7:0] s1_add = {A0[6:0], Q0[7]} + M0;
    wire [7:0] s1_sub = {A0[6:0], Q0[7]} - M0;

    always @(posedge clk) begin
        if (rst) begin
            A1 <= 0; Q1 <= 0; M1 <= 0;
        end else begin
  
            if (A0[7] == 1'b1) begin 
                A1 <= s1_add;
                Q1 <= {Q0[6:0], ~s1_add[7]};
            end else begin         
                A1 <= s1_sub;
                Q1 <= {Q0[6:0], ~s1_sub[7]};
            end
            M1 <= M0;
        end
    end

    wire [7:0] s2_add = {A1[6:0], Q1[7]} + M1;
    wire [7:0] s2_sub = {A1[6:0], Q1[7]} - M1;

    always @(posedge clk) begin
        if (rst) begin
            A2 <= 0; Q2 <= 0; M2 <= 0;
        end else begin
            if (A1[7] == 1'b1) begin
                A2 <= s2_add;
                Q2 <= {Q1[6:0], ~s2_add[7]};
            end else begin
                A2 <= s2_sub;
                Q2 <= {Q1[6:0], ~s2_sub[7]};
            end
            M2 <= M1;
        end
    end

    wire [7:0] s3_add = {A2[6:0], Q2[7]} + M2;
    wire [7:0] s3_sub = {A2[6:0], Q2[7]} - M2;

    always @(posedge clk) begin
        if (rst) begin
            A3 <= 0; Q3 <= 0; M3 <= 0;
        end else begin
            if (A2[7] == 1'b1) begin
                A3 <= s3_add;
                Q3 <= {Q2[6:0], ~s3_add[7]};
            end else begin
                A3 <= s3_sub;
                Q3 <= {Q2[6:0], ~s3_sub[7]};
            end
            M3 <= M2;
        end
    end

    wire [7:0] s4_add = {A3[6:0], Q3[7]} + M3;
    wire [7:0] s4_sub = {A3[6:0], Q3[7]} - M3;

    always @(posedge clk) begin
        if (rst) begin
            A4 <= 0; Q4 <= 0; M4 <= 0;
        end else begin
            if (A3[7] == 1'b1) begin
                A4 <= s4_add;
                Q4 <= {Q3[6:0], ~s4_add[7]};
            end else begin
                A4 <= s4_sub;
                Q4 <= {Q3[6:0], ~s4_sub[7]};
            end
            M4 <= M3;
        end
    end

    wire [7:0] s5_add = {A4[6:0], Q4[7]} + M4;
    wire [7:0] s5_sub = {A4[6:0], Q4[7]} - M4;

    always @(posedge clk) begin
        if (rst) begin
            A5 <= 0; Q5 <= 0; M5 <= 0;
        end else begin
            if (A4[7] == 1'b1) begin
                A5 <= s5_add;
                Q5 <= {Q4[6:0], ~s5_add[7]};
            end else begin
                A5 <= s5_sub;
                Q5 <= {Q4[6:0], ~s5_sub[7]};
            end
            M5 <= M4;
        end
    end

    wire [7:0] s6_add = {A5[6:0], Q5[7]} + M5;
    wire [7:0] s6_sub = {A5[6:0], Q5[7]} - M5;

    always @(posedge clk) begin
        if (rst) begin
            A6 <= 0; Q6 <= 0; M6 <= 0;
        end else begin
            if (A5[7] == 1'b1) begin
                A6 <= s6_add;
                Q6 <= {Q5[6:0], ~s6_add[7]};
            end else begin
                A6 <= s6_sub;
                Q6 <= {Q5[6:0], ~s6_sub[7]};
            end
            M6 <= M5;
        end
    end

    wire [7:0] s7_add = {A6[6:0], Q6[7]} + M6;
    wire [7:0] s7_sub = {A6[6:0], Q6[7]} - M6;

    always @(posedge clk) begin
        if (rst) begin
            A7 <= 0; Q7 <= 0; M7 <= 0;
        end else begin
            if (A6[7] == 1'b1) begin
                A7 <= s7_add;
                Q7 <= {Q6[6:0], ~s7_add[7]};
            end else begin
                A7 <= s7_sub;
                Q7 <= {Q6[6:0], ~s7_sub[7]};
            end
            M7 <= M6;
        end
    end

    always @(*) begin
        if (M7 == 8'd0) begin
            out = 8'd0;       
            remainder = 8'd0; 
        end else begin
            out = Q7; 
           
            if (A7[7] == 1'b1)
                remainder = A7 + M7; 
            else
                remainder = A7;    
        end
    end

endmodule
