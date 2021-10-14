module testbench;
    reg clk, nclr;
    wire num1, num2, num3, num4; 
    integer i;

    counter_10 cnt(.clk(clk), .nclr(nclr), .num1(num1), .num2(num2), .num3(num3), .num4(num4));
    initial begin
        clk = 0;
        nclr = 0;
        #1 nclr = 1;

        for (i = 0; i < 20; i = i + 1) begin
            #1 clk <= ~clk;
        end


        #2 $finish;
    end
    initial $monitor ($time, " clk = %d | val = %d%d%d%d", clk, num1, num2, num3, num4);
endmodule
