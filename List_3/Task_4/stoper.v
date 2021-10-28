// Bartosz Szpila
// 28.10.2021
// Implementation of stoper

module BCD(input clk, rst, output [3:0] num, output next);
    reg [3:0] num_buf;
    reg next_buf;
    always @(posedge clk or posedge rst)
    begin
        next_buf <= rst == 1 ? 0 : num_buf == 9;

        num_buf <= rst == 1 ? 0 :
                   num_buf == 9 ? 0 : num_buf + 1;
    end
    assign num = num_buf;
    assign next = next_buf;
endmodule 

module stoper(input clk, rst, output [15:0] num);
    wire reset_all, reset_seconds, n1, n2;

    assign reset_all = rst | (num[15:12] == 9 & num[11:8] == 9);
    assign  reset_seconds = reset_all | (num[7:4] == 6);

    BCD b1(.clk(clk), .rst(rst), .num(num[3:0]), .next(n1));
    BCD b2(.clk(n1), .rst(reset_seconds), .num(num[7:4]), .next());

    BCD b3(.clk(reset_seconds), .rst(reset_all), .num(num[11:8]), .next(n2));
    BCD b4(.clk(n2), .rst(reset_all), .num(num[15:12]), .next());
endmodule
