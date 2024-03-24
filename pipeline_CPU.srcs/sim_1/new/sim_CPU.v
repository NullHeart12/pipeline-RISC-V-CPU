`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 21:00:29
// Design Name: 
// Module Name: sim_CPU
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


module sim_CPU();
    reg clk_dis;
    reg rst;
    wire [7:0] an;
    wire [7:0] seg0;
    wire [7:0] seg1;
    CPU cpu(
        .clk_dis(clk_dis),
        .rst(rst),
        .an(an),
        .seg0(seg0),
        .seg1(seg1)
        );
        
    initial
    begin
        clk_dis<=1;
        rst<=1;
        #50 rst<=0;
    end
    
    always #50 clk_dis=~clk_dis;
    
endmodule
