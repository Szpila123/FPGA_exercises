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

module buf_latch(input [16:0] value, input clk, rst, output [16:0] out);
	reg [16:0] buffer;
	always @(posedge clk or posedge rst)
	begin
		if (rst) buffer <= 16'h0000;
		else buffer <= value;
	end 

	assign out = buffer;

endmodule

module shift5to10(input [79:0] values, input clk, rst, output[159:0] out);
	reg [4:0] counter;
	reg [2:0] latches_set = 2'b00;
	reg down;
	
	wire [223:0] in_latch;
	wire [223:0] out_latch;

	assign in_latch = latches_set != 2'b10 ? {values[79:0], 144'h0} : 
					  down ? 		   {out_latch[207:0], 16'h0000} :
					    	 		   {16'h0000, out_latch[223:16]};

	genvar idx;
	generate
	for (idx = 0; idx < 14; idx = idx + 1) begin : GENERATE_LATCHES
		buf_latch l(.value(in_latch[idx*16+15:idx*16]), .clk(clk), .rst(0), .out(out_latch[idx*16+15:idx*16]));
	end
	endgenerate
	
	always @(posedge clk or posedge rst)
	begin
		if (rst) begin
			counter <= 0;
			down <= 0;
			latches_set <= 0;
		end else begin
			counter <= latches_set != 2'b10 ? counter : counter == 8 ? 5'b0 : counter + 5'b1;
			down <= latches_set != 2'b10 ? down : counter == 8 ? ~down : down;
			latches_set <= latches_set[1] ? 2'b10 : 2'b11;
		end
	end

	assign out = out_latch[191:32];
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


localparam [79:0] values = {16'h0100, 16'h0a00, 16'h4000, 16'h0a00, 16'h0100};

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire new_clk;
wire [159:0] leds;

//=======================================================
//  Structural coding
//=======================================================

ms100_clk c1(.clk(CLOCK_50), .rst(0), .new_clk(new_clk));
shift5to10 s1(.clk(new_clk), .values(values), .rst(0), .out(leds));
pwm p1(.top(16'hffff), .comp(leds), .clk(CLOCK_50), .rst(0), .pol(1), .mode(0), .out(LEDR));


endmodule
