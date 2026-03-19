module four_1_mux(kgp,Y,select_lines);
input [1:0]kgp,select_lines;
output reg[1:0]Y;

always @(*)
 begin
        case (select_lines)
            2'b00: Y=2'b00;
            2'b01: Y=kgp;
            2'b10: Y=kgp;
            2'b11: Y=2'b11; 
        endcase
    end
endmodule
