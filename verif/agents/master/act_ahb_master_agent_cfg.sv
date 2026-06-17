`ifndef ACT_AHB_MASTER_AGENT_CFG
`define ACT_AHB_MASTER_AGENT_CFG

class act_ahb_master_agent_cfg extends uvm_object;

  `uvm_object_utils(act_ahb_master_agent_cfg)

  uvm_active_passive_enum is_active;

  ahb_endianness_e endianness;

  bit enable_idle_insertion;
  bit enable_busy_insertion;

  int unsigned max_idle_cycles;
  int unsigned max_busy_cycles;

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
