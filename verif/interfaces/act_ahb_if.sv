`ifndef ACT_AHB_IF
`define ACT_AHB_IF

interface act_ahb_if#(parameter ADDR_WIDTH = 32,parameter DATA_WIDTH = 32) (input logic HCLK,input logic HRESETn);

logic [ADDR_WIDTH-1:0] HADDR;

logic [1:0] HTRANS;
logic       HWRITE;

logic [2:0] HSIZE;
logic [2:0] HBURST;

logic [3:0] HPROT;

logic [DATA_WIDTH-1:0] HWDATA;
logic [DATA_WIDTH-1:0] HRDATA;

logic HREADY;
logic HRESP;

//Clocking Blocks
clocking master_drv_cb @(posedge HCLK);
    default input #1step output #0;

    output HADDR;
    output HTRANS;
    output HWRITE;
    output HSIZE;
    output HBURST;
    output HPROT;
    output HWDATA;

    input HREADY;
    input HRESP;
    input HRDATA;
endclocking

clocking master_mon_cb @(posedge HCLK);
    default input #1step;

    input HADDR;
    input HTRANS;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;

    input HWDATA;
    input HRDATA;

    input HREADY;
    input HRESP;
endclocking
    
clocking slave_drv_cb @(posedge HCLK);
    default input #1step output #0;

    input HADDR;
    input HTRANS;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;
    input HWDATA;
    
    output HRDATA;
    output HREADY;
    output HRESP;
endclocking

clocking slave_mon_cb @(posedge HCLK);
    default input #1step;

    input HADDR;
    input HTRANS;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;

    input HWDATA;
    input HRDATA;

    input HREADY;
    input HRESP;
endclocking

    // MODPORTS
    modport MASTER_DRV_MP (
        clocking master_drv_cb,
        input HRESETn
    );

    modport MASTER_MON_MP (
        clocking master_mon_cb,
        input HRESETn
    );

    modport SLAVE_DRV_MP (
        clocking slave_drv_cb,
        input HRESETn
    );

    modport SLAVE_MON_MP (
        clocking slave_mon_cb,
        input HRESETn
    );
endinterface
`endif // ACT_AHB_IF
