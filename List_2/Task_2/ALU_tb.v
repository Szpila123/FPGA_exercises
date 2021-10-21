// Bartosz Szpila
// 20.10.2021

module testbench;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [7:0] oper;
    reg [7:0] out_cmp;
    reg [7:0] mem[0:255];
    wire [7:0] out;
    integer i;

    ALU alu1(.num1(num1), .num2(num2), .oper(oper[2:0]), .result(out));

    initial begin
        $readmemh("hexfile.data", mem);
        for (i = 0; i < 255 ; i = i + 4)
        begin
            num1 = mem[i];
            num2 = mem[i + 1];
            oper = mem[i + 2];
            out_cmp = mem[i + 3];
            if (num1 == 8'hff & num2 == 8'hff & oper == 8'hff & out_cmp == 8'hff) i = 255;
            #1;
        end
    end

    initial $monitor ($time, " out: %b, expected %b, num1: %b, num2: %b, oper: %d", out, out_cmp, num1, num2, oper);
endmodule