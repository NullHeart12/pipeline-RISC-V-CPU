`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 09:39:22
// Design Name: 
// Module Name: DataMem
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

module DataMem(
    input wire rst,
    input wire re,
    input wire we,
    input wire signed [31:0] rs2,
    input wire [7:0] raddr,
    input wire [7:0] waddr,
    output reg signed [31:0] rdata
    );
    
    (*keep="true"*)reg [7:0] mem[0:255];
    
    reg [9:0] i;
    always @(*)
    begin
        if(rst==`Enable)
        begin
            for(i=0;i<256;i=i+1)
                mem[i]<=8'b00000000;
            {mem[3],mem[2],mem[1],mem[0]}<=32'h00000000;
            {mem[7],mem[6],mem[5],mem[4]}<=32'h04070405;
            {mem[15],mem[14],mem[13],mem[12]}<=32'h01020304;
            {mem[23],mem[22],mem[21],mem[20]}<=32'h0000ffff;
            {mem[27],mem[26],mem[25],mem[24]}<=32'h00001234;
            {mem[31],mem[30],mem[29],mem[28]}<=32'h00004321;
        end
        else
        begin
            if(we==`Enable&&waddr!=8'h00)
                {mem[waddr+3],mem[waddr+2],mem[waddr+1],mem[waddr]}<=rs2;         
        end
    end
    
    always @(*)
    begin
        if(rst==`Enable)
        begin
            rdata<=32'h00000000;
        end
        else
        begin
            if(re==`Enable&&raddr!=8'h00)
            begin
                rdata<={mem[raddr+3],mem[raddr+2],mem[raddr+1],mem[raddr]};
            end
            else
            begin
                rdata<=32'h80000000;
            end
        end
    end

endmodule
