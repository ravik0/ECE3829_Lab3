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
    always@(chosenSwitches)
        begin
            case(chosenSwitches)
                0: SEG=7'b0000001;
                1: SEG=7'b1001111;
                2: SEG=7'b0010010;
                3: SEG=7'b0000110;
                4: SEG=7'b1001100;
                5: SEG=7'b0100100;
                6: SEG=7'b0100000;
                7: SEG=7'b0001111;
                8: SEG=7'b0000000;
                9: SEG=7'b0000100;
                10: SEG=7'b0001000;
                11: SEG=7'b1100000;
                12: SEG=7'b0110001;
                13: SEG=7'b1000010;
                14: SEG=7'b0110000;
                15: SEG=7'b0111000; //if chosenSwitch has a specific number, then set SEG to its corrisponding value. The SEG values are determined graphically.
            endcase
        end
endmodule