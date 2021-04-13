`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 10:44:35 AM
// Design Name: 
// Module Name: morse_game
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 04:29:36 PM
// Design Name: 
// Module Name: game_rng
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "definitions.vh"

module morse_game (
      input basys_clock, clk_50hz, clk_1524hz, clk_10hz, clk_1hz, 
      input btnC, btnU, btnD,
      output reg [3:0]an = 4'b1111,
      output reg [6:0]seg = 7'b1111111,
      output reg [2:0]print_combo = 3'd0
        );            
        
reg [3:0]rng = 4'd0; //0 to 9
reg [3:0]d0,d1,d2,d3;
reg [3:0]s = 4'd1; //state
reg [3:0]out_num0, out_num1, out_num2, out_num3;
reg [6:0]out_arr0, out_arr1, out_arr2, out_arr3;
reg [6:0]j_arr0, j_arr1, j_arr2, j_arr3;
reg [6:0]a_arr0, a_arr1, a_arr2, a_arr3;
reg [5:0]sum = 6'd0; 

reg [4:0]temp = 5'd0;
reg [3:0]temp_num = 4'd0; //storing digit 0 to 9 inclusive
reg [2:0]i = 3'd0; //0 to 4, reset at 5

reg [19:0]long_combo = 20'd0; //20 digit arr
reg [4:0]long_i = 5'd0; //0 to 20 

reg [1:0]d_count = 2'd0;
reg [1:0]count = 2'd0;
reg [4:0]print_count = 5'd0;

 
always @ (posedge clk_50hz) begin 
	
	if (btnC) begin temp[i] <= 1; long_combo[long_i] <= 1; i <= i+1; long_i <= long_i + 1; end 
	if (btnD) begin temp[i] <= 0; long_combo[long_i] <= 0; i <= i+1; long_i <= long_i + 1; end 

    if (btnU) begin s<=1; temp<=5'd0; i<=0; long_combo <= 20'd0; long_i<=0; print_combo <=0; end 
    if (i>4) begin s<=s+1; i<=0; end 
  
     
     
  if (s==10) begin      
        if (long_combo == {`SIX, `TWO, `ZERO, `TWO}) print_combo =1;
        else if (long_combo == {`ZERO, `SIX, `SIX, `TWO}) print_combo =2;
        else if (long_combo == {`SIX, `FOUR, `SIX, `FIVE}) print_combo =3;
        else print_combo = 4;
    end
    
   case (s)
      1: ; //key in 1st arr, wait for complete input
      2: begin out_num3 <= (s==2)? temp_num : out_num3; s <= 3; end //temp state to store n hold val
      3: ; //time to key in
      4: begin out_num2 <= (s==4)? temp_num : out_num2; s <= 5; end
      5: ; 
      6: begin out_num1 <= (s==6)? temp_num : out_num1; s <= 7; end
      7: ; 
      8: begin out_num0 <= (s==8)? temp_num : out_num0; s <= 10; end //JUMPING S=9

      10: ; // check if its 2026 or 2660 or 5646; then print as necessary
  
     endcase

 
 
 
   case (temp)
   `ZERO: temp_num <= 0;
   `ONE: temp_num <= 1;
   `TWO: temp_num <= 2;
   `THREE: temp_num <= 3;
   `FOUR: temp_num <= 4;
   `FIVE: temp_num <= 5;
   `SIX: temp_num <= 6;
   `SEVEN: temp_num <= 7;
   `EIGHT: temp_num <= 8;
   `NINE: temp_num <= 9;
   default temp_num <= 10;
    
   endcase
    
    case (out_num0)
            0: out_arr0 <= 7'b1000000; 
            1: out_arr0 <= 7'b1111001; 
            2: out_arr0 <= 7'b0100100; 
            3: out_arr0 <= 7'b0110000; 
            4: out_arr0 <= 7'b0011001; 
            5: out_arr0 <= 7'b0010010; 
            6: out_arr0 <= 7'b0000010; 
            7: out_arr0 <= 7'b1111000;
            8: out_arr0 <= 7'b0000000;
            9: out_arr0 <= 7'b0010000;
            10: out_arr0 <= `CHAR_A;
           endcase
           
     case (out_num1)
                   0: out_arr1 <= 7'b1000000; 
                   1: out_arr1 <= 7'b1111001; 
                   2: out_arr1 <= 7'b0100100; 
                   3: out_arr1 <= 7'b0110000; 
                   4: out_arr1 <= 7'b0011001; 
                   5: out_arr1 <= 7'b0010010; 
                   6: out_arr1 <= 7'b0000010; 
                   7: out_arr1 <= 7'b1111000;
                   8: out_arr1 <= 7'b0000000;
                   9: out_arr1 <= 7'b0010000;
                   10: out_arr1 <= `CHAR_A;
                  endcase
                  
    case (out_num2)
                          0: out_arr2 <= 7'b1000000; 
                          1: out_arr2 <= 7'b1111001; 
                          2: out_arr2 <= 7'b0100100; 
                          3: out_arr2 <= 7'b0110000; 
                          4: out_arr2 <= 7'b0011001; 
                          5: out_arr2 <= 7'b0010010; 
                          6: out_arr2 <= 7'b0000010; 
                          7: out_arr2 <= 7'b1111000;
                          8: out_arr2 <= 7'b0000000;
                          9: out_arr2 <= 7'b0010000;
                          10: out_arr2 <= `CHAR_A;
                         endcase
                         
     case (out_num3)
                                 0: out_arr3 <= 7'b1000000; 
                                 1: out_arr3 <= 7'b1111001; 
                                 2: out_arr3 <= 7'b0100100; 
                                 3: out_arr3 <= 7'b0110000; 
                                 4: out_arr3 <= 7'b0011001; 
                                 5: out_arr3 <= 7'b0010010; 
                                 6: out_arr3 <= 7'b0000010; 
                                 7: out_arr3 <= 7'b1111000;
                                 8: out_arr3 <= 7'b0000000;
                                 9: out_arr3 <= 7'b0010000;
                                 10: out_arr3 <= `CHAR_A;
                                endcase
                                                                       
                  
end


  always @ (posedge clk_1524hz) begin
       d_count <= d_count +1;  
    case (d_count) //driver for print function
    
         0: begin //leftmost 
             seg = (s>=3)? out_arr3 : 7'b1111111;   //s>=2   
         end
         
         1: begin //2nd fr left
            seg = (s>=5)? out_arr2 : 7'b1111111;   //s>=3  
         end
         
         2: begin 
            seg = (s>=7)? out_arr1 : 7'b1111111;   //s>=4
         end
         
         3: begin 
             seg = (s>=9)? out_arr0 : 7'b1111111;   
         end  
         
         endcase

end

endmodule

