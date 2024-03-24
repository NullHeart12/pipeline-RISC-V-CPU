`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 13:04:05
// Design Name: 
// Module Name: ID_EX
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

module ID_EX(
    input wire clk,
    input wire rst,
    input wire clr,
    input wire [2:0] optype,
    input wire [3:0] operator,
    input wire [7:0] pc,
    input wire [4:0] rd,
    (*keep="true"*)input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    input wire signed [31:0] rs1,
    input wire signed [31:0] rs2,
    input wire signed [31:0] imm,
    output reg [2:0] out_optype,
    output reg [3:0] out_operator,
    output reg [7:0] out_pc,
    output reg [4:0] out_rd,
    (*keep="true"*)output reg [4:0] out_rs1_addr,
    (*keep="true"*)output reg [4:0] out_rs2_addr,
    output reg [4:0] out_ex_mem_rs2_addr,
    output reg signed [31:0] out_rs1,
    output reg signed [31:0] out_rs2,
    output reg signed [31:0] out_imm,
        
    input wire stall
    );
    
    reg [2:0] temp_optype;
    reg [3:0] temp_operator;
    reg [7:0] temp_pc;
    reg [4:0] temp_rd;
    //reg [4:0] temp_rs1_addr;
    reg [4:0] temp_rs2_addr;
    reg signed [31:0] temp_rs1;
    reg signed [31:0] temp_rs2;
    reg signed [31:0] temp_imm;
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_optype<=3'b0000;
        else
            temp_optype<=optype;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_operator<=4'b0000;
        else
            temp_operator<=operator;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_pc<=8'b0000_0000;
        else
            temp_pc<=pc;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_rd<=5'b00000;
        else
            temp_rd<=rd;
    end
    
    always @(*)
    begin
        if(stall==`Disable)
        begin
            if(clr==`Enable)
                out_rs1_addr<=5'b00000;
            else
                out_rs1_addr<=rs1_addr;
        end
    end
    
    always @(*)
    begin
        if(stall==`Disable)
        begin
            if(clr==`Enable)
                out_rs2_addr<=5'b00000;
            else
                out_rs2_addr<=rs2_addr;
        end
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_rs1<=32'h0000_0000;
        else
            temp_rs1<=rs1;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_rs2<=32'h0000_0000;
        else
            temp_rs2<=rs2;
    end
    
    always @(*)
    begin
        if(clr==`Enable)
            temp_imm<=32'h0000_0000;
        else
            temp_imm<=imm;
    end
    
    always @(posedge clk or posedge rst)
    begin
        if(rst==`Enable)
        begin
            out_optype<=3'b000;
            out_operator<=4'b0000;
            out_pc<=8'b0000_0000;
            out_rd<=5'b00000;
            out_rs1<=32'h0000_0000;
            out_rs2<=32'h0000_0000;
            out_imm<=32'h0000_0000;
        end
        else
        begin
            if(stall==`Disable)
            begin
                out_optype<=temp_optype;
                out_operator<=temp_operator;
                out_pc<=temp_pc;
                out_rd<=temp_rd;
                out_ex_mem_rs2_addr<=rs2_addr;
                out_rs1<=temp_rs1;
                out_rs2<=temp_rs2;
                out_imm<=temp_imm;
            end
        end
    end
endmodule
