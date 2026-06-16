package act_ahb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"


  typedef enum {
    LITTLE_ENDIAN,
    BIG_ENDIAN
  } ahb_endianness_e;

  typedef enum {
    AHB_RESP_OKAY,
    AHB_RESP_ERROR
  } ahb_resp_mode_e;


  `include "../env/act_ahb_env_cfg.sv"

  `include "../agents/master/act_ahb_master_agent_cfg.sv"
  `include "../agents/slave/act_ahb_slave_agent_cfg.sv"


  `include "../agents/master/act_ahb_master_sequencer.sv"
  `include "../agents/master/act_ahb_master_driver.sv"
  `include "../agents/master/act_ahb_master_monitor.sv"
  `include "../agents/master/act_ahb_master_agent.sv"

  `include "../agents/slave/act_ahb_slave_sequencer.sv"
  `include "../agents/slave/act_ahb_slave_driver.sv"
  `include "../agents/slave/act_ahb_slave_monitor.sv"
  `include "../agents/slave/act_ahb_slave_agent.sv"


  `include "../env/act_ahb_virtual_sequencer.sv"
  `include "../env/act_ahb_scoreboard.sv"
  `include "../env/act_ahb_coverage.sv"
  `include "../env/act_ahb_env.sv"


  `include "../tests/act_ahb_base_test.sv"

endpackage : act_ahb_pkg