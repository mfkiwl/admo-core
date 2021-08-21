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

//******************************************************************************
// ADMO CORE ARITHMETIC LOGIC UNIT
//******************************************************************************
module admo_alu
#(
    parameter DATA_WIDTH = 32
)
(
    input  wire [DATA_WIDTH-1:0]    operand_a_i,
    input  wire [DATA_WIDTH-1:0]    operand_b_i,
    input  wire [3:0]               operator_i,
    // input   [$clog2(DATA_WIDTH):0] shamt,
    output wire [DATA_WIDTH-1:0]    result_o
);

    //**************************************
    // SHIFTER RELATED
    //**************************************

    reg     [DATA_WIDTH-1:0]    shift_stage_0;
    reg     [DATA_WIDTH-1:0]    shift_stage_1;
    reg     [DATA_WIDTH-1:0]    shift_stage_2;
    reg     [DATA_WIDTH-1:0]    shift_stage_3;
    reg     compl_bit;

    // reg     [DATA_WIDTH-1:0]    shift_stage [$clog2(DATA_WIDTH)-1:0];
    // integer stage;
        
    //**************************************
    // ADDER/SUBTRACTOR
    //**************************************

    wire    [DATA_WIDTH:0]     adder_res;
    wire    [DATA_WIDTH:0]     adder_a;
    reg     [DATA_WIDTH:0]     adder_b;
    
    assign  adder_a = {operand_a_i,1'b1};
    assign  adder_res = adder_a + adder_b;
    
    always @(operand_b_i or operator_i) begin
        case(operator_i)
            `ALU_SUB, 
            `ALU_LTS, 
            `ALU_LTU: adder_b = {operand_b_i,1'b0} ^ {DATA_WIDTH+1{1'b1}};
            default: adder_b = {operand_b_i,1'b0};
        endcase
    end

    reg     [DATA_WIDTH-1:0]   result_reg;
   
    assign  result_o = result_reg;

    always @(operand_a_i or operand_b_i or operator_i or adder_res) 
    begin    
        compl_bit = operand_a_i[DATA_WIDTH-1] & operator_i[3];
        case(operator_i)
            //**************************************
            // ARITHMETIC
            //**************************************
            `ALU_ADD, `ALU_SUB: begin 
                result_reg = adder_res[DATA_WIDTH:1];
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
            `ALU_SLL: begin
                if(operand_b_i[0] == 1'b1) begin
                    shift_stage_0 = {operand_a_i[30:0],1'b0};
                end else begin
                    shift_stage_0 = operand_a_i;
                end

                if(operand_b_i[1] == 1'b1) begin
                    shift_stage_1 = {shift_stage_0[29:0],2'b00};
                end else begin
                    shift_stage_1 = shift_stage_0;
                end

                if(operand_b_i[2] == 1'b1) begin
                    shift_stage_2 = {shift_stage_1[27:0],4'b0000};
                end else begin
                    shift_stage_2 = shift_stage_1;
                end

                if(operand_b_i[3] == 1'b1) begin
                    shift_stage_3 = {shift_stage_2[23:0],8'b00000000};
                end else begin
                    shift_stage_3 = shift_stage_2;
                end 

                if(operand_b_i[4] == 1'b1) begin
                    result_reg = {shift_stage_3[15:0],16'b0000000000000000};
                end else begin 
                    result_reg = shift_stage_3;
                end
            end
            
            `ALU_SRL, `ALU_SRA: begin 
                if(operand_b_i[0] == 1'b1) begin
                    shift_stage_0 = {{1{compl_bit}}, operand_a_i[31:1]};
                end else begin
                    shift_stage_0 = operand_a_i;
                end

                if(operand_b_i[1] == 1'b1) begin
                    shift_stage_1 = {{2{compl_bit}}, shift_stage_0[31:2]};
                end else begin
                    shift_stage_1 = shift_stage_0;
                end

                if(operand_b_i[2] == 1'b1) begin
                    shift_stage_2 = {{4{compl_bit}}, shift_stage_1[31:4]};
                end else begin
                    shift_stage_2 = shift_stage_1;
                end

                if(operand_b_i[3] == 1'b1) begin
                    shift_stage_3 = {{8{compl_bit}}, shift_stage_2[31:8]};
                end else begin
                    shift_stage_3 = shift_stage_2;
                end

                if(operand_b_i[4] == 1'b1) begin
                    result_reg = {{16{compl_bit}}, shift_stage_3[31:16]};
                end else begin
                    result_reg = shift_stage_3;
                end
            end
            
            //**************************************
            // COMPARATOR
            //**************************************
            `ALU_LTS, `ALU_LTU: begin
                if(operand_a_i[31] == operand_b_i[31]) begin
                    result_reg = adder_res[32];
                end else begin
                    if(operator_i == `ALU_LTU) begin
                        result_reg = !operand_a_i[31];
                    end else begin
                        result_reg = operand_a_i[31];
                    end
                end
            end

            default: begin
                result_reg = adder_res[32:1];
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
