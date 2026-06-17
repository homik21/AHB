`ifndef ACT_AHB_BASE_SEQ
`define ACT_AHB_BASE_SEQ

class act_ahb_base_seq extends uvm_sequence #(act_ahb_seq_item);

  `uvm_object_utils(act_ahb_base_seq)

  function new(string name="act_ahb_base_seq");
    super.new(name);
  endfunction

  task body();
    act_ahb_seq_item tr;
    `uvm_info(get_type_name(),"Entered sequence body",UVM_NONE)
    repeat(10) begin
      tr = act_ahb_seq_item::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
  endtask
endclass
`endif // ACT_AHB_BASE_SEQ
