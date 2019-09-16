`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2019 10:47:50 AM
// Design Name: 
// Module Name: lab3_top
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


module lab3_top(
    input clk,
    input reset,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output hSync,
    output vSync,
    output [6:0] SEG,
    output [3:0] ANODE
    );
    
    //10Hz ENABLE SIGNAL SECTION
    reg en_10Hz;
    reg [23:0] counter10;
    always @ (posedge clk)
        begin
            if(counter10 == 5000000-1) 
                begin
                    counter10 <= 0;
                    en_10Hz <= en_10Hz == 1 ? 0 : 1;
                end
            else
                begin
                    counter10 <= counter10 + 1'b1;
                end
        end
    
    wire locked;
    wire clk_25M;
    wire blank;
    wire [10:0] hCount;
    wire [10:0] vCount;
    wire up, down, left, right;
    wire [4:0] posH;
    wire [3:0] posV;
    wire [3:0] A, B, C, D;
    clk_wiz_0 mmcm_inst
      (
      // Clock out ports  
      .clk_25M(clk_25M),
      // Status and control signals               
      .reset(reset), 
      .locked(locked),
     // Clock in ports
      .clk_in1(clk)
      );
    
    assign D = posH >= 10 ? 4'b0001 : 4'b0000;
    assign C = posH >= 10 ? posH-10 : posH[3:0];
    assign B = posV >= 10 ? 4'b0001 : 4'b0000;
    assign A = posV >= 10 ? posV-10 : posV;
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnU), .newBtn(up));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnD), .newBtn(down));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnL), .newBtn(left));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnR), .newBtn(right));
    
    movement_logic(.clk(en_10Hz), .posH(posH), .posV(posV), .btnU(up), .btnD(down), .btnL(left), .btnR(right), .reset(reset),
    .blank(blank), .hcount(hCount), .vcount(vCount), .red(vgaRed), .blue(vgaBlue), .green(vgaGreen));
    vga_controller_640_60 u2(.rst(reset), .pixel_clk(clk_25M), .HS(hSync), .VS(vSync), .hcount(hCount), .vcount(vCount), .blank(blank));
    seven_seg(.clk(clk_25M), .A(A), .B(B), .C(C), .D(D), .SEG(SEG), .ANODE(ANODE));
endmodule