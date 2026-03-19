module nrd_without(
    input [7:0] Q,       // Dividend
    input [7:0] M,       // Divisor
    output [7:0] out,    // Quotient
    output [7:0] remainder
);

    wire [7:0] A0, A1, A2, A3, A4, A5, A6, A7;
    wire [7:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    assign A0 = {7'b0, Q[7]} - M;      
    assign Q0 = {Q[6:0], ~A0[7]};   

    
    assign A1 = (A0[7]) ? ({A0[6:0], Q0[7]} + M) : ({A0[6:0], Q0[7]} - M);
    assign Q1 = {Q0[6:0], ~A1[7]};    

    assign A2 = (A1[7]) ? ({A1[6:0], Q1[7]} + M) : ({A1[6:0], Q1[7]} - M);
    assign Q2 = {Q1[6:0], ~A2[7]};

    assign A3 = (A2[7]) ? ({A2[6:0], Q2[7]} + M) : ({A2[6:0], Q2[7]} - M);
    assign Q3 = {Q2[6:0], ~A3[7]};

    assign A4 = (A3[7]) ? ({A3[6:0], Q3[7]} + M) : ({A3[6:0], Q3[7]} - M);
    assign Q4 = {Q3[6:0], ~A4[7]};

   
    assign A5 = (A4[7]) ? ({A4[6:0], Q4[7]} + M) : ({A4[6:0], Q4[7]} - M);
    assign Q5 = {Q4[6:0], ~A5[7]};

    assign A6 = (A5[7]) ? ({A5[6:0], Q5[7]} + M) : ({A5[6:0], Q5[7]} - M);
    assign Q6 = {Q5[6:0], ~A6[7]};

    assign A7 = (A6[7]) ? ({A6[6:0], Q6[7]} + M) : ({A6[6:0], Q6[7]} - M);
    assign Q7 = {Q6[6:0], ~A7[7]};

    assign out = (M == 0) ? 8'd0 : Q7;

  
    assign remainder = (M == 0) ? 8'd0 : 
                       (A7[7])  ? (A7 + M) : A7;

endmodule
