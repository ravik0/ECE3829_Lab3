`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ravi Kirschner & Jonathan Lee 
// 
// Create Date: 09/16/2019 11:04:56 AM
// Design Name: Movement Logic 
// Module Name: movement_logic
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module deals with the logic for moving the block. It takes in a 10Hz clock, the debounced buttons, a signal that says
// whether a pixel is on the screen or not, a reset signal, and the current horizontal and vertical pixel count. It outputs the RGB value 
// for the pixel and the current block location in (0,0) -> (19,14)
// 
//////////////////////////////////////////////////////////////////////////////////


module movement_logic(
    input clk,
    input btnU,
    input btnD,
    input btnR,
    input btnL,
    input blank,
    input reset,
    input [10:0] hcount,
    input [10:0] vcount,
    output [3:0] red,
    output [3:0] blue,
    output [3:0] green,
    output [4:0] posH,
    output [3:0] posV
    );
    
    reg [4:0] posHorizontal = 0;
    reg [3:0] posVertical = 0;
    reg moved = 0;
    //the moved reg prevents holding the button from doing anything.
    
    wire withinConstraint; //the location in which the block can be drawn
    
    always @ (posedge clk, posedge reset) begin
        if(reset) begin
            posHorizontal = 0;
            posVertical = 0; 
            moved = 0;
        end
        else if(btnU && posVertical != 0 && !moved) begin
            posVertical = posVertical - 1'b1;
            moved = 1'b1; //if press up & not at the top of the screen
        end
        else if(btnD && posVertical != 14 && !moved) begin
            posVertical = posVertical + 1'b1;
            moved = 1'b1; //if press down & not at the bottom of the screen
        end
        else if(btnR && posHorizontal != 19 && !moved) begin
            posHorizontal = posHorizontal + 1'b1;
            moved = 1'b1; //if press right & not at the right of the screen
        end
        else if(btnL && posHorizontal != 0 && !moved) begin
            posHorizontal = posHorizontal - 1'b1;
            moved = 1'b1; //if press left & not at the left of the screen
        end
        else if(!btnL && !btnR && !btnU && !btnD) moved = 1'b0; //if no buttons pressed, can accept another input.
        else begin
            posHorizontal = posHorizontal;
            posVertical = posVertical;
            moved = moved; //else to prevent latch
        end
    end
    
    assign withinConstraint =( vcount >= 32 * posVertical && vcount <= 32 * posVertical + 32) 
                            && (hcount >= 32 * posHorizontal && hcount <= 32 * posHorizontal + 32);
                    
    assign red = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign blue = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign green = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign posH = posHorizontal;
    assign posV = posVertical;
endmodule