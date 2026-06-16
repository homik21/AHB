class act_ahb_virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(act_ahb_virtual_sequencer)

  act_ahb_master_sequencer master_seqr_h;
  act_ahb_slave_sequencer  slave_seqr_h;

  function new(string name = "act_ahb_virtual_sequencer",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : act_ahb_virtual_sequencer