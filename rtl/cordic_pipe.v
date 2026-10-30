// Pipelined CORDIC: one result per clock, latency = N+1 cycles
// Values scaled by 2^14 (1.0 = 16384). Angle range: -pi/2 .. pi/2
module cordic_pipe #(
    parameter W = 16,
    parameter N = 14
)(
    input  clk,
    input  rst_n,
    input  valid_in,
    input  signed [W-1:0] angle,
    output signed [W-1:0] cos_out,
    output signed [W-1:0] sin_out,
    output valid_out
);
    function signed [W-1:0] atan_lut;
        input integer i;
        begin
            case (i)
                0: atan_lut = 12868;
                1: atan_lut = 7596;
                2: atan_lut = 4014;
                3: atan_lut = 2037;
                4: atan_lut = 1023;
                5: atan_lut = 512;
                6: atan_lut = 256;
                7: atan_lut = 128;
                8: atan_lut = 64;
                9: atan_lut = 32;
                10: atan_lut = 16;
                11: atan_lut = 8;
                12: atan_lut = 4;
                13: atan_lut = 2;
                default: atan_lut = 1;
            endcase
        end
    endfunction

    reg signed [W-1:0] x_r [0:N];
    reg signed [W-1:0] y_r [0:N];
    reg signed [W-1:0] z_r [0:N];
    reg [N:0] v;

    // Input register
    always @(posedge clk) begin
        x_r[0] <= 16'sd9949;
        y_r[0] <= 16'sd0;
        z_r[0] <= angle;
    end

    // One register after every stage
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : stage
            wire signed [W-1:0] xo, yo, zo;
            cordic_stage #(.W(W), .I(i)) u (
                .x_in(x_r[i]), .y_in(y_r[i]), .z_in(z_r[i]),
                .angle(atan_lut(i)),
                .x_out(xo), .y_out(yo), .z_out(zo)
            );
            always @(posedge clk) begin
                x_r[i+1] <= xo;
                y_r[i+1] <= yo;
                z_r[i+1] <= zo;
            end
        end
    endgenerate

    // The valid flag moves down the pipe alongside the data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) v <= 0;
        else        v <= {v[N-1:0], valid_in};
    end

    assign cos_out   = x_r[N];
    assign sin_out   = y_r[N];
    assign valid_out = v[N];
endmodule
