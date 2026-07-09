`ifndef ACT_TB_TOP
`define ACT_TB_TOP

module act_tb_top;

  import uvm_pkg::*;
  import act_ahb_pkg::*;

  logic hclk;
  logic hresetn;

  initial begin
    hclk = 0;
    forever #5 hclk = ~hclk;
  end

  initial begin
    hresetn = 0;
    repeat(5)
      @(posedge hclk);
    hresetn = 1;
  end

  //mid sim reset
  //initial
  //  begin
  //    #100ns;
  //    hresetn = 0;
  //    #45ns;
  //    hresetn = 1;
  //end

  act_ahb_if vif(.HCLK(hclk),.HRESETn(hresetn));

  initial begin
    vif.HREADY = 1;
    uvm_config_db#(virtual act_ahb_if)::set(null,"*","vif",vif);
    run_test();
  end

endmodule
`endif // ACT_TB_TOP
