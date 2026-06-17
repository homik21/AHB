`ifndef ACT_AHB_MASTER_DRIVER
`define ACT_AHB_MASTER_DRIVER

class act_ahb_master_driver extends uvm_driver #(act_ahb_seq_item);

  `uvm_component_utils(act_ahb_master_driver)

  act_ahb_master_agent_cfg cfg_h;
  act_ahb_seq_item tr;

  function new(string name = "act_ahb_master_driver",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(act_ahb_master_agent_cfg)::get(this,"","cfg",cfg_h))
      `uvm_fatal("CFG","Failed to get act_ahb_master_agent_cfg")
  endfunction

  task run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(tr);
    `uvm_info(get_type_name(),$sformatf("Received Transaction:\n%s",tr.sprint()),UVM_LOW)
    seq_item_port.item_done();
  end
endtask
endclass : act_ahb_master_driver
`endif // ACT_AHB_MASTER_DRIVER
