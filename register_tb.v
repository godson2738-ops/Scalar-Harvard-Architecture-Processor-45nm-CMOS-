`timescale 1ns / 1ps

module register_tb();
    reg clk;
    reg write_en;
    reg [4:0]read_inaddr;
    reg [4:0]write_inaddr;
    reg [7:0]data_in;
    wire [7:0]data_out;

register uut(
    .clk(clk),
    .write_en(write_en),
    .read_inaddr(read_inaddr),
    .write_inaddr(write_inaddr),
    .data_in(data_in),
    .data_out(data_out)
);

always #5 clk = ~clk;

initial begin
        
        clk = 0;
        write_en = 0;
        read_inaddr = 5'd0;
        write_inaddr = 5'd0;
        data_in = 8'h00;

        
        #15;

       
        
        @(negedge clk);
        write_en = 1;
        write_inaddr = 5'd5;   // Select Register 5
        data_in = 8'hAA;       // Write AA
        
        @(negedge clk);
        write_inaddr = 5'd10;  // Select Register 10
        data_in = 8'hBB;       // Write BB
        
        @(negedge clk);
        write_inaddr = 5'd31;  // Select Register 31 (Highest register)
        data_in = 8'hCC;       // Write CC
        
        @(negedge clk);
        write_en = 0;          // Turn off writing

        
        
        #10 read_inaddr = 5'd5;  // Should output AA
        #10 read_inaddr = 5'd10; // Should output BB
        #10 read_inaddr = 5'd31; // Should output CC
        #10 read_inaddr = 5'd0;  // Uninitialized register (will output XX)

        #20 $finish;
    end

 
    initial begin
        $monitor("Time: %0t | Write_En: %b | W_Addr: %2d | Data_In: %h || R_Addr: %2d | Data_Out: %h", 
                 $time, write_en, write_inaddr, data_in, read_inaddr, data_out);
    end

endmodule
