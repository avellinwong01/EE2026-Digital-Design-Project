`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 04:29:36 PM
// Design Name: 
// Module Name: game_rng
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

module game_rng (
      input basys_clock, clk_10hz, clk_1524hz, clk_50hz, clk_15hz, 
      input btnC,btnU,
      output reg [3:0]an = 4'b1111,
      output reg [6:0]seg = 7'b1111111,
      output reg [1:0]res = 2'd0
        );     
        
reg [3:0]rng = 4'd0; //0 to 9
reg [5:0]d0,d1,d2,d3; //changed fr [3:0] to [5:0]
reg [3:0]s = 4'd1; //state up to 16
reg [3:0]out_num0, out_num1, out_num2, out_num3;
reg [6:0]out_arr0, out_arr1, out_arr2, out_arr3;
reg [5:0]sum = 6'd0; 

reg [1:0]d_count = 2'd0;

 wire [5:0]sum1,sum2,sumf;
 wire ci1,ci2,ci3;
  six_adder test1(sum1,ci1,d0, d1,0);
  six_adder test2(sum2,ci2,d2,sum1,ci1);
  six_adder test3(sumf,ci3,d3,sum2,ci2);
 
always @ (posedge clk_15hz) begin
    rng <= {rng[2],rng[1],rng[0],~(rng[2]^rng[3])};
    
end 

always @ (posedge clk_50hz) begin    
    
    if (btnC & s<=4) s<=s+1; 
    if (btnU) begin s<=1; d3<=0; d2<=0; d1<=0; d0<=0; sum<=0; res<=0; end //added d3,2,1,0 <=0
  

   case (s) //added intermediate states
    1:  begin d3 <= (s==1)? rng:d3; out_num3 <= d3;  end
    2:  begin d2 <= (s==2)? rng:d2; out_num2 <= d2;  end //if (cb) s<=3; end s==2
    3:  begin d1 <= (s==3)? rng:d1; out_num1 <= d1;  end //if (cb) s<=4; end   s==3       
    4:  begin d0 <= (s==4)? rng:d0; out_num0 <= d0;  end //if (cb) s<=5; end   s==4              
    5:  begin sum = sumf; if (sum >= 25) res <=1; else res<=2; end 
    endcase
    
    case (out_num0)
            0: out_arr0 <= 7'b1000000; 
            1: out_arr0 <= 7'b1111001; 
            2: out_arr0 <= 7'b0100100; 
            3: out_arr0 <= 7'b0110000; 
            4: out_arr0 <= 7'b0011001; 
            5: out_arr0 <= 7'b0010010; 
            6: out_arr0 <= 7'b0000010; 
            7: out_arr0 <= 7'b1111000;
            8: out_arr0 <= 7'b0000000;
            9: out_arr0 <= 7'b0010000;
           endcase
           
     case (out_num1)
                   0: out_arr1 <= 7'b1000000; 
                   1: out_arr1 <= 7'b1111001; 
                   2: out_arr1 <= 7'b0100100; 
                   3: out_arr1 <= 7'b0110000; 
                   4: out_arr1 <= 7'b0011001; 
                   5: out_arr1 <= 7'b0010010; 
                   6: out_arr1 <= 7'b0000010; 
                   7: out_arr1 <= 7'b1111000;
                   8: out_arr1 <= 7'b0000000;
                   9: out_arr1 <= 7'b0010000;
                  endcase
                  
    case (out_num2)
                          0: out_arr2 <= 7'b1000000; 
                          1: out_arr2 <= 7'b1111001; 
                          2: out_arr2 <= 7'b0100100; 
                          3: out_arr2 <= 7'b0110000; 
                          4: out_arr2 <= 7'b0011001; 
                          5: out_arr2 <= 7'b0010010; 
                          6: out_arr2 <= 7'b0000010; 
                          7: out_arr2 <= 7'b1111000;
                          8: out_arr2 <= 7'b0000000;
                          9: out_arr2 <= 7'b0010000;
                         endcase
                         
     case (out_num3)
                                 0: out_arr3 <= 7'b1000000; 
                                 1: out_arr3 <= 7'b1111001; 
                                 2: out_arr3 <= 7'b0100100; 
                                 3: out_arr3 <= 7'b0110000; 
                                 4: out_arr3 <= 7'b0011001; 
                                 5: out_arr3 <= 7'b0010010; 
                                 6: out_arr3 <= 7'b0000010; 
                                 7: out_arr3 <= 7'b1111000;
                                 8: out_arr3 <= 7'b0000000;
                                 9: out_arr3 <= 7'b0010000;
                                endcase                
                  
end


    always @ (posedge clk_1524hz) begin
       d_count <= d_count +1;  

    case (d_count) //driver for print function
    
         0: begin //leftmost 
             an[0] <= 1; 
             an[3] <= 0;

             seg[6:0] <= (s>=1)? out_arr3 : 7'b1111111;   //s>=2   
         end
         
         1: begin //2nd fr left
             an[3] <= 1; 
             an[2] <= 0; //C 

             seg[6:0] <= (s>=2)? out_arr2 : 7'b1111111;   //s>=3  
         end
         
         2: begin 
             an[2] <= 1; 
             an[1] <= 0; //R          
           
            seg[6:0] <= (s>=3)? out_arr1 : 7'b1111111;   //s>=4
         end
         
         3: begin 
             an[1] <= 1; 
             an[0] <= 0; 
           
            seg[6:0] <= (s>=4)? out_arr0 : 7'b1111111;   
         end  
         
         endcase

end

endmodule
