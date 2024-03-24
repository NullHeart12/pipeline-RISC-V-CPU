`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 16:46:23
// Design Name: 
// Module Name: InsDecoder
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

module InsDecoder(
    input wire[`InsMemDataWidth-1:0] ins,
    output reg[6:0] opcode,
    output reg[2:0] func1,
    output reg[6:0] func2,
    (*keep="true"*)output reg[4:0] rs1,
    (*keep="true"*)output reg[4:0] rs2,
    output reg[4:0] rd,
    output reg signed [11:0] imm1,
    output reg signed [19:0] imm2
    );

    always @(ins)
    begin
        opcode<=ins[6:0];
        func1<=3'b000;
        func2<=7'b0000000;
        rs1<=5'b00000;
        rs2<=5'b00000;
        rd<=5'b00000;
        imm1<=12'h000;
        imm2<=20'h00000;
        case(ins[6:0])
            7'b0110011:
            begin
                rs1<=ins[19:15];
                rs2<=ins[24:20];
                rd<=ins[11:7];
                func1<=ins[14:12];
                func2<=ins[31:25];
            end
            7'b0000011:
            begin
                rs1<=ins[19:15];
                rd<=ins[11:7];
                imm1<=ins[31:20];
                func1<=ins[14:12];
            end
            7'b0010011:
            begin
                rs1<=ins[19:15];
                rd<=ins[11:7];
                imm1<=ins[31:20];
                func1<=ins[14:12];
            end
            
            7'b0100011:
            begin
                rs1<=ins[19:15];
                rs2<=ins[24:20];
                imm1<={ins[31:25],ins[11:7]};
                func1<=ins[14:12];
            end
            7'b1100011:
            begin
                rs1<=ins[19:15];
                rs2<=ins[24:20];
                imm1<={ins[31],ins[7],ins[30:25],ins[11:8]};
                func1<=ins[14:12];
            end
            7'b1101111:
            begin
                imm2<={ins[31],ins[19:12],ins[20],ins[30:21]};
            end
        endcase
    end
endmodule
