// This is ongoing EEE 304 project Ladder and Snake Game's ongoing implementation under Apache License.
// © SM Haider Ali Shuvo 

module trial_2(input clk,push,switch,output [2:0] dice_live , output [3:0] state_1_live , state_2_live ,
		output [15:0] led_16_1,led_16_2 , output reg [1:0] winner);
	
	wire [2:0] dice;
	wire [3:0] added_1,added_2,state_1,state_2 , o_11 , o_12 , o_21 , o_22 , o_31 , o_32;
	reg T;
	always@(negedge switch) T<=~T;
	
	counter produce_dice(clk,switch,dice);
	adder do_addition(state_1,state_2,dice,T,added_1 , added_2);
	
	register R_11(push , added_1 , o_11);
	register R_12(push,added_2,o_12);
	
	overflow_control OF_1(state_1 , o_11 , o_21);
	overflow_control OF_2(state_2 , o_12 , o_22);
	
	ladder_snake LS_1(o_21,push,o_31);
	ladder_snake LS_2(o_22,push,o_32);
	
	decoder DEC_1(o_31,led_16_1);
	decoder DEC_2(o_32,led_16_2);
	
	register R_21(~switch,o_31,state_1);
	register R_22(~switch,o_32,state_2);
	
	
	assign dice_live = dice;
	assign state_1_live = state_1;
	assign state_2_live = state_2;	

	always@(negedge push) begin
		if(!(o_31 == 4'b1111) || !(o_32 == 4'b1111)) begin
			if( o_31 == 4'b 1111 ) winner = 2'b01;
			else if(o_32 == 4'b 1111) winner= 2'b10;
			else winner = 2'b00;
		end
	end
endmodule

module counter(input clk,E,output reg [2:0] count);

	always @(posedge clk) begin
		if(!E) begin
		count = count+1;
		if (count==7)
		count = 0;
		end
	end
	
endmodule 	

module adder(input [3:0] state0,state1 , input [2:0] dice, input T,output reg [3:0] result0,result1);
	
	always@(*) begin
		if(T) begin
		result1 = state1 + dice ;
		result0 = state0;
		end
		else if(T  == 0) begin 
		result0 = state0 + dice;
		result1 = state1;
		end
	end
	
endmodule 

module register(input clk,input [3:0] D ,output reg [3:0] Q);
	
	always@(posedge clk)
		
		Q<=D;
		
endmodule 

module overflow_control(input [3:0] state , added,
	output reg [3:0] result);
	
	always @(*) begin
	
		if (state>added) result = state;
		else if(state<added) result=added;
		else result = added;
		
	end
	
endmodule 

module ladder_snake(input [3:0] inn , input push ,

	output reg [3:0] outt);
	
	
	always @(*) begin
	
		if(push) outt=inn;
		
		else begin
		
		if(inn==3) outt=9;
		else if(inn==11) outt=0;
		else outt=inn;
		end
		
	end
	
endmodule 

module decoder(input [3:0] decoded,
	output reg [15:0] led);
	
	always@(*)begin
	
		led=0;
		
		led[decoded] = 1;
		
	end
	
endmodule 

