`timescale 1ns / 1ps

module writeback_tb(); 

    
    reg [31:0] instruction;
    
    wire [7:0] data_out;
    wire [4:0] reg_addr_out;
    wire [7:0] mem_addr_out;

   
    writeback dut (
        .instruction(instruction),
        .data_out(data_out),
        .reg_addr_out(reg_addr_out),
        .mem_addr_out(mem_addr_out)
    );

   
    initial begin
        // Initialize input
        instruction = 32'h00000000;
        #10;
        
        // --- TEST 1: MOV Immediate ---
        // Opcode [31:26] = 000000
        // Rdst [25:21] = 10 (01010 in binary)
        // Immediate [7:0] = AA (10101010 in binary)
        // Binary: 000000_01010_0000000000000_10101010 -> Hex: 32'h014000AA
        instruction = 32'h014000AA; 
        
        // EXPECTED: reg_addr_out = 10, mem_addr_out = xx, data_out = AA
        #20;

        // --- TEST 2: STORE (Writes to Data Memory) ---
        // Opcode [31:26] = 000011
        // Dst Address [25:18] = F0 (11110000 in binary)
        // Binary: 000011_11110000_000000000000000000 -> Hex: 32'h0FC00000
        instruction = 32'h0FC00000;
        
        // EXPECTED: reg_addr_out = xx, mem_addr_out = F0, data_out = 00
        #20;

        // --- TEST 3: ALU Operation (ADD) ---
        // Opcode [31:26] = 000100
        // Rdst1 [20:16] = 20 (10100 in binary)
        // Binary: 000100_00000_10100_0000000000000000 -> Hex: 32'h10140000
        instruction = 32'h10140000;
        
        // EXPECTED: reg_addr_out = 20, mem_addr_out = xx, data_out = 00
        #20;

        // --- TEST 4: Invalid/Catch-all ---
        // Opcode [31:26] = 111111 (Not in your list)
        // Binary: 111111_000000000000000000000000000 -> Hex: 32'hFC000000
        instruction = 32'hFC000000;
        
        // EXPECTED: reg_addr_out = xx, mem_addr_out = xx, data_out = 00
        #20;
        
        $finish;
    end


    initial begin
        $monitor("Time: %0t | Opcode: %b | Reg_Addr: %2d (Hex: %h) | Mem_Addr: %h | Data_Out: %h", 
                 $time, instruction[31:26], reg_addr_out, reg_addr_out, mem_addr_out, data_out);
    end

endmodule
