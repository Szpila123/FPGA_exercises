// Bartosz Szpila
// 20.10.2021

module pwm(input [15:0] top, comp, input clk, rst, pol, mode, output out, output [15:0] out_counter);
reg [15:0] counter;
reg up;

always @(posedge clk or posedge rst) begin
    if (rst == 1) begin 
        counter <= 0;
        up <= 1;
    end
    else begin
        if (mode == 0) counter <= (counter >= top) ? 16'b0 : counter + 1;
        else begin
            up <= (counter == top) ? 1'b0 : (counter == 16'b0) ? 1'b1 : up;
            counter <= (counter == top) ? counter - 1 :
                     (counter == 16'b0) ? counter + 1 : 
                     (up == 1) ? counter + 1 : counter - 1;
        end
    end
end

assign out = (pol == 1) ? counter < comp : ~(counter<comp);
assign out_counter = counter;
endmodule