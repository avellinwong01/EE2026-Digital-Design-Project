`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 17:29:53
// Design Name: 
// Module Name: volume_display
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

module volume_display(
    input [10:6]sw, 
    input basys_clock, clk_50hz,  
    input [`PIXELXYBIT:0] x, y, 
    input [3:0] vol_num, // 0 to 15
    input btnL, btnR, 
    output [`OLEDBIT:0] oled_data 
    );

    wire [`COLBIT:0] border_col, whole_col, vol_colTop, vol_colMid, vol_colBot; 
    wire [`OLEDBIT: 0] oled_border, oled_volume;
    wire [1:0] border_width; 
    assign border_width = (sw[6] ? 1 : (sw[7] ? 3: 0)); 
    // change border based on switch state 
    border b0 (border_col, whole_col, border_width, x, y, oled_border);   

    // change colour based on switch state 
    colour_change c0 (sw[8], sw[9], sw[10], basys_clock, border_col, whole_col, vol_colTop, vol_colMid, vol_colBot); 
    
    // change x_left and x_right by push button    
    reg [`PIXELXYBIT:0] x_left = 38, x_right = 57; // toggle based on push button 
    // default: x_left = 38, x_right = 57 
    always @ (posedge clk_50hz) begin 
        if (btnL && x_left - 8 > 0) begin 
            x_left <= x_left - 10; 
            x_right <= x_right - 10;  
        end 
        if (btnR && x_right + 10 < `WIDTH) begin 
            x_left <= x_left + 10; 
            x_right <= x_right + 10; 
        end 
    end 
    
    // instantiate volume_bar module 
    volume_bar v0 (whole_col, vol_colTop, vol_colMid, vol_colBot, basys_clock, x, y, x_left, x_right, vol_num, oled_volume); 
    // change oled screen with border and volume bar
    oled_screen s0 (x, y, border_width, oled_border, oled_volume, oled_data); 
    
    
endmodule
