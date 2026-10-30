`timescale 1ns/1ps
module tb_cordic;
    reg  signed [15:0] angle;
    wire signed [15:0] c, s;
    integer deg;
    real rad;

    cordic_core #(.W(16), .N(14)) dut (.angle(angle), .cos_out(c), .sin_out(s));

    initial begin
        for (deg = -90; deg <= 90; deg = deg + 15) begin
            rad   = deg * 3.14159265358979 / 180.0;
            angle = $rtoi(rad * 16384.0);
            #10;
            $display("%4d deg | cos = %8.5f (exp %8.5f) | sin = %8.5f (exp %8.5f)",
                     deg, c / 16384.0, $cos(rad), s / 16384.0, $sin(rad));
        end
        $finish;
    end
endmodule
