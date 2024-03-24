`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 10:10:56
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB(
    input clk,
    input rst,
    input wire [2:0] optype,
    input wire [3:0] operator,
    
    input wire signed [31:0] mem_data,
    input wire signed [31:0] alu_result,
    input wire [4:0] rd,
    output reg signed [31:0] out_data,
    output reg [4:0] out_rd,
    output reg [2:0] out_optype,
    output reg [3:0] out_operator
    );
    
    reg [2:0] temp_optype;
    reg [3:0] temp_operator;
    reg signed [31:0] temp_data;
    reg [4:0] temp_rd;
    
    always @(*)
    begin
        if(optype==`RType)
            temp_data<=alu_result;
        else if(optype==`IType&&operator==`Ilw)
            temp_data<=mem_data;
        else if(optype==`IType)
            temp_data<=alu_result;
        else
            temp_data<=32'h00000000;
    end
    
    always @(rd)
    begin
        temp_rd<=rd;
    end
    
    always @(optype)
    begin
        temp_optype<=optype;
    end
    
    always @(operator)
    begin
        temp_operator<=operator;
    end
    
    always @(posedge clk)
    begin
        if(rst==`Enable)
        begin
            out_optype<=3'b000;
            out_operator<=4'b0000;
            out_data<=32'h00000000;
            out_rd<=5'b00000;
        end
        else
        begin
            out_optype<=temp_optype;
            out_operator<=temp_operator;
            out_data<=temp_data;
            out_rd<=temp_rd;
        end
    end
endmodule
