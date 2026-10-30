// One CORDIC stage, vectoring mode: direction chosen by sign of y
module cordic_vstage #(
    parameter W = 16,
    parameter I = 0
)(
    input  signed [W-1:0] x_in,
    input  signed [W-1:0] y_in,
    input  signed [W-1:0] z_in,
    input  signed [W-1:0] angle,
    output signed [W-1:0] x_out,
    output signed [W-1:0] y_out,
    output signed [W-1:0] z_out
);
    wire y_neg = y_in[W-1];

    wire signed [W-1:0] x_shift = x_in >>> I;
    wire signed [W-1:0] y_shift = y_in >>> I;

    assign x_out = y_neg ? x_in - y_shift : x_in + y_shift;
    assign y_out = y_neg ? y_in + x_shift : y_in - x_shift;
    assign z_out = y_neg ? z_in - angle   : z_in + angle;
endmodule
