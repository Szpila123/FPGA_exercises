module BCD_ADD_SUB(input oper, input [7:0] word1, input[15:0] word2 , output [15:0] result);
wire [9:0] sub;
wire [14:0] buffer;
wire [2:0] carry;

// First num and carry
assign buffer[4:0] = oper ? {1'b0, word2[3:0]} - {1'b0, word1[3:0]} : {1'b0, word2[3:0]} + {1'b0, word1[3:0]};
assign carry[0] = buffer[4:0] > 5'b1001;

// Second num  and carry
assign buffer[9:5] = oper ? {1'b0, word2[7:4]} - {1'b0, word1[7:4]} - {4'b0, carry[0]} : {1'b0, word2[7:4]} + {1'b0, word1[7:4]} + {4'b0, carry[0]};
assign carry[1] = buffer[9:5] > 5'b1001;

// Third num and carry
assign buffer[14:10] =  oper ? {1'b0, word2[11:8]} - {4'b0, carry[1]} : {1'b0, word2[11:8]} + {4'b0, carry[1]};
assign carry[2] = buffer[14:10] > 5'b1001; 

// Results (and fourth num, without carry)
assign result[3:0] = carry[0] ? (oper ? buffer[4:0] + 5'b1010 : buffer[4:0] - 5'b1010) : buffer[4:0];
assign result[7:4] = carry[1] ? (oper ? buffer[9:5] + 5'b1010 : buffer[9:5] - 5'b1010) : buffer[9:5];
assign result[11:8] = carry[2] ? (oper ? buffer[14:10] + 5'b1010 : buffer[14:10] - 5'b1010) : buffer[14:10];
assign result[15:12] = oper ? {word2[15:12]} - {4'b0, carry[2]} : {1'b0, word2[15:12]} + {4'b0, carry[2]};
endmodule

module BCD_Calc(input rst, input [2:0] oper, input [7:0] in_nums, output [15:0] out_nums);

reg [15:0] memory;
wire [15:0] result;
wire [7:0] in_with_of;

assign in_with_of[3:0] = in_nums[3:0] > 4'b1001 ? 4'b1001 : in_nums[3:0];
assign in_with_of[7:4] = in_nums[7:4] > 4'b1001 ? 4'b1001 : in_nums[7:4];

BCD_ADD_SUB as1(.oper(oper[0]), .word1(in_with_of), .word2(memory), .result(result));

always @(posedge oper[1] or posedge rst)
begin
	if (rst) memory <= 15'h0;
	else
	begin
		memory <= result;
	end
end

assign out_nums = memory;

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

module Calculator(

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
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

genvar i;
wire [15:0] bcd_result;
wire [27:0] bcd_result_out;
wire [2:0] oper;
wire rst;

//=======================================================
//  Structural coding
//=======================================================

assign oper = {~KEY[2] | ~KEY[1], ~KEY[1]};
assign rst = ~KEY[3];

BCD_Calc bc1(.rst(rst), .oper(oper), .in_nums(SW[7:0]), .out_nums(bcd_result));
generate
	for (i = 0; i < 4; i = i + 1) begin : OUTPUT_GENERATION
		bcd_to_seg bts(.bcd(bcd_result[i*4 +:4]), .seg(bcd_result_out[i*7 +: 7]));
	end
endgenerate

bcd_to_seg input_0(.bcd(SW[3:0]), .seg(HEX0));
bcd_to_seg input_1(.bcd(SW[7:4]), .seg(HEX1));

assign HEX5 = bcd_result_out[27:21];
assign HEX4 = bcd_result_out[20:14];
assign HEX3 = bcd_result_out[13:7];
assign HEX2 = bcd_result_out[6:0];


endmodule
