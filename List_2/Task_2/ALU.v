// Bartosz Szpila
// 20.10.2021

module ALU(input [7:0] num1, input [7:0] num2, input [2:0] oper, output [7:0] result);
    wire [7:0] w_result;
    assign w_result = (oper[1:0] == 0) ? num1 + num2 :
                      (oper[1:0] == 1) ? num1 - num2 :
                      (oper[1:0] == 2) ? num1 & num2 :
                      (oper[1:0] == 3) ? num1 | num2 :
                      8'h00;
    assign result = (oper[2] == 1) ? ~w_result : w_result;
endmodule