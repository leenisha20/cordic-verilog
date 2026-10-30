`timescale 1ns/1ps
module tb_sweep;
    reg  signed [15:0] angle;
    wire signed [15:0] c, s;
    integer a;

    cordic_core #(.W(16), .N(14)) dut (.angle(angle), .cos_out(c), .sin_out(s));

    initial begin
        for (a = -25735; a <= 25735; a = a + 31) begin
            angle = a;
            #1;
            $display("%0d %0d %0d", a, c, s);
        end
        $finish;
    end
endmodule
