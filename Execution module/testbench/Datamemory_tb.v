`timescale 1ns / 1ps

module datamemory_tb();
    reg clk;
    reg write_en;
    reg [7:0]read_addr;
    reg [7:0]write_addr;
    reg [7:0]data_in;
    wire [7:0]data_out;

datamemory uut(
     .clk(clk),
     .write_en(write_en),
     .read_addr(read_addr),
     .write_addr(write_addr),
     .data_in(data_in),
     .data_out(data_out)
);

always #5 clk = ~clk;

initial begin
       
        clk = 0;
        write_en = 0;
        read_addr = 8'd0;
        write_addr = 8'd0;
        data_in = 8'h00;

       
        #15;
       
        
        @(negedge clk);
        write_en = 1;
        write_addr = 8'd10;    // Select Memory Address 10
        data_in = 8'hDE;       // Write Hex 'DE'
        
        @(negedge clk);
        write_addr = 8'd100;   // Select Memory Address 100
        data_in = 8'hAD;       // Write Hex 'AD'
        
        @(negedge clk);
        write_addr = 8'd255;   // Select Memory Address 255 (Max address)
        data_in = 8'hBE;       // Write Hex 'BE'
        
        @(negedge clk);
        write_en = 0;          // Turn off writing

     
        #10 read_addr = 8'd10;  // Should output DE
        #10 read_addr = 8'd100; // Should output AD
        #10 read_addr = 8'd255; // Should output BE
        #10 read_addr = 8'd50;  // Uninitialized memory (will output XX)

      
        #20 $finish;
    end

    initial begin
        $monitor("Time: %0t | Write_En: %b | W_Addr: %3d | Data_In: %h || R_Addr: %3d | Data_Out: %h", 
                 $time, write_en, write_addr, data_in, read_addr, data_out);
    end

endmodule
