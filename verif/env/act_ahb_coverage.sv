`ifndef ACT_AHB_COVERAGE
`define ACT_AHB_COVERAGE

class act_ahb_coverage extends uvm_component;

  `uvm_component_utils(act_ahb_coverage)

  function new(string name = "act_ahb_coverage",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : act_ahb_coverage
`endif // ACT_AHB_COVERAGE
