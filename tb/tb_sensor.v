`timescale 1ns/1ps
module tb_sensor;
    reg clk = 0;
    reg valid_in = 0;
    reg [15:0] ch_a, ch_b;
    wire valid_out;
    wire signed [15:0] mag, ang;
    reg [15:0] A [0:9];
    reg [15:0] B [0:9];
    integer i;

    sensor_cordic dut (
        .clk(clk), .valid_in(valid_in), .ch_a(ch_a), .ch_b(ch_b),
        .valid_out(valid_out), .mag_out(mag), .ang_out(ang)
    );

    always #5 clk = ~clk;

    initial begin
        A[0]=65535; B[0]=0;
        A[1]=60000; B[1]=10000;
        A[2]=50000; B[2]=20000;
        A[3]=40000; B[3]=40000;
        A[4]=30000; B[4]=52000;
        A[5]=20000; B[5]=60000;
        A[6]=10000; B[6]=64000;
        A[7]=0;     B[7]=65535;
        A[8]=65535; B[8]=65535;
        A[9]=32768; B[9]=16384;

        for (i = 0; i < 10; i = i + 1) begin
            ch_a = A[i];
            ch_b = B[i];
            valid_in = 1;
            @(posedge clk);
            #1;
            if (valid_out)
                $display("a=%5d b=%5d | mag = %8.5f | angle = %9.4f deg",
                         ch_a, ch_b, mag / 16384.0,
                         ang / 16384.0 * 180.0 / 3.14159265358979);
        end
        valid_in = 0;
        $finish;
    end
endmodule
