`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 11:37:59
// Design Name: 
// Module Name: MUX2to1imm
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
`include "define_file.v"

module MUX2to1imm(
    input wire choice,
    input wire signed [31:0] rs2,
    input wire signed [31:0] imm,
    output reg signed [31:0] out
    );
    always @(*)
    begin
        if(choice==`Enable)
            out<=rs2;
        else
            out<=imm;
    end
endmodule
