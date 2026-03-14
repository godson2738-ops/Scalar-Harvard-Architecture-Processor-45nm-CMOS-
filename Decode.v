module decode (
    input [31:0] instruction,
    input [7:0] reg_data1,  
    input [7:0] reg_data2,  
    output [4:0] reg_addr1, 
    output [4:0] reg_addr2, 
    output reg [7:0] A,     
    output reg [7:0] B      
);


assign reg_addr1 = instruction[9:5];  
assign reg_addr2 = instruction[4:0];  

always @(*) begin
    
    A = 8'b00000000;
    B = 8'b00000000;

   
    if (instruction[31:26] == 6'b000100) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b000101) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b000110) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b000111) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b001000) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b001001) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b001010) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b001011) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b001100) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b001101) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else if (instruction[31:26] == 6'b001110) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b001111) begin
        A = reg_data1;
        B = reg_data2;
    end
   
    else if (instruction[31:26] == 6'b010000) begin
        A = reg_data1;
        B = reg_data2;
    end
    
    else begin
        A = 8'b00000000;
        B = 8'b00000000;
    end
end


endmodule