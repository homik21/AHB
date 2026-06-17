`ifndef ACT_AHB_ENV_CFG
`define ACT_AHB_ENV_CFG

class act_ahb_env_cfg extends uvm_object;

  `uvm_object_utils(act_ahb_env_cfg)

  bit has_master_agent;
  bit has_slave_agent;

  bit has_scoreboard;
  bit has_coverage;

  bit has_virtual_sequencer;

  function new(string name = "act_ahb_env_cfg");
    super.new(name);

    has_master_agent      = 1;
    has_slave_agent       = 1;

    has_scoreboard        = 1;
    has_coverage          = 1;

    has_virtual_sequencer = 1;
  endfunction

endclass
`endif // ACT_AHB_ENV_CFG
