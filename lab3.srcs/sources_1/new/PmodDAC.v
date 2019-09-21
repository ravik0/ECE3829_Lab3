`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ravi Kirschner & Jonathan Lee
// 
// Create Date: 09/17/2019 09:54:57 AM
// Design Name: PmodDAC Wave Former
// Module Name: PmodDAC
// Project Name: DAC Waveform and Moving Block
// Target Devices: Basys 3
// Description: This module takes care of sending data to the PmodDAC. It takes in the SCLK, CS, and reset signals, and outputs the DAC data. 
// This uses a 20-state state machine to choose what new data value to send to the DAC.
// 
//////////////////////////////////////////////////////////////////////////////////


module PmodDAC(
    input SCLK,
    input CS,
    input reset,
    output reg DO
    );
    
    reg[15:0] values; //The values that will be sent to the DAC
    
    parameter [15:0] zero = {8'b0, 8'b0};
    parameter [15:0] one = {8'b0, 8'b00011000};
    parameter [15:0] two = {8'b0, 8'b00110010};
    parameter [15:0] three = {8'b0, 8'b01001011};
    parameter [15:0] four = {8'b0, 8'b01100101};
    parameter [15:0] five = {8'b0, 8'b01111111};
    parameter [15:0] six = {8'b0, 8'b10011000};
    parameter [15:0] seven = {8'b0, 8'b10110010};
    parameter [15:0] eight = {8'b0, 8'b11001011};
    parameter [15:0] nine = {8'b0, 8'b11100101};
    parameter [15:0] ten = {8'b0, 8'b11111111}; //The values of the data to be sent to the DAC
    //Leftmost bits are control bits, rightmost are data bits.
    
    parameter [4:0] s0 = 0, 
        s1 = 1, 
        s2 = 2, 
        s3 = 3,
        s4 = 4, 
        s5 = 5, 
        s6 = 6, 
        s7 = 7, 
        s8 = 8, 
        s9 = 9, 
        s10 = 10,
        s11 = 11,
        s12 = 12, 
        s13 = 13, 
        s14 = 14, 
        s15 = 15, 
        s16 = 16, 
        s17 = 17, 
        s18 = 18,
        s19 = 19; //all the states
    reg [4:0] current_state, next_state; 
    reg shiftedState; //Tells the FPGA whether the state has been shifted. 
    
    always @ (posedge SCLK, posedge reset)
        if(reset) values <= 16'b0; 
        else if (CS == 1) begin
                current_state <= next_state; //If CS == 1, change the current state
                if(!shiftedState) //If we haven't shifted the state already, then shift next_state along.
                //When next_state is changed, shiftedState goes to 1, so that current_state doesn't continually shift
                //while CS is 1.
                    case(current_state) //needs to be here because we are dealing with the value reg in both nextstate and currentstate logic.
                        s0: begin
                            values <= zero;
                            next_state <= s1;
                            shiftedState <= 1'b1;
                            end
                        s1: begin
                            values <= one;
                            next_state <= s2;
                            shiftedState <= 1'b1;
                            end
                        s2: begin
                            values <= two;
                            next_state <= s3;
                            shiftedState <= 1'b1;
                            end
                        s3: begin
                            values <= three;
                            next_state <= s4;
                            shiftedState <= 1'b1;
                            end
                        s4: begin
                            values <= four;
                            next_state <= s5;
                            shiftedState <= 1'b1;
                            end
                        s5: begin
                            values <= five;
                            next_state <= s6;
                            shiftedState <= 1'b1;
                            end
                        s6: begin
                            values <= six;
                            next_state <= s7;
                            shiftedState <= 1'b1;
                            end
                        s7: begin
                            values <= seven;
                            next_state <= s8;
                            shiftedState <= 1'b1;
                            end
                        s8: begin
                            values <= eight;
                            next_state <= s9;
                            shiftedState <= 1'b1;
                            end
                        s9: begin
                            values <= nine;
                            next_state <= s10;
                            shiftedState <= 1'b1;
                            end
                        s10: begin
                            values <= ten;
                            next_state <= s11;
                            shiftedState <= 1'b1;
                            end
                        s11: begin
                            values <= nine;
                            next_state <= s12;
                            shiftedState <= 1'b1;
                            end
                        s12: begin
                            values <= eight;
                            next_state <= s13;
                            shiftedState <= 1'b1;
                            end
                        s13: begin
                            values <= seven;
                            next_state <= s14;
                            shiftedState <= 1'b1;
                            end
                        s14: begin
                            values <= six;
                            next_state <= s15;
                            shiftedState <= 1'b1;
                            end
                        s15: begin
                            values <= five;
                            next_state <= s16;
                            shiftedState <= 1'b1;
                            end
                        s16: begin
                            values <= four;
                            next_state <= s17;
                            shiftedState <= 1'b1;
                            end
                        s17: begin
                            values <= three;
                            next_state <= s18;
                            shiftedState <= 1'b1;
                            end
                        s18: begin
                            values <= two;
                            next_state <= s19;
                            shiftedState <= 1'b1;
                            end
                        s19: begin
                            values <= one;
                            next_state <= s0;
                            shiftedState <= 1'b1;
                            end
                        default: begin
                            values <= zero;
                            next_state <= s0;
                            shiftedState <= 1'b1;
                        end
                    endcase
        else begin
            shiftedState <= 1'b0;
            DO <= values[15];
            values <= {values[14:0], 1'b0};
            //If CS is 0, every posedge SCLK shift a new data value to the DAC and set shiftedState to 0.
        end
    end
            
    
//    always @ (posedge SCLK)
//        if(reset) values <= 15'b0;
//        else if(CS == 0) begin
//            DO <= values[15];
//            values <= { values[14:0], 1'b0 };
//        end
//        else values <= {8'b0, sw};
// This was the code for shifting switch data.
    
endmodule
