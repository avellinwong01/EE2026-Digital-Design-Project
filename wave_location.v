`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 15:01:45
// Design Name: 
// Module Name: wave_location
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

module wave_location(
    input swc, 
    input sw,
    input [11:0] mic_data,
    input [`PIXELXYBIT:0] y, //0 to 63
    output [`OLEDBIT:0] oled_data    
    );
    
    //depending on colour scale we can invert colours
    reg [15:0]GREEN = (swc)? `CYAN:`GREEN;
    reg [15:0]YELLOW = (swc)? `MAGENTA:`YELLOW;
    reg [15:0]RED = (swc)? `ORANGE:`RED;
   
   
   localparam hgt = 64; 
        localparam maxBar = 21;
     localparam pos_green = 10;
             localparam pos_yellow = 20;
             
    wire [6:0] y_symm;
    assign y_symm = hgt - 1 - y;

    reg [5:0] num, num_flip;
    reg green_zone, yel_zone, red_zone;
   

 always @ (*) begin
         
        if (sw) begin
                num = (mic_data[11] ? mic_data[10:5] : 0); 
                if (y_symm < num) begin
                        green_zone = (num >= 1 && num <= maxBar);
                    yel_zone = (num >= 1+maxBar && num <= 2*maxBar);
                        red_zone = (num >= 1+2*maxBar);
                end 
   
                else begin
                        green_zone = 0;
                    yel_zone = 0;
                     red_zone = 0;
                end 
                
         end  
                
        else begin
            num = mic_data[11:6]; 
              num_flip = num > hgt/2 ? num : hgt - num; 
           
            if (y_symm < num_flip && y_symm > hgt - num_flip) begin
                green_zone = (num_flip <= hgt/2 + pos_green && num_flip >= hgt/2 - pos_green);
                    yel_zone = !green_zone && (num_flip <= hgt/2 + pos_yellow && num_flip >= hgt/2 - pos_yellow);
                        red_zone = !yel_zone && (num_flip > hgt/2 + pos_yellow && num_flip < hgt/2 - pos_yellow);
            end 
            
            else begin
                green_zone = 0;
                 yel_zone = 0;
                red_zone = 0;
            end
            
        end
            
    end
    
    assign oled_data = green_zone ? GREEN : 
                         yel_zone ? YELLOW : 
                            red_zone ? RED :                   
                        sw && !num && !y_symm || 
                     !sw && num == hgt/2 && y_symm == hgt/2 ? 
                     `WHITE : `BLACK;
   
endmodule
