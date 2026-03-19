`include "8_bit_recursivedoublingbasedcla.v"

module eight_bit_recursivedoublingbasedcla_tb;
reg [7:0]A,B;
wire [8:0]out;

eight_bit_recursivedoublingbasedcla uut(A,B,out);
initial begin
    //1
    A=8'b10110010;
    B=8'b10110101;
    $finish;

end
initial 
$monitor ("A=%b B=%b || out=%b",A,B,out);
endmodule
