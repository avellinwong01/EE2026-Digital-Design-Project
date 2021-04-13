`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 14:44:57
// Design Name: 
// Module Name: seg_control
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


module seg_control(
    input clk_1hz, fast_clk,
    input [11:0]mic, 
    input sw_f, sw_l, sw_c,
    output reg [`ANBIT:0]an,
    output reg [`SEGBIT:0]seg
    );
 
 reg [1:0]d_count = 2'd0;
 reg [`SEGBIT:0]letter = 7'd0;
 reg [`SEGBIT:0]b_num = 7'd0;
 reg [`SEGBIT:0]s_num = 7'd0;
 
 reg [`SEGBIT:0]n0 = 7'd0;
 reg [`SEGBIT:0]n1 = 7'd0;
 reg [`SEGBIT:0]n2 = 7'd0;
 reg [`SEGBIT:0]n3 = 7'd0;
 
 reg [`SEGBIT:0]h0 = 7'd0;
 reg [`SEGBIT:0]h1 = 7'd0;
 reg [`SEGBIT:0]h2 = 7'd0;
 reg [`SEGBIT:0]h3 = 7'd0;
 
 reg [4:0]l; //ALL 26 letters number L,M,H
 reg [3:0]b; //big no
 reg [3:0]s; //small no
 
 reg [3:0]fc; 
 
 always @ (posedge clk_1hz) begin
    fc <= (!sw_f)? 0: ((fc == 10)? 1: fc+1); 
    
        case (fc)
           0: begin h3 <= 7'b1111111; h2 <= 7'b1111111; h1 <= 7'b1111111; h0 <= 7'b1111111; end //0000
           1: begin h3 <= 7'b1111111; h2 <= 7'b1111111; h1 <= 7'b1111111; h0 <= 7'b1111111; end //0000
           2: begin h3 <= 7'b1111111; h2 <= 7'b1111111; h1 <= 7'b1111111; h0 <= 7'b0001110; end //000F
           3: begin h3 <= 7'b1111111; h2 <= 7'b1111111; h1 <= 7'b0001110; h0 <= 7'b0101111; end //00FR
           4: begin h3 <= 7'b1111111; h2 <= 7'b0001110; h1 <= 7'b0101111; h0 <= 7'b0000110; end //0FRE
           5: begin h3 <= 7'b0001110; h2 <= 7'b0101111; h1 <= 7'b0000110; h0 <= 7'b0000110; end //FREE
           6: begin h3 <= 7'b0101111; h2 <= 7'b0000110; h1 <= 7'b0000110; h0 <= 7'b0100100; end //REEZ
           7: begin h3 <= 7'b0000110; h2 <= 7'b0000110; h1 <= 7'b0100100; h0 <= 7'b0000110; end //EEZE
           8: begin h3 <= 7'b0000110; h2 <= 7'b0100100; h1 <= 7'b0000110; h0 <= 7'b1111111; end //EZE0
           9: begin h3 <= 7'b0100100; h2 <= 7'b0000110; h1 <= 7'b1111111; h0 <= 7'b1111111; end //ZE00
          10: begin h3 <= 7'b0000110; h2 <= 7'b1111111; h1 <= 7'b1111111; h0 <= 7'b1111111; end //E000
           endcase
 end  
    
 always @ (posedge fast_clk) begin  
    d_count <= d_count +1;
    
    case (d_count) //driver for print function
   
    0: begin //leftmost aka LMH
        an[0] <= 1; 
        an[3] <= 0;
 
        if (sw_f) seg[6:0] <= h3; //freeze first priority
        else if (sw_c) seg[6:0] <= n3;
        else if (sw_l) seg[6:0] <= `CLR_SEG; //letter switch
        else seg[6:0] <= letter;
        
        
    end
    
    1: begin //2nd fr left
        an[3] <= 1; 
        an[2] <= 0; //C 

        if (sw_f) seg[6:0] <= h2; 
        else if (sw_c) seg[6:0] <= n2;
        else seg[6:0] <= 7'b1111111; //(!sw_c)
        
         
    end
    2: begin 
        an[2] <= 1; 
        an[1] <= 0; //R 

        if (sw_f) seg[6:0] <= h1; 
        else if (sw_c) seg[6:0] <= n1;
        else seg[6:0] <= b_num; 
        
        
    end
    3: begin 
        an[1] <= 1; 
        an[0] <= 0; 
        if (sw_f) seg[6:0] <= h0; 
        else if (sw_c) seg[6:0] <= n0;
        else seg[6:0] <= s_num;
        
        
    end  
    endcase
    
    case (l)
    12: letter <= `CHAR_L; //L
    13: letter <= `CHAR_M; //M
    8:  letter <= `CHAR_H; //H
    endcase
    
    
     case (b)
       0: b_num <= `CLR_SEG; //L 
       1: b_num <= 7'b1111001; //M
      endcase
      
     case (s)
        0: s_num <= `DIG0; 
        1: s_num <= `DIG1; 
        2: s_num <= `DIG2; 
        3: s_num <= `DIG3; 
        4: s_num <= `DIG4; 
        5: s_num <= `DIG5; 
        6: s_num <= `DIG6; 
        7: s_num <= `DIG7;
        8: s_num <= `DIG8;
        9: s_num <= `DIG9;
       endcase 
   
    
        if (mic > 2048 & mic <= 2200) begin b <= 0; s <= 0; end
        else if (mic > 2200 & mic <= 2325) begin b <= 0; s <= 0; end
        else if (mic > 2325 & mic <= 2450) begin b <= 0; s <= 1; end
        else if (mic > 2450 & mic <= 2575) begin b <= 0; s <= 2; end
        
        else if (mic > 2575 & mic <= 2700) begin b <= 0; s <= 3; end
        else if (mic > 2700 & mic <= 2825) begin b <= 0; s <= 4; end
        else if (mic > 2825 & mic <= 2950) begin b <= 0; s <= 5; end
        else if (mic > 2950 & mic <= 3075) begin b <= 0; s <= 6; end
        
        else if (mic > 3075 & mic <= 3200) begin b <= 0; s <= 7; end
        else if (mic > 3200 & mic <= 3325) begin b <= 0; s <= 8; end
        else if (mic > 3325 & mic <= 3450) begin b <= 0; s <= 9; end
        else if (mic > 3450 & mic <= 3575) begin b <= 1; s <= 0; end
        
        else if (mic > 3575 & mic <= 3700) begin b <= 1; s <= 1; end
        else if (mic > 3700 & mic <= 3825) begin b <= 1; s <= 2; end
        else if (mic > 3825 & mic <= 3950) begin b <= 1; s <= 3; end
        else if (mic > 3950 & mic <= 4025) begin b <= 1; s <= 4; end
        else if (mic > 4025) begin b <= 1; s <= 5; end
                
          if (mic > 2048 & mic <= 2825) l <= 12;
          else if (mic > 2825 & mic <= 3575) l <= 13;    
          else if (mic > 3575) l <= 8;
      
 
         if (mic > 2048 & mic <= 2450) begin n3 <= 7'b0100001; n2 <= 7'b0000110; n1 <= 7'b0001000; n0 <= 7'b0001110; end //DEAF   
         else if (mic > 2450 & mic <= 2950) begin n3 <= 7'b0010010; n2<= 7'b1000000; n1 <= 7'b0001110; n0 <= 7'b0000111; end //SOFT         
         else if (mic > 2950 & mic <= 3575) begin n3 <= 7'b1000000; n2<= 7'b0001001; n1 <= 7'b0001000; n0 <= 7'b0010001; end //OKAY         
         else if (mic > 3575 & mic <= 4025) begin n3 <= 7'b1000111; n2<= 7'b1000000; n1 <= 7'b1000001; n0 <= 7'b0100001; end //LOUD       
         else if (mic > 4025) begin n3 <= 7'b0001000; n2<= 7'b0001000; n1 <= 7'b0001000; n0 <= 7'b0001000; end //AAAA
 

        end
endmodule
