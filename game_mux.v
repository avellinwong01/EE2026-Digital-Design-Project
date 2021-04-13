`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 12:01:40
// Design Name: 
// Module Name: game_mux
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


module game_mux(
    input basys_clock, 
    input [11:0] mic_in, 
    input clk_10hz, clk_1524hz, clk_50hz, clk_1hz, clk_15hz, clk_20khz, clk_3p125mhz, 
    input btnU, btnD, btnC, btnL, btnR, 
    input [`PIXELBIT:0] pixel_index, 
    input [`PIXELXYBIT:0] x, y, 
    output reg [`ANBIT:0] an = `CLR_AN, 
    output reg [`SEGBIT:0] seg = `CLR_SEG, 
    output reg [`OLEDBIT:0] oled_data = `BLACK
    );

    // Wires 
    wire [`ANBIT:0] an_rng, an_morse, an_freeze; 
    wire [`SEGBIT:0] seg_rng, seg_morse, seg_freeze; 
    wire [`OLEDBIT:0] oled_menu, oled_rng, oled_morse, oled_freeze; 
    wire [`LDBIT:0] led_freeze; 
    wire [2:0] state; // 0: default, 1: hammer, 2: key, 3: fpga
       
    // instantiate menu screen 
    game_pick_tool m0 (clk_50hz, x, y, btnU, btnD, oled_menu, state); 
    
    // instantiate 3 game modules 
    rng_main rng (basys_clock, clk_10hz, clk_1524hz, clk_50hz, clk_1hz, clk_15hz, btnC, btnU, pixel_index, an_rng, seg_rng, oled_rng); 
    morse_main morse (basys_clock, clk_10hz, clk_1524hz, clk_50hz, clk_1hz, btnC, btnU, btnD, pixel_index, an_morse, seg_morse, oled_morse);  
    freeze_main freeze (basys_clock, mic_in, clk_20khz, clk_1524hz, clk_50hz, clk_3p125mhz, clk_1hz, pixel_index, btnU, led_freeze, an_freeze, seg_freeze, oled_freeze); 
    
   
    reg [2:0] progress = 3'd0; // 0 to 3
    /*
    0 - menu selection screen
    1 - Hammer + RNG
    2 - Key + morse code password 
    3 - FPGA + mic scream/freeze 
    */
     
    always @ (posedge basys_clock) begin 
        if (progress == 0) begin // menu screen 
            an <= `CLR_AN; 
            seg <= `CLR_SEG; 
            oled_data <= oled_menu; 
            if (btnR && state == 1) progress = 1; // go to RNG
            else if (btnR && state == 2) progress = 2; // go to morse code  
            else if (btnR && state == 3) progress = 3; // go to mic scream/freeze
        end 
        else if (progress == 1) begin // RNG
            an <= an_rng; 
            seg <= seg_rng; 
            oled_data <= oled_rng; 
            if (btnL) progress = 0; // reset to menu
        end 
        else if (progress == 2) begin // morse code 
            an <= an_morse; 
            seg <= seg_morse; 
            oled_data <= oled_morse; 
            if (btnL) progress = 0; // reset to menu
        end 
        else if (progress == 3) begin // freeze 
            an <= an_freeze; 
            seg <= seg_freeze;
            oled_data <= oled_freeze; 
            if (btnL) progress = 0; // reset to menu 
        end 
    end 

endmodule
