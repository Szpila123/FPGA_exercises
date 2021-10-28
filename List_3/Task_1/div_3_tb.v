// Bartosz Szpila
// 28.10.2021

module testbench;
    integer i, j, k;
    parameter length = 4;
    reg [4*length:0] num;
    wire out;

    div_3 #(length) div2(.num(num), .divisable(out));

    initial begin
        num = 16'b0;

        for (k = 0; k < 10 ; k = k + 1)
        begin
            num[11:8] = k;
            for (j = 0; j < 10 ; j = j + 1)
            begin
                num[7:4] = j;
                for (i = 0; i < 10 ; i = i + 1)
                begin
                    num[3:0] = i;
                    #1;
                end
            end
        end

    end

    initial $monitor ($time, " out: %d, num: %h", out, num);
endmodule