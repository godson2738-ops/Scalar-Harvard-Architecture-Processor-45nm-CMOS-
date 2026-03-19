module tb_nrd_without;
    reg [7:0] Q, M;
    wire [7:0] out, remainder;

    nrd_without uut (.Q(Q), .M(M), .out(out), .remainder(remainder));

    initial begin
       
        $dumpfile("nrd_without.vcd"); 
        $dumpvars(0, nrd_without_tb); 
        
        $display("Time | Q / M    | Output");
        $display("---------------------------");
        
        Q = 20; M = 3;  #10; $display("%4t | 20 / 3   | Q=%d, R=%d", $time, out, remainder);
        Q = 50; M = 7;  #10; $display("%4t | 50 / 7   | Q=%d, R=%d", $time, out, remainder);
        Q = 121; M = 11; #10; $display("%4t | 121 / 11 | Q=%d, R=%d", $time, out, remainder);
        
        
        Q = 91; M = 7;  #10; $display("%4t | 91 / 07  | Q=%d, R=%d ", $time, out, remainder);
        
        $finish;
    end
endmodule
