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

module morse_main(
    input basys_clock, clk_10hz, clk_1524hz, clk_50hz, clk_1hz, 
      input btnC, btnU, btnD,
      input [`PIXELBIT:0] pixel_index,
      output reg [3:0]an = `CLR_AN, 
      output reg [6:0]seg = `CLR_SEG, 
      output reg [`OLEDBIT:0] oled_data = `BLACK
    );
 
 // BRAM Images 
 reg [15:0] key_unlock [0:6143];
 reg [15:0] lose [0:6143]; 
 reg [15:0] win [0:6143]; 
 reg [15:0] jared [0:6143]; 
 reg [15:0] avellin [0:6143]; 
 
 initial begin 
      $readmemh ("key_unlock.mem", key_unlock); 
      $readmemh ("lose.mem", lose); 
      $readmemh ("win.mem", win); 
      $readmemh ("jared.mem", jared); 
      $readmemh ("avellin.mem", avellin); 
 end 
    
  reg [2:0]m = 3'd0; //main state
  reg [3:0]t = 4'd0; //t for top val
  reg [1:0]d_count = 2'd0;
  reg [4:0]print_count = 5'd0;
  
  reg [6:0]j_arr0, j_arr1, j_arr2, j_arr3;
  reg [6:0]a_arr0, a_arr1, a_arr2, a_arr3;
  
  wire [2:0]res;
  wire [3:0]an_mini;
  wire [6:0]seg_mini;
    
morse_game mini_morse(basys_clock,clk_50hz, clk_1524hz, clk_10hz, clk_1hz, btnC, btnU, btnD,an_mini,seg_mini,res);

always @ (posedge clk_1hz) begin
    if (m==2) t<= 9;
    if (m==3) t<= 11;

    print_count <= (m!=0 & t!=0)? ((print_count == t)? 1: print_count+1): 0; 
 end 

always @ (posedge clk_50hz) begin 
    if (btnU) m<=0; 

    case (m)
    0: begin 
    if (res==1) m<=1; 
    if (res==2) m<=2;
    if (res==3) m<=3;
    if (res==4) m<=4;
        end
    1: ; //HELLO
    2: ; //JARED
    3: ; //AVELLIN
    4: ; //FAIL   
    endcase      
 end   
 
 always @ (posedge basys_clock) begin 
     case (m) 
     0: oled_data <= key_unlock[pixel_index]; 
     1: oled_data <= win[pixel_index]; 
     2: oled_data <= jared[pixel_index]; 
     3: oled_data <= avellin[pixel_index];  
     4: oled_data <= lose[pixel_index]; 
     endcase
 end 

 always @ (posedge clk_1524hz) begin
        d_count <= d_count +1;  
 
  
  case (print_count)
        1: begin 
        j_arr3 <= `BLANK; j_arr2 <= `BLANK; j_arr1 <= `BLANK; j_arr0 <= `BLANK;
        a_arr3 <= `BLANK; a_arr2 <= `BLANK; a_arr1 <= `BLANK; a_arr0 <= `BLANK;
        end
        
        2: begin
        j_arr3 <= `BLANK; j_arr2 <= `BLANK; j_arr1 <= `BLANK; j_arr0 <= `CHAR_J;
        a_arr3 <= `CHAR_N; a_arr2 <= `BLANK; a_arr1 <= `BLANK; a_arr0 <= `BLANK;
        end
        
        3: begin
         j_arr3 <= `BLANK; j_arr2 <= `BLANK; j_arr1 <= `CHAR_J; j_arr0 <= `CHAR_A;
        a_arr3 <= `CHAR_I; a_arr2 <= `CHAR_N; a_arr1 <= `BLANK; a_arr0 <= `BLANK;    
        end
        
        4: begin
         j_arr3 <= `BLANK; j_arr2 <= `CHAR_J; j_arr1 <= `CHAR_A; j_arr0 <= `CHAR_R;
         a_arr3 <= `CHAR_L; a_arr2 <= `CHAR_I; a_arr1 <= `CHAR_N; a_arr0 <= `BLANK;   
        end
        
        5:begin
         j_arr3 <= `CHAR_J; j_arr2 <= `CHAR_A; j_arr1 <= `CHAR_R; j_arr0 <= `CHAR_E;
         a_arr3 <= `CHAR_L; a_arr2 <= `CHAR_L; a_arr1 <= `CHAR_I; a_arr0 <= `CHAR_N;   
        end
        
        6:begin
         j_arr3 <= `CHAR_A; j_arr2 <= `CHAR_R; j_arr1 <= `CHAR_E; j_arr0 <= `CHAR_D;
         a_arr3 <= `CHAR_E; a_arr2 <= `CHAR_L; a_arr1 <= `CHAR_L; a_arr0 <= `CHAR_I;   
        end
        7:begin
         j_arr3 <= `CHAR_R; j_arr2 <= `CHAR_E; j_arr1 <= `CHAR_D; j_arr0 <= `BLANK;
         a_arr3 <= `CHAR_V; a_arr2 <= `CHAR_E; a_arr1 <= `CHAR_L; a_arr0 <= `CHAR_L;   
        end
        8:begin
         j_arr3 <= `CHAR_E; j_arr2 <= `CHAR_D; j_arr1 <= `BLANK; j_arr0 <= `BLANK;
         a_arr3 <= `CHAR_A; a_arr2 <= `CHAR_V; a_arr1 <= `CHAR_E; a_arr0 <= `CHAR_L;   
        end
        9:begin
         j_arr3 <= `CHAR_D; j_arr2 <= `BLANK; j_arr1 <= `BLANK; j_arr0 <= `BLANK;
         a_arr3 <= `BLANK; a_arr2 <= `CHAR_A; a_arr1 <= `CHAR_V; a_arr0 <= `CHAR_E;   
        end
        10: begin
         a_arr3 <= `BLANK; a_arr2 <= `BLANK; a_arr1 <= `CHAR_A; a_arr0 <= `CHAR_V;
         end
         11: begin
         a_arr3 <= `BLANK; a_arr2 <= `BLANK; a_arr1 <= `BLANK; a_arr0 <= `CHAR_A;
         end   
        
        
        endcase
  
  
      
     case (d_count) //driver for print function
     
          0: begin //leftmost 
              if (m==0) begin an[1] <= 1; an[0] <= 0; end
              else begin an[0] <= 1; an[3] <= 0; end
              
              if (m == 1) seg <= `CHAR_H;
              else if (m == 2) seg <= j_arr3;
              else if (m == 3) seg <= a_arr3;
              else if (m == 4) seg <= `CHAR_F; 
              else if (m==0) seg <= seg_mini;//s>=2   
          end
          
          1: begin //2nd fr left
              if (m==0) begin an[0] <= 1; an[3] <= 0; end
              else begin an[3] <= 1; an[2] <= 0; end //C 

              if (m == 1) seg <= `CHAR_E;
              else if (m == 2) seg <= j_arr2;
              else if (m == 3) seg <= a_arr2;
              else if (m == 4) seg <= `CHAR_A;
              else if (m==0) seg <= seg_mini; //s>=2   
          end
          
          2: begin 
              if (m==0) begin an[3] <= 1; an[2] <= 0; end
              else begin an[2] <= 1; an[1] <= 0; end //R 

             if (m == 1) seg[6:0] <= `CHAR_L;
             else if (m == 2) seg[6:0] <= j_arr1;
             else if (m == 3) seg[6:0] <= a_arr1;
             else if (m == 4) seg[6:0] <= `CHAR_I;
             else if (m==0) seg <= seg_mini; //s>=2   
          end
          
          3: begin 
             if (m==0) begin an[2] <= 1; an[1] <= 0; end
             else begin an[1] <= 1; an[0] <= 0; end
              
             if (m == 1) seg[6:0] <= `CHAR_O;
             else if (m == 2) seg[6:0] <= j_arr0;
             else if (m == 3) seg[6:0] <= a_arr0;
             else if (m == 4) seg[6:0] <= `CHAR_L;
             else if (m==0) seg <= seg_mini; //s>=2   
          end  
          
          endcase
 
 end   
          
    
endmodule
