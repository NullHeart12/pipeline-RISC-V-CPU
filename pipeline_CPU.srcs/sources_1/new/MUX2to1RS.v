`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 16:38:56
// Design Name: 
// Module Name: MUX2to1RS
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

module MUX2to1RS(
    input valid,
    input wire signed [31:0] value,
    input wire signed [31:0] rs,
    output reg signed [31:0] out_rs
    );
    
    always @(*)
    begin
        if(valid==`Enable)
            out_rs<=value;
        else
            out_rs<=rs;
    end
    
endmodule
