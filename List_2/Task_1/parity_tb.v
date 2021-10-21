// Bartosz Szpila
// 20.10.2021

module testbench;
    function automatic integer grey_code(input integer num);
        grey_code = num ^ (num >> 1);
    endfunction

    parameter length = 10;
    integer i;
    reg [length:0] num;
    wire out;

    parity_checker #(length) pc1(.num(num), .parity(out));

    initial begin
        for (i = 0; i < 2 ** length; i = i + 1) begin
            #1 num = grey_code(i);
        end

    end

    initial $monitor ($time, " code: %b, parity: %d", num, out);
endmodule
