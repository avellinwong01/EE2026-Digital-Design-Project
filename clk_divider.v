`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 15:54:25
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input basys_clock,
    input [31:0] m,
    output reg output_clk = 0
    );
    
    reg [31:0] count = 0; 
        
    always @ (posedge basys_clock) 
    begin 
        count <= (count == m) ? 0: (count + 1); 
        output_clk <= (count == 0) ? ~output_clk : output_clk; 
    end
    
endmodule
