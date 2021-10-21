module testbench;
    reg clk, rst, dir, zero; 
    wire [16:0] out;

    two_way_counter twc(.clk(clk), .rst(rst), .dir(dir), .zero(zero), .out(out));
    initial begin
        clk = 0;
        dir = 0;
        zero = 0;
        rst = 1;
        #1 rst = 0;

        repeat (32) #1 clk = ~clk;
        
        dir = 1;
        repeat (64) #1 clk = ~clk;

        #1 zero = 1;
        #1 clk = ~clk;
    end

    initial $monitor ($time, " out: %b, clk: %d", out, clk);
endmodule