`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 18:20:22
// Design Name: 
// Module Name: CPU
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

module CPU(
    input wire clk_dis,
    input wire rst,
    output wire [7:0] an,
    output wire [7:0] seg0,
    output wire [7:0] seg1,
    output reg light
    );
    
    wire [7:0] input_PC;
    wire [7:0] output_PC;

    wire [7:0] new_PC;

    wire [31:0] ins;

    wire [7:0] IF_ID_PC;
    wire [31:0] IF_ID_ins;

    wire [6:0] opcode;
    wire [2:0] func1;
    wire [6:0] func2;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire signed [11:0] imm1;
    wire signed [19:0] imm2;

    wire re1;
    wire re2;
    wire [2:0] optype;
    wire [3:0] operator;
    wire clr;
    wire mem_we;
    wire mem_re;
    wire wb_we;

    wire [31:0] imm;

    wire [31:0] rdata1;
    wire [31:0] rdata2;

    wire [2:0] out_optype;
    wire [3:0] out_operator;
    wire [7:0] out_pc;
    wire [4:0] out_rd;
    wire [4:0] out_rs1_addr;
    wire [4:0] out_rs2_addr;
    wire [4:0] out_ex_mem_rs2_addr;
    wire signed [31:0] out_rs1;
    wire signed [31:0] out_rs2;
    wire signed [31:0] out_imm;

    wire rs1_valid;
    wire rs2_valid;
    wire signed [31:0] rs1_imm;
    wire signed [31:0] rs2_imm;
    wire stall;
    wire rs2_valid_mem;
    wire [31:0] rs2_imm_mem;

    wire [31:0] RS_out_rs2_mem;

    wire [31:0] RS_out_rs1;
    wire [31:0] RS_out_rs2;

    wire [31:0] result;
    wire [7:0] data_mem_addr;
    wire [7:0] jump_pc;
    wire [4:0] rd_out;
    wire branch;

    wire [4:0] EX_MEM_rs2_addr;
    wire [2:0] EX_MEM_optype;
    wire [3:0] EX_MEM_operator;
    wire [31:0] EX_MEM_rs2;
    wire [31:0] EX_MEM_result;
    wire [7:0] wmem_addr;
    wire [7:0] rmem_addr;
    wire [4:0] EX_MEM_rd;

    wire [31:0] mem_rdata;

    wire signed [31:0] mem_wb_data;
    wire [4:0] mem_wb_rd;
    wire [2:0] mem_wb_optype;
    wire [3:0] mem_wb_operator;

    reg [4:0] temp_rd_exe_mem;
    
    
    wire clk;
    wire clk2;

    reg [31:0] display_data;

//    reg [31:0] counter_max1=32'h05f5e100;
//    reg [31:0] counter_max2=32'h0000c350;
    reg [31:0] counter_max1=32'h000000000;
    reg [31:0] counter_max2=32'h000000000;

    always @(posedge clk or posedge rst)
    begin
        if(rst==1'b1)
            light<=1'b1;
        else
            light<=~light;
    end

    divider div1(
        .clk_dis(clk_dis),
        .rst(rst),
        .counter_max(counter_max1),
        .clk(clk)
    );

    divider div2(
        .clk_dis(clk_dis),
        .rst(rst),
        .counter_max(counter_max2),
        .clk(clk2)
    );

    display dis(
        .clk_dis(clk2),
        .rst(rst),
        .data(display_data),
        .an(an),
        .seg0(seg0),
        .seg1(seg1)
    );

    always @(posedge clk or posedge rst)
    begin
        if(rst==1'b1)
            display_data<=32'h00000000;
        else
        begin
            // display_data<=rs2_imm;
            display_data<=mem_wb_data;
            // if(result!=32'h80000000)
            //     display_data<=ins;
            // else
            //     display_data<=32'h00000000;
        end
    end

    MUX2to1 mux(
        .branch(branch),
        .new_pc(new_PC),
        .jump(jump_pc),
        .set_pc(input_PC)
        );

    PC pc(
        .clk(clk),
        .rst(rst),
        .addr(input_PC),
        .pc(output_PC),
        .stall(stall)
        );

    PCALU pcalu(
        .pc(output_PC),
        .new_pc(new_PC)
        );
    
    InsMem insmem(
        .rst(rst),
        .pc(output_PC),
        .ins(ins)
        );

    IF_ID if_id(
        .clk(clk),
        .rst(rst),
        .clr(clr),
        .input_pc(new_PC),
        .input_ins(ins),
        .output_pc(IF_ID_PC),
        .output_ins(IF_ID_ins),
        .stall(stall)
        );

    InsDecoder insdecoder(
        .ins(IF_ID_ins),
        .opcode(opcode),
        .func1(func1),
        .func2(func2),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm1(imm1),
        .imm2(imm2)
        );

    CU cu(
        .opcode(opcode),
        .func1(func1),
        .func2(func2),
        .re1(re1),
        .re2(re2),
        .optype(optype),
        .operator(operator),
        .branch(branch),
        .clr(clr),
        .mem_optype(EX_MEM_optype),
        .mem_operator(EX_MEM_operator),
        .mem_we(mem_we),
        .mem_re(mem_re),
        .wb_optype(mem_wb_optype),
        .wb_we(wb_we)
        );

    expand_truncation_imm expand_truncation_imm_(
        .optype(optype),
        .imm1(imm1),
        .imm2(imm2),
        .imm(imm)
        );
    
    registers regs(
        .clk(clk),
        .rst(rst),
        .re1(re1),
        .raddr1(rs1),
        .rdata1(rdata1),
        .re2(re2),
        .raddr2(rs2),
        .rdata2(rdata2),
        .we(wb_we),
        .waddr(mem_wb_rd),
        .wdata(mem_wb_data)
        );
    
    ID_EX id_ex(
        .clk(clk),
        .rst(rst),
        .clr(clr),
        .optype(optype),
        .operator(operator),
        .pc(IF_ID_PC),
        .rd(rd),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rs1(rdata1),
        .rs2(rdata2),
        .imm(imm),
        .out_optype(out_optype),
        .out_operator(out_operator),
        .out_pc(out_pc),
        .out_rd(out_rd),
        .out_rs1_addr(out_rs1_addr),
        .out_rs2_addr(out_rs2_addr),
        .out_ex_mem_rs2_addr(out_ex_mem_rs2_addr),
        .out_rs1(out_rs1),
        .out_rs2(out_rs2),
        .out_imm(out_imm),
        .stall(stall)
        );

    RS RS_(
        .clk(clk),
        .rst(rst),
        .rd_exe(rd_out),
        .data_exe(result),
        .rd_mem(temp_rd_exe_mem),
        .data_mem(mem_rdata),
        .rs1_addr(out_rs1_addr),
        .rs2_addr(out_rs2_addr),
        .rs1_valid(rs1_valid),
        .rs2_valid(rs2_valid),
        .rs1_imm(rs1_imm),
        .rs2_imm(rs2_imm),
        .stall(stall),
        .mem_rs2_addr(EX_MEM_rs2_addr),
        .rs2_valid_mem(rs2_valid_mem),
        .rs2_imm_mem(rs2_imm_mem)
        );
    
    MUX2to1RS mux1(
        .valid(rs1_valid),
        .value(rs1_imm),
        .rs(out_rs1),
        .out_rs(RS_out_rs1)
        );
    MUX2to1RS mux2(
        .valid(rs2_valid),
        .value(rs2_imm),
        .rs(out_rs2),
        .out_rs(RS_out_rs2)
        );
    MUX2to1RS mux3(
        .valid(rs2_valid_mem),
        .value(rs2_imm_mem),
        .rs(EX_MEM_rs2),
        .out_rs(RS_out_rs2_mem)
        );
    
    ALU alu(
        .clk(clk),
        .stall(stall),
        .optype(out_optype),
        .operator(out_operator),
        .rs1(RS_out_rs1),
        .rs2(RS_out_rs2),
        .imm(out_imm),
        .pc(out_pc),
        .rd_in(out_rd),
        .rd_out(rd_out),
        .result(result),
        .data_mem_addr(data_mem_addr),
        .new_pc(jump_pc),
        .branch(branch)
        );

    EX_MEM ex_mem(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .optype(out_optype),
        .operator(out_operator),
        .rs2(out_rs2),
        .rs2_addr(out_ex_mem_rs2_addr),
        .result(result),
        .data_mem_addr(data_mem_addr),
        .rd(out_rd),
        .out_optype(EX_MEM_optype),
        .out_operator(EX_MEM_operator),
        .out_rs2_addr(EX_MEM_rs2_addr),
        .out_rs2(EX_MEM_rs2),
        .out_result(EX_MEM_result),
        .rmem_addr(rmem_addr),
        .wmem_addr(wmem_addr),
        .out_rd(EX_MEM_rd)
        );

    always @(negedge clk)
    begin
        temp_rd_exe_mem<=EX_MEM_rd;
    end
    
    DataMem datamem(
        .rst(rst),
        .re(mem_re),
        .we(mem_we),
        .rs2(RS_out_rs2_mem),
        .raddr(rmem_addr),
        .waddr(wmem_addr),
        .rdata(mem_rdata)
        );

    MEM_WB mem_wb(
        .clk(clk),
        .rst(rst),
        .optype(EX_MEM_optype),
        .operator(EX_MEM_operator),
        .mem_data(mem_rdata),
        .alu_result(EX_MEM_result),
        .rd(EX_MEM_rd),
        .out_rd(mem_wb_rd),
        .out_data(mem_wb_data),
        .out_optype(mem_wb_optype),
        .out_operator(mem_wb_operator)
        );

endmodule
