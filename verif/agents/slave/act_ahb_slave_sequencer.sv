`ifndef ACT_AHB_SLAVE_SEQUENCER
`define ACT_AHB_SLAVE_SEQUENCER

class act_ahb_slave_sequencer extends uvm_sequencer#(act_ahb_seq_item);

  `uvm_component_utils(act_ahb_slave_sequencer)

  function new(string name = "act_ahb_slave_sequencer",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : act_ahb_slave_sequencer
`endif // ACT_AHB_SLAVE_SEQUENCER
