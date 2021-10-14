module testbench;
    reg  i1, i2, i3, i4, s1, s2;
    wire out;

    mux_4 mux1(i1, i2, i3, i4, s1, s2, out);
    initial begin
        i1 = 0;
        i2 = 1;
        i3 = 0;
        i4 = 1;
        s1 = 0;
        s2 = 0;

        // i1
        #1 i1 = 1;

        // i2
        #1 s2 = 1;
        #1 i2 = 0;

        // i3
        #1 s2 = 0;
        s1 = 1;
        #1 i3 = 1;
        
        // i4
        #1 s2 = 1;
        #1 i4 = 0;



        #2 $finish;
    end
    initial $monitor ($time, " s1=%d, s2=%d, i1=%d, i2=%d, i3=%d, i4=%d, out=%d", s1, s2, i1, i2, i3, i4, out);
endmodule
