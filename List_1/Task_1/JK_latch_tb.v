module testbench;
    reg j, k, clk;
    wire out;

    jk_latch jk1(.j(j), .k(k), .clk(clk), .q(out));
    initial begin
        clk = 0;
        j = 0;
        k = 0;

        #1 j = 1;
        #1 clk = 1;
        #1 clk = 0;

        #1 j = 0;
        #1 clk = 1;
        #1 clk = 0;

        #2 k = 1;
        #1 clk = 1;
        #1 clk = 0;
        #1 k = 0;

        #1 j = 1;
        k = 1;
        #1 clk = 1;
        #1 clk = 0;
        j = 0;
        k = 0;

        #1 clk = 1;
        #1 clk = 0;

        #2 $finish;
    end
    initial $monitor ($time, " j=%d, k=%d, clk=%d out=%d", j, k, clk, out);
endmodule
