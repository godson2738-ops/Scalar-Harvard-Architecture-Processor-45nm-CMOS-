`timescale 1ns / 1ps

module tb_pipelined_wallace;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] A;
    reg [7:0] B;

    // Outputs
    wire [15:0] result;

    // Testbench Variables
    integer i;
    integer errors;
    
    // Queue to handle expected values with latency
    reg [15:0] expected_queue [0:100]; 
    integer queue_ptr_in;
    integer queue_ptr_out;
    integer sent_count;

    // Instantiate the Unit Under Test (UUT)
    pipelined_wallace_multiplier uut (
        .clk(clk),
        .rst(rst),
        .A(A), 
        .B(B), 
        .result(result)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        A = 0;
        B = 0;
        errors = 0;
        queue_ptr_in = 0;
        queue_ptr_out = 0;
        sent_count = 0;

        $dumpfile("pipelined_test.vcd");
        $dumpvars(0, tb_pipelined_wallace);

        $display("----------------------------------------------------------------");
        $display("Starting PIPELINED Wallace Tree Verification");
        $display("----------------------------------------------------------------");

        // Reset Sequence
        #20;
        rst = 0;
        $display("Time=%0t | Reset De-asserted", $time);
        
        // --- DRIVER BLOCK: Feeds inputs ---
        for (i = 0; i < 50; i = i + 1) begin
            // Drive inputs on NEGEDGE to avoid setup violations
            @(negedge clk); 
            A = $random;
            B = $random;
            
            // Push expected result into queue
            expected_queue[queue_ptr_in] = A * B;
            queue_ptr_in = queue_ptr_in + 1;
            sent_count = sent_count + 1;

            $display("Time=%0t | [IN]  Cycle %0d: A=%d, B=%d", $time, i+1, A, B);
        end

        // Stop driving inputs after 50 tests
        @(negedge clk);
        A = 0; B = 0;
        
        // Wait for the pipeline to empty (Latency + buffer)
        #100;
        $finish;
    end

    // --- CHECKER BLOCK: Verifies outputs ---
    // This runs in parallel with the Driver
    initial begin
        // 1. Sync with Reset
        wait(rst == 0);
        
        // 2. Wait for Pipeline Latency (3 Cycles)
        // Cycle 1: Inputs clocked into Regs A/B
        // Cycle 2: Tree result clocked into Regs Sum/Carry
        // Cycle 3: Final Result clocked into Output Reg
        @(posedge clk); // End of Cycle 1
        @(posedge clk); // End of Cycle 2
        @(posedge clk); // End of Cycle 3 (Data is now valid at output)

        // 3. Start Checking
        while (queue_ptr_out < 50) begin
            // We check immediately after the positive edge where data became valid.
            // A small delay (#1) ensures we read the stable value after the clock edge.
            #1; 

            if (result !== expected_queue[queue_ptr_out]) begin
                $display("[FAIL] Time=%0t | [OUT] Cycle %0d: Expected=%d, Got=%d", 
                         $time, queue_ptr_out+1, expected_queue[queue_ptr_out], result);
                errors = errors + 1;
            end else begin
                $display("[PASS] Time=%0t | [OUT] Cycle %0d: Result=%d", 
                         $time, queue_ptr_out+1, result);
            end

            queue_ptr_out = queue_ptr_out + 1;

            // Wait for the NEXT clock edge to verify the next value
            @(posedge clk);
        end

        // Final Report
        $display("----------------------------------------------------------------");
        if (errors == 0) begin
            $display("SUCCESS: All 50 Pipelined Tests Passed!");
        end else begin
            $display("FAILURE: %d mismatches found.", errors);
        end
        $display("----------------------------------------------------------------");
    end

endmodule
