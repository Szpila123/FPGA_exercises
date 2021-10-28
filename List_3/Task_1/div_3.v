// Bartosz Szpila
// 28.10.2021
// Checks if number (in BCD format) is divisable by 3

module rem_3(input [4:0] num, output [4:0] result);
    assign result = num < 5'h03 ? num     :
                    num < 5'h06 ? num - 3 :
                    num < 5'h09 ? num - 6 :
                    num - 9;
endmodule

module div_3(input [length*4:0] num, output divisable);
    parameter length = 2;
    genvar i;
    wire [4:0] segment[length:0];

    rem_3 r1(.num(num[3:0]), .result(segment[0]));
    for (i = 1; i < length ; i = i + 1) begin
       rem_3 r(.num(num[i*4+3:i*4] + segment[i-1]), .result(segment[i])) ;
    end

    assign divisable = (segment[length-1] == 0);
endmodule