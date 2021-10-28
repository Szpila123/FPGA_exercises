// Bartosz Szpila
// 28.10.2021

module testbench;
    wire [15:0] num;
    reg clk, rst;

    stoper s1(.clk(clk), .rst(rst), .num(num));

    initial begin
        rst = 0;
        clk = 0;
        #1 rst = 1;
        #1 rst = 0;

        repeat(16000) #1 clk = ~clk;

    end

    initial $monitor ($time, " %d%d:%d%d", num[15:12],  num[11:8], num[7:4], num[3:0]);
endmodule