class act_ahb_master_monitor extends uvm_monitor;

  `uvm_component_utils(act_ahb_master_monitor)

  act_ahb_master_agent_cfg cfg_h;

  function new(string name = "act_ahb_master_monitor",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(act_ahb_master_agent_cfg)::get(this,"","cfg",cfg_h))
      `uvm_fatal("CFG","Failed to get act_ahb_master_agent_cfg")
  endfunction

endclass : act_ahb_master_monitor