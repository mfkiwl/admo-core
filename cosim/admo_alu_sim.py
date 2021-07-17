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

import random
import cocotb
from cocotb.triggers import Timer
from admo_alu_model import admo_alu_model

@cocotb.test()
async def admo_alu_test(mod):
    """ Test admo_alu """
    
    mod.alu_op = 1
    for i in range(10000):
        val_a = random.randint(0,1<<32)
        val_b = random.randint(0,1<<32)
        val_op = random.randint(0,16) & 0b1111
        # val_op = 0
        val_res = admo_alu_model(val_a,val_b,val_op)

        mod.alu_a <= val_a 
        mod.alu_b <= val_b
        mod.alu_op <= val_op

        await Timer(1, units='ns')
        assert mod.alu_res == val_res, \
        f"[{i}] - incorrect for A: {val_a}, B: {val_b}, OP: {val_op} \n"\
        f"Expected {val_res}, returned: {mod.alu_res.value+0}"