`ifndef ACT_AHB_MASTER_AGENT_CFG
`define ACT_AHB_MASTER_AGENT_CFG

class act_ahb_master_agent_cfg extends uvm_object;

  `uvm_object_utils(act_ahb_master_agent_cfg)

  uvm_active_passive_enum is_active;

  ahb_endianness_e endianness;

  bit enable_idle_insertion;
  bit enable_busy_insertion;
  
  // Idle configuration
  int unsigned idle_min_cycles;
  int unsigned idle_max_cycles;
  int unsigned idle_probability;   
  
  // Busy configuration
  int unsigned busy_min_cycles;
  int unsigned busy_max_cycles;
  int unsigned busy_probability;   
  
  bit enable_error_injection;

  function new(string name = "act_ahb_master_agent_cfg");
    super.new(name);

    is_active = UVM_ACTIVE;

    endianness = LITTLE_ENDIAN;

    enable_idle_insertion = 0;
    enable_busy_insertion = 0;

    enable_error_injection = 0;
  endfunction : new

endclass : act_ahb_master_agent_cfg
`endif // ACT_AHB_MASTER_AGENT_CFG
