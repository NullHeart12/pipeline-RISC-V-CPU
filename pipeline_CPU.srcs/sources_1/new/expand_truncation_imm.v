`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 10:33:33
// Design Name: 
// Module Name: expand_truncation_imm
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

module expand_truncation_imm(
    input wire [2:0]optype,
    input wire signed [11:0] imm1,
    input wire signed [19:0] imm2,
    output reg signed [31:0] imm
    );
    
    always @(*)
    begin
        if(optype==`JType)
            imm<={{12{imm2[19]}},imm2};
        else if(optype==`IType||optype==`SType||optype==`BType)
            imm<={{20{imm1[11]}},imm1};
        else
            imm<=32'h00000000;
    end
    
endmodule
