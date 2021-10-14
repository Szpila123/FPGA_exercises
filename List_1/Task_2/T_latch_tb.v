
module testbench;
    reg rst, en, clk;
    wire out;

    t_latch t1(.rst(rst), .en(en), .clk(clk), .q(out));
    initial begin
        clk = 0;
        rst = 0;
        en = 0;

        #1 rst = 1;
        #1 rst = 0;

        #1 clk = 1;
        #1 clk = 0;

        #1 en = 1;
        #1 clk = 1;
        #1 clk = 0;
        en = 0;

        #1 clk = 1;
        #1 clk = 0;

        #1 en = 1;
        #1 clk = 1;
        #1 clk = 0;
        en = 0;

        #1 clk = 1;
        #1 clk = 0;

        #2 $finish;
    end
    initial $monitor ($time, " en=%d, rst=%d, clk=%d out=%d", en, rst, clk, out);
endmodule
