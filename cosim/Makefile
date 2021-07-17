PWD=$(shell pwd)
HDLDIR=$(PWD)/../hdl

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(HDLDIR)/admo_alu.v $(HDLDIR)/admo_defs.v 
MODULE = admo_alu_sim
TOPLEVEL = admo_alu
COMPILE_ARGS=-I$(HDLDIR)

include $(shell cocotb-config --makefiles)/Makefile.sim