`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 11:48:56 PM
// Design Name: 
// Module Name: six_adder
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


module six_adder(
        output[5:0] sum,
        output c_out,
        input[5:0] a, b,
        input c_in);
        
    wire [1:0] c_o;
    four_adder great_name(.sum(sum[3:0]), .c_out(c_o[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in)); 
    full_adder fa1(sum[4],c_o[1],a[4],b[4],c_o[0]); //1-bit adder
    full_adder fa2(sum[5],c_out,a[5],b[5],c_o[1]); //1-bit adder

endmodule
