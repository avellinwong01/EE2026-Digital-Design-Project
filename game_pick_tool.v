`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 23:24:20
// Design Name: 
// Module Name: game_pick_tool
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

module game_pick_tool(
    input clk_50hz, 
    input [`PIXELXYBIT:0] x, y,  
    input btnU, btnD, 
    output reg [`OLEDBIT:0] oled_data, 
    output reg [2:0] state // 1: hammer, 2: key, 3: fpga
    );
    
    wire pick_tool_y, hammer_y, key_y, fpga_y; 
    wire pick_tool, hammer, key, fpga; 
    wire p1, i, c, k1, t, o1, o2, l, h, a1, m1, m2, e1, r, k2, e2, y1, f, p2, g, a2; 
    
    assign pick_tool_y = (y >= 5 && y <= 14); 
    assign hammer_y = (y >= 22 && y <= 31); 
    assign key_y = (y >= 35 && y <= 44); 
    assign fpga_y = (y >= 48 && y <= 58); 
    
    assign p1 = (pick_tool_y && x == 14) || (x >= 14 && x <= 19 && (y == 5 || y == 9)) || (x == 19 && y >= 5 && y <= 9); 
    assign i = (pick_tool_y && x == 25) || (x >= 22 && x <= 28 && (y == 5 || y == 14)); 
    assign c = (pick_tool_y && x == 31) || (x >= 31 && x <= 36 && (y == 5 || y == 14)); 
    assign k1 = (pick_tool_y && x == 39) || (x == 40 && y >= 8 && y <= 9) || (x == 41 && y >= 7 && y <= 10) || 
                (x == 42 && (y == 7 || y == 10 || y == 11)) || (x == 43 && (y >= 5 || y <= 7 || y == 11 || y == 12)) || 
                (x == 44 && (y == 5 || y == 12 || y == 13)) || (x == 45 && (y == 13 || y == 14)); 
    assign t = (pick_tool_y && x == 55) || (y == 5 && x >= 51 && x <= 58); 
    assign o1 = (pick_tool_y && (x == 61 || x == 67)) || (x >= 61 && x <= 67 && (y == 5 || y == 14)); 
    assign o2 = (pick_tool_y && (x == 70 || x == 76)) || (x >= 70 && x <= 76 && (y == 5 || y == 14)); 
    assign l = (pick_tool_y && x == 79) || (y == 14 && x >= 79 && x <= 85); 
    
    assign h = (hammer_y && (x == 11 || x == 17)) || (y == 26 && x >= 11 && x <= 17); 
    assign a1 = (hammer_y && (x == 21 || x == 27)) || (x >= 21 && x <= 27 && (y == 26 || y == 22)); 
    assign m1 = (hammer_y && (x == 31 || x == 37)) || (y >= 22 && y <= 24 && (x == 32 || x == 36)) || 
                (y >= 24 && y <= 26 && (x == 33 || x == 35)) || (y == 26 && (x >= 33 && x <= 35)); 
    assign m2 = (hammer_y && (x == 41 || x == 47)) || (y >= 22 && y <= 24 && (x == 42 || x == 46)) || 
                (y >= 24 && y <= 26 && (x == 43 || x == 45)) || (y == 26 && (x >= 43 && x <= 45)); 
    assign e1 = (hammer_y && x == 51) || (x >= 51 && x <= 56 && (y == 22 || y == 27 || y == 31)); 
    assign r = (hammer_y && x == 60) || (x >= 60 && x <= 65 && (y == 22 || y == 26)) || (x == 65 && y >= 22 && y <= 26) || 
                (x >= 61 && x <= 62 && y == 27) || (y >= 28 && y <= 29 && x == 62) || (x >= 63 && x <= 64 && y == 29) || 
                (x >= 64 && x <= 65 && y == 30) || (x >= 65 && x <= 66 && y == 31); 
    
    assign k2 = (key_y && x == 11) || (x == 12 && y >= 38 && y <= 40) || (x == 13 && (y >= 37 && y <= 38 || y >= 40 && y <= 42)) || 
                (x == 14 && (y >= 36 && y <= 37 || y >= 42 && y <= 43)) || (x == 15 && (y >= 35 && y <= 36 || y >= 43 && y <= 44)); 
    assign e2 = (key_y && x == 19) || (x >= 19 && x <= 24 && (y == 35 || y == 40 || y == 44)); 
    assign y1 = (x == 32 && y >= 39 && y <= 44) || (y >= 38 && y <= 39 && (x == 31 || x == 33)) || (y >= 37 && y <= 38 && (x == 30 || x == 34)) ||
                (y >= 35 && y <= 37 && (x == 29 || x == 35)) || (y == 35 && (x == 28 || x == 36)); 
    
    assign f = (fpga_y && x == 11) || (x >= 11 && x <= 16 && (y == 48 || y == 53)); 
    assign p2 = (fpga_y && x == 20) || (x >= 20 && x <= 26 && (y == 48 || y == 53)) || 
                (x == 26 && (y >= 48 && y <= 53)); 
    assign g = (fpga_y && x == 30) || (y == 48 && x >= 30 && x <= 37) || (y == 58 && x >= 30 && x <= 36) 
                || (x == 36 && y >= 55 && y <= 58) || (y == 54 && x >= 33 && x <= 37); 
    assign a2 = (fpga_y && (x == 41 || x == 47)) || (x >= 41 && x <= 47 && (y == 48 || y == 52)); 
    
    assign pick_tool = p1 || i || c || k1 || t || o1 || o2 || l; 
    assign hammer = h || a1 || m1 || m2 || e1 || r; 
    assign key = k2 || e2 || y1; 
    assign fpga = f || p2 || g || a2; 
    
    wire boxwidth, box1, box2, box3;  
    wire [15:0] display [0:3];
    
    assign boxwidth = x >= 0 && x <= 95; 
    // Each box is slightly taller than the letters themselves 
    assign box1 = boxwidth && (y >= 21 && y <= 32) && ~hammer; 
    assign box2 = boxwidth && (y >= 34 && y <= 45) && ~key; 
    assign box3 = boxwidth && (y >= 47 && y <= 59) && ~fpga; 
    
    assign display[0] = (pick_tool || hammer || key || fpga); 
    assign display[1] = (pick_tool || box1 || key || fpga); 
    assign display[2] = (pick_tool || hammer || box2 || fpga); 
    assign display[3] = (pick_tool || hammer || key || box3); 
    
    always @ (posedge clk_50hz) begin 
        state = btnU && state != 0 ? state - 1 : btnD && state != 3 ? state + 1 : state;
    end 
    
    always @ (*) begin 
        oled_data <= display[state] ? `WHITE: `BLACK; 
    end 
    
endmodule
