`ifndef ACT_AHB_MASTER_DRIVER
`define ACT_AHB_MASTER_DRIVER

class act_ahb_master_driver extends uvm_driver #(act_ahb_seq_item);

  `uvm_component_utils(act_ahb_master_driver)

  virtual act_ahb_if vif;
  act_ahb_master_agent_cfg cfg_h;
  act_ahb_seq_item tr;
  event reset_detected_e;

  function new(string name = "act_ahb_master_driver",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(act_ahb_master_agent_cfg)::get(this,"","cfg",cfg_h))
      `uvm_fatal("CFG","Failed to get act_ahb_master_agent_cfg")

    if(!uvm_config_db#(virtual act_ahb_if)::get(this,"","vif",vif))
      `uvm_fatal("VIF","Failed to get virtual interface")
  endfunction

  task run_phase(uvm_phase phase);
    reset_bus();
      fork
        monitor_reset();
        drive_ahb();
      join
  endtask
    
  task monitor_reset();
    forever begin
      @(negedge vif.HRESETn);
      `uvm_info(get_type_name(),"RESET ASSERTED",UVM_MEDIUM)
      reset_bus();
      -> reset_detected_e;
      @(posedge vif.HRESETn);
      `uvm_info(get_type_name(),"RESET DEASSERTED",UVM_MEDIUM)
    end
  endtask

  task drive_ahb();
    forever begin 
      wait(vif.HRESETn);
      seq_item_port.get_next_item(tr);
      `uvm_info(get_type_name(),$sformatf("Received Transaction:\n%s",tr.sprint()),UVM_LOW)
      fork
        begin
          `uvm_info("DRV","START drive_transaction",UVM_NONE)
          drive_transaction(tr);
          `uvm_info("DRV","END drive_transaction",UVM_NONE)
        end

        begin
          @(reset_detected_e);
          `uvm_info("DRV","RESET EVENT RECEIVED",UVM_NONE)
        end
      join_any
      disable fork;
      `uvm_info("DRV","AFTER disable fork",UVM_NONE)
      seq_item_port.item_done();
    end
  endtask

  task reset_bus();
    vif.master_drv_cb.HADDR  <= '0;
    vif.master_drv_cb.HTRANS <= AHB_IDLE;
    vif.master_drv_cb.HWRITE <= '0;
    vif.master_drv_cb.HSIZE  <= AHB_WORD;
    vif.master_drv_cb.HBURST <= AHB_SINGLE;
    vif.master_drv_cb.HPROT  <= '0;
    vif.master_drv_cb.HWDATA <= '0;
  endtask

  task drive_transaction(act_ahb_seq_item tr);
    if(tr.write)
      drive_write_burst(tr);
    else
      drive_read_burst(tr);
    drive_idle();
  endtask
  
  task drive_write_burst(act_ahb_seq_item tr);
    int cycle_cnt;
    ahb_htrans_e trans_str;
    string pipe_log;
  
    int unsigned beats;
    int unsigned addr_idx;
    int unsigned data_idx;
  
    bit [31:0] curr_addr;
  
    cycle_cnt = 0;
    beats     = tr.data_q.size();
    curr_addr = tr.addr;
  
    addr_idx  = 0;
    data_idx  = 0;
    pipe_log =
  "\n-------------------------------------------------------------\n\
  Cycle | HTRANS | Address      | Data\n\
  -------------------------------------------------------------\n";
    while(data_idx <= beats) begin
      @(vif.master_drv_cb);
      if(vif.master_drv_cb.HREADY) begin
        if(addr_idx < beats) begin
          drive_address_phase(
            curr_addr,
            tr.size,
            tr.burst,
            (addr_idx == 0) ? AHB_NONSEQ : AHB_SEQ,
            1'b1
          );
          curr_addr = calc_next_addr(curr_addr,tr.size);
          addr_idx++;
        end
        else begin
          vif.master_drv_cb.HTRANS <= AHB_IDLE;
        end
        if(data_idx > 0) begin
          drive_data_phase(tr.data_q[data_idx-1]);
        end
        //for logging purpose
        cycle_cnt++;
        trans_str = ahb_htrans_e'(vif.master_drv_cb.HTRANS);
          pipe_log = {
                      pipe_log,
                      $sformatf("%5d | %-6s | 0x%08h | %s\n",
                                cycle_cnt,
                                trans_str.name(),
                                vif.master_drv_cb.HADDR,
                                (data_idx > 0) ? $sformatf("0x%08h",vif.master_drv_cb.HWDATA) : "--------")
                     };
        data_idx++;
      end
    end
    `uvm_info("AHB_PIPE", pipe_log, UVM_LOW)
  endtask
  
  task drive_read_burst(act_ahb_seq_item tr);
    int unsigned beats;
    int unsigned addr_idx;
    bit [31:0] curr_addr;
    beats     = tr.data_q.size();
    curr_addr = tr.addr;
    addr_idx  = 0;
  
    while(addr_idx < beats) begin
      @(vif.master_drv_cb);
      if(vif.master_drv_cb.HREADY) begin
        drive_address_phase(
                              curr_addr,
                              tr.size,
                              tr.burst,
                              (addr_idx == 0) ? AHB_NONSEQ : AHB_SEQ,
                              1'b0
                            );
        curr_addr = calc_next_addr(curr_addr,tr.size);
        addr_idx++;
      end
    end
    @(vif.master_drv_cb);
    while(!vif.master_drv_cb.HREADY)
      @(vif.master_drv_cb);
  endtask
  
  task drive_address_phase(
                            bit [31:0]   addr,
                            ahb_hsize_e  size,
                            ahb_hburst_e burst,
                            ahb_htrans_e trans,
                            bit          write
                          );
    vif.master_drv_cb.HADDR  <= addr;
    vif.master_drv_cb.HTRANS <= trans;
    vif.master_drv_cb.HWRITE <= write;
    vif.master_drv_cb.HSIZE  <= size;
    vif.master_drv_cb.HBURST <= burst;
  endtask
  
  task drive_data_phase(bit [31:0] data);
    vif.master_drv_cb.HWDATA <= data;
  endtask
    
  task drive_idle();
    @(vif.master_drv_cb);
    vif.master_drv_cb.HTRANS <= AHB_IDLE;
  endtask
  
  function automatic int unsigned get_bytes_per_beat(ahb_hsize_e size);
    case(size)
      AHB_BYTE      : return 1;
      AHB_HALFWORD  : return 2;
      AHB_WORD      : return 4;
      AHB_DWORD     : return 8;
  
      AHB_128BIT    : return 16;
      AHB_256BIT    : return 32;
      AHB_512BIT    : return 64;
      AHB_1024BIT   : return 128;
  
      default       : return 4;
    endcase
  endfunction
  
  function automatic bit [31:0] calc_next_addr(bit [31:0]  curr_addr,ahb_hsize_e size);
    return (curr_addr + get_bytes_per_beat(size));
  endfunction

endclass : act_ahb_master_driver

`endif // ACT_AHB_MASTER_DRIVER
