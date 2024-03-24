`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 15:58:02
// Design Name: 
// Module Name: IF_ID
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

module IF_ID(
    input clk,
    input rst,
    input clr,
    input wire[`InsMemAddrWidth-1:0] input_pc,
    input wire[`InsMemDataWidth-1:0] input_ins,
    output reg[`InsMemAddrWidth-1:0] output_pc,
    output reg[`InsMemDataWidth-1:0] output_ins,
    
    input wire stall
    );
    
    reg [`InsMemAddrWidth-1:0] temp_pc;
    reg [`InsMemDataWidth-1:0] temp_ins;
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_pc<=8'b0000000;
        else
            temp_pc<=input_pc;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_ins<=32'h00000000;
        else
            temp_ins<=input_ins;
    end
    
    always @(posedge clk or posedge rst)
    begin
        if(rst==`RstEnable)
        begin
            output_pc<=8'b00000000;
            output_ins<=32'h00000000;
        end
        else
        begin
            if(stall==`Disable)
            begin
                output_pc<=temp_pc;
                output_ins<=temp_ins;
            end
        end
    end
endmodule
