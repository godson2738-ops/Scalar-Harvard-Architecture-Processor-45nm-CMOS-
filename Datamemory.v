module datamemory(
    input clk,
    input write_en,
    input [7:0]read_addr,
    input [7:0]write_addr,
    input [7:0]data_in,
    output [7:0]data_out
);
reg [7:0] datamem [0:255];
always @(posedge clk) begin
    if (write_en == 1'b1)begin
        datamem[write_addr] <= data_in;
    end
end
assign data_out = datamem[read_addr];
endmodule