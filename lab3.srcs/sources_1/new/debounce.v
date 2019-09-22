`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ravi Kirschner & Jonathan Lee
// 
// Create Date: 09/16/2019 11:08:17 AM
// Design Name: Button Debouncer
// Module Name: debounce
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module debounces a button press by checking the current button value every 100ms - That means that if the button
// bounces, the debouncer will smooth out that bounce to either a 1 or a 0. This debouncer uses a state machine to operate.
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
            default: nextState = s0;
        endcase
            
    assign newBtn = currentState == s1; //s1 means button is 1.
    
endmodule