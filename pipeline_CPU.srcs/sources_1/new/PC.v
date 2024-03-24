`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 10:08:12
// Design Name: 
// Module Name: PC
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

module PC(
    input wire clk,
    input wire rst,
    input wire [`InsMemAddrWidth-1:0] addr,
    output reg [`InsMemAddrWidth-1:0] pc,
    
    input wire stall
    );

    always @(posedge clk or posedge rst)
    begin
        if(rst==`RstEnable)
            pc<=8'b00000000;
        else
        begin
            if(stall==`Disable)
            begin
                if(addr>=`InsMemRange)
                    pc<=8'b00000000;
                else
                    pc<=addr;
            end
        end
    end

endmodule
