//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ravi Kirschner and Jonathan Lee
// 
// Create Date: 09/10/2019 03:57:40 PM
// Design Name: Seven Segment Decoder
// Module Name: seg_decoder
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module decodes a 4-bit input into a 6-bit output for the seven-segment display onboard to use and display the correct number.
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_decoder(
    input [3:0] chosenSwitches,
    output reg [6:0] SEG
    );
     parameter zero = 7'b0000001, 
        one = 7'b1001111, 
        two = 7'b0010010, 
        three = 7'b0000110, 
        four = 7'b1001100,
        five = 7'b0100100, 
        six = 7'b0100000, 
        seven = 7'b0001111, 
        eight = 7'b0000000, 
        nine = 7'b0000100, 
        A = 7'b0001000,
        B = 7'b1100000,
        C = 7'b0110001, 
        D = 7'b1000010, 
        E = 7'b0110000,
        F = 7'b0111000; //Creating constants for each of the hex numbers 0-F
    
    always@(chosenSwitches)
        begin
            case(chosenSwitches) //depending on the number that is in the chosen set of numbers, we'll tell SEG which segments to turn on/off to display that number.
                0: SEG=zero;
                1: SEG=one;
                2: SEG=two;
                3: SEG=three;
                4: SEG=four;
                5: SEG=five;
                6: SEG=six;
                7: SEG=seven;
                8: SEG=eight;
                9: SEG=nine;
                10: SEG=A;
                11: SEG=B;
                12: SEG=C;
                13: SEG=D;
                14: SEG=E;
                15: SEG=F;
                default: SEG = 7'b0;
            endcase
        end
endmodule