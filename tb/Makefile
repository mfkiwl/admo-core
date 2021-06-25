SYNTH=iverilog
RTL=$(wildcard ../rtl/*.v)
TB=$(patsubst %.v,%.o,$(wildcard *.v))
FLAGS=-I../rtl

all: $(TB)
	echo "TB: " $(TB)
	echo "RTL: " $(RTL)

%.o: %.v
	$(SYNTH) $(FLAGS) $(RTL) $< -o $@

clean:
	rm $(TB)