`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ravi Kirschner & Jonathan Lee
// 
// Create Date: 09/16/2019 10:47:50 AM
// Design Name: Lab3 Top File
// Module Name: lab3_top
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module is the top module for all of Lab 3. It takes in the 100MHz FPGA clock, a reset signal, and 4 button signals.
// It then outputs the VGA RGB/hSync/vSync signals, SEG and ANODE for the seven-segment display, and the chip-select, SCLK, and data for
// the DAC. This module also deals with creating the 86% duty cycle 100kHz clk, uses the MMCM to create a 25MHz and 10MHz clk, and
// creates a 10Hz clock for the movement logic.
// 
//////////////////////////////////////////////////////////////////////////////////


module lab3_top(
    input clk,
    input reset,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    //input [7:0] sw, //from testing slider switches
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output hSync,
    output vSync,
    output [6:0] SEG,
    output [3:0] ANODE,
    output CS,
    output SCLK,
    output DO
    );
    wire clk_25M;
    wire clk_10M;
    
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
        
    //100kHz CLK - Only down for 16 SCLK cycles, or 1600ns
    reg clk_100K;
    reg [6:0] counter100;
    always @ (posedge clk_10M) //To keep the CS and SCLK synced, we derive the CS from SCLK.
        if(clk_100K == 1 && counter100 == 100-1) begin
            counter100 <= 0;
            clk_100K <= 0;
        end
        else if (clk_100K == 0 && counter100 == 16-1) begin
            clk_100K <= 1;
        end
        else counter100 <= counter100 + 1'b1;
                
    
    wire locked; //Locked signal to tell whether the MMCM is generating clock or not. Not currently used.
    wire blank;
    wire [10:0] hCount; //Horizontal/vertical count of pixel
    wire [10:0] vCount;
    wire up, down, left, right; //Debounced button outputs.
    wire [4:0] posH; //Current horizontal and vertical position of the white block on the VGA display, (0,0) -> (19,14)
    wire [3:0] posV;
    wire [3:0] A, B, C, D; //Seven segment inputs.
    //25MHz clk & 10MHz clk
    clk_wiz_0 mmcm_inst
      (
      // Clock out ports  
      .clk_25M(clk_25M),
      .clk_10M(clk_10M),
      // Status and control signals               
      .reset(reset), 
      .locked(locked),
     // Clock in ports
      .clk_in1(clk)
      );
    
    assign D = posH >= 10 ? 4'b0001 : 4'b0000; //If horizontal is between 10 & 19, then the first digit 1, otherwise it's 0
    assign C = posH >= 10 ? posH-10 : posH[3:0]; //If horizontal is between 10 & 19, second digit is posH-10 so it is only a value 0-9.
    assign B = posV >= 10 ? 4'b0001 : 4'b0000; //Same logic as D
    assign A = posV >= 10 ? posV-10 : posV; //Same logic as C
    //Debouncing the 4 buttons using a 10Hz clock.
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnU), .newBtn(up));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnD), .newBtn(down));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnL), .newBtn(left));
    debounce(.clk(en_10Hz), .reset(reset), .btn(btnR), .newBtn(right)); 
     
    movement_logic(.clk(en_10Hz), .posH(posH), .posV(posV), .btnU(up), .btnD(down), .btnL(left), .btnR(right), .reset(reset),
    .blank(blank), .hcount(hCount), .vcount(vCount), .red(vgaRed), .blue(vgaBlue), .green(vgaGreen));
    vga_controller_640_60 u2(.rst(reset), .pixel_clk(clk_25M), .HS(hSync), .VS(vSync), .hcount(hCount), .vcount(vCount), .blank(blank));
    //VGA controller takes in a reset signal (to redraw the screen), a 25MHz clock, and outputs hSync/vSync signals, as well as outputs the current
    //vertical and horizontal pixel location that it's working on. It also outputs blank, which says if the pixel it is working on is off the screen
    //or not. Description written here as can't write in VGA controller module. 
    seven_seg(.clk(clk_25M), .A(A), .B(B), .C(C), .D(D), .SEG(SEG), .ANODE(ANODE));
    PmodDAC(.SCLK(clk_10M), .CS(clk_100K), .reset(reset), .DO(DO));
    
    assign SCLK = clk_10M;
    assign CS = clk_100K;
endmodule
