// Bartosz Szpila
// 20.10.2021

module pwm(input [15:0] top, input [159:0] comp, input clk, rst, pol, mode, output [9:0] out);
reg [15:0] counter;
reg up;
genvar idx;

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

generate
	for (idx = 0; idx < 10; idx = idx + 1) begin : ASSIGN_GEN
		assign out[idx] = (pol == 1) ? counter < comp[idx * 16 + 15 : idx * 16] : ~(counter < comp[idx * 16 + 15 : idx * 16]);
	end
endgenerate

endmodule

module ms100_clk(input clk, rst, output new_clk);
	reg [32:0] cnt;
	wire on;
	integer period = 5_000_000;

	always @(posedge clk or posedge rst)
	begin
		if (rst) cnt <= 0;
		else cnt <= (cnt == period) ? 1 : cnt + 1;
	end

	assign new_clk = (cnt == period);
endmodule

module shift5to10(input [79:0] values, input clk, rst, output[159:0] out);
	reg [223:0] buffer;
	reg [4:0] counter;
	reg up;
	
	genvar idx;
	
	always @(posedge clk or posedge rst)
	begin
		if (rst) begin
			counter <= 0;
			up <= 0;
			buffer[79:0] <= counter;
			buffer[223:80] <= 0;
		end else begin
			counter <= counter == 10 ? 0 : counter + 1;
			up <= counter == 10 ? ~up : up;
			buffer[15:0] <= up ? 0 : buffer[31:16];
			buffer[223:208] <= up ? buffer[207:192] : 0;
			for (idx = 1; idx < 14; idx = idx + 1) begin
				buffer[idx * 16 + 15 -: 16] <= up ? buffer[(idx-1) * 16 + 15 -: 16] : buffer[(idx+1) * 16 + 15 -: 16];
			end
		end
	end

	assign out = buffer[191:32];
endmodule

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module CyclonEyes(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR
);


localparam [159:0] values = {
	16'h0100, 16'h0a00, 16'h4000, 16'h0a00, 
	16'h0100, 16'h0000, 16'h0000, 16'h0000, 
	16'h0000, 16'h0000};

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire new_clk;
wire [159:0] leds;

//=======================================================
//  Structural coding
//=======================================================

ms10_clk c1(.clk(CLOCK_50), .rst(0), .new_clk(new_clk));
shift5to10 s1(.clk(new_clk), .values(values), .rst(0), .out(leds));
pwm p1(.top(16'hffff), .comp(leds), .clk(CLOCK_50), .rst(0), .pol(1), .mode(0), .out(LEDR));


endmodule
