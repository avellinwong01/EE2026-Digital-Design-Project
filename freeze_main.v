`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 04:57:06 PM
// Design Name: 
// Module Name: freeze_main
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

module freeze_main (
    input basys_clock, 
    input [11:0] mic_in, 
    input clk_20khz, clk_1524hz, clk_50hz, clk_3p125mhz, clk_1hz, 
    input [`PIXELBIT:0] pixel_index,
    input btnU,
    output reg [`LDBIT:0]led = 16'b0,
    output reg [`ANBIT:0]an = `CLR_AN,
    output reg [`SEGBIT:0]seg = `CLR_SEG, 
    output reg [`OLEDBIT:0] oled_data = `BLACK
    );
    
    // BRAM images 
    reg [15:0] fpga_unlock [0:6143];
    reg [15:0] lose [0:6143]; 
    reg [15:0] win [0:6143]; 
    
    initial begin 
         $readmemh ("fpga_unlock.mem", fpga_unlock); 
         $readmemh ("lose.mem", lose); 
         $readmemh ("win.mem", win); 
    end 
  
    wire [3:0]an_mini;
    wire [6:0]seg_mini;
    wire [1:0]res;
    reg [2:0]m = 3'd0; //main state
  
    reg [1:0]d_count = 2'd0;
    wire [3:0]lvl;
    wire [15:0]led_out;   
        
  game_freeze testgame(basys_clock, clk_1524hz, clk_1hz, clk_20khz, clk_50hz, mic_in, btnU, an_mini, seg_mini, res);
  led_control test_led(clk_3p125mhz,mic_in,lvl,led_out);
      
always @ (posedge clk_50hz) begin 
    if (btnU) m<=0; 
     led <= led_out;
   

    case (m)
    0: begin 
        if (res==1) m<=1; 
        if (res==2) m<=2;
    end
    1: ; //LIVE
    2: ; //DEAD 
    endcase 
       
 end  
 
 always @ (posedge basys_clock) begin 
    case (m) 
    0: oled_data <= fpga_unlock[pixel_index]; 
    1: oled_data <= win[pixel_index]; 
    2: oled_data <= lose[pixel_index]; 
    endcase 
 end
    
 always @ (posedge clk_1524hz) begin
        d_count <= d_count +1;  
        
           
            case (d_count) //driver for print function
            
                 0: begin //leftmost 
                     an[0] <= 1; 
                     an[3] <= 0;
                     
                     if (m == 1) seg <= `CHAR_L;
                     else if (m == 2) seg <= `CHAR_D;
                     else if (m==0) seg <= seg_mini; //s>=2   
                 end
                 
                 1: begin //2nd fr left
                     an[3] <= 1; 
                     an[2] <= 0; //C 
       
                     if (m == 1) seg <= `CHAR_I;
                     else if (m == 2) seg <= `CHAR_E;
                     else if (m==0) seg <= seg_mini; //s>=2   
                 end
                 
                 2: begin 
                     an[2] <= 1; 
                     an[1] <= 0; //R 
       
                    if (m == 1) seg <= `CHAR_V;
                    else if (m == 2) seg <= `CHAR_A;
                    else if (m==0) seg <= seg_mini; //s>=2   
                 end
                 
                 3: begin 
                     an[1] <= 1; 
                     an[0] <= 0; 
                     
                    if (m == 1) seg <= `CHAR_E;
                    else if (m == 2) seg <= `CHAR_D;
                    else if (m==0) seg <= seg_mini; //s>=2   
                 end  
                 
                 endcase
        
      end 
        
  endmodule  
