`timescale 1ns / 1ps

module fetch_tb();
    reg clk;
    reg reset;
    reg load_en;
    reg [31:0]instr_in;
    reg [5:0]read_addr;
    wire [31:0]instr_out;


fetch uut (
    .clk(clk),
    .reset(reset),
    .load_en(load_en),
    .instr_in(instr_in),
    .read_addr(read_addr),
    .instr_out(instr_out)
);

always #5 clk = ~clk;

initial begin
   
        clk = 0;
        reset = 0;
        load_en = 0;
        instr_in = 32'h00000000;
        read_addr = 6'd0;

       
        #10 reset = 1; 
        #10 reset = 0; 

       
        @(negedge clk);
        load_en = 1;
        instr_in = 32'hA1A1A1A1; // Writes to memory[0]
        
        @(negedge clk);
        instr_in = 32'hB2B2B2B2; // Writes to memory[1]
        
        @(negedge clk);
        instr_in = 32'hC3C3C3C3; // Writes to memory[2]
        
        @(negedge clk);
        load_en = 0;             // Stop loading

        #10 read_addr = 6'd0; // Should output A1A1A1A1
        #10 read_addr = 6'd1; // Should output B2B2B2B2
        #10 read_addr = 6'd2; // Should output C3C3C3C3
        #10 read_addr = 6'd5; // Uninitialized memory (likely outputs X or 0)

     
        #20 $finish;
    end

   
    initial begin
        $monitor("Time: %0t | Reset: %b | Load_En: %b | Instr_In: %h | Read_Addr: %d | Instr_Out: %h", 
                 $time, reset, load_en, instr_in, read_addr, instr_out);
    end

endmodule
