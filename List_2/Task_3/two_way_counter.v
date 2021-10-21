// Bartosz Szpila
// 20.10.2021

module two_way_counter(input clk, rst, dir, zero, output reg [16:0] out);
    always @(posedge clk or posedge rst) 
        if (rst | zero) out <= 16'b0;
        else out <= (dir == 0) ? out + 1 : out - 1;
endmodule