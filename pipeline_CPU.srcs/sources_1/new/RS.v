`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 14:22:17
// Design Name: 
// Module Name: RS
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

module RS(
    input wire clk,
    input wire rst,

    input wire [4:0] rd_exe,
    input wire [31:0] data_exe,
    input wire [4:0] rd_mem,
    input wire [31:0] data_mem,

    (*keep="true"*)input wire [4:0] rs1_addr,
    (*keep="true"*)input wire [4:0] rs2_addr,
    output reg rs1_valid,
    output reg rs2_valid,
    output reg signed [31:0] rs1_imm,
    output reg signed [31:0] rs2_imm,
    (*keep="true"*)output reg stall,

    input wire [4:0] mem_rs2_addr,
    output reg rs2_valid_mem,
    output reg signed [31:0] rs2_imm_mem
    );
    
    (*keep="true"*)reg [37:0] RS [0:3];
    reg [2:0] i;
    reg [2:0] j;
    reg [2:0] k;
    reg [2:0] l;
    reg [2:0] m;
    reg [2:0] counter;
    reg rs1_stall;
    reg rs2_stall;
        
    always @(*)
    begin
        if(rst==`Enable)
        begin
            counter<=0;
            for(k=0;k<4;k=k+1)
            begin
                RS[k]<=38'b0000_0000_0000_0000_0000_0000_0000_0000_0000_00;
            end
        end
        else
        begin
            if(rd_exe!=5'b00000&&RS[0][37:33]!=rd_exe&&RS[1][37:33]!=rd_exe&&RS[2][37:33]!=rd_exe&&RS[3][37:33]!=rd_exe)
            begin
                RS[counter][37:33]<=rd_exe;
                RS[counter][32]<=`Disable;
                counter<=counter+1;
                if(counter==3)
                    counter<=0;
            end
            
            for(j=0;j<4;j=j+1)
            begin
                if(RS[j][37:33]==rd_exe&&rd_exe!=5'b00000&&RS[j][32]==`Disable&&data_exe!=32'h80000000)
                begin
                    RS[j][32]<=`Enable;
                    RS[j][31:0]<=data_exe;
                end
            end

            for(j=0;j<4;j=j+1)
            begin
                if(RS[j][37:33]==rd_mem&&rd_mem!=5'b00000&&RS[j][32]==`Disable&&data_mem!=32'h80000000)
                begin
                    RS[j][32]<=`Enable;
                    RS[j][31:0]<=data_mem;
                end
            end
        end     
    end
    
    always @(posedge clk or posedge rst)
    begin
        if(rst==`Enable)
        begin
            rs1_valid<=`Disable;
            rs1_stall<=`Disable;
            rs1_imm<=32'h00000000;
            rs2_valid<=`Disable;
            rs2_stall<=`Disable;
            rs2_imm<=32'h00000000;            
        end
        else
        begin
            rs1_valid<=`Disable;
            rs1_stall<=`Disable;
            rs1_imm<=32'h00000000; 
            rs2_valid<=`Disable;
            rs2_stall<=`Disable;
            rs2_imm<=32'h00000000;
            for(i=0;i<4;i=i+1)
            begin
                if(RS[i][37:33]==rs1_addr&&rs1_addr!=5'b00000)
                begin
                    rs1_valid<=RS[i][32];
                    rs1_imm<=RS[i][31:0];
                    if(RS[i][32]==`Disable)
                        rs1_stall<=`Enable;
                end
                if(RS[i][37:33]==rs2_addr&&rs2_addr!=5'b00000)
                begin
                    rs2_valid<=RS[i][32];
                    rs2_imm<=RS[i][31:0];
                    if(RS[i][32]==`Disable)
                        rs2_stall<=`Enable;
                end                  
            end
        end
    end

    // always @(posedge clk or posedge rst)
    // begin
    //     if(rst==`Enable)
    //     begin
    //         rs2_valid<=`Disable;
    //         rs2_stall<=`Disable;
    //         rs2_imm<=32'h00000000;
    //     end
    //     else
    //     begin
    //         rs2_valid<=`Disable;
    //         rs2_stall<=`Disable;
    //         rs2_imm<=32'h00000000;        
    //         for(j=0;j<4;j=j+1)
    //         begin
    //             if(RS[j][37:33]==rs2_addr&&rs2_addr!=5'b00000)
    //             begin
    //                 rs2_valid<=RS[j][32];
    //                 rs2_imm<=RS[j][31:0];
    //                 if(RS[j][32]==`Disable)
    //                     rs2_stall<=`Enable;
    //             end            
    //         end
    //     end
    // end

    always @(*)
    begin
        rs2_valid_mem<=`Disable;
        rs2_imm_mem<=32'h00000000;
        for(m=0;m<4;m=m+1)
        begin
            if(RS[m][37:33]==mem_rs2_addr&&mem_rs2_addr!=5'b00000)
            begin
                rs2_valid_mem<=RS[m][32];
                rs2_imm_mem<=RS[m][31:0];
            end
        end
    end

    always @(*)
    begin
        if(rst==`Enable)
            stall<=`Disable;
        else if(rs1_stall==`Enable||rs2_stall==`Enable)
            stall<=`Enable;
        else
            stall<=`Disable;
    end
    
endmodule
