`include "four_1_mux.v"
module rdcla_with_pipeline(A,B,clk,rst,out);
input [7:0]A,B;
input clk,rst;
output reg [8:0]out;

//stage 1
reg [17:0]kgp;
reg [7:0]A_s1,B_s1;

always @(posedge clk) begin
    if (rst) begin
        kgp <= 0;
        A_s1 <= 0;
        B_s1 <= 0;

    end
    else begin
        
         kgp[1:0] <= 2'b00;     
         kgp[3:2] <= {B[0],A[0]};
         kgp[5:4] <= {B[1],A[1]};
         kgp[7:6] <= {B[2],A[2]};
         kgp[9:8] <= {B[3],A[3]};
         kgp[11:10] <= {B[4],A[4]};
         kgp[13:12] <= {B[5],A[5]};
         kgp[15:14] <= {B[6],A[6]};
         kgp[17:16] <= {B[7],A[7]};

         A_s1 <= A;
         B_s1 <= B;
    end
    
end

// stage 2

reg [15:0]kgp1;
reg [7:0]A_s2,B_s2;
reg [1:0] c2;
wire [15:0]mux_1;

        four_1_mux m1(kgp[1:0],mux_1[3:2],kgp[3:2]);
        four_1_mux m2(kgp[3:2],mux_1[5:4],kgp[5:4]);
        four_1_mux m3(kgp[5:4],mux_1[7:6],kgp[7:6]);
        four_1_mux m4(kgp[7:6],mux_1[9:8],kgp[9:8]);
        four_1_mux m5(kgp[9:8],mux_1[11:10],kgp[11:10]);
        four_1_mux m6(kgp[11:10],mux_1[13:12],kgp[13:12]);
        four_1_mux m7(kgp[13:12],mux_1[15:14],kgp[15:14]);


always @(posedge clk) begin
    if (rst) begin
        kgp1 <= 0;
        A_s2 <= 0;
        B_s2 <= 0;
    end
    else begin

        
        kgp1 <= {mux_1[15:2],kgp[1:0]};
        c2 <= kgp[17:16];
        A_s2 <= A_s1;
        B_s2 <= B_s1;
    end
end  
 
 //stage 3

reg [15:0]kgp2;
reg [7:0]A_s3,B_s3;
reg [1:0]c3;
wire [15:0]mux_2;


        four_1_mux u1(kgp1[1:0],mux_2[5:4],kgp1[5:4]);
        four_1_mux u2(kgp1[3:2],mux_2[7:6],kgp1[7:6]);
        four_1_mux u3(kgp1[5:4],mux_2[9:8],kgp1[9:8]);
        four_1_mux u4(kgp1[7:6],mux_2[11:10],kgp1[11:10]);
        four_1_mux u5(kgp1[9:8],mux_2[13:12],kgp1[13:12]);
        four_1_mux u6(kgp1[11:10],mux_2[15:14],kgp1[15:14]);

always @(posedge clk) begin
    if (rst) begin
        kgp2 <= 0;
        A_s3 <= 0;
        B_s3 <= 0;
        c3 <= 0;
    end

    else begin
      
        kgp2 <= {mux_2[15:4],kgp1[3:0]};
        c3 <= c2;
        A_s3 <= A_s2;
        B_s3 <= B_s2;
    end
    
end
// stage 4

reg [15:0]kgp3;
wire [15:0]mux_3;
reg [7:0]A_s4,B_s4;
reg [1:0]c4;

four_1_mux w1(kgp2[1:0],mux_3[9:8],kgp2[9:8]);
        four_1_mux w2(kgp2[3:2],mux_3[11:10],kgp2[11:10]);
        four_1_mux w3(kgp2[5:4],mux_3[13:12],kgp2[13:12]);
        four_1_mux w4(kgp2[7:6],mux_3[15:14],kgp2[15:14]);

always @(posedge clk) begin
    if (rst) begin
        kgp3 <= 0;
        A_s4 <= 0;
        B_s4 <= 0;
        c4 <= 0;

    end
    
    else begin
        
        kgp3 <={mux_3[15:8],kgp2[7:0]};
        A_s4 <= A_s3;
        B_s4 <= B_s3;
        c4 <= c3;

    end
end

// 1 bit conversion

reg [7:0]kgp4;

always @(posedge clk) begin
    if (rst) begin
        out <= 9'b0;
        kgp4 <= 8'b0;
    end
    else begin
        kgp4[0]<=kgp3[1];
        kgp4[1]<=kgp3[3];
        kgp4[2]<=kgp3[5];
        kgp4[3]<=kgp3[7];
        kgp4[4]<=kgp3[9];
        kgp4[5]<=kgp3[11];
        kgp4[6]<=kgp3[13];
        kgp4[7]<=kgp3[15];

        out[0] = (A_s4[0]) ^ (B_s4[0]) ^ (kgp4[0]);
        out[1] = (A_s4[1]) ^ (B_s4[1]) ^ (kgp4[1]);
        out[2] = (A_s4[2]) ^ (B_s4[2]) ^ (kgp4[2]);
        out[3] = (A_s4[3]) ^ (B_s4[3]) ^ (kgp4[3]);
        out[4] = (A_s4[4]) ^ (B_s4[4]) ^ (kgp4[4]);
        out[5] = (A_s4[5]) ^ (B_s4[5]) ^ (kgp4[5]);
        out[6] = (A_s4[6]) ^ (B_s4[6]) ^ (kgp4[6]);
        out[7] = (A_s4[7]) ^ (B_s4[7]) ^ (kgp4[7]);

        if (c4==2'b00) begin
            out[8] <= 1'b0;
        end
        else if (c4==2'b11) begin
            out[8] <= 1'b1;
        end
        else begin
            out[8] <= kgp4[7];
        end
    end 

end


endmodule





