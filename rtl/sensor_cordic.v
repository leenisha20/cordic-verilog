// Sensor-to-CORDIC wrapper: two unsigned 16-bit sensor channels in,
// magnitude and angle out (registered, with a valid flag).
// Channels are shifted right by 3 so the CORDIC never overflows.
// Angle = atan2(ch_b, ch_a) in radians * 2^14 (0 to ~90 degrees).
// Magnitude = sqrt(a^2 + b^2) / 8, in Q2.14.
module sensor_cordic (
    input  wire               clk,
    input  wire               valid_in,
    input  wire        [15:0] ch_a,
    input  wire        [15:0] ch_b,
    output reg                valid_out,
    output reg  signed [15:0] mag_out,
    output reg  signed [15:0] ang_out
);
    wire signed [15:0] x_s = {3'b000, ch_a[15:3]};
    wire signed [15:0] y_s = {3'b000, ch_b[15:3]};
    wire signed [15:0] mag_w, ang_w;

    cordic_vec #(.W(16), .N(14)) core (
        .x_in(x_s), .y_in(y_s), .mag_out(mag_w), .ang_out(ang_w)
    );

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in) begin
            mag_out <= mag_w;
            ang_out <= ang_w;
        end
    end
endmodule
