`timescale 1ns / 1ps

module tb_wallace_tree_multiplier;

    // Inputs
    reg [7:0] A;
    reg [7:0] B;

    // Outputs
    wire [15:0] result;

    // Variables for validation
    reg [15:0] expected;
    integer i;
    integer errors;

    // Instantiate the Unit Under Test (UUT)
    wallace_tree_multiplier uut (
        .A(A), 
        .B(B), 
        .result(result)
    );

    initial begin
        // Initialize Inputs
        A = 0;
        B = 0;
        errors = 0;

        // Create a VCD file for waveform viewing (optional)
        $dumpfile("wallace_test.vcd");
        $dumpvars(0, tb_wallace_tree_multiplier);

        $display("----------------------------------------------------------------");
        $display("Starting Wallace Tree Multiplier Verification");
        $display("----------------------------------------------------------------");

        // --- TEST 1: Corner Cases ---
        run_test(8'd0, 8'd0);       // Zero test
        run_test(8'd1, 8'd1);       // Identity test
        run_test(8'd255, 8'd255);   // Max value test (Result should be 65025)
        run_test(8'd255, 8'd0);     // Max * Zero
        run_test(8'd255, 8'd1);     // Max * One
        run_test(8'd128, 8'd2);     // Power of 2 test

        // --- TEST 2: Random Stress Test (100 Iterations) ---
        $display("Running 100 Random Test Cases...");
        for (i = 0; i < 100; i = i + 1) begin
            A = $random;
            B = $random;
            #10; // Wait for logic to settle
            
            expected = A * B;
            
            if (result !== expected) begin
                $display("[FAIL] Time=%0t | A=%d, B=%d | Expected=%d, Got=%d", $time, A, B, expected, result);
                errors = errors + 1;
            end
        end

        // --- Final Report ---
        $display("----------------------------------------------------------------");
        if (errors == 0) begin
            $display("ALL TESTS PASSED SUCCESSFULLY at Time=%0t", $time);
        end else begin
            $display("TEST FAILED with %d errors.", errors);
        end
        $display("----------------------------------------------------------------");
        
        $finish;
    end

    // Task to run a single test case
    task run_test;
        input [7:0] in_a;
        input [7:0] in_b;
        begin
            A = in_a;
            B = in_b;
            #10; // Wait for propagation
            
            expected = A * B;
            
            if (result === expected) begin
                // %0t formats time without extra leading spaces
                $display("[PASS] Time=%0t | A=%3d, B=%3d -> Result=%5d", $time, A, B, result);
            end else begin
                $display("[FAIL] Time=%0t | A=%d, B=%d | Expected=%d, Got=%d", $time, A, B, expected, result);
                errors = errors + 1;
            end
        end
    endtask

endmodule
