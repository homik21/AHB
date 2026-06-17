`ifndef ACT_AHB_BASE_TEST
`define ACT_AHB_BASE_TEST

class act_ahb_base_test extends uvm_test;

  `uvm_component_utils(act_ahb_base_test)

  act_ahb_env env_h;

  act_ahb_env_cfg          env_cfg_h;
  act_ahb_master_agent_cfg master_cfg_h;
  act_ahb_slave_agent_cfg  slave_cfg_h;
  act_ahb_base_seq seq_h;

  function new(string name = "act_ahb_base_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_cfg_h =act_ahb_env_cfg::type_id::create("env_cfg_h");
    master_cfg_h =act_ahb_master_agent_cfg::type_id::create("master_cfg_h");
    slave_cfg_h =act_ahb_slave_agent_cfg::type_id::create("slave_cfg_h");

    uvm_config_db#(act_ahb_env_cfg)::set(this,"*","env_cfg",env_cfg_h);
    uvm_config_db#(act_ahb_master_agent_cfg)::set(this,"*.master_agent_h*","cfg",master_cfg_h);
    uvm_config_db#(act_ahb_slave_agent_cfg)::set(this,"*.slave_agent_h*","cfg",slave_cfg_h);
    
    env_h =act_ahb_env::type_id::create("env_h",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq_h = act_ahb_base_seq::type_id::create("seq_h");
    `uvm_info(get_type_name(),"Starting sequence",UVM_NONE)
    seq_h.start(env_h.master_agent_h.sequencer_h);
    `uvm_info(get_type_name(),"Sequence completed",UVM_NONE)
    phase.drop_objection(this);
  endtask

endclass : act_ahb_base_test
`endif // ACT_AHB_BASE_TEST
