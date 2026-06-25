`ifndef ACT_AHB_MASTER_MONITOR
`define ACT_AHB_MASTER_MONITOR

class act_ahb_master_monitor extends uvm_monitor;

  `uvm_component_utils(act_ahb_master_monitor)

  virtual act_ahb_if vif;
  act_ahb_master_agent_cfg cfg_h;

  uvm_analysis_port #(act_ahb_seq_item) ap;

  function new(string name = "act_ahb_master_monitor",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap",this);
    if(!uvm_config_db#(act_ahb_master_agent_cfg)::get(this,"","cfg",cfg_h))
      `uvm_fatal("CFG","Failed to get act_ahb_master_agent_cfg")
    if(!uvm_config_db#(virtual act_ahb_if)::get(this,"","vif",vif))
      `uvm_fatal("VIF","Failed to get virtual interface")
  endfunction

  task run_phase(uvm_phase phase);
    act_ahb_seq_item tr;
    int ct;
    forever begin
      wait_for_start_of_transfer();
      tr = act_ahb_seq_item::type_id::create("tr");
      collect_transfer(tr);
      `uvm_info(get_type_name(),$sformatf("Collected Transaction:\n%s",tr.sprint()),UVM_LOW)
      if(vif.HRESETn)begin
        ct++;
        ap.write(tr);
        `uvm_info(get_type_name(),$sformatf("Transaction %0d sent to analysis port",ct),UVM_DEBUG)
      end
    end
  endtask

  task wait_for_start_of_transfer();
    forever begin
      @(vif.master_mon_cb);
      if(vif.HRESETn && vif.master_mon_cb.HREADY && vif.master_mon_cb.HTRANS == AHB_NONSEQ)
        break;
    end
    `uvm_info(get_type_name(),
              $sformatf("START DETECTED : HADDR=%0h HTRANS=%s HWRITE=%0b HBURST=%s HSIZE=%s",
                vif.master_mon_cb.HADDR,
                ahb_htrans_e'(vif.master_mon_cb.HTRANS),
                vif.master_mon_cb.HWRITE,
                ahb_hburst_e'(vif.master_mon_cb.HBURST),
                ahb_hsize_e'(vif.master_mon_cb.HSIZE)),
              UVM_LOW)
  endtask

  task collect_transfer(act_ahb_seq_item tr);
    int burst_len;

    tr.addr  = vif.master_mon_cb.HADDR;
    tr.write = vif.master_mon_cb.HWRITE;
    tr.size  = ahb_hsize_e'(vif.master_mon_cb.HSIZE);
    tr.burst = ahb_hburst_e'(vif.master_mon_cb.HBURST);
    `uvm_info(get_type_name(),
              $sformatf("ADDR PHASE : ADDR=%0h WRITE=%0b BURST=%s SIZE=%s",
                tr.addr,
                tr.write,
                tr.burst.name(),
                tr.size.name()),
              UVM_LOW)

    if(tr.burst != AHB_INCR) begin
      burst_len = get_burst_len(tr.burst);
      tr.data_q = new[burst_len];
      for(int i=0;i<burst_len;i++) begin
        @(vif.master_mon_cb);
        while(!vif.master_mon_cb.HREADY)
          @(vif.master_mon_cb);
          if(!vif.HRESETn) begin
            `uvm_info(get_type_name(),"Reset detected. Dropping partial transaction",UVM_MEDIUM)
            return;
          end
        if(tr.write) begin
          tr.data_q[i] = vif.master_mon_cb.HWDATA;
          `uvm_info(get_type_name(),
                     $sformatf("WRITE DATA[%0d] = %0h",i,tr.data_q[i]),
                     UVM_LOW)
        end
        else begin
          tr.data_q[i] = vif.master_mon_cb.HRDATA;
          `uvm_info(get_type_name(),
                    $sformatf("READ DATA[%0d] = %0h",i,tr.data_q[i]),
                    UVM_LOW)
        end
      end
    end
    else begin
      bit [31:0] data_q_tmp[$];
      forever begin
        @(vif.master_mon_cb);
        while(!vif.master_mon_cb.HREADY)
          @(vif.master_mon_cb);
        if(!vif.HRESETn) begin
          `uvm_info(get_type_name(),"Reset detected. Dropping partial transaction",UVM_MEDIUM)
          return;
        end
        if(tr.write)
          data_q_tmp.push_back(vif.master_mon_cb.HWDATA);
        else
          data_q_tmp.push_back(vif.master_mon_cb.HRDATA);
          
        `uvm_info(get_type_name(),
                  $sformatf("INCR DATA[%0d] = %0h",
                    data_q_tmp.size()-1,
                    data_q_tmp[data_q_tmp.size()-1]),
                  UVM_LOW)
        @(vif.master_mon_cb);
        if(vif.master_mon_cb.HREADY && (vif.master_mon_cb.HTRANS != AHB_SEQ))
          break;
      end
      tr.data_q = new[data_q_tmp.size()];
      foreach(data_q_tmp[i])
        tr.data_q[i] = data_q_tmp[i];
    end
  endtask

  function int get_burst_len(ahb_hburst_e burst);
    case(burst)
      AHB_SINGLE : return 1;
      AHB_WRAP4,
      AHB_INCR4  : return 4;
      AHB_WRAP8,
      AHB_INCR8  : return 8;
      AHB_WRAP16,
      AHB_INCR16 : return 16;
      default    : return 1;
    endcase
  endfunction

endclass : act_ahb_master_monitor
`endif // ACT_AHB_MASTER_MONITOR
