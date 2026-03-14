`timescale 1ns / 1ps

module decode_tb();
    reg [31:0] instruction;
    reg [7:0] reg_data1;  
    reg [7:0] reg_data2; 
    wire [4:0] reg_addr1; 
    wire [4:0] reg_addr2; 
    wire [7:0] A;     
    wire [7:0] B;

decode uut(
    .instruction(instruction),
    .reg_data1(reg_data1),
    .reg_data2(reg_data2),
    .reg_addr1(reg_addr1),
    .reg_addr2(reg_addr2),
    .A(A),
    .B(B)
);

initial begin
        
        instruction = 32'h00000000;
        
        
        reg_data1 = 8'hAA; // 10101010
        reg_data2 = 8'h55; // 01010101

        #10;
        
        // --- TEST 1: Valid ALU Instruction (ADD) ---
        // Opcode [31:26] = 000100 (ADD)
        // Rsrc2 [9:5] = 10 (01010 in binary)
        // Rsrc1 [4:0] = 20 (10100 in binary)
        // Binary: 000100_0000000000000000_01010_10100 -> Hex: 32'h10000154
        instruction = 32'h10000154; 
        
        // EXPECTED: reg_addr1 = 10, reg_addr2 = 20, A = AA, B = 55
        
        #20;

        // --- TEST 2: Valid ALU Instruction (SUB) ---
        // Opcode [31:26] = 000101 (SUB)
        // Keeping addresses the same
        // Binary: 000101_0000000000000000_01010_10100 -> Hex: 32'h14000154
        instruction = 32'h14000154;
        
        // EXPECTED: reg_addr1 = 10, reg_addr2 = 20, A = AA, B = 55

        #20;

        // --- TEST 3: Invalid/Non-ALU Instruction ---
        // Opcode [31:26] = 111111 (Not in your 13 if-else statements)
        // Keeping addresses the same
        // Binary: 111111_0000000000000000_01010_10100 -> Hex: 32'hFC000154
        instruction = 32'hFC000154;
        
        // EXPECTED: reg_addr1 = 10, reg_addr2 = 20, A = 00, B = 00 
        // (Because your 'else' block catches it!)

        #20;
        $finish;
    end

    // 4. Monitor the outputs in the console
    initial begin
        $monitor("Time: %0t | Opcode: %b | Addr1 (Rsrc2): %2d | Addr2 (Rsrc1): %2d | A: %h | B: %h", 
                 $time, instruction[31:26], reg_addr1, reg_addr2, A, B);
    end

endmodule

