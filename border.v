`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 15:36:00
// Design Name: 
// Module Name: border
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

module border(
    input [`COLBIT:0] border_col, whole_col,  
    input [1:0] border_width, // 1 pixel or 3 pixels thickness
    input [`PIXELXYBIT:0] x, y, 
    output [`OLEDBIT:0] oled_data 
    );
    
    // assign border colour if border width is not zero. Else assign whole screen colour 
    assign oled_data = (border_width && (x <= border_width - 1 || x >= `WIDTH - border_width || y <= border_width - 1 || y >= `HEIGHT - border_width)) ?
                                border_col : whole_col;
    
endmodule
