// NCO: phase accumulator + quadrant folding + pipelined CORDIC
// freq_word: phase step per clock (65536 = one full circle)
// Output frequency = freq_word / 65536 * clock frequency
module nco (
    input  clk,
    input  rst_n,
    input  [15:0] freq_word,
    output reg signed [15:0] cos_out,
    output reg signed [15:0] sin_out,
    output valid_out
);
    reg [15:0] phase;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) phase <= 16'd0;
        else        phase <= phase + freq_word;
    end

    wire [1:0]  quad = phase[15:14];
    wire [13:0] p    = phase[13:0];

    // Map 0..16383 onto 0..pi/2 (25736 = pi/2 * 2^14)
    wire [31:0] prod = p * 16'd25736;
    wire signed [15:0] a = prod[29:14];

    wire signed [15:0] c, s;
    cordic_pipe #(.W(16), .N(14)) u_cordic (
        .clk(clk), .rst_n(rst_n), .valid_in(1'b1),
        .angle(a), .cos_out(c), .sin_out(s), .valid_out(valid_out)
    );

    // Delay the quadrant by the CORDIC latency (15 clocks)
    reg [29:0] qs;
    always @(posedge clk) qs <= {qs[27:0], quad};
    wire [1:0] q = qs[29:28];

    always @* begin
        case (q)
            2'd0: begin cos_out =  c; sin_out =  s; end
            2'd1: begin cos_out = -s; sin_out =  c; end
            2'd2: begin cos_out = -c; sin_out = -s; end
            default: begin cos_out =  s; sin_out = -c; end
        endcase
    end
endmodule
