`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 16:24:43
// Design Name: 
// Module Name: display
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

module display(
    input wire clk_dis,
    input wire rst,
    input wire [31:0] data,
    output reg [7:0] an,
    (*keep="true"*)output reg [7:0] seg0,
    (*keep="true"*)output reg [7:0] seg1
    );

    reg [2:0] bit_num;
    reg [3:0] dis_num;

    always @(posedge clk_dis or posedge rst)
    begin
        if(rst==`RstEnable)
        begin
            an<=8'hff;
            bit_num<=3'b000;
            dis_num<=4'b0000;
        end
        else
        begin
            case(bit_num)
                3'b000:begin an<=8'b0000_0001; dis_num<=data[3:0]; end
                3'b001:begin an<=8'b0000_0010; dis_num<=data[7:4]; end
                3'b010:begin an<=8'b0000_0100; dis_num<=data[11:8]; end
                3'b011:begin an<=8'b0000_1000; dis_num<=data[15:12]; end
                3'b100:begin an<=8'b0001_0000; dis_num<=data[19:16]; end
                3'b101:begin an<=8'b0010_0000; dis_num<=data[23:20]; end
                3'b110:begin an<=8'b0100_0000; dis_num<=data[27:24]; end
                3'b111:begin an<=8'b1000_0000; dis_num<=data[31:28]; end
            endcase
            if(bit_num==3'b111)
                bit_num<=3'b000;
            else
                bit_num<=bit_num+1;
        end
    end

    always @(dis_num or rst)
    begin
        if(rst==`RstEnable)
        begin
            seg0<=8'hff;
            seg1<=8'hff;
        end
        else
        begin
            case(dis_num)
                4'h0 :begin seg1 = 8'hfc; seg0 = 8'hfc; end
                4'h1 :begin seg1 = 8'h60; seg0 = 8'h60; end
                4'h2 :begin seg1 = 8'hda; seg0 = 8'hda; end
                4'h3 :begin seg1 = 8'hf2; seg0 = 8'hf2; end
                4'h4 :begin seg1 = 8'h66; seg0 = 8'h66; end
                4'h5 :begin seg1 = 8'hb6; seg0 = 8'hb6; end
                4'h6 :begin seg1 = 8'hbe; seg0 = 8'hbe; end
                4'h7 :begin seg1 = 8'he0; seg0 = 8'he0; end
                4'h8 :begin seg1 = 8'hfe; seg0 = 8'hfe; end
                4'h9 :begin seg1 = 8'hf6; seg0 = 8'hf6; end
                4'ha :begin seg1 = 8'hee; seg0 = 8'hee; end
                4'hb :begin seg1 = 8'h3e; seg0 = 8'h3e; end
                4'hc :begin seg1 = 8'h9c; seg0 = 8'h9c; end
                4'hd :begin seg1 = 8'h7a; seg0 = 8'h7a; end
                4'he :begin seg1 = 8'h9e; seg0 = 8'h9e; end
                4'hf :begin seg1 = 8'h8e; seg0 = 8'h8e; end
            endcase
        end
    end

endmodule
