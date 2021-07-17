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

`include "admo_defs.v"

module admo_alu
(
    input   [`DATA_WIDTH-1:0]   alu_a,
    input   [`DATA_WIDTH-1:0]   alu_b,
    input   [3:0]               alu_op,
    output  [`DATA_WIDTH-1:0]   alu_res
);
    reg     [`DATA_WIDTH-1:0]   result_reg;
    wire    [`DATA_WIDTH-1:0]  sub_w;


    assign sub_w = alu_a - alu_b;
    assign alu_res = result_reg;


    always @(alu_a or alu_b or alu_op) 
    begin    
        case(alu_op)
            //**************************************
            // ARITHMETIC
            //**************************************
            `ALU_ADD: begin
                result_reg = (alu_a + alu_b);
            end
            `ALU_SUB: begin 
                result_reg = sub_w;
            end
            //**************************************
            // BITWISE
            //**************************************
            `ALU_AND: begin
                result_reg = alu_a & alu_b;
            end
            `ALU_OR: begin
                result_reg = alu_a | alu_b;
            end
            `ALU_XOR: begin
                result_reg = alu_a ^ alu_b;
            end
            default:
            begin
                result_reg = alu_a;
            end
        endcase
    end

endmodule 