// 2-to-1 Multiplexer Building Block
module mux2x1_node (
    input  wire select_bit,
    input  wire in_0,
    input  wire in_1,
    output wire out_bit
);
    assign out_bit = select_bit ? in_1 : in_0; 
endmodule


// 8-Bit Pipelined Right Shifter
module pipe_right_shift_8b (
    input  wire clk,
    input  wire reset,      
    input  wire [7:0] din,  
    input  wire [2:0] shamt,
    output reg  [7:0] dout  
);

    // --- Combinational Output Wires (Pre-Register) ---
    wire [7:0] comb_out_s1;
    wire [7:0] comb_out_s2;
    wire [7:0] comb_out_s3;

    // --- Pipeline Registers ---
    reg [7:0] pipe_data_s1;
    reg [2:0] pipe_shamt_s1;

    reg [7:0] pipe_data_s2;
    reg [2:0] pipe_shamt_s2;

    

    mux2x1_node m1_b0 (.select_bit(shamt[0]), .in_0(din[0]), .in_1(din[1]), .out_bit(comb_out_s1[0]));
    mux2x1_node m1_b1 (.select_bit(shamt[0]), .in_0(din[1]), .in_1(din[2]), .out_bit(comb_out_s1[1]));
    mux2x1_node m1_b2 (.select_bit(shamt[0]), .in_0(din[2]), .in_1(din[3]), .out_bit(comb_out_s1[2]));
    mux2x1_node m1_b3 (.select_bit(shamt[0]), .in_0(din[3]), .in_1(din[4]), .out_bit(comb_out_s1[3]));
    mux2x1_node m1_b4 (.select_bit(shamt[0]), .in_0(din[4]), .in_1(din[5]), .out_bit(comb_out_s1[4]));
    mux2x1_node m1_b5 (.select_bit(shamt[0]), .in_0(din[5]), .in_1(din[6]), .out_bit(comb_out_s1[5]));
    mux2x1_node m1_b6 (.select_bit(shamt[0]), .in_0(din[6]), .in_1(din[7]), .out_bit(comb_out_s1[6]));
    mux2x1_node m1_b7 (.select_bit(shamt[0]), .in_0(din[7]), .in_1(1'b0),   .out_bit(comb_out_s1[7])); // MSB zero-pad

    // Stage 1 Flop
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pipe_data_s1  <= 8'd0;
            pipe_shamt_s1 <= 3'd0;
        end else begin
            pipe_data_s1  <= comb_out_s1;
            pipe_shamt_s1 <= shamt;
        end
    end


    mux2x1_node m2_b0 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[0]), .in_1(pipe_data_s1[2]), .out_bit(comb_out_s2[0]));
    mux2x1_node m2_b1 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[1]), .in_1(pipe_data_s1[3]), .out_bit(comb_out_s2[1]));
    mux2x1_node m2_b2 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[2]), .in_1(pipe_data_s1[4]), .out_bit(comb_out_s2[2]));
    mux2x1_node m2_b3 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[3]), .in_1(pipe_data_s1[5]), .out_bit(comb_out_s2[3]));
    mux2x1_node m2_b4 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[4]), .in_1(pipe_data_s1[6]), .out_bit(comb_out_s2[4]));
    mux2x1_node m2_b5 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[5]), .in_1(pipe_data_s1[7]), .out_bit(comb_out_s2[5]));
    mux2x1_node m2_b6 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[6]), .in_1(1'b0),            .out_bit(comb_out_s2[6])); // Zero-pad
    mux2x1_node m2_b7 (.select_bit(pipe_shamt_s1[1]), .in_0(pipe_data_s1[7]), .in_1(1'b0),            .out_bit(comb_out_s2[7])); // Zero-pad

    // Stage 2 Flop
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pipe_data_s2  <= 8'd0;
            pipe_shamt_s2 <= 3'd0;
        end else begin
            pipe_data_s2  <= comb_out_s2;
            pipe_shamt_s2 <= pipe_shamt_s1; // Propagate shift amount down the pipe
        end
    end


    mux2x1_node m3_b0 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[0]), .in_1(pipe_data_s2[4]), .out_bit(comb_out_s3[0]));
    mux2x1_node m3_b1 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[1]), .in_1(pipe_data_s2[5]), .out_bit(comb_out_s3[1]));
    mux2x1_node m3_b2 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[2]), .in_1(pipe_data_s2[6]), .out_bit(comb_out_s3[2]));
    mux2x1_node m3_b3 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[3]), .in_1(pipe_data_s2[7]), .out_bit(comb_out_s3[3]));
    mux2x1_node m3_b4 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[4]), .in_1(1'b0),            .out_bit(comb_out_s3[4])); // Zero-pad
    mux2x1_node m3_b5 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[5]), .in_1(1'b0),            .out_bit(comb_out_s3[5])); // Zero-pad
    mux2x1_node m3_b6 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[6]), .in_1(1'b0),            .out_bit(comb_out_s3[6])); // Zero-pad
    mux2x1_node m3_b7 (.select_bit(pipe_shamt_s2[2]), .in_0(pipe_data_s2[7]), .in_1(1'b0),            .out_bit(comb_out_s3[7])); // Zero-pad


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 8'd0;
        end else begin
            dout <= comb_out_s3;
        end
    end

endmodule
