module alu(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [5:0] opcode,
    output reg [7:0] C
);

    wire [8:0]  cla_add_out;
    wire [8:0]  cla_sub_out;
    wire [15:0] wallace_prod;
    wire [7:0]  div_quotient;
    wire [7:0]  div_remainder;
    wire [7:0]  lsh_out;
    wire [7:0]  rsh_out;


    rdcla_with_pipeline u_add (
        .clk(clk), .rst(rst), .A(A), .B(B), 
        .out(cla_add_out)
    );

    
    wire [7:0] B_twos_comp = ~B + 8'd1; 
    rdcla_with_pipeline u_sub (
        .clk(clk), .rst(rst), .A(A), .B(B_twos_comp), 
        .out(cla_sub_out)
    );

 
    pipelined_wallace_multiplier u_mul (
        .clk(clk), .rst(rst), .A(A), .B(B), 
        .result(wallace_prod)
    );

   
    nonrestoringdivision u_div (
        .clk(clk), .rst(rst), .Q(A), .M(B), 
        .out(div_quotient), .remainder(div_remainder)
    );

   
    shift_left_8b_pipe u_lsh (
        .clk(clk), .reset(rst), .din(A), .shamt(B[2:0]), 
        .dout(lsh_out)
    );

  
    pipe_right_shift_8b u_rsh (
        .clk(clk), .reset(rst), .din(A), .shamt(B[2:0]), 
        .dout(rsh_out)
    );

    // Combinational Output Multiplexer
    always @(*) begin
        case(opcode)
            // Arithmetic Operations
            6'b000100: C = cla_add_out[7:0];   
            6'b000101: C = cla_sub_out[7:0];   
            6'b000110: C = -A;                 
            6'b000111: C = wallace_prod[7:0];  
            6'b001000: C = div_quotient;      
            
            // Logical Operations (These execute instantly!)
            6'b001001: C = A | B;              // OR
            6'b001010: C = A ^ B;              // XOR
            6'b001011: C = ~(A & B);           // NAND
            6'b001100: C = ~(A | B);           // NOR
            6'b001101: C = ~(A ^ B);           // XNOR
            6'b001110: C = ~A;                 // NOT
            
            // Shift Operations (Pipelined)
            6'b001111: C = lsh_out; 
            6'b010000: C = rsh_out; 
            
            default:   C = 8'd0;
        endcase
    end

endmodule
