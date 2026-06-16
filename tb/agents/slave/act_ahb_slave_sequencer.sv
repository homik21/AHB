class act_ahb_slave_sequencer extends uvm_sequencer;

  `uvm_component_utils(act_ahb_slave_sequencer)

  function new(string name = "act_ahb_slave_sequencer",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : act_ahb_slave_sequencer