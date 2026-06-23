# Project Settings
SIM_DIR   := sim
LOG_DIR   := logs
WAVE_DIR  := waves

FILELIST  := $(SIM_DIR)/act_filelist.f
TOP       := act_tb_top

TEST ?= act_ahb_base_test
SEED ?= random
DUMP ?= 0

SIM ?= questa
PLUSARGS ?= 

# Simulator Selection
ifeq ($(SIM),questa)

VLIB = vlib
VMAP = vmap
VLOG = vlog
VSIM = vsim

ifeq ($(DUMP),1)
  WAVE_OPT = -wlf $(WAVE_DIR)/$(TEST).wlf
  DO_CMD   = "log -r /*; run -all; quit -f"
else
  WAVE_OPT =
  DO_CMD   = "run -all; quit -f"
endif

COMPILE_CMD = $(VLOG) \
	-sv \
	-mfcu \
	-timescale 1ns/1ps \
	-f $(FILELIST) \
	-l $(LOG_DIR)/compile.log

RUN_CMD = $(VSIM) -c $(PLUSARGS) \
	$(WAVE_OPT) \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED) \
	-voptargs=+acc \
	-do $(DO_CMD) \
	-l $(LOG_DIR)/$(TEST).log

GUI_CMD = $(VSIM) \
	$(WAVE_OPT) \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED) \
	-voptargs=+acc

VIEW_CMD = $(VSIM) -view $(WAVE_DIR)/$(TEST).wlf

endif

# Riviera
ifeq ($(SIM),riviera)

VLIB = vlib
VLOG = vlog
VSIM = vsim

ifeq ($(DUMP),1)
DO_CMD = "database -open $(WAVE_DIR)/$(TEST).asdb; \
          probe -create -all -depth all; \
          run -all; \
          database -close; \
          exit"
else
DO_CMD = "run -all; exit"
endif

COMPILE_CMD = $(VLOG) \
    -sv \
    -timescale 1ns/1ps \
    +incdir+$(ALDEC_HOME)/vlib/uvm-1800.2-2020/src \
    -uvmver 1800.2-2020 \
    -f $(FILELIST) \
    -l $(LOG_DIR)/compile.log

RUN_CMD = $(VSIM) -c \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED) \
	-do $(DO_CMD) \
	-l $(LOG_DIR)/$(TEST).log

GUI_CMD = $(VSIM) \
	work.$(TOP) \
	+UVM_TESTNAME=$(TEST) \
	-sv_seed $(SEED)

VIEW_CMD = $(VSIM) -asdb $(WAVE_DIR)/$(TEST).asdb

endif

# Directories
dirs:
	@mkdir -p $(LOG_DIR)
	@mkdir -p $(WAVE_DIR)

# Work Library
work:
ifeq ($(SIM),questa)
	@if [ ! -d work ]; then \
		$(VLIB) work; \
		$(VMAP) work work; \
	fi
endif

ifeq ($(SIM),riviera)
	@if [ ! -d work ]; then \
		$(VLIB) work; \
	fi
endif

# Compile
compile: dirs work
	@echo ""
	@echo "=========================================="
	@echo "Simulator : $(SIM)"
	@echo "Compiling AHB VIP"
	@echo "=========================================="
	@echo ""

	$(COMPILE_CMD)

# Run
run: compile
	@echo ""
	@echo "=========================================="
	@echo "Simulator : $(SIM)"
	@echo "Running    : $(TEST)"
	@echo "Seed       : $(SEED)"
	@echo "Dump       : $(DUMP)"
	@echo "=========================================="
	@echo ""

	$(RUN_CMD)

# GUI
gui: compile
	@echo ""
	@echo "=========================================="
	@echo "Launching GUI ($(SIM))"
	@echo "=========================================="
	@echo ""

	$(GUI_CMD)

# View Waves
view:
	@echo ""
	@echo "Opening waveform..."
	@echo ""

ifeq ($(SIM),questa)
	@$(VIEW_CMD)
endif

ifeq ($(SIM),riviera)
	@$(VIEW_CMD) >/dev/null 2>&1 &
endif

clean:
	rm -rf work
	rm -rf transcript
	rm -rf vsim.wlf
	rm -rf *.asdb
	rm -rf $(LOG_DIR)/*
	rm -rf $(WAVE_DIR)/*

help:
	@echo ""
	@echo "Examples:"
	@echo ""
	@echo "make compile SIM=questa"
	@echo "make run     SIM=questa"
	@echo "make gui     SIM=questa"
	@echo "make run     SIM=questa DUMP=1"
	@echo ""
	@echo "make compile SIM=riviera"
	@echo "make run     SIM=riviera"
	@echo "make gui     SIM=riviera"
	@echo "make run     SIM=riviera DUMP=1"
	@echo ""
