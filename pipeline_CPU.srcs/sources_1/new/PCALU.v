`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 15:36:01
// Design Name: 
// Module Name: PCALU
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

module PCALU(
    input wire[`InsMemAddrWidth-1:0] pc,
    output reg[`InsMemAddrWidth-1:0] new_pc
    );
    always @(pc)
    begin
        new_pc<=pc+4;
    end
endmodule
