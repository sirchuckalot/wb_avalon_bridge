module avalon_bfm_transactor #(
    parameter MEM_HIGH = 256,
    parameter AUTORUN = 0,
    parameter VERBOSE = 0,
    parameter AW = 32,
    parameter DW = 32
)(
    input wb_clk_i,
    
    // Avalon Master Output
    output [AW-1:0]   m_av_address_o,
    output [DW/8-1:0] m_av_byteenable_o,
    output            m_av_read_o,
    input   [DW-1:0]  m_av_readdata_i,
    output [7:0]      m_av_burstcount_o,
    output            m_av_write_o,
    output [DW-1:0]   m_av_writedata_o,
    input             m_av_waitrequest_i,
    input             m_av_readdatavalid_i,

    //Test Control
    output done
);

endmodule