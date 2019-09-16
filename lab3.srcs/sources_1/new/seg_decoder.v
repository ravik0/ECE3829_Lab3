`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2019 03:57:40 PM
// Design Name: 
// Module Name: seg_decoder
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
                15: SEG=7'b0111000;
            endcase
        end
endmodule
