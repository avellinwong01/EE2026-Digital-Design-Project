`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 10:05:19 PM
// Design Name: 
// Module Name: game_freeze
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

module game_freeze( 
      input basys_clock, clk_1524hz, clk_1hz, clk_20khz, clk_50hz, 
      input [11:0]mic, //actl mic_in
      input btnU,
      output reg [3:0]an = 4'hF,
      output reg [6:0]seg = 7'b1111111,
      output reg [1:0]res = 2'd0
        );
      
      reg [1:0]d_count = 2'd0;
      reg reset = 0;
      reg [3:0]count = 4'd0;
      reg [6:0]h0,h1,h2,h3 = 7'd0;
      reg [6:0]score = 7'd0;
      reg [6:0]b_num,s_num;
      reg [3:0]b,s;
      wire [11:0]peak_wire;
      reg [11:0]peak_out = 12'd0;
      reg one_try = 0;
      reg peak_a = 0; 
      reg [5:0]one_timer = 6'd0; 

 
     peak make_peak(clk_20khz, mic, 20000, peak_wire);   
          
     always @ (posedge clk_50hz) begin 
         one_timer <= (one_timer == 50)? 0: one_timer + 1;  
         count <= (one_timer != 50)? count: ((count==9)? 9: (btnU)? 1: count+1); 
         
         if (btnU) begin count<=1; res<=0; score <= 0; peak_out<=0; b<=0; s<=0; one_try<=0; end 
         if (count==9) begin if (b>=8) res<=1; else res<=2; end 
         
         if (count == 7) begin    
                   score <= (peak_out <2000)? 0: (peak_out > 3999)? 99: (peak_out - 2000)/20; 
                   
                   if (!one_try) begin peak_out <= peak_wire; one_try<=1; end
                   b <= score/10; 
                   s <= score%10; 
                 end
    
    end
    
    always @ (posedge clk_1524hz) begin         
         d_count <= d_count +1;
             
            case (count)
                0: begin h3 <= `BLANK; h2 <= `BLANK; h1 <= `BLANK; h0 <= `BLANK; end //nothing
                1: begin h3 <= `CHAR_R; h2 <= `CHAR_D; h1 <= `CHAR_Y; h0 <= `BLANK; reset <= 0; end //0RDY
                2: begin h3 <= `BLANK; h2 <= `BLANK; h1 <= `BLANK; h0 <= 7'b0110000; end//3
                3: h0 <= 7'b0100100;//2
                4: h0 <= 7'b1111001;//1 
                5: begin h2 <= `CHAR_G; h1 <= `CHAR_O; h0 <= `BLANK; end //Go
                6: ;//Go; 2048,4096 rescale to 0 to 100
                7: begin h3 <= `CHAR_T; h2 <= `CHAR_O; h1 <= `CHAR_P; h0 <= `CHAR_S; end //Stop
                8: begin h3 <= `BLANK; h2 <= b_num; h1 <= s_num; h0 <= `BLANK; end //disp score
                
                9: ; //nothing, to hold vals
    
            endcase
          
          
          case (b)
                    0: b_num <= 7'b1000000; 
                    1: b_num <= 7'b1111001; 
                    2: b_num <= 7'b0100100; 
                    3: b_num <= 7'b0110000; 
                    4: b_num <= 7'b0011001; 
                    5: b_num <= 7'b0010010; 
                    6: b_num <= 7'b0000010; 
                    7: b_num <= 7'b1111000;
                    8: b_num <= 7'b0000000;
                    9: b_num <= 7'b0010000;
                   endcase
          
          case (s)
                    0: s_num <= 7'b1000000; 
                    1: s_num <= 7'b1111001; 
                    2: s_num <= 7'b0100100; 
                    3: s_num <= 7'b0110000; 
                    4: s_num <= 7'b0011001; 
                    5: s_num <= 7'b0010010; 
                    6: s_num <= 7'b0000010; 
                    7: s_num <= 7'b1111000;
                    8: s_num <= 7'b0000000;
                    9: s_num <= 7'b0010000;
          endcase 
           
           case (d_count) //driver for print function
        
             0: begin //leftmost aka LMH
                 seg[6:0] <= h3;      
             end
             
             1: begin //2nd fr left
                 seg[6:0] <= h2;     
             end
             
             2: begin  
                 seg[6:0] <= h1;    
             end
             
             3: begin 
                 seg[6:0] <= h0;   
             end  
             
             endcase
             
         end
         
endmodule
