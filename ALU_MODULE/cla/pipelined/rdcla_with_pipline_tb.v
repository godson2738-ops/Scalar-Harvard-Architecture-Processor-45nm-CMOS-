`include "rdcla_with_pipline.v"
module rdcla_with_pipline_tb;
reg [7:0]A,B;
reg clk,rst;
wire [8:0]out;

rdcla_with_pipeline uut(A,B,clk,rst,out);

always
#10 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    A = 0;
    B = 0;

    #10
        rst=0;
    A= 8'd170;
    B= 8'd85;

    #40

    A= 8'd1;
    B= 8'd127;

   #40

    A= 8'd255;
    B= 8'd255;

   #40

    A = 8'd150;
    B = 8'd86;

    #200 $finish;

     end

    initial begin
        $monitor("TIME=%0t | out=%d (binary: %b)", 
                 $time, out, out);
    end



endmodule 
