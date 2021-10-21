module testbench;
    reg [15:0] top, comp;
    reg clk, rst, pol, mode; 
    wire out;
    wire [15:0] cnt;


    pwm pwm1(.top(top), .comp(comp), .clk(clk), .rst(rst), .pol(pol), .mode(mode), .out(out), .counter(cnt));
    initial begin
        clk = 0;
        pol = 0;
        mode = 0;
        top = 16'h0003;
        comp = 16'h0001;
        rst = 1;
        #1 rst = 0;
        repeat (16) #1 clk = ~clk;

        $display ("Mode change");
        mode = 1;
        rst = 1;
        #1 rst = 0;
        repeat (32) #1 clk = ~clk;

        $display ("Bigger top value");
        clk = 0;
        pol = 1;
        mode = 0;
        top = 16'h0010;
        comp = 16'h0001;
        rst = 1;
        #1 rst = 0;
        repeat (40) #1 clk = ~clk;

        $display ("Mode change");
        mode = 1;
        rst = 1;
        #1 rst = 0;
        repeat (66) #1 clk = ~clk;
    end

    initial $monitor ($time, " out: %b,clk: %b, cnt: %b", out, clk, cnt);
endmodule