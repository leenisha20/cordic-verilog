`timescale 1ns/1ps
module tb_vec;
    reg  signed [15:0] x, y;
    wire signed [15:0] mag, ang;
    integer deg, mi;
    real m, rad;

    cordic_vec #(.W(16), .N(14)) dut (
        .x_in(x), .y_in(y), .mag_out(mag), .ang_out(ang)
    );

    initial begin
        for (mi = 0; mi < 2; mi = mi + 1) begin
            m = 0.5 + 0.5 * mi;
            for (deg = -80; deg <= 80; deg = deg + 20) begin
                rad = deg * 3.14159265358979 / 180.0;
                x = $rtoi(m * $cos(rad) * 16384.0);
                y = $rtoi(m * $sin(rad) * 16384.0);
                #10;
                $display("m=%4.2f %4d deg in | mag = %8.5f (exp %8.5f) | angle = %9.4f deg (exp %4d)",
                         m, deg, mag / 16384.0, m,
                         ang / 16384.0 * 180.0 / 3.14159265358979, deg);
            end
        end
        $finish;
    end
endmodule
