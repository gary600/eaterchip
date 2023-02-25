YOSYS ?= yosys
YOSYS_OPTS = -q

CC ?= g++
CC_OPTS = -I$(shell $(YOSYS)-config --datdir)/include --std=c++14

SV_FILES = $(wildcard src/*.sv)
CPP_FILES = $(wildcard src/*.cpp) eaterchip.cpp

.PHONY: all clean show

all: sim

clean:
	rm sim eaterchip.* *.o
	
sim: $(CPP_FILES)
	$(CC) $(CC_OPTS) -o sim $(CPP_FILES)

define YOSYS_SCRIPT
	read_verilog -sv $(SV_FILES); \
	hierarchy -top EaterChip; \
	proc;
endef
.PHONY: eaterchip.cpp
eaterchip.cpp: $(SV_FILES)
	$(YOSYS) $(YOSYS_OPTS) -p "$(YOSYS_SCRIPT) write_cxxrtl -header eaterchip.cpp;"

show: show.dot

show.dot: $(SV_FILES)
	$(YOSYS) $(YOSYS_OPTS) -p "$(YOSYS_SCRIPT) abc -lut 16; show;"