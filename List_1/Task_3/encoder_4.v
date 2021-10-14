// Bartosz Szpila
// 10.10.2021
// 4 encoder using two 2 encoders

module encoder_2(input v1, v2, output valid, num);
    wire nv1;
    or  (valid, v1, v2);
    not (nv1, v1);
    and (num, nv1, v2);
endmodule

module encoder_4(input v1, v2, v3, v4, output valid, num1, num2);
    wire valid1, valid2, onum1, onum2;
    encoder_2 enc1 (.v1(v1), .v2(v2), .valid(valid1), .num(onum1));
    encoder_2 enc2 (.v1(v3), .v2(v4), .valid(valid2), .num(onum2));

    or (valid, valid1, valid2);

    wire a1, a2;
    not (num1, valid1);
    and (a1, valid1, onum1);
    and (a2, num1, onum2);
    or  (num2, a1, a2);
endmodule
    
