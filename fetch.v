module fetch(
    input clk,
    input reset,
    input load_en,
    input [31:0]instr_in,
    input [5:0]read_addr,
    output [31:0]instr_out
);
reg [5:0]count;
reg [31:0] mem_array [0:63];

always @(posedge clk) begin
    if (reset == 1'b1) begin
        count <= 0;
    end
    else begin
        if (load_en == 1'b1) begin
            mem_array[count] <= instr_in;
            count <= count + 1;
        end
        
    end
end


assign instr_out = mem_array[read_addr];
endmodule