`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 14:01:22
// Design Name: 
// Module Name: peak
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

module peak( // 1/20kHz per count; 
    input clk_20khz,
    input [11:0]mic, 
    input [31:0]m,
    output reg [11:0]peak
    );
 
  reg [31:0]count = 32'd0;
  reg [11:0]temp_peak = 12'd0;
  
  
   always @ (posedge clk_20khz) begin
    count <= count + 1; 
    
    if (mic > temp_peak) temp_peak <= mic;
    
    if (count == m) begin    
        peak <= temp_peak;
        count <= 32'd0;
        temp_peak <= 12'd0;
     end
          
   end
    
endmodule
