`timescale 1ns/1ps
module tb_pipe;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg signed [15:0] angle = 0;
    wire signed [15:0] c, s;
    wire valid_out;
    integer k, out_idx;
    real rad_in, rad_out;

    cordic_pipe #(.W(16), .N(14)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .angle(angle), .cos_out(c), .sin_out(s), .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pipe.vcd");
        $dumpvars(0, tb_pipe);
        out_idx = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;
        for (k = 0; k < 13; k = k + 1) begin
            @(negedge clk);
            rad_in   = (-90 + 15 * k) * 3.14159265358979 / 180.0;
            angle    = $rtoi(rad_in * 16384.0);
            valid_in = 1;
        end
        @(negedge clk);
        valid_in = 0;
        repeat (20) @(posedge clk);
        $finish;
    end

    always @(posedge clk) begin
        if (valid_out) begin
            rad_out = (-90 + 15 * out_idx) * 3.14159265358979 / 180.0;
            $display("%4d deg | cos = %8.5f (exp %8.5f) | sin = %8.5f (exp %8.5f)",
                     -90 + 15 * out_idx, c / 16384.0, $cos(rad_out),
                     s / 16384.0, $sin(rad_out));
            out_idx = out_idx + 1;
        end
    end
endmodule
