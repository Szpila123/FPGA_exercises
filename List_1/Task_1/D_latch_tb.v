module testbench;
    reg d, clk;
    wire out;

    d_latch d1(.d(d), .clk(clk), .q(out));
    initial begin
        clk = 0;
        d = 0;

        #1 d = 1;
        clk = 1;
        #1 clk = 0;
        d = 0;

        #2 d = 1;
        clk = 1;
        #1 d = 0;
        clk = 0;

        #2 clk = 1;
        #1 clk = 0;

        #2 clk = 1;
        #1 clk = 0;

        #2 $finish;
    end
    initial $monitor ($time, " d=%d, clk=%d out=%d", d, clk, out);
endmodule
