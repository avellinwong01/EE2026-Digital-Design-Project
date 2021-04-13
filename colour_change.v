`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 23:32:04
// Design Name: 
// Module Name: colour_change
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

module colour_change(
    input sw8, sw9, sw10, 
    input basys_clock, 
    output reg [`COLBIT:0] border_col, whole_col, vol_colTop, vol_colMid, vol_colBot
    );
    
    always @ (posedge basys_clock) begin 
        if (!sw8 && !sw9 && !sw10) begin 
            border_col <= `WHITE; 
            whole_col <= `BLACK; 
            vol_colTop <= `RED; 
            vol_colMid <= `YELLOW; 
            vol_colBot <= `GREEN; 
        end 
        
        else if (!sw8 && sw9 && !sw10) begin 
            border_col <= `RED; 
            whole_col <= `WHITE; 
            vol_colTop <= `BLUE; 
            vol_colMid <= `CYAN; 
            vol_colBot <= `MAGENTA; 
        end 
        else if (!sw8 && !sw9 && sw10) begin 
            border_col <= `BLUE;
            whole_col <= `GREY;
            vol_colTop <= `RED;
            vol_colMid <= `GREEN;
            vol_colBot <= `WHITE; 
        end  
        else if (sw8) begin // switch off volume bar
            border_col <= `WHITE; 
            whole_col <= `BLACK; 
            vol_colTop <= `BLACK; 
            vol_colMid <= `BLACK; 
            vol_colBot <= `BLACK;
        end 
    end 
    
endmodule
