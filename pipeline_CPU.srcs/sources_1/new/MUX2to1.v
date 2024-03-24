`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 15:39:19
// Design Name: 
// Module Name: MUX2to1
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

module MUX2to1(
    input wire branch,
    input wire[`InsMemAddrWidth-1:0] new_pc,
    input wire[`InsMemAddrWidth-1:0] jump,
    output reg[`InsMemAddrWidth-1:0] set_pc
    );
    always @(*)
    begin
        if(branch==`Enable)
            set_pc<=jump;
        else
            set_pc<=new_pc;
    end
    
endmodule
