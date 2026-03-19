module register(
    input clk,
    input write_en,
    input [4:0]read_inaddr,
    input [4:0]write_inaddr,
    input [7:0]data_in,
    output [7:0]data_out
);
reg [7:0] reg_array [0:31];
always @(posedge clk) begin
    if (write_en == 1'b1)begin
        reg_array[write_inaddr] <= data_in;
    end
end
assign data_out = reg_array[read_inaddr];
endmodule
