`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:37:27
// Design Name: 
// Module Name: my_d_flip_flop
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


module my_d_flip_flop(
    input D,
    input DFF_CLOCK,
    output reg Q = 0
    );
    
    always @ (posedge DFF_CLOCK) 
    begin 
        Q <= D; 
    end 
    
endmodule
