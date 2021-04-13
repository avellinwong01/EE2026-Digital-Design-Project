`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:40:46
// Design Name: 
// Module Name: my_debounced_single_pulse
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


module my_debounced_single_pulse(
    input push_button,
    input dsp_clock,
    output dsp_output
    );
    
    wire my_dff_out1; 
    wire my_dff_out2; 
    
    my_d_flip_flop unit1 (.D(push_button), .DFF_CLOCK(dsp_clock), .Q(my_dff_out1)); 
    my_d_flip_flop unit2 (.D(my_dff_out1), .DFF_CLOCK(dsp_clock), .Q(my_dff_out2)); 
    
   assign dsp_output = ~my_dff_out2 & my_dff_out1; 
    
endmodule
