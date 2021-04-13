`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 10:46:01 AM
// Design Name: 
// Module Name: morse_main
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

module rng_main(
    input basys_clock, clk_10hz, clk_1524hz, clk_50hz, clk_1hz, clk_15hz, 
      input btnC, btnU,
      input [`PIXELBIT:0] pixel_index,
      output reg [3:0]an = `CLR_AN,
      output reg [6:0]seg = `CLR_SEG, 
      output reg [`OLEDBIT:0] oled_data = `BLACK
    );

// BRAM images 
 reg [15:0] hammer_unlock [0:6143];
 reg [15:0] lose [0:6143]; 
 reg [15:0] win [0:6143]; 
 
 initial begin 
      $readmemh ("hammer_unlock.mem", hammer_unlock); 
      $readmemh ("lose.mem", lose); 
      $readmemh ("win.mem", win); 
 end 
   
  reg [2:0]m = 3'd0; //main state
  reg [1:0]d_count = 2'd0;
  
  wire [2:0]res;
  wire [3:0]an_mini;
  wire [6:0]seg_mini;   
    
game_rng mini_rng(basys_clock,clk_10hz, clk_1524hz, clk_50hz, clk_15hz,btnC,btnU,an_mini,seg_mini,res);

always @ (posedge clk_50hz) begin 
    if (btnU) m<=0; 

    case (m)
    0: begin 
    if (res==1) m<=1; 
    if (res==2) m<=2;
        end
    1: ; //PASS
    2: ; //FAIL 
    endcase 
       
 end  
 
 always @ (posedge basys_clock) begin 
    case (m) 
    0: oled_data <= hammer_unlock[pixel_index]; // during the game
    1: oled_data <= win[pixel_index]; // success
    2: oled_data <= lose[pixel_index]; // failure 
    endcase 
 end   
  
 always @ (posedge clk_1524hz) begin
        d_count <= d_count +1;  
      
     case (d_count) //driver for print function 
     
          0: begin //leftmost 
              if (m==0) begin an[1] <= 1; an[0] <= 0; end
              else begin an[0] <= 1; an[3] <= 0; end
              
              if (m == 1) seg <= `CHAR_P;
              else if (m == 2) seg <= `CHAR_F; 
              else if (m==0) seg <= seg_mini;  
          end
          
          1: begin //2nd fr left
              if (m==0) begin an[0] <= 1; an[3] <= 0; end
              else begin an[3] <= 1; an[2] <= 0; end //C 

              if (m == 1) seg <= `CHAR_A;
              else if (m == 2) seg <= `CHAR_A;            
              else if (m==0) seg <= seg_mini;//s>=2   
          end
          
          2: begin 
              if (m==0) begin an[3] <= 1; an[2] <= 0; end
              else begin an[2] <= 1; an[1] <= 0; end //R 

             if (m == 1) seg[6:0] <= `CHAR_S;
             else if (m == 2) seg[6:0] <= `CHAR_I;
             else if (m==0) seg <= seg_mini;   //s>=2   
          end
          
          3: begin 
             if (m==0) begin an[2] <= 1; an[1] <= 0; end
             else begin an[1] <= 1; an[0] <= 0; end
              
             if (m == 1) seg[6:0] <= `CHAR_S;
             else if (m == 2) seg[6:0] <= `CHAR_L;
             else if (m==0) seg <= seg_mini; //s>=2   
          end  
          
          endcase
 
 end   
    
endmodule

