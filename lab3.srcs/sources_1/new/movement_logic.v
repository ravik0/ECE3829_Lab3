`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2019 11:04:56 AM
// Design Name: 
// Module Name: movement_logic
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
    
    wire withinConstraint;
    
    always @ (posedge clk, posedge reset) begin
        if(reset) begin
            posHorizontal = 0;
            posVertical = 0; 
            moved = 0;
        end
        else if(btnU && posVertical != 0 && !moved) begin
            posVertical = posVertical - 1'b1;
            moved = 1'b1;
        end
        else if(btnD && posVertical != 14 && !moved) begin
            posVertical = posVertical + 1'b1;
            moved = 1'b1;
        end
        else if(btnR && posHorizontal != 19 && !moved) begin
            posHorizontal = posHorizontal + 1'b1;
            moved = 1'b1;
        end
        else if(btnL && posHorizontal != 0 && !moved) begin
            posHorizontal = posHorizontal - 1'b1;
            moved = 1'b1;
        end
        else if(!btnL && !btnR && !btnU && !btnD) moved = 1'b0;
    end
    
    assign withinConstraint = vcount >= 32 * posVertical && vcount <= 32 * posVertical + 32 && hcount >= 32 * posHorizontal && hcount <= 32 * posHorizontal + 32;
                    
    assign red = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign blue = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign green = blank ? 4'b0000 : withinConstraint ? 4'b1111 : 4'b0000;
    assign posH = posHorizontal;
    assign posV = posVertical;
endmodule
