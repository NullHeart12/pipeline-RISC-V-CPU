`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 18:31:59
// Design Name: 
// Module Name: registers
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

module registers(
    input wire clk,
    input wire rst,

    input wire re1,
    input wire[4:0] raddr1,
    output reg[31:0] rdata1,
    
    input wire re2,
    input wire[4:0] raddr2,
    output reg[31:0] rdata2,
    
    input wire we,
    input wire[4:0] waddr,
    input wire[31:0] wdata
    );
    
    (*keep="true"*)reg[31:0] regs[0:31];
    reg [5:0] i;

    always @(negedge clk)
    begin
        if(re1==`Enable)
            rdata1<=regs[raddr1];
        else
            rdata1<=32'h00000000;
    end
    
    always @(negedge clk)
    begin
        if(re2==`Enable)
            rdata2<=regs[raddr2];
        else
            rdata2<=32'h00000000;
    end
    
    always @(negedge clk or posedge rst)
    begin
        if(rst==`Enable)
        begin
            for(i=0;i<32;i=i+1)
                regs[i]<=32'h00000000;
            regs[9]<=32'h00000000;
            regs[18]<=32'h0a0b0c0d;
            regs[19]<=32'h01020304;
            regs[26]<=32'h01000100;
        end
        else if(we==`Enable)
            regs[waddr]<=wdata;
    end
    
endmodule
