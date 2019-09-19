`timescale 1ns / 1ps
// Engineer: Ravi Kirschner and Jonathan Lee
// 
// Create Date: 09/01/2019 11:55:04 AM
// Design Name: Seven Segment Decoder
// Module Name: seven_seg
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module takes 4 4-bit inputs and cycles through the anodes at 800Hz, which is derived from the 25MHz from the Top File. Because of the way
// the seven seg board operates, SEG only contains one of the four 4-bit inputs decoded at a time. It is cycled through at 800Hz, similar to the anodes. The anodes
// and SEG change in tune with each other so a different number is displayed on each of the four seven segment displays on the board.
// 
//////////////////////////////////////////////////////////////////////////////////

module seven_seg(
    input clk, //25M clk
    input[3:0] A,
    input[3:0] B,
    input[3:0] C,
    input[3:0] D,
    output [6:0] SEG,
    output reg[3:0] ANODE
    );
    
    reg clk_en; //this is a pulse for the 800Hz clock. It does not need to be a square wave.
    reg [14:0] counter; //15 bit bus to hold up to 31250. 2^15 = 32768, 32768 > 31250.
    always @ (posedge clk)
        begin
            if(counter == 31250-1) 
                begin
                    counter <= 0;
                    clk_en <= 1;
                end
            else
                begin
                    counter <= counter + 1'b1;
                    clk_en <= 0;
                end
        end
    
    reg [3:0] chosenSwitches; //current set of values to be decoded
    reg [1:0] SEL = 2'b00; //current selected anode
    
    always @(posedge clk)
        if(clk_en) SEL <= SEL + 1'b1; //if the 800Hz clk pings, increment SEL
    
    always @(posedge clk)   
        if(clk_en) begin
            case(SEL)
                0: chosenSwitches = A;
                1: chosenSwitches = B;
                2: chosenSwitches = C;
                3: chosenSwitches = D;
            endcase //depending on SEL, change the set of values to be decoded
            case(SEL)
                0: ANODE = 4'b1110;
                1: ANODE = 4'b1101;
                2: ANODE = 4'b1011;
                3: ANODE = 4'b0111;
            endcase //depending on SEL, change the current anode that is being activated
        end
        
    seg_decoder(.chosenSwitches(chosenSwitches), .SEG(SEG)); 
    //use the seg_decoder module to acquire a set of decoded values for SEG.
                
endmodule
