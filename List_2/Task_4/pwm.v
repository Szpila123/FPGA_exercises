// Bartosz Szpila
// 20.10.2021

module pwm(input [15:0] top, comp, input clk, rst, pol, mode, output out, output [15:0] counter);
reg [15:0] clock;
reg up;

always @(posedge clk or posedge rst) begin
    if (rst == 1) begin 
        clock <= 0;
        up <= 1;
    end
    else begin
        if (mode == 0) clock <= (clock >= top) ? 16'b0 : clock + 1;
        else begin
            up <= (clock == top) ? 1'b0 : (clock == 16'b0) ? 1'b1 : up;
            clock <= (clock == top) ? clock - 1 :
                     (clock == 16'b0) ? clock + 1 : 
                     (up == 1) ? clock + 1 : clock - 1;
        end
    end
end

assign out = (pol == 1) ? clock < comp : ~(clock<comp);
assign counter = clock;
endmodule