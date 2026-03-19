module writeback (
    input [31:0] instruction,
    output reg [7:0] data_out,
    output reg [4:0] reg_addr_out,
    output reg [7:0] mem_addr_out
);

always @(*) begin
  
    data_out = 8'b00000000;
    reg_addr_out = 5'bxxxxx;
    mem_addr_out = 8'bxxxxxxxx;

    //  MOV Immediate
    if (instruction[31:26] == 6'b000000) begin 
        reg_addr_out = instruction[25:21]; 
        mem_addr_out = 8'bxxxxxxxx;
        data_out = instruction[7:0];      
    end
    //  MOV Register
    else if (instruction[31:26] == 6'b000001) begin 
        reg_addr_out = instruction[25:21]; // Rdst is at [25:21]
        mem_addr_out = 8'bxxxxxxxx;
    end
    //  LOAD
    else if (instruction[31:26] == 6'b000010) begin 
        reg_addr_out = instruction[25:21]; // Rdst is at [25:21]
        mem_addr_out = 8'bxxxxxxxx;
    end
    //  STORE (Writes to Data Memory)
    else if (instruction[31:26] == 6'b000011) begin 
        reg_addr_out = 5'bxxxxx;
        mem_addr_out = instruction[25:18]; // Dst Address is at [25:18]!
    end
    
    //  ALU OPERATIONS 
    // All of these write back to Rdst1, which is located at [20:16]
    
    else if (instruction[31:26] == 6'b000100) begin // ADD
        reg_addr_out = instruction[20:16]; 
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b000101) begin // SUB
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b000110) begin // NEG
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b000111) begin // MUL
        reg_addr_out = instruction[20:16]; 
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001000) begin // DIV
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001001) begin // OR
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001010) begin // XOR
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001011) begin // NAND
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001100) begin // NOR
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001101) begin // NXOR
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001110) begin // NOT
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b001111) begin // LLSH
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    else if (instruction[31:26] == 6'b010000) begin // LRSH
        reg_addr_out = instruction[20:16];
        mem_addr_out = 8'bxxxxxxxx;
    end
    
    // Catch-all for invalid opcodes
    else begin 
        reg_addr_out = 5'bxxxxx;
        mem_addr_out = 8'bxxxxxxxx;
        data_out = 8'b00000000;
    end
end

endmodule
