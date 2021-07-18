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
    input   [`DATA_WIDTH-1:0]   operand_a_i,
    input   [`DATA_WIDTH-1:0]   operand_b_i,
    input   [3:0]               operator_i,
    output  [`DATA_WIDTH-1:0]   result_o
);

    reg     [`DATA_WIDTH-1:0]   result_reg;

    reg     [`DATA_WIDTH-1:0]   shift_stage_0;
    reg     [`DATA_WIDTH-1:0]   shift_stage_1;
    reg     [`DATA_WIDTH-1:0]   shift_stage_2;
    reg     [`DATA_WIDTH-1:0]   shift_stage_3;

    wire    [`DATA_WIDTH-1:0]   sub_res;

    assign sub_res = operand_a_i - operand_b_i;
    assign result_o = result_reg;

    always @(operand_a_i or operand_b_i or operator_i) 
    begin    
        case(operator_i)
            //**************************************
            // ARITHMETIC
            //**************************************
            `ALU_ADD: begin
                result_reg = (operand_a_i + operand_b_i);
            end
            `ALU_SUB: begin 
                result_reg = sub_res;
            end
            //**************************************
            // BITWISE
            //**************************************
            `ALU_AND: begin
                result_reg = operand_a_i & operand_b_i;
            end
            `ALU_OR: begin
                result_reg = operand_a_i | operand_b_i;
            end
            `ALU_XOR: begin
                result_reg = operand_a_i ^ operand_b_i;
            end
            //**************************************
            // SHIFT
            //**************************************
            // `ALU_SLL: begin
            //     result_reg = operand_a_i <<< operand_b_i;
            //     // if(operand_b_i[0] == 1'b1) begin
            //     //     shift_stage_0 = {operand_a_i[30:0],1'b0};
            //     // end else begin
            //     //     shift_stage_0 = operand_a_i;
            //     // end

            //     // if(operand_b_i[1] == 1'b1) begin
            //     //     shift_stage_1 = {shift_stage_0[29:0],2'b00};
            //     // end else begin
            //     //     shift_stage_1 = shift_stage_0;
            //     // end

            //     // if(operand_b_i[2] == 1'b1) begin
            //     //     shift_stage_2 = {shift_stage_1[27:0],4'b0000};
            //     // end else begin
            //     //     shift_stage_2 = shift_stage_1;
            //     // end

            //     // if(operand_b_i[3] == 1'b1) begin
            //     //     shift_stage_3 = {shift_stage_2[23:0],8'b00000000};
            //     // end else begin
            //     //     shift_stage_3 = shift_stage_2;
            //     // end 

            //     // // if(operand_b_i[31:5]) begin
            //     // //     result_reg = {32{1'b0}};
            //     // // end else begin 
            //     //     if(operand_b_i[4] == 1'b1) begin
            //     //         result_reg = {shift_stage_3[15:0],16'b0000000000000000};
            //     //     end else begin 
            //     //         result_reg = shift_stage_3;
            //     //     end
            //     // // end
            // end
            default: begin
                result_reg = operand_a_i;
            end
        endcase
    end


    `ifdef COCOTB_SIM
    initial begin
        $dumpfile ("../wave/admo_alu.vcd");
        $dumpvars (0, admo_alu);
        #1;
    end
    `endif

endmodule 