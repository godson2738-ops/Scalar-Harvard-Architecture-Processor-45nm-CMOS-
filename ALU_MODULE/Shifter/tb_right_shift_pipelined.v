 `include "eight_bit_right_shifter_pipelined.v"

module tb_eight_bit_right_shifter_pipelined;

    reg clk;
    reg rst;
    reg [7:0] X;
    reg [2:0] S;

    wire [7:0] Y;

    // DUT instantiation
    eight_bit_right_shifter_pipelined dut (
        .clk(clk),
        .rst(rst),
        .X(X),
        .S(S),
        .Y(Y)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        rst = 1;
        X = 0;
        S = 0;

        #10;
        rst = 0;

        // -------- Test 1 --------
        // 10110011 << 0
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd0;

        // -------- Test 2 --------
        // 10110011 << 2
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd2;

        // -------- Test 3 --------
        // 10110011 << 3
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd3;

        // -------- Test 4 --------
        // 11111111 << 4
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd4;

        // -------- Test 5 --------
        // 10000000 << 5
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd5;

        // -------- Test 6 --------
        // 01010101 << 4
        @(negedge clk);
        X = 8'b10110011;
        S = 3'd6;

        // Allow pipeline to flush (3-stage pipeline)
        repeat (10) @(posedge clk);

        $finish;
    end

    initial begin
        $dumpfile("shifter_pipelined.vcd");
        $dumpvars(0, tb_eight_bit_right_shifter_pipelined);

        $monitor("time=%0t  Y=%b",
                 $time, Y);
    end

endmodule
