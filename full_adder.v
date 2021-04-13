`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 11:51:36 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    output sum,
    output c_out,   // carry out
    input a,
    input b,
    input c_in);    // carry in

wire sum1;
wire c_in1;
wire c_out2;
    half_adder ha1(sum1,c_in1,a,b);
    half_adder ha2(sum,c_out2,sum1,c_in);
    or(c_out,c_out2,c_in1);
endmodule
