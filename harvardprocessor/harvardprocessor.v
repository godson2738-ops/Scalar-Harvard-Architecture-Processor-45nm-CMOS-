`include "fetch.v"
`include "register.v"
`include "Decode.v"
`include "Datamemory.v"
`include "writeback.v"
`include "ALU.v"
module harvardprocessor(
    input clk,
    input reset,
    input load_en,
    input [31:0] instr_in
);

   
    wire [31:0] instruction;
    wire [5:0]  opcode = instruction[31:26];
    
    // Register Wires
    wire [4:0]  reg_read_addr1, reg_read_addr2;
    wire [7:0]  reg_data1, reg_data2;
    wire [7:0]  reg_write_data;            
    
    // ALU Wires
    wire [7:0]  alu_A, alu_B;
    wire [7:0]  alu_result;
    
    // Memory & Writeback Wires
    wire [7:0]  dmem_out;
    wire [7:0]  wb_imm_data;
    wire [4:0]  wb_reg_addr_out;
    wire [7:0]  wb_mem_addr_out;

    
    // Write to Register for everything EXCEPT the STORE instruction (000011)
    // Also, don't write while loading the program!
    // ONLY write to a register if the command IS NOT a STORE, and IS NOT a NOP
    wire reg_write_en = (!load_en) && (opcode != 6'b000011) && (opcode != 6'b000001);
    
    // Write to Data Memory ONLY during the STORE instruction (000011)
    wire mem_write_en = (!load_en) && (opcode == 6'b000011);

    
    reg [5:0] pc;
    always @(posedge clk) begin
        if (reset) 
            pc <= 6'b000000;
        else if (!load_en) 
            pc <= pc + 1; 
    end

    fetch u_fetch (
        .clk(clk),
        .reset(reset),
        .load_en(load_en),
        .instr_in(instr_in),
        .read_addr(pc),             
        .instr_out(instruction)    
    );

  
    decode u_decode (
        .instruction(instruction),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .reg_addr1(reg_read_addr1),
        .reg_addr2(reg_read_addr2),
        .A(alu_A),
        .B(alu_B)
    );

  
    register u_reg (
        .clk(clk),
        .write_en(reg_write_en),
        .read_inaddr(reg_read_addr1),
        .read_inaddr_2(reg_read_addr2), 
        .write_inaddr(wb_reg_addr_out), 
        .data_in(reg_write_data),      
        .data_out(reg_data1),
        .data_out2(reg_data2)        
    );


    alu u_alu (
        .clk(clk),
        .rst(reset),
        .A(alu_A),
        .B(alu_B),
        .opcode(opcode),
        .C(alu_result)
    );


    datamemory u_dmem (
        .clk(clk),
        .write_en(mem_write_en),
        .read_addr(wb_mem_addr_out),  
        .write_addr(wb_mem_addr_out), 
        .data_in(reg_data2),           
        .data_out(dmem_out)
    );


    writeback u_wb (
        .instruction(instruction),
        .data_out(wb_imm_data),
        .reg_addr_out(wb_reg_addr_out),
        .mem_addr_out(wb_mem_addr_out)
    );

    assign reg_write_data = (opcode == 6'b000000) ? wb_imm_data : // MOV Immediate -> save immediate data
                            (opcode == 6'b000010) ? dmem_out    : // LOAD -> save data from memory
                            alu_result;                           // EVERYTHING ELSE -> save ALU math result

endmodule
