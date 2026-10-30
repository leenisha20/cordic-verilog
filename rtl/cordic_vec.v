// Combinational CORDIC, vectoring mode: (x, y) -> magnitude, angle
// Values scaled by 2^14. x_in must be >= 0. Angle output in radians * 2^14.
module cordic_vec #(
    parameter W = 16,
    parameter N = 14
)(
    input  signed [W-1:0] x_in,
    input  signed [W-1:0] y_in,
    output signed [W-1:0] mag_out,
    output signed [W-1:0] ang_out
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

    wire signed [W-1:0] x [0:N];
    wire signed [W-1:0] y [0:N];
    wire signed [W-1:0] z [0:N];

    assign x[0] = x_in;
    assign y[0] = y_in;
    assign z[0] = 16'sd0;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : stage
            cordic_vstage #(.W(W), .I(i)) u (
                .x_in(x[i]),  .y_in(y[i]),  .z_in(z[i]),
                .angle(atan_lut(i)),
                .x_out(x[i+1]), .y_out(y[i+1]), .z_out(z[i+1])
            );
        end
    endgenerate

    // Remove the CORDIC gain: multiply by 0.60725 (9949 / 2^14)
    wire signed [2*W-1:0] mag_full = x[N] * 16'sd9949;

    assign mag_out = mag_full >>> 14;
    assign ang_out = z[N];
endmodule
