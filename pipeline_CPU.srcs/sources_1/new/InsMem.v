`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 10:55:03
// Design Name: 
// Module Name: InsMem
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

module InsMem(
    input wire rst,
    input wire[`InsMemAddrWidth-1:0] pc,
    output reg[`InsMemDataWidth-1:0] ins
    );

    (*keep="true"*)reg[`InsMemUnitWidth-1:0] mem[0:`InsMemRange-1];

    reg [9:0] i;
    
    //initial the instruction memory by reset signal
    always @(rst)
    begin
        if(rst==`RstEnable)
        begin
            for(i=0;i<`InsMemRange;i=i+1)
                mem[i]<=8'h00;

            {mem[3],mem[2],mem[1],mem[0]}<=32'b0000000_10011_10010_000_01100_0110011;       //Radd rs2=r19,rs1=r18,rd=r12
            {mem[7],mem[6],mem[5],mem[4]}<=32'b000000010111_10010_000_01101_0010011;        //Iaddi imm=23,rs1=r18,rd=r13
            {mem[11],mem[10],mem[9],mem[8]}<=32'b000000000100_01001_010_10100_0000011;      //Lw offset=4,rs1=r9,rd=r20
            {mem[15],mem[14],mem[13],mem[12]}<=32'b000000001100_01001_010_10101_0000011;    //Lw offset=12,rs1=r9,rd=r21
            // {mem[19],mem[18],mem[17],mem[16]}<=32'b0100000_10101_10100_000_01110_0110011;   //Rsub rs2=r21,rs1=r20,rd=r14
            // {mem[19],mem[18],mem[17],mem[16]}<=32'b0000000_10101_10100_110_01110_0110011;   //Ror rs2=r21,rs1=r20,rd=r14
            {mem[19],mem[18],mem[17],mem[16]}<=32'b0000000_10011_10101_000_01110_0110011;   //Radd rs2=r19,rs1=r21,rd=r14
            {mem[23],mem[22],mem[21],mem[20]}<=32'b0000000_01110_01001_010_01000_0100011;   //Sw offset=8,rs2=r14,rs1=r9
            {mem[27],mem[26],mem[25],mem[24]}<=32'b0000000_01100_01100_100_01100_0110011;   //Rxor rs2=r12,rs1=r12,rd=r12
            {mem[31],mem[30],mem[29],mem[28]}<=32'b000000010100_01001_010_10110_0000011;    //Lw offset=20,rs1=r9,rd=r22
            {mem[35],mem[34],mem[33],mem[32]}<=32'b111111111111_10110_100_10111_0010011;    //Ixori imm=-1,rs1=r22,rd=r23
            {mem[39],mem[38],mem[37],mem[36]}<=32'b0000000_10111_01001_010_10000_0100011;   //Sw offset=16,rs2=r23,rs1=r9
            {mem[43],mem[42],mem[41],mem[40]}<=32'b000000011000_01001_010_11000_0000011;    //Lw offset=24,rs1=r9,rd=r24
            {mem[47],mem[46],mem[45],mem[44]}<=32'b000000011100_01001_010_11001_0000011;    //Lw offset=28,rs1=r9,rd=r25
            {mem[51],mem[50],mem[49],mem[48]}<=32'b0000000_11001_11000_000_00100_1100011;   //Bbeq rs2=r25,rs1=r24,offset=2
            // {mem[51],mem[50],mem[49],mem[48]}<=32'b0000000_10110_11001_000_00100_1100011;   //Bbeq rs2=r22,rs1=r25,offset=2
            {mem[55],mem[54],mem[53],mem[52]}<=32'b0000000_01010_11010_001_11011_0010011;   //Islli sll=10,rs1=r26,rd=r27
            {mem[59],mem[58],mem[57],mem[56]}<=32'b0000000_10110_11010_101_11100_0010011;   //Isrli srl=22,rs1=r26,rd=r28
            {mem[63],mem[62],mem[61],mem[60]}<=32'b1_1111110000_1_11111111_11111_1101111;    //Jal imm=0xfffffff0
            {mem[67],mem[66],mem[65],mem[64]}<=32'b0000000_11011_11100_110_11101_0110011;   //Ror rs2=r28,rs1=r27,rd=r29
            {mem[71],mem[70],mem[69],mem[68]}<=32'b0000001_11101_01001_010_00000_0100011;    //Sw offset=32,rs2=r29,rs1=r9
        end
    end
    
    always @(*)
    begin
        ins<={mem[pc+3],mem[pc+2],mem[pc+1],mem[pc]};
    end
endmodule
