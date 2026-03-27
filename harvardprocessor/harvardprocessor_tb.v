module harvardprocessor_tb();

reg clk;
reg reset;
reg load_en;
reg [31:0] instr_in;

harvardprocessor uut(
    .clk(clk),
    .reset(reset),
    .load_en(load_en),
    .instr_in(instr_in)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Instruction Loading & Execution
initial begin
    clk = 0;
    reset = 1;
    load_en = 0;
    instr_in = 32'd0;

    #20 reset = 0;
    load_en = 1;

    // --- NEW 12-LINE PROGRAM: (A<<2) - (B<<3) + (C<<4) ---
    // Replace the LOADs with MOV Immediate!
    // 1. MOV R1, 1  (Changing A from 5 to 1 to force a negative intermediate result)
    #10 instr_in = 32'b000000_00001_0000000000000_00000001;
    // 2. MOV R2, 2
    #10 instr_in = 32'b000000_00010_0000000000000_00000010; 
    // 3. MOV R3, 3
    #10 instr_in = 32'b000000_00011_0000000000000_00000011;
 
    // 4. MOV R4, 2
    #10 instr_in = 32'b000000_00100_0000000000000_00000010; 
    // 5. LSH R5, R1, R4
    #10 instr_in = 32'b001111_00000_00101_000000_00001_00100; 
    
    // 6. MOV R4, 3
    #10 instr_in = 32'b000000_00100_0000000000000_00000011; 
    // 7. LSH R6, R2, R4
    #10 instr_in = 32'b001111_00000_00110_000000_00010_00100; 
    
    // 8. SUB R5, R5, R6
    #10 instr_in = 32'b000101_00000_00101_000000_00101_00110; 
    
    // 9. MOV R4, 4
    #10 instr_in = 32'b000000_00100_0000000000000_00000100; 
    // 10. LSH R7, R3, R4
    #10 instr_in = 32'b001111_00000_00111_000000_00011_00100; 
    
    // 11. ADD R5, R5, R7
    #10 instr_in = 32'b000100_00000_00101_000000_00101_00111; 
    
    // 12. STORE R5, [3]
    #10 instr_in = 32'b000011_00101_0000000000000_00000011; 

    // Stop loading instructions
    #10 load_en = 0;
    instr_in = 32'd0;

    // Let the processor run for a bit to finish the last commands
    #200 
    $display("Simulation Complete!");
    $finish;
end
// --- WORKAROUND: Create simple wires for the monitor ---
wire signed [7:0] r1_val = uut.u_reg.reg_array[1];
wire signed [7:0] r2_val = uut.u_reg.reg_array[2];
wire signed [7:0] r3_val = uut.u_reg.reg_array[3];
wire signed [7:0] r4_val = uut.u_reg.reg_array[4];
wire signed [7:0] r5_val = uut.u_reg.reg_array[5];
wire signed [7:0] r6_val = uut.u_reg.reg_array[6];
wire signed [7:0] r7_val = uut.u_reg.reg_array[7];
// Track all 7 registers used in the math!
// Track all 7 registers used in the math!
initial begin
    $monitor("Time: %0t | R1: %0d | R2: %0d | R3: %0d | R4 (ShiftAmt): %0d | R5 (Ans): %0d | R6: %0d | R7: %0d", 
             $time, r1_val, r2_val, r3_val, r4_val, r5_val, r6_val, r7_val);
end
endmodule
