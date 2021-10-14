
module testbench;
    reg v1, v2;
    wire valid, num;

    encoder_2 enc1(.v1(v1), .v2(v2), .valid(valid), .num(num));
    initial begin
        v1 = 0;
        v2 = 0;

        #1 v2 = 1;
        #1 v2 = 0;

        #1 v1 = 1;
        #1 v1 = 0;

        #1 v2 = 1;
        #1 v1 = 1;
        #1 v1 = 0;
        #2 $finish;
    end
    initial $monitor ($time, " v1=%d, v2=%d | num=%d valid=%d", v1, v2, num, valid);
endmodule
