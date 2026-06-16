SIM_DIR   := sim
LOG_DIR   := logs
WAVE_DIR  := waves

FILELIST  := $(SIM_DIR)/act_filelist.f
TOP       := act_tb_top

TEST ?= act_ahb_base_test
SEED ?= random
DUMP ?= 0

VLIB = vlib
VMAP = vmap
VLOG = vlog
VSIM = vsim

ifeq ($(DUMP),1)
  WLF_OPT = -wlf $(WAVE_DIR)/$(TEST).wlf
else
  WLF_OPT =
endif

dirs:
	@mkdir -p $(LOG_DIR)
	@mkdir -p $(WAVE_DIR)

work:
	@if [ ! -d work ]; then \
		$(VLIB) work; \
		$(VMAP) work work; \
	fi

compile: dirs work
	@echo ""
	@echo "=========================================="
	@echo "Compiling AHB VIP"
	@echo "=========================================="
	@echo ""

	$(VLOG) \
	-sv \
	-mfcu \
	-timescale 1ns/1ps \
	-f $(FILELIST)

run: compile
	@echo ""
	@echo "=========================================="
	@echo "Running $(TEST)"
	@echo "=========================================="
	@echo ""

	$(VSIM) -c \
	$(WLF_OPT) \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED) \
	-do "run -all; quit -f" \
	-l $(LOG_DIR)/$(TEST).log

gui: compile
	$(VSIM) \
	$(WLF_OPT) \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED)

view:
	$(VSIM) -view $(WAVE_DIR)/$(TEST).wlf

clean:
	rm -rf work
	rm -rf transcript
	rm -rf vsim.wlf
	rm -rf $(LOG_DIR)/*
	rm -rf $(WAVE_DIR)/*

help:
	@echo ""
	@echo "make compile"
	@echo "make run"
	@echo "make gui"
	@echo "make run DUMP=1"
	@echo "make gui DUMP=1"
	@echo "make clean"
	@echo ""