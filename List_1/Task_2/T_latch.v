// Bartosz Szpila
// 10.10.2021
// T latch using primitive directive

// T latch logic table
// clk | rst | en | q
// -------------------
//  ?  |  1  |  ? | 0
//  -  |  0  |  ? | q
//  r  |  0  |  0 | q
//  r  |  0  |  1 | ~q

primitive t_latch(q, clk, rst, en);
    output q;
    input clk, rst, en;
    reg q;

    table
    // clk  rst  en  :  q    q+
        ?    1   ?   :  ?  :  0  ;
       (?0)  0   ?   :  ?  :  -  ; // ignore changes on falling edge
       (1?)  0   ?   :  ?  :  -  ; 
        ?    0  (??) :  ?  :  -  ; // ignore changes when stable
        ?  (??)  ?   :  ?  :  -  ; // ignore reset changes 

       (01)  0   0   :  ?  :  -  ;

    // clk  rst  en  :  q  :  q+
       (01)  0   1   :  0  :  1  ;
       (01)  0   1   :  1  :  0  ;

    endtable
endprimitive
