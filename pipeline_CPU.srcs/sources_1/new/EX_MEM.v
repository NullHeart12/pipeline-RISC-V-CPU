`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 19:27:55
// Design Name: 
// Module Name: EX_MEM
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

module EX_MEM(
    input wire clk,
    input wire rst,
    input stall,
    input wire [2:0] optype,
    input wire [3:0] operator,
    input wire signed [31:0] rs2,
    input wire [4:0] rs2_addr,
    input wire signed [31:0] result,
    input wire [7:0] data_mem_addr,
    input wire [4:0] rd,
    output reg [2:0] out_optype,
    output reg [3:0] out_operator,
    output reg [4:0] out_rs2_addr,
    output reg signed [31:0] out_rs2,
    output reg signed [31:0] out_result,
    output reg [7:0] rmem_addr,
    output reg [7:0] wmem_addr,
    output reg [4:0] out_rd
    );
    
    reg [2:0] temp_optype;
    reg [3:0] temp_operator;
    reg signed [31:0] temp_rs2;
    reg [4:0] temp_rs2_addr;
    reg signed [31:0] temp_result;  
    reg [7:0] temp_data_mem_addr;
    reg [4:0] temp_rd;
    
    always @(optype)
    begin
        temp_optype<=optype;
    end
    
    always @(operator)
    begin
        temp_operator<=operator;
    end
    
    always @(rs2)
    begin
        temp_rs2<=rs2;
    end

    always @(rs2_addr)
    begin
        temp_rs2_addr<=rs2_addr;
    end
    
    always @(result)
    begin
        temp_result<=result;
    end
    
    always @(data_mem_addr)
    begin
        temp_data_mem_addr<=data_mem_addr;
    end
    
    always @(rd)
    begin
        temp_rd<=rd;
    end
    
    always @(posedge clk)
    begin
        if(rst==`Enable)
        begin
            out_optype<=3'b000;
            out_operator<=4'b0000;
            out_rs2_addr<=5'b00000;
            out_rs2<=32'h00000000;
            out_result<=32'h00000000;
            rmem_addr<=8'h00;
            wmem_addr<=8'h00;
            out_rd<=5'b00000;
        end
        begin
            if(stall==`Disable)
            begin
                out_optype<=temp_optype;
                out_operator<=temp_operator;
                out_rs2<=temp_rs2;
                if(temp_optype==`SType)
                begin
                    out_rs2_addr<=temp_rs2_addr;
                    out_rs2<=temp_rs2;
                end
                else
                begin
                    out_rs2_addr<=5'b00000;
                    out_rs2<=32'h00000000;
                end
                out_result<=temp_result;
                if(temp_optype==`IType&&temp_operator==`Ilw)
                begin
                    rmem_addr<=temp_data_mem_addr;
                    wmem_addr<=8'h00;
                end
                else if(temp_optype==`SType&&temp_operator==`Ssw)
                begin
                    wmem_addr<=temp_data_mem_addr;
                    rmem_addr<=8'h00;
                end
                out_rd<=temp_rd;
            end
        end
    end
    
endmodule
