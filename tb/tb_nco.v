`timescale 1ns/1ps
module tb_nco;
    reg clk = 0, rst_n = 0;
    wire signed [15:0] c, s;
    wire valid_out;

    nco dut (.clk(clk), .rst_n(rst_n), .freq_word(16'd1024),
             .cos_out(c), .sin_out(s), .valid_out(valid_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("nco.vcd");
        $dumpvars(0, tb_nco);
        repeat (3) @(posedge clk);
        rst_n = 1;
        repeat (300) @(posedge clk);
        $finish;
    end

    always @(posedge clk)
        if (valid_out) $display("%0d %0d", c, s);
endmodule
