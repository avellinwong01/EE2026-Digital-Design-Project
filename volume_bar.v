`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 15:52:31
// Design Name: 
// Module Name: volume_bar
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

module volume_bar(
    input [`COLBIT:0] whole_col, vol_colTop, vol_colMid, vol_colBot, 
    input basys_clock, 
    input [`PIXELXYBIT:0] x, y, 
    input [`PIXELXYBIT:0] x_left, x_right, // toggle based on push button 
    // default: x_left = 38, x_right = 57 
    input [3:0] vol_num, // 0 to 15 
    output reg [`OLEDBIT:0] oled_data 
    );
    
    wire x_range; 
    assign x_range = x >= x_left && x <= x_right; 
    
    wire [15:0] vol; // volume bar 

    assign vol[0] = 0;
    assign vol[1] = (vol_num >= 1 && (y <= `LVL1 && y >= `LVL1 - `LVLHEIGHT));
    assign vol[2] = (vol_num >= 2 && (y <= `LVL2 && y >= `LVL2 - `LVLHEIGHT));
    assign vol[3] = (vol_num >= 3 && (y <= `LVL3 && y >= `LVL3 - `LVLHEIGHT));
    assign vol[4] = (vol_num >= 4 && (y <= `LVL4 && y >= `LVL4 - `LVLHEIGHT));
    assign vol[5] = (vol_num >= 5 && (y <= `LVL5 && y >= `LVL5 - `LVLHEIGHT));
    assign vol[6] = (vol_num >= 6 && (y <= `LVL6 && y >= `LVL6 - `LVLHEIGHT));
    assign vol[7] = (vol_num >= 7 && (y <= `LVL7 && y >= `LVL7 - `LVLHEIGHT));
    assign vol[8] = (vol_num >= 8 && (y <= `LVL8 && y >= `LVL8 - `LVLHEIGHT));
    assign vol[9] = (vol_num >= 9 && (y <= `LVL9 && y >= `LVL9 - `LVLHEIGHT));
    assign vol[10] = (vol_num >= 10 && (y <= `LVL10 && y >= `LVL10 - `LVLHEIGHT));
    assign vol[11] = (vol_num >= 11 && (y <= `LVL11 && y >= `LVL11 - `LVLHEIGHT));
    assign vol[12] = (vol_num >= 12 && (y <= `LVL12 && y >= `LVL12 - `LVLHEIGHT));
    assign vol[13] = (vol_num >= 13 && (y <= `LVL13 && y >= `LVL13 - `LVLHEIGHT));
    assign vol[14] = (vol_num >= 14 && (y <= `LVL14 && y >= `LVL14 - `LVLHEIGHT));
    assign vol[15] = (vol_num >= 15 && (y <= `LVL15 && y >= `LVL15 - 1));
    
    always @ (posedge basys_clock) begin
        if (x_range && vol && vol_num > 0) begin
            if (vol[5:1])
                oled_data <= vol_colBot;
            if (vol[10:6])
                oled_data <= vol_colMid;
            if (vol[15:11]) 
                oled_data <= vol_colTop; 
        end else 
            oled_data <= whole_col;
    end
    
   
    
    
endmodule
