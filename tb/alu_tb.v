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

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    
    reg [3:0] op;

    wire [31:0] res;


    admo_alu ALU(
        .alu_a(a),
        .alu_b(b),
        .alu_op(op),
        .alu_res(res)
    );


    initial begin
        $dumpfile("dump_alu_tb.vcd");
        $dumpvars(1,alu_tb);

        #1 a <= 32'b11011000;
        #1 b <= 32'b11110000;

        #10 a <= {32{1'b0}};
        #10 a <= {32{1'b0}};

        #15 a <= {32{1'b1}};
        #15 a <= {32{1'b1}};


        #20 $finish;

    end

endmodule
