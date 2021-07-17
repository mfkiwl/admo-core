/*******************************************************************************

MIT License

Copyright (c) 2021 Gustavo Ale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*******************************************************************************/

`define DATA_WIDTH          32

//**************************************
// ALU OPCODES
//**************************************
// @TODO: Redefine these values based on a more refined architecture 
//`define ALU_NOP             4'b0000
// First LSB bits match RISC-V FUNC3 field
`define ALU_ADD             4'b0000
`define ALU_SUB             4'b1000 
`define ALU_XOR             4'b0100
`define ALU_OR              4'b0110 
`define ALU_AND             4'b0111 
`define ALU_SLL             4'b0001
`define ALU_SRL             4'b0101
`define ALU_SRA             4'b1101
`define ALU_LTS             4'b0010
`define ALU_LTU             4'b0011
