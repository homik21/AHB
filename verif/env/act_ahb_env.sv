`ifndef ACT_AHB_ENV
`define ACT_AHB_ENV

class act_ahb_env extends uvm_env;

  `uvm_component_utils(act_ahb_env)

  act_ahb_env_cfg cfg_h;

  act_ahb_master_agent        master_agent_h;
  act_ahb_slave_agent         slave_agent_h;

  act_ahb_scoreboard          scoreboard_h;
  act_ahb_coverage            coverage_h;

  act_ahb_virtual_sequencer   virtual_seqr_h;

  function new(string name = "act_ahb_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(act_ahb_env_cfg)::get(this,"","env_cfg",cfg_h))
      `uvm_fatal("ENV_CFG","Failed to get act_ahb_env_cfg")

    if(cfg_h.has_master_agent)
      master_agent_h =act_ahb_master_agent::type_id::create("master_agent_h",this);

    if(cfg_h.has_slave_agent)
      slave_agent_h =act_ahb_slave_agent::type_id::create("slave_agent_h",this);

    if(cfg_h.has_scoreboard)
      scoreboard_h =act_ahb_scoreboard::type_id::create("scoreboard_h",this);

    if(cfg_h.has_coverage)
      coverage_h =act_ahb_coverage::type_id::create("coverage_h",this);

    if(cfg_h.has_virtual_sequencer)
      virtual_seqr_h =act_ahb_virtual_sequencer::type_id::create("virtual_seqr_h",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass : act_ahb_env
`endif // ACT_AHB_ENV
