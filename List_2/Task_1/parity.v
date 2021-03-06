// Bartosz Szpila
// 20.10.2021

module parity_checker(input [length:0] num, output parity);
    parameter length = 7;
    assign parity = ~^num;
endmodule