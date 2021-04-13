// Screen dimmensions
`define WIDTH 96
`define HEIGHT 64
// Colours
`define BLACK 16'b0
`define WHITE ~`BLACK
`define MAGENTA 16'b11111_000000_11111
`define CYAN 16'b00000_111111_11111
`define YELLOW 16'b11111_111111_00000
`define GREEN 16'b00000_111111_00000
`define RED 16'b11111_000000_00000
`define BLUE 16'b00000_000000_11111
`define ORANGE 16'b11111_100110_00000
`define GREY 16'b01100_011000_01100

// Bit numbers 
`define LDBIT       15
`define OLEDBIT     15
`define ANBIT       3
`define SEGBIT      6 //without dp
`define COLBIT      15 //colour
`define PIXELBIT    12 // Pixel_index from oled_display
`define PIXELXYBIT  6 // for x and y coordinate system 
// To clear AN/SEG
`define CLR_AN  ~4'b0
`define CLR_SEG ~7'b0

// 7SEG DIGITS
`define DIG0    7'b1000000
`define DIG1    7'b1111001
`define DIG2    7'b0100100
`define DIG3    7'b0110000
`define DIG4    7'b0011001
`define DIG5    7'b0010010
`define DIG6    7'b0000010
`define DIG7    7'b1111000
`define DIG8    7'b0
`define DIG9    7'b0010000 
`define BLANK   7'b1111111   
// char

//PASS
`define CHAR_P  7'b0001100
`define CHAR_A  7'b0001000
`define CHAR_S  7'b0010010

// FAIL 
`define CHAR_F  7'b0001110
`define CHAR_A  7'b0001000
`define CHAR_I  7'b1001111
`define CHAR_L  7'b1000111 

// HELLO
`define CHAR_H  7'b0001001
`define CHAR_E  7'b0000110
`define CHAR_O  7'b1000000

//JARED
`define CHAR_J  7'b1100001
`define CHAR_R  7'b0101111
`define CHAR_D  7'b0100001

//AVELLIN; V,N
`define CHAR_V  7'b1100011
`define CHAR_N  7'b0101011

//RDY
`define CHAR_Y  7'b0010001

//GO
`define CHAR_G  7'b0010000

//STOP
`define CHAR_T  7'b0000111

// M for LMH
`define CHAR_M  7'b1101010

// numbers for morse code. Dot: 0, Dash: 1 
// key in from right to left 
`define ZERO    5'b11111
`define ONE     5'b01111 
`define TWO     5'b00111
`define THREE   5'b00011
`define FOUR    5'b00001
`define FIVE    5'b00000
`define SIX     5'b10000
`define SEVEN   5'b11000
`define EIGHT   5'b11100
`define NINE    5'b11110 

// Vol Bar Levels
`define LVLDIFF 4 // difference in distance between bars 
`define LVLHEIGHT 2 // height of each bar
`define LVL1 60
`define LVL2 (`LVL1 - `LVLDIFF)
`define LVL3 (`LVL2 - `LVLDIFF)
`define LVL4 (`LVL3 - `LVLDIFF)
`define LVL5 (`LVL4 - `LVLDIFF)
`define LVL6 (`LVL5 - `LVLDIFF)
`define LVL7 (`LVL6 - `LVLDIFF)
`define LVL8 (`LVL7 - `LVLDIFF)
`define LVL9 (`LVL8 - `LVLDIFF)
`define LVL10 (`LVL9 - `LVLDIFF)
`define LVL11 (`LVL10 - `LVLDIFF)
`define LVL12 (`LVL11 - `LVLDIFF)
`define LVL13 (`LVL12 - `LVLDIFF)
`define LVL14 (`LVL13 - `LVLDIFF)
`define LVL15 (`LVL14 - `LVLDIFF)



