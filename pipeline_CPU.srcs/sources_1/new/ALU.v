`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 16:20:48
// Design Name: 
// Module Name: ALU
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

module ALU(
    input clk,
    input stall,
    input wire [2:0] optype,
    input wire [3:0] operator,
    input wire signed [31:0] rs1,
    input wire signed [31:0] rs2,
    input wire signed [31:0] imm,
    input wire [7:0] pc,
    input wire [4:0] rd_in,
    output reg [4:0] rd_out,
    output reg signed [31:0] result,
    output reg [7:0] data_mem_addr,
    output reg [7:0] new_pc,
    output reg branch
    );
        
    always @(negedge clk)
    begin
        if(stall==`Disable)
        begin
            result<=32'h00000000;
            data_mem_addr<=8'h00;
            new_pc<=8'h00;
            rd_out<=5'b00000;
            branch<=`Disable;
            case(optype)
                `RType:
                begin
                    rd_out<=rd_in;
                    case(operator)
                        `Radd:
                            result<=rs1+rs2;
                        `Rsub:
                            result<=rs1-rs2;
                        `Rsll:
                            result<=rs1<<rs2[4:0];
                        `Rslt:
                        begin
                            if(rs1<rs2)
                                result<=32'h00000001;
                            else
                                result<=32'h00000000;
                        end
                        `Rxor:
                            result<=rs1^rs2;
                        `Rsrl:
                            result<=rs1>>rs2[4:0];
                        `Rsra:
                            result<=rs1>>>rs2[4:0];
                    endcase
                end
                `IType:
                begin
                    rd_out<=rd_in;
                    case(operator)
                        `Ilw:
                        begin
                            result<=32'h80000000;
                            data_mem_addr<=rs1[7:0]+{imm[11],imm[6:0]};
                        end
                        `Iaddi:
                            result<=rs1+imm;
                        `Islti:
                        begin
                            if(rs1<imm)
                                result<=32'h00000001;
                            else
                                result<=32'h00000000;
                        end
                        `Ixori:
                            result<=rs1^imm;
                        `Iori:
                            result<=rs1|imm;
                        `Iandi:
                            result<=rs1&imm;
                        `Islli:
                            result<=rs1<<imm[4:0];
                        `Isrlai:
                        begin
                            if(imm[10]==`Disable)
                                result<=rs1>>imm[4:0];
                            else 
                                result<=rs1>>>imm[4:0];
                        end
                    endcase
                end
                `SType:
                begin
                    case(operator)
                        `Ssw:
                            data_mem_addr<=rs1[7:0]+{imm[11],imm[6:0]};
                    endcase
                end
                `BType:
                begin
                    case(operator)
                        `Bbeq:
                        begin
                            if(rs1==rs2)
                            begin
                                new_pc<=pc+({imm[11],imm[4:0]}<<2);
                                branch<=`Enable;
                            end
                            else
                                new_pc<=pc;
                        end
                        `Bbne:
                        begin
                            if(rs1!=rs2)
                            begin
                                new_pc<=pc+({imm[11],imm[4:0]}<<2);
                                branch<=`Enable;
                            end
                            else
                                new_pc<=pc;
                        end
                        `Bblt:
                        begin
                            if(rs1<rs2)
                            begin
                                new_pc<=pc+({imm[11],imm[4:0]}<<2);
                                branch<=`Enable;
                            end
                            else
                                new_pc<=pc;
                        end
                        `Bbge:
                        begin
                            if(rs1>=rs2)
                            begin
                                new_pc<=pc+({imm[11],imm[4:0]}<<2);
                                branch<=`Enable;
                            end
                            else
                                new_pc<=pc;
                        end
                    endcase
                end
                `JType:
                begin
                    case(operator)
                        `Jjal:
                        begin
                            new_pc<=pc+({imm[20],imm[4:0]}<<2);
                            branch<=`Enable;
                        end
                    endcase
                end
            endcase
        end
    end
    
endmodule
