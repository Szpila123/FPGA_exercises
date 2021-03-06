// Bartosz Szpila
// 11.11.2021
// Implementation of stoper on Cyclon V FPGA

module BCD(input clk, rst, output [3:0] num, output next);
    reg [3:0] num_buf;
    reg next_buf;
    always @(posedge clk or posedge rst)
    begin
        next_buf <= rst == 1 ? 0 : num_buf == 9;

        num_buf <= rst == 1 ? 0 :
                   num_buf == 9 ? 0 : num_buf + 1;
    end
    assign num = num_buf;
    assign next = next_buf;
endmodule 

module stoper(input clk, rst, output [15:0] num);
    wire reset_all, reset_seconds, n1, n2;

    assign reset_all = rst | (num[15:12] == 9 & num[11:8] == 9);
    assign  reset_seconds = reset_all | (num[7:4] == 6);

    BCD b1(.clk(clk), .rst(rst), .num(num[3:0]), .next(n1));
    BCD b2(.clk(n1), .rst(reset_seconds), .num(num[7:4]), .next());

    BCD b3(.clk(reset_seconds), .rst(reset_all), .num(num[11:8]), .next(n2));
    BCD b4(.clk(n2), .rst(reset_all), .num(num[15:12]), .next());
endmodule

module seconds_clk(input clk, rst, output new_clk);
	reg [32:0] cnt;
	wire on;
	integer period = 50_000_000;

	always @(posedge clk or posedge rst)
	begin
		if (rst) cnt = 0;
		else cnt = (cnt == period) ? 1 : cnt + 1;
	end

	assign new_clk = (cnt == period);
endmodule

module bcd_to_seg(input [3:0] bcd, output [6:0] seg);
	function [6:0] convert(input [3:0] code);
		case(code)
			4'b0000: convert = 7'b1000000;
			4'b0001: convert = 7'b1111001;
			4'b0010: convert = 7'b0100100;
			4'b0011: convert = 7'b0110000;
			4'b0100: convert = 7'b0011001;
			4'b0101: convert = 7'b0010010;
			4'b0110: convert = 7'b0000010;
			4'b0111: convert = 7'b1111000;
			4'b1000: convert = 7'b0000000;
			4'b1001: convert = 7'b0010000;
			default: convert = 7'b1111111;
		endcase
	endfunction

	assign seg = convert(bcd);
endmodule

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Stoper(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire s_clk;
wire [15:0] out;
wire rst;

//=======================================================
//  Structural coding
//=======================================================

assign rst = ~KEY[0];

// Convert hardware clock to seconds clock
seconds_clk sc1(.clk(CLOCK_50), .rst(rst), .new_clk(s_clk));

// Stoper module
stoper stp1(.clk(s_clk), .rst(rst), .num(out));

// Convert bcd to seg
bcd_to_seg bts1(.bcd(out[3:0]), .seg(HEX0[6:0]));
bcd_to_seg bts2(.bcd(out[7:4]), .seg(HEX1[6:0]));
bcd_to_seg bts3(.bcd(out[11:8]), .seg(HEX2[6:0]));
bcd_to_seg bts4(.bcd(out[15:12]), .seg(HEX3[6:0]));

assign HEX4 = 'b1111111;
assign HEX5 = 'b1111111;

endmodule
