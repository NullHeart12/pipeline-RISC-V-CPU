`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 11:53:20
// Design Name: 
// Module Name: MUX2to1offset
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

module MUX2to1offset(
    input wire choice,
    input wire signed [7:0] b_offset,
    input wire signed [7:0] j_offset,
    output reg signed [7:0] offset
    );
    always @(*)
    begin
        if(choice==`Enable)
            offset<=b_offset;
        else
            offset<=j_offset;
    end
endmodule
