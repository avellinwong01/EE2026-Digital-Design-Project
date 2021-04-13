`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 15:06:13
// Design Name: 
// Module Name: wave
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

module wave(
    input swclr, 
    input sw, freeze,
    input my_fast_clk,
    input [11:0] mic_in,
    input [`PIXELXYBIT:0] x, y,
    output [`OLEDBIT:0] oled_data
    );
    
    reg [11:0] mic_data [`WIDTH-1:0];
    integer i; 
    
    initial begin //setting arr to all 0
        for (i = 0; i < 96; i = i+1) begin
            mic_data[i] = 0; //per row, all 0s
        end
    end
    
    reg [`PIXELXYBIT:0] my_counter = 0; // iterating row by row, fr 0 to 95
    wire [5:0] num; // value from 0 to 63
    
    always @ (posedge my_fast_clk) begin 
        my_counter <= (my_counter == 95) ? 0 : my_counter + 1; //reset counter to 0 if hit 95
        mic_data[my_counter] <= freeze ? mic_data[my_counter] : ( (my_counter < 95)? mic_data[my_counter+1] : mic_in ); // if finish scanning all 96 rows, go back to start
    end
    
    //going into sub-module
    wave_location test_findmywave(swclr, sw, mic_data[x], y, oled_data);
    
endmodule
