class act_ahb_master_agent extends uvm_agent;

  `uvm_component_utils(act_ahb_master_agent)

  act_ahb_master_agent_cfg cfg_h;

  act_ahb_master_driver     driver_h;
  act_ahb_master_monitor    monitor_h;
  act_ahb_master_sequencer  sequencer_h;

  function new(string name = "act_ahb_master_agent",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(act_ahb_master_agent_cfg)::get(this,"","cfg",cfg_h))
      `uvm_fatal("CFG","Failed to get act_ahb_master_agent_cfg")
    
    monitor_h =act_ahb_master_monitor::type_id::create("monitor_h",this);

    if(cfg_h.is_active == UVM_ACTIVE) begin
      driver_h = act_ahb_master_driver::type_id::create("driver_h",this);
      sequencer_h =act_ahb_master_sequencer::type_id::create("sequencer_h",this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg_h.is_active == UVM_ACTIVE)
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  endfunction

endclass : act_ahb_master_agent