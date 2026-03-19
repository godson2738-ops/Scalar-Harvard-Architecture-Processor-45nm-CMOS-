`timescale 1ns / 1ps

module tb_nonrestoringdivision;

    reg [7:0] Q, M;
    reg clk, rst;
    wire [7:0] out, remainder;

    nonrestoringdivision uut (
        .Q(Q), .M(M), .clk(clk), .rst(rst), 
        .out(out), .remainder(remainder)
    );

  
    always #5 clk = ~clk;

    initial begin
      
        clk = 0; rst = 1; Q = 0; M = 0;

        
        $dumpfile("nrd.vcd"); 
        
        $dumpvars(0, tb_nonrestoringdivision); 
        
        $display("-----------------------------------------------------");
        $display("Time | Action | Input (Q/M) | Output (Q, R)");
        $display("-----------------------------------------------------");

    
        #20 rst = 0;

      
        @(posedge clk); Q <= 8'd20; M <= 8'd3;  $display("%4t | IN     | 20 / 3      | --", $time);
        @(posedge clk); Q <= 8'd10; M <= 8'd2;  $display("%4t | IN     | 10 / 2      | --", $time);
        @(posedge clk); Q <= 8'd50; M <= 8'd7;  $display("%4t | IN     | 50 / 7      | --", $time);
        @(posedge clk); Q <= 8'd100; M <= 8'd10; $display("%4t | IN     | 100 / 10    | --", $time);
        @(posedge clk); Q <= 8'd15; M <= 8'd4;  $display("%4t | IN     | 15 / 4      | --", $time);
        @(posedge clk); Q <= 8'd25; M <= 8'd5;  $display("%4t | IN     | 25 / 5      | --", $time);
        @(posedge clk); Q <= 8'd9;  M <= 8'd2;  $display("%4t | IN     | 9 / 2       | --", $time);
        @(posedge clk); Q <= 8'd121; M <= 8'd11;  $display("%4t | IN     | 121 / 11     | --", $time);
        
        
        @(posedge clk); Q <= 0; M <= 0;

        
        repeat (15) begin
            @(negedge clk); 
            if (out != 0 || remainder != 0)
                $display("%4t | OUT    | --          | Q=%d, R=%d", $time, out, remainder);
        end

        $display("-----------------------------------------------------");
        $finish;
    end

endmodule
