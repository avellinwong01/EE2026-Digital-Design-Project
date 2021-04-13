`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M 
//
//  STUDENT A NAME: Jared Cheang 
//  STUDENT A MATRICULATION NUMBER: A0222660N
//
//  STUDENT B NAME: Wong Zi Xin, Avellin 
//  STUDENT B MATRICULATION NUMBER: A0225646B
//
//////////////////////////////////////////////////////////////////////////////////
`include "definitions.vh" 

module Top_Student (
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input basys_clock,
    input btnC, btnL, btnR, btnU, btnD, 
    input [15:0]sw,
    output [`LDBIT:0]led,
    output [`ANBIT:0] an, 
    output [`SEGBIT:0] seg, 
    output pmodoledrgb_cs, 
    output pmodoledrgb_sdin, 
    output pmodoledrgb_sclk, 
    output pmodoledrgb_d_cn, 
    output pmodoledrgb_resn,
    output pmodoledrgb_vccen,
    output pmodoledrgb_pmoden
    );

    // Clocks
    wire clk_20khz, clk6p25m, clk_100hz, clk_3p125mhz, clk_10hz, clk_381hz, clk_1hz, clk_50hz, clk_1524hz, clk_15hz; 
    clk_divider my_1524hz_clock(basys_clock,32808,clk_1524hz); 
    clk_divider my_15hz_clock(basys_clock,3333333,clk_15hz); 
    clk_divider my_50hz_clock (.basys_clock(basys_clock), .m(999999), .output_clk(clk_50hz));
    clk_divider my_3p125mhz_clock(basys_clock, 15, clk_3p125mhz); 
    clk_divider my_20khz_clock (.basys_clock(basys_clock), .m(2499), .output_clk(clk_20khz)); 
    clk_divider my_6p25Mhz_clock (.basys_clock(basys_clock), .m(7), .output_clk(clk6p25m));       
    clk_divider my_100hz_clock(basys_clock,499999,clk_100hz); 
    clk_divider my_10hz_clock(basys_clock,4999999,clk_10hz); 
    clk_divider my_381hz_clock(basys_clock,131233,clk_381hz); 
    clk_divider my_1hz_clock(basys_clock,49999999,clk_1hz);  

    // Single Pulses
    wire reset_pulse, leftpb_out, rightpb_out, uppb_out, downpb_out, centrepb_out; 
    my_debounced_single_pulse unit0 (.push_button(btnC), .dsp_clock(clk6p25m), .dsp_output(reset_pulse)); // reset button
    my_debounced_single_pulse left (.push_button(btnL), .dsp_clock(clk_50hz), .dsp_output(leftpb_out)); 
    my_debounced_single_pulse right (.push_button(btnR), .dsp_clock(clk_50hz), .dsp_output(rightpb_out)); 
    my_debounced_single_pulse up (.push_button(btnU), .dsp_clock(clk_50hz), .dsp_output(uppb_out)); 
    my_debounced_single_pulse down (.push_button(btnD), .dsp_clock(clk_50hz), .dsp_output(downpb_out)); 
    my_debounced_single_pulse centre (.push_button(btnC), .dsp_clock(clk_50hz), .dsp_output(centrepb_out)); 
   
    // Wires and Registers 
    wire [`ANBIT:0]an_mic, an_game;
    wire [`SEGBIT:0]seg_mic, seg_game;
    wire [11:0] signal; // change between peak or mic_in depends on switch 0 
    wire [11:0] mic_in; 
    wire [11:0] peak; 
    wire [`LDBIT:0]led_mic, led_game;
    wire [3:0] vol_num; //0 to 15
    wire [`OLEDBIT:0] oled_data, oled_wave, oled_volume, oled_game; 
    wire frame_begin, sending_pixels, sample_pixel, teststate; 
    wire [`PIXELBIT:0] pixel_index; 
    wire [2:0] state; 
    
    wire [`PIXELXYBIT:0] x; // 0 to 95
    wire [`PIXELXYBIT:0] y; // 0 to 63
    assign x = pixel_index % 96; 
    assign y = pixel_index / 96; 
    
    // Instantiation of Microphone 
    Audio_Capture test1(basys_clock,                  // 100MHz clock
         clk_20khz,                   // sampling clock, 20kHz
         J_MIC3_Pin3,                 // J_MIC3_Pin3, serial mic input
         J_MIC3_Pin1,            // J_MIC3_Pin1
         J_MIC3_Pin4,            // J_MIC3_Pin4, MIC3 serial clock
         mic_in    // 12-bit audio sample data
         );
            
    // Instantiation of Oled Display Module 
    Oled_Display my_oled_display (.clk(clk6p25m), .reset(reset_pulse), 
                                  .frame_begin(frame_begin), .sending_pixels(sending_pixels),
                                  .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), 
                                  .cs(pmodoledrgb_cs), .sdin(pmodoledrgb_sdin), .sclk(pmodoledrgb_sclk), 
                                  .d_cn(pmodoledrgb_d_cn), .resn(pmodoledrgb_resn), .vccen(pmodoledrgb_vccen), 
                                  .pmoden(pmodoledrgb_pmoden), .teststate(teststate));    
    
    /* 
    Microphone, Volume bar and Waveform Generator subsystem
    sw[10] change vol bar colour scheme 2
    sw[9] change vol bar colour scheme 1
    sw[8] turn off volume bar
    sw[7] vol bar - turn on border 3 pixel
    sw[6] vol bar - turn on border 1 pixel
    sw[5] waveform - change colour scheme for wave disp
    sw[4] waveform - toggle btwn 2 wave disp modes
    sw[3] mic - change to SOFT LOUD mode (can only be used if mic is peak, not mic_in) 
    sw[2] mic - LMH on off
    sw[1] freeze (only for waveform generator subsystem)  
    sw[0] mic - toggle read in peak or mic_in actual; 1 = mic_in, 0 = peak   
    */     
    assign signal = sw[0] ? mic_in : peak; 
    peak make_peak(clk_20khz, mic_in, 4000, peak);
    led_control l0 (clk_3p125mhz, signal, vol_num, led_mic);
    seg_control s0 (clk_1hz, clk_20khz, signal, sw[1], sw[2], sw[3], an_mic, seg_mic);
    volume_display v0 (sw[10:6], basys_clock, clk_50hz, x, y, vol_num, leftpb_out, rightpb_out, oled_volume);
    wave w0 (sw[5], sw[4], sw[1], clk_20khz, signal, x, y, oled_wave);
    
    // Arcade Game Subsystem 
    game_mux (basys_clock, mic_in, clk_10hz, clk_1524hz, clk_50hz, clk_1hz, clk_15hz, clk_20khz, clk_3p125mhz, uppb_out, downpb_out, 
            centrepb_out, leftpb_out, rightpb_out, pixel_index, x, y, an_game, seg_game, oled_game); 
 
    /* Overall System 
        sw[15] trigger vol bar system 
        sw[14] trigger waveform generator
        sw[13] trigger arcade game 
    */ 
    final_mux (basys_clock, sw[1], sw[15:13], led_mic, led_game, an_mic, an_game, seg_mic, seg_game, oled_volume, oled_wave, oled_game, 
                led, oled_data, an, seg); 

endmodule