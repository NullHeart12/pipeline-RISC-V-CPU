`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 16:12:31
// Design Name: 
// Module Name: divider
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

module divider(
    input wire clk_dis,
    input wire rst,
    input wire [31:0] counter_max,
    output reg clk
    );

    reg [31:0] counter;

    always @(posedge clk_dis or posedge rst)
    begin
        if(rst==`RstEnable)
        begin
            counter<=32'h00000000;
            clk<=1;
        end
        else
        begin
            if(counter==counter_max)
            begin
                clk<=~clk;
                counter<=32'h00000000;
            end
            else
                counter<=counter+1;
        end
    end

endmodule
