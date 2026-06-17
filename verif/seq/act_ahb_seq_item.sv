`ifndef ACT_AHB_SEQ_ITEM
`define ACT_AHB_SEQ_ITEM

class act_ahb_seq_item extends uvm_sequence_item;
  rand bit [31:0] addr;

  rand bit        write;

  rand ahb_hsize_e  size;
  rand ahb_hburst_e burst;

  rand bit [31:0] data_q[];

  ahb_resp_mode_e resp;
    
  `uvm_object_utils_begin(act_ahb_seq_item)
     `uvm_field_int(addr, UVM_ALL_ON)
     `uvm_field_int(write, UVM_ALL_ON)
     `uvm_field_enum(ahb_hsize_e,size,UVM_ALL_ON)
     `uvm_field_enum(ahb_hburst_e,burst,UVM_ALL_ON)
     `uvm_field_array_int(data_q,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "act_ahb_seq_item");
    super.new(name);
  endfunction

  constraint c_size_values {
    solve burst before data_q.size;
  }
  
  constraint c_addr_values {
    solve size before addr;
  }

  constraint c_burst_length {
  if(burst == AHB_SINGLE)
    data_q.size() == 1;

  if(burst == AHB_INCR4 || burst == AHB_WRAP4)
    data_q.size() == 4;

  if(burst == AHB_INCR8 || burst == AHB_WRAP8)
    data_q.size() == 8;

  if(burst == AHB_INCR16 || burst == AHB_WRAP16)
    data_q.size() == 16;

  if(burst == AHB_INCR)
    data_q.size() inside {[1:16]};
  }

  constraint c_addr_alignment {
  if(size == AHB_HALFWORD)
    addr[0] == 0;

  if(size == AHB_WORD)
    addr[1:0] == 0;

  if(size == AHB_DWORD)
    addr[2:0] == 0;
 }
endclass : act_ahb_seq_item
`endif // ACT_AHB_SEQ_ITEM
