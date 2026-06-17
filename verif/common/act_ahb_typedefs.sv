`ifndef ACT_AHB_TYPEDEFS
`define ACT_AHB_TYPEDEFS

  typedef enum {
    LITTLE_ENDIAN,
    BIG_ENDIAN
  } ahb_endianness_e;

  typedef enum {
    AHB_RESP_OKAY,
    AHB_RESP_ERROR,
    AHB_RETRY,
    AHB_SPLIT
  } ahb_resp_mode_e;

  typedef enum bit [1:0] {
    AHB_IDLE,
    AHB_BUSY,
    AHB_NONSEQ,
    AHB_SEQ
  } ahb_htrans_e;

  typedef enum bit [2:0] {
    AHB_BYTE,
    AHB_HALFWORD,
    AHB_WORD,
    AHB_DWORD,
    AHB_128BIT,
    AHB_256BIT,
    AHB_512BIT,
    AHB_1024BIT
  } ahb_hsize_e;
  
  typedef enum bit [2:0] {
    AHB_SINGLE,
    AHB_INCR,
    AHB_WRAP4,
    AHB_INCR4,
    AHB_WRAP8,
    AHB_INCR8,
    AHB_WRAP16,
    AHB_INCR16
  } ahb_hburst_e;
`endif // ACT_AHB_TYPEDEFS
