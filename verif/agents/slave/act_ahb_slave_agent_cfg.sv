`ifndef ACT_AHB_SLAVE_AGENT_CFG
`define ACT_AHB_SLAVE_AGENT_CFG

class act_ahb_slave_agent_cfg extends uvm_object;

  `uvm_object_utils(act_ahb_slave_agent_cfg)

  uvm_active_passive_enum is_active;

  ahb_endianness_e endianness;

  bit [31:0] base_addr;

  int unsigned mem_depth;

  bit enable_wait_states;

  int unsigned max_wait_states;

  ahb_resp_mode_e response_mode;

  bit enable_error_injection;

  function new(string name = "act_ahb_slave_agent_cfg");
    super.new(name);

    is_active = UVM_ACTIVE;

    endianness = LITTLE_ENDIAN;

    base_addr = 32'h0000_0000;
    mem_depth = 1024;

    enable_wait_states = 0;
    max_wait_states    = 8;

    response_mode = AHB_RESP_OKAY;

    enable_error_injection = 0;
  endfunction : new

endclass : act_ahb_slave_agent_cfg
`endif // ACT_AHB_SLAVE_AGENT_CFG
