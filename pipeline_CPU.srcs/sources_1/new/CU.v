`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 20:34:46
// Design Name: 
// Module Name: CU
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

module CU(
    input wire[6:0] opcode,
    input wire[2:0] func1,
    input wire[6:0] func2,
    output reg re1,
    output reg re2,
    output reg [2:0] optype,
    output reg [3:0] operator,
    
    input wire branch,
    output reg clr,
    
    input wire [2:0] mem_optype,
    input wire [3:0] mem_operator,
    output reg mem_we,
    output reg mem_re,
    
    input wire [2:0] wb_optype,
    output reg wb_we
    );
    
    always @(*)
    begin
        re1<=`Disable;
        re2<=`Disable;
        case(opcode)
            7'b0110011:
            begin
                re1<=`Enable;
                re2<=`Enable;
                optype<=`RType;
                if(func1==3'b000&&func2==7'b0000000)
                    operator<=`Radd;
                else if(func1==3'b000&&func2==7'b0100000)
                    operator<=`Rsub;
                else if(func1==3'b001&&func2==7'b0000000)
                    operator<=`Rsll;
                else if(func1==3'b010&&func2==7'b0000000)
                    operator<=`Rslt;
                else if(func1==3'b100&&func2==7'b0000000)
                    operator<=`Rxor;
                else if(func1==3'b101&&func2==7'b0000000)
                    operator<=`Rsrl;
                else if(func1<=3'b101&&func2==7'b0100000)
                    operator<=`Rsra;
                else if(func1==3'b110&&func2==7'b0000000)
                    operator<=`Ror;
                else if(func1==3'b111&&func2==7'b0000000)
                    operator<=`Rand;     
                else
                    operator<=`invalid;           
            end
            7'b0000011:
            begin
                re1<=`Enable;
                optype<=`IType;
                if(func1==3'b010)
                    operator<=`Ilw;
                else
                    operator<=`invalid;
            end
            7'b0010011:
            begin
                re1<=`Enable;
                optype<=`IType;
                if(func1==3'b000)
                    operator<=`Iaddi;
                else if(func1==3'b010)
                    operator<=`Islti;
                else if(func1==3'b100)
                    operator<=`Ixori;
                else if(func1==3'b110)
                    operator<=`Iori;
                else if(func1==3'b111)
                    operator<=`Iandi;
                else if(func1==3'b001)
                    operator<=`Islli;
                else if(func1==3'b101)
                    operator<=`Isrlai;
                else
                    operator<=`invalid;
            end
            7'b0100011:
            begin
                re1<=`Enable;
                re2<=`Enable;
                optype<=`SType;
                if(func1==3'b010)
                    operator<=`Ssw;
                else
                    operator<=`invalid;
            end
            7'b1100011:
            begin
                re1<=`Enable;
                re2<=`Enable;
                optype<=`BType;
                if(func1==3'b000)
                    operator<=`Bbeq;
                else if(func1==3'b001)
                    operator<=`Bbne;
                else if(func1==3'b100)
                    operator<=`Bblt;
                else if(func1==3'b101)
                    operator<=`Bbge;
                else
                    operator<=`invalid;
            end
            7'b1101111:
            begin
                optype<=`JType;
                operator<=`Jjal;
            end
            default:
            begin
                optype<=`tInvalid;
                operator<=`invalid;
            end
        endcase
    end
    
    always @(branch)
    begin
        if(branch==`Enable)
            clr<=`Enable;
        else
            clr<=`Disable;
    end
    
    always @(mem_optype or mem_operator)
    begin
        mem_re<=`Disable;
        mem_we<=`Disable;
        case(mem_optype)
            `IType:
            begin
                if(mem_operator==`Ilw)
                    mem_re<=`Enable;
            end
            `SType:
            begin
                if(mem_operator==`Ssw)
                    mem_we<=`Enable;
            end
        endcase
    end
    
    always @(wb_optype)
    begin
        wb_we<=`Disable;
        if(wb_optype==`RType||wb_optype==`IType)
        begin
            wb_we<=`Enable;
        end
    end
    
endmodule
