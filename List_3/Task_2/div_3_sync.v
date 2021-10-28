// Bartosz Szpila
// 28.10.2021
// Checks if number (in BCD format) is divisable by 3, synchronously

module rem_3(input [4:0] num, output [4:0] result);
    assign result = num < 5'h03 ? num     :
                    num < 5'h06 ? num - 3 :
                    num < 5'h09 ? num - 6 :
                    num - 9;
endmodule

module div_3(input [4:0] num, input clk, en, rst, output divisable);
    reg [4:0] segment;
    wire [4:0] reminder;

    rem_3 rem1(.num(segment + num), .result(reminder));
    always @(posedge clk or posedge rst)
    begin
        segment <= rst == 1 ? 0 :
                   en  == 1 ? reminder :
                   segment;
    end

    assign divisable = (segment == 0);
endmodule