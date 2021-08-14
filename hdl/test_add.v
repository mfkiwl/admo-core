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

module test_add
(
    input   [`DATA_WIDTH-1:0]   operand_a_i,
    input   [`DATA_WIDTH-1:0]   operand_b_i,
    input   [3:0]               operator_i,
    output  [`DATA_WIDTH-1:0]   result_o
);

    reg     [`DATA_WIDTH-1:0]   result_reg;
   
    wire    [`DATA_WIDTH:0] adder_res;
    wire    [`DATA_WIDTH:0]   adder_a;
    reg     [`DATA_WIDTH:0]   adder_b;
    
    assign adder_a = {operand_a_i,1'b1};
    
    always @(operand_b_i or operator_i) begin
        if(operator_i[3]) begin
            adder_b = {operand_b_i,1'b0} ^ {33{1'b1}};
        end else begin
            adder_b = {operand_b_i,1'b0};
        end
    end

    assign adder_res = adder_a + adder_b;
    
    assign result_o = result_reg;

    always @(operand_a_i or operand_b_i or operator_i or adder_res) 
    begin    
        case(operator_i)
            //**************************************
            // ARITHMETIC
            //**************************************
            `ALU_ADD, `ALU_SUB: begin 
                result_reg = adder_res[32:1];
            end

            default: begin
                result_reg = adder_res[32:1];
            end
        endcase
    end


    `ifdef COCOTB_SIM
    initial begin
        $dumpfile ("../wave/test_add.vcd");
        $dumpvars (0, test_add);
        #1;
    end
    `endif

endmodule 