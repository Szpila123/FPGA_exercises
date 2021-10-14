// Bartosz Szpila
// 10.10.2021
// Gate level modeling
// JK latch using D latch and mux 4

// Presentation 1 slide 43
module d_latch(input d, clk, output q, nq);
    wire na1, na2, na3, na4;

    nand (na1, na4, na2);
    nand (na2, na1, clk);
    nand (na3, na2, clk, na4);
    nand (na4, na3, d);
    nand (q, na2, nq);
    nand (nq, na3, q);
endmodule


module dec_24(input s1, s2, output o1, o2, o3, o4);
    wire ns1, ns2;

    not (ns1, s1);
    not (ns2, s2);

    and (o1, ns1, ns2);
    and (o2, ns1, s2);
    and (o3, s1, ns2);
    and (o4, s1, s2);
endmodule

// Presentation 1 slide 39
module mux_4(input i1, i2, i3, i4, s1, s2, output out);
   wire m1, m2, m3, m4;
   wire a1, a2, a3, a4;
   dec_24 dec1(.s1(s1), .s2(s2), .o1(m1), .o2(m2), .o3(m3), .o4(m4));
   and (a1, m1, i1);
   and (a2, m2, i2);
   and (a3, m3, i3);
   and (a4, m4, i4);
   or  (out, a1, a2, a3, a4);
endmodule 

// JK latch logic table
// clk | j | k | q
// ----------------
// -   | ? | ? | q
// -   | 0 | 0 | q
// -   | 0 | 1 | 0
// -   | 1 | 0 | 1
// -   | 1 | 1 | ~q
module jk_latch(input clk, j, k, output q);
   wire nq, buf_d;
   mux_4 mux1(.i1(q), .i2(1'b0), .i3(1'b1), .i4(nq), .s1(j), .s2(k), .out(buf_d));
   d_latch d1(.d(buf_d), .clk(clk), .q(q), .nq(nq));
endmodule

