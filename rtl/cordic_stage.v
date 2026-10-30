// One CORDIC rotation stage (rotation mode, combinational)
module cordic_stage #(
    parameter W = 16,          // data width
    parameter I = 0            // stage index (shift amount)
)(
    input  signed [W-1:0] x_in,
    input  signed [W-1:0] y_in,
    input  signed [W-1:0] z_in,   // remaining angle
    input  signed [W-1:0] angle,  // atan(2^-I) for this stage
    output signed [W-1:0] x_out,
    output signed [W-1:0] y_out,
    output signed [W-1:0] z_out
);
    // If remaining angle is negative, rotate the other way
    wire z_neg = z_in[W-1];

    wire signed [W-1:0] x_shift = x_in >>> I;
    wire signed [W-1:0] y_shift = y_in >>> I;

    assign x_out = z_neg ? x_in + y_shift : x_in - y_shift;
    assign y_out = z_neg ? y_in - x_shift : y_in + x_shift;
    assign z_out = z_neg ? z_in + angle   : z_in - angle;
endmodule
