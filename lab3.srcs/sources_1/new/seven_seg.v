`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2019 11:55:04 AM
// Design Name: 
// Module Name: seven_seg
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

module seven_seg(
    input clk, //25M clk
    input[3:0] A,
    input[3:0] B,
    input[3:0] C,
    input[3:0] D,
    output [6:0] SEG,
    output reg[3:0] ANODE
    );
    
    reg clk_en;
    reg [14:0] counter;
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
    
    reg [3:0] chosenSwitches;
    reg [1:0] SEL = 2'b00;
    
    always @(posedge clk)
        if(clk_en) SEL <= SEL + 1'b1;
    
    always @(posedge clk)   
        if(clk_en) begin
            case(SEL)
                0: chosenSwitches = A;
                1: chosenSwitches = B;
                2: chosenSwitches = C;
                3: chosenSwitches = D;
            endcase
            case(SEL)
                0: ANODE = 4'b1110;
                1: ANODE = 4'b1101;
                2: ANODE = 4'b1011;
                3: ANODE = 4'b0111;
            endcase
        end
        
    seg_decoder(.chosenSwitches(chosenSwitches), .SEG(SEG));
                
endmodule
