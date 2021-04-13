`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 11:50:38 PM
// Design Name: 
// Module Name: four_adder
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


module four_adder(
        output[3:0] sum,
        output c_out,       // carry out
        input[3:0] a, b,    // operands
        input c_in);        // carry in
    
    wire [2:0] c_o;
    full_adder fa1(sum[0],c_o[0],a[0],b[0],c_in);
    full_adder fa2(sum[1],c_o[1],a[1],b[1],c_o[0]);
    full_adder fa3(sum[2],c_o[2],a[2],b[2],c_o[1]);
    full_adder fa4(sum[3],c_out,a[3],b[3],c_o[2]);
  
endmodule
