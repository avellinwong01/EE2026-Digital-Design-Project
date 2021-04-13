`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2021 17:45:55
// Design Name: 
// Module Name: led_control
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

module led_control(
    input clk_3p125mhz,
    input [11:0]mic,
    output reg [3:0]lvl = 4'd0,
    output reg [`LDBIT:0]led = 16'h0000
    );

  always @ (posedge clk_3p125mhz) begin   
    if (mic > 2048 & mic <= 2200) begin lvl <=0; led <= 16'd0; end
    else if (mic > 2200 & mic <= 2325) begin lvl <=0; led <= 16'd1; end
    else if (mic > 2325 & mic <= 2450) begin lvl <=1; led <= 16'd3; end
    else if (mic > 2450 & mic <= 2575) begin lvl <=2; led <= 16'd7; end
    
    else if (mic > 2575 & mic <= 2700) begin lvl <=3; led <= 16'd15; end
    else if (mic > 2700 & mic <= 2825) begin lvl <=4; led <= 16'd31; end
    else if (mic > 2825 & mic <= 2950) begin lvl <=5; led <= 16'd63; end
    else if (mic > 2950 & mic <= 3075) begin lvl <=6; led <= 16'd127; end
    
    else if (mic > 3075 & mic <= 3200) begin lvl <=7; led <= 16'd255; end
    else if (mic > 3200 & mic <= 3325) begin lvl <=8; led <= 16'd511; end
    else if (mic > 3325 & mic <= 3450) begin lvl <=9; led <= 16'd1023; end
    else if (mic > 3450 & mic <= 3575) begin lvl <=10; led <= 16'd2047; end
    
    else if (mic > 3575 & mic <= 3700) begin lvl <=11; led <= 16'd4095; end
    else if (mic > 3700 & mic <= 3825) begin lvl <=12; led <= 16'd8191; end
    else if (mic > 3825 & mic <= 3950) begin lvl <=13; led <= 16'd16383; end
    else if (mic > 3950 & mic <= 4025) begin lvl <=14; led <= 16'd32767; end
    else if (mic > 4025) begin lvl <=15; led <= 16'd65535; end
    end

endmodule

