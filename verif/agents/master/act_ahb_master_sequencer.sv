`ifndef ACT_AHB_MASTER_SEQUENCER
`define ACT_AHB_MASTER_SEQUENCER

class act_ahb_master_sequencer extends uvm_sequencer#(act_ahb_seq_item);

  `uvm_component_utils(act_ahb_master_sequencer)

  function new(string name = "act_ahb_master_sequencer",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : act_ahb_master_sequencer
`endif // ACT_AHB_MASTER_SEQUENCER
