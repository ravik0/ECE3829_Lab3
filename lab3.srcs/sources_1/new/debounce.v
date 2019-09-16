`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2019 11:08:17 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk, //10Hz clk
    input reset,
    input btn,
    output newBtn
    );
    
    parameter s0 = 1'b0, s1 = 1'b1;
    reg currentState, nextState;
    
    always @ (posedge clk, posedge reset)
        if(reset) currentState <= s0;
        else currentState <= nextState;
    
    always @ (currentState, btn)
        case(currentState)
            s0: if(btn == 1) nextState = s1;
                else nextState = s0;
            s1: if(btn == 0) nextState = s0;
                else nextState = s1;
        endcase
            
    assign newBtn = currentState == s1;
    
endmodule
