import random
import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def admo_alu_test(dut):
    """ Test admo_alu """
    
    dut.alu_op = 1
    for i in range(10):
        val_a = random.randint(0,10000)
        val_b = random.randint(0,10000)

        dut.alu_a <= val_a 
        dut.alu_b <= val_b
        
        await Timer(2, units='ns')
        #print(f"{dut.alu_res} = {val_a} + {val_b}")
        assert dut.alu_res == (val_a + val_b), f"output was incorrect for {val_a},{val_b}"