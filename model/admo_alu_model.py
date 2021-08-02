################################################################################
#
# MIT License
# 
# Copyright (c) 2021 Gustavo Ale
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
################################################################################

from admo_defs import *

# Returns a signed int from 32 bit hex value 
def cast_signed(a: int) -> int:
    if(a & 1 << 31):
        a = -((~a) & 0xFFFFFFFF) -1
    return a 

# Shift right logical
def srl(a: int,b: int) -> int:
    if(a < 0 and b != 0):
        return ((a >> 1) & 0x7FFFFFFF) >> (b-1)
    return a >> b

# Shift right arithmetical
def sra(a: int,b: int) -> int:
    a = cast_signed(a)
    return a >> b

# Less than signed
def lts(a: int, b: int) -> int:
    if cast_signed(a) < cast_signed(b):
        return 1
    return 0

def admo_alu_model(alu_a: int, alu_b: int, alu_op: int) -> int:
    return {
        ALU_ADD: alu_a + alu_b,
        ALU_SUB: alu_a - alu_b,
        ALU_AND: alu_a & alu_b,
        ALU_OR:  alu_a | alu_b,
        ALU_XOR: alu_a ^ alu_b,  
        ALU_SLL: alu_a << (alu_b & 0x1F),  
        ALU_SRL: alu_a >> (alu_b & 0x1F),
        ALU_SRA: sra(alu_a,alu_b & 0x1F),
        ALU_LTS: lts(alu_a,alu_b),
        ALU_LTU: alu_a < alu_b,
        # ALU_SRL: srl(alu_a,alu_b & 0x1F),
        # ALU_SRA: alu_a >> (alu_b & 0x1F),  
    }.get(alu_op,alu_a+alu_b) & 0xFFFFFFFF