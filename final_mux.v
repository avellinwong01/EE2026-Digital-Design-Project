`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 17:11:11
// Design Name: 
// Module Name: final_mux
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

module final_mux(
    input basys_clock, 
    input sw1, 
    input [15:13]sw, 
    input [`LDBIT:0] led_mic, led_game,
    input [`ANBIT:0] an_mic, an_game, 
    input [`SEGBIT:0] seg_mic, seg_game, 
    input [`OLEDBIT:0] oled_volume, oled_wave, oled_game, 
    output reg [`LDBIT:0] led = 16'b0,
    output reg [`OLEDBIT:0] oled_data = `BLACK, 
    output reg [`ANBIT:0] an = `CLR_AN, 
    output reg [`SEGBIT:0] seg = `CLR_SEG
    );
    
    always @ (posedge basys_clock) begin 
        if (sw[15]) begin // mic and vol bar 
            led <= (sw1)? led : led_mic; 
            an <= an_mic; 
            seg <= seg_mic; 
            oled_data <= oled_volume; 
        end 
        else if (sw[14]) begin // mic and waveform generator
            led <= (sw1)? led : led_mic; // freeze LED if sw1 is on 
            an <= an_mic; 
            seg <= seg_mic; 
            oled_data <= oled_wave;  
        end
        else if (sw[13]) begin // arcade game 
            led <= led_game; 
            an <= an_game; 
            seg <= seg_game; 
            oled_data <= oled_game; 
        end 
    end 
endmodule
