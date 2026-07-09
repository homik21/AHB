class act_ahb_idle_insert_test extends act_ahb_base_test;

  `uvm_component_utils(act_ahb_idle_insert_test)

  function new(string name="act_ahb_idle_insert_test",
               uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    master_cfg_h.enable_idle_insertion = 1;
    master_cfg_h.enable_busy_insertion = 0;

    master_cfg_h.idle_probability = 100;
    master_cfg_h.idle_min_cycles  = 1;
    master_cfg_h.idle_max_cycles  = 1;
  endfunction

  //function void end_of_elaboration_phase(uvm_phase phase);
  //  super.end_of_elaboration_phase(phase);
  //  uvm_top.print_topology();
  //endfunction

  //task run_phase(uvm_phase phase);
  //  phase.raise_objection(this);
  //  seq_h = act_ahb_base_seq::type_id::create("seq_h");
  //  `uvm_info(get_type_name(),"Starting sequence",UVM_NONE)
  //  seq_h.start(env_h.master_agent_h.sequencer_h);
  //  `uvm_info(get_type_name(),"Sequence completed",UVM_NONE)
  //  #100;
  //  phase.drop_objection(this);
  //endtask

endclass