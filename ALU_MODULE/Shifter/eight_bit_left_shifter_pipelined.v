module mux2x1_logic (
    input  wire sel, 
    input  wire a, 
    input  wire b, 
    output wire q
);
    assign q = sel ? b : a; 
endmodule



module shift_left_8b_pipe (
    input  wire clk,
    input  wire reset,      
    input  wire [7:0] din,  
    input  wire [2:0] shamt,
    output reg  [7:0] dout  
);


    wire [7:0] stg1_mux_out;
    wire [7:0] stg2_mux_out;
    wire [7:0] stg3_mux_out;

  
    reg [7:0] reg_data_stg1;
    reg [2:0] reg_shamt_stg1;

    reg [7:0] reg_data_stg2;
    reg [2:0] reg_shamt_stg2;

    

    mux2x1_logic m1_0 (.sel(shamt[0]), .a(din[0]), .b(1'b0),   .q(stg1_mux_out[0]));
    mux2x1_logic m1_1 (.sel(shamt[0]), .a(din[1]), .b(din[0]), .q(stg1_mux_out[1]));
    mux2x1_logic m1_2 (.sel(shamt[0]), .a(din[2]), .b(din[1]), .q(stg1_mux_out[2]));
    mux2x1_logic m1_3 (.sel(shamt[0]), .a(din[3]), .b(din[2]), .q(stg1_mux_out[3]));
    mux2x1_logic m1_4 (.sel(shamt[0]), .a(din[4]), .b(din[3]), .q(stg1_mux_out[4]));
    mux2x1_logic m1_5 (.sel(shamt[0]), .a(din[5]), .b(din[4]), .q(stg1_mux_out[5]));
    mux2x1_logic m1_6 (.sel(shamt[0]), .a(din[6]), .b(din[5]), .q(stg1_mux_out[6]));
    mux2x1_logic m1_7 (.sel(shamt[0]), .a(din[7]), .b(din[6]), .q(stg1_mux_out[7]));

 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_data_stg1  <= 8'd0;
            reg_shamt_stg1 <= 3'd0;
        end else begin
            reg_data_stg1  <= stg1_mux_out;
            reg_shamt_stg1 <= shamt;
        end
    end


    mux2x1_logic m2_0 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[0]), .b(1'b0),             .q(stg2_mux_out[0]));
    mux2x1_logic m2_1 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[1]), .b(1'b0),             .q(stg2_mux_out[1]));
    mux2x1_logic m2_2 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[2]), .b(reg_data_stg1[0]), .q(stg2_mux_out[2]));
    mux2x1_logic m2_3 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[3]), .b(reg_data_stg1[1]), .q(stg2_mux_out[3]));
    mux2x1_logic m2_4 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[4]), .b(reg_data_stg1[2]), .q(stg2_mux_out[4]));
    mux2x1_logic m2_5 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[5]), .b(reg_data_stg1[3]), .q(stg2_mux_out[5]));
    mux2x1_logic m2_6 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[6]), .b(reg_data_stg1[4]), .q(stg2_mux_out[6]));
    mux2x1_logic m2_7 (.sel(reg_shamt_stg1[1]), .a(reg_data_stg1[7]), .b(reg_data_stg1[5]), .q(stg2_mux_out[7]));


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_data_stg2  <= 8'd0;
            reg_shamt_stg2 <= 3'd0;
        end else begin
            reg_data_stg2  <= stg2_mux_out;
            reg_shamt_stg2 <= reg_shamt_stg1; 
        end
    end

    mux2x1_logic m3_0 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[0]), .b(1'b0),             .q(stg3_mux_out[0]));
    mux2x1_logic m3_1 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[1]), .b(1'b0),             .q(stg3_mux_out[1]));
    mux2x1_logic m3_2 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[2]), .b(1'b0),             .q(stg3_mux_out[2]));
    mux2x1_logic m3_3 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[3]), .b(1'b0),             .q(stg3_mux_out[3]));
    mux2x1_logic m3_4 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[4]), .b(reg_data_stg2[0]), .q(stg3_mux_out[4]));
    mux2x1_logic m3_5 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[5]), .b(reg_data_stg2[1]), .q(stg3_mux_out[5]));
    mux2x1_logic m3_6 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[6]), .b(reg_data_stg2[2]), .q(stg3_mux_out[6]));
    mux2x1_logic m3_7 (.sel(reg_shamt_stg2[2]), .a(reg_data_stg2[7]), .b(reg_data_stg2[3]), .q(stg3_mux_out[7]));


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 8'd0;
        end else begin
            dout <= stg3_mux_out;
        end
    end

endmodule
