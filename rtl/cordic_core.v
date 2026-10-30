// Combinational CORDIC: angle in -> cos, sin out
// All values are scaled by 2^14 (1.0 = 16384). Angle range: -pi/2 .. pi/2
module cordic_core #(
    parameter W = 16,
    parameter N = 14
)(
    input  signed [W-1:0] angle,
    output signed [W-1:0] cos_out,
    output signed [W-1:0] sin_out
);
    // atan(2^-i) scaled by 2^14 (from scripts/gen_table.py)
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

    wire signed [W-1:0] x [0:N];
    wire signed [W-1:0] y [0:N];
    wire signed [W-1:0] z [0:N];

    // Start: x = K (gain correction 0.60725 * 2^14), y = 0, z = target angle
    assign x[0] = 16'sd9949;
    assign y[0] = 16'sd0;
    assign z[0] = angle;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : stage
            cordic_stage #(.W(W), .I(i)) u (
                .x_in(x[i]),  .y_in(y[i]),  .z_in(z[i]),
                .angle(atan_lut(i)),
                .x_out(x[i+1]), .y_out(y[i+1]), .z_out(z[i+1])
            );
        end
    endgenerate

    assign cos_out = x[N];
    assign sin_out = y[N];
endmodule
