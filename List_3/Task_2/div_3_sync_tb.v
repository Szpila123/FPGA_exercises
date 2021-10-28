// Bartosz Szpila
// 28.10.2021

module testbench;
    integer i;
    parameter length = 4;
    reg [4:0] num;
    reg clk, en, rst;
    wire out;

    div_3 div(.num(num), .clk(clk), .en(en), .rst(rst), .divisable(out));

    initial begin
        num = 4'b0;
        rst = 0;
        clk = 0;
        #1 rst = 1;
        #1 rst = 0;
        en = 1;

        for (i = 0; i < 9; i = i + 1)
        begin
            num = i;
            #1 clk = 1;
            #1 clk = 0;
        end

        en = 0;
        for (i = 0; i < 9; i = i + 1)
        begin
            num = i;
            #1 clk = 1;
            #1 clk = 0;
        end
    end

    initial $monitor ($time, " out: %d, num: %h, rst %b, clk %b, en %b", out, num, rst, clk, en);
endmodule