
module testbench;
    reg v1, v2, v3, v4;
    wire valid, num1, num2;

    encoder_4 enc1(.v1(v1), .v2(v2), .v3(v3), .v4(v4), .valid(valid), .num1(num1), .num2(num2));
    initial begin
        v1 = 0;
        v2 = 0;
        v3 = 0;
        v4 = 0;

        #1 v2 = 1;
        #1 v2 = 0;

        #1 v4 = 1;
        #1 v4 = 0;

        #1 v2 = 1;
        #1 v1 = 1;
        #1 v1 = 0;
        #1 v4 = 1;
        #1 v3 = 1;
        #1 v2 = 0;
        #1 v3 = 0;
        #1 v1 = 1;

        #2 $finish;
    end
    initial $monitor ($time, " v1=%d, v2=%d, v3=%d v4=%d | num=2'b%d%d valid=%d", v1, v2, v3, v4, num1, num2, valid);
endmodule
