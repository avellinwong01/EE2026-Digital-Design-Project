`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 22:39:03
// Design Name: 
// Module Name: oled_screen
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

module oled_screen(
    input [`PIXELXYBIT:0] x, y, 
    input [1:0] border_width, 
    input [`OLEDBIT: 0] oled_border, oled_volume, 
    output [`OLEDBIT:0] oled_data 
    );
    
    assign oled_data = (x < border_width || x >= `WIDTH - border_width || y < border_width || y >= `HEIGHT - border_width) ?
                                    oled_border : oled_volume;
        
endmodule
