`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 10:28:12
// Design Name: 
// Module Name: define_file
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
//******************global define*******************
`define RstEnable           1'b1
`define RstDisable          1'b0
`define Enable              1'b1
`define Disable             1'b0

`define tInvalid            3'b000
`define RType               3'b001
`define IType               3'b010
`define SType               3'b011
`define BType               3'b100
`define JType               3'b101

`define invalid             4'b0000

`define Radd                4'b0001
`define Rsub                4'b0010
`define Rsll                4'b0011
`define Rslt                4'b0100
`define Rxor                4'b0101
`define Rsrl                4'b0110
`define Rsra                4'b0111
`define Ror                 4'b1000
`define Rand                4'b1001

`define Ilw                 4'b0001
`define Iaddi               4'b0010
`define Islti               4'b0011
`define Ixori               4'b0100
`define Iori                4'b0101
`define Iandi               4'b0110
`define Islli               4'b0111
`define Isrlai              4'b1000
//`define Israi               4'b1001

`define Ssw                 4'b0001

`define Bbeq                4'b0001
`define Bbne                4'b0010
`define Bblt                 4'b0011
`define Bbge                 4'b0100

`define Jjal                4'b0001


//*****************ins mem define******************
`define InsMemRange         256
`define InsMemAddrWidth     8
`define InsMemDataWidth     32
`define InsMemUnitWidth     8

//*****************register files******************
`define RegAddrWidth        5
`define RegDataWidth        32
`define RegRange            32
