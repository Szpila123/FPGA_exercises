// Bartosz Szpila
// 10.10.2021
// Gate level modeling
// Counter using D latches

// Presentation 1 slide 43
module d_latch(input d, clk, nclr, output q, nq);
    wire na1, na2, na3, na4;

    nand (na1, na4, na2);
    nand (na2, na1, clk, nclr);
    nand (na3, na2, clk, na4);
    nand (na4, na3, d, nclr);
    nand (q, na2, nq);
    nand (nq, na3, q, nclr);
endmodule


module counter_10(input clk, nclr, output num1, num2, num3, num4);
    wire nq1, nq2, nq3, nq4, nclr1;
    wire singnal;
    nand (signal, num1, nq3, num3, nq1);
    and (nclr1, nclr, signal);
    d_latch d1(.d(nq1), .clk(clk), .q(num4), .nq(nq1), .nclr(nclr1));
    d_latch d2(.d(nq2), .clk(nq1), .q(num3), .nq(nq2), .nclr(nclr1));
    d_latch d3(.d(nq3), .clk(nq2), .q(num2), .nq(nq3), .nclr(nclr1));
    d_latch d4(.d(nq4), .clk(nq3), .q(num1), .nq(nq4), .nclr(nclr1));
endmodule
