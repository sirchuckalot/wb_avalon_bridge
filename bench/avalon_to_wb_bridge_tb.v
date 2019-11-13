/* avalon_to_wb_bridge_tb. Part of wb_avalon_bridge
 *
 * ISC License
 *
 * Copyright (C) 2019  Charley Picker <charleypicker@yahoo.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/*Testbench for avalon_to_wb_bridge
 */
`default_nettype none
module avalon_to_wb_bridge_tb
        #(parameter AUTORUN = 1);

    localparam aw = 32;
    localparam dw = 32;

    localparam MEM_SIZE = 256;


    reg wb_clk = 1'b1;
    reg wb_rst = 1'b1;

    // Wires from Avalon BFM Transactor to dut
    wire [aw-1:0]   m_av_address_o;
    wire [dw/8-1:0] m_av_byteenable_o;
    wire            m_av_read_o;
    wire [dw-1:0]   m_av_readdata_i;
    wire [7:0]      m_av_burstcount_o;
    wire            m_av_write_o;
    wire [dw-1:0]   m_av_writedata_o;
    wire            m_av_waitrequest_i;
    wire            m_av_readdatavalid_i;

    // Wires from dut to wishbone bfm memory
    wire [aw-1:0]   wbs_m2s_adr;
    wire [dw-1:0]   wbs_m2s_dat;
    wire [dw/8-1:0] wbs_m2s_sel;
    wire            wbs_m2s_we;
    wire            wbs_m2s_cyc;
    wire            wbs_m2s_stb;
    wire [2:0]      wbs_m2s_cti;
    wire [1:0]      wbs_m2s_bte;
    wire [dw-1:0]   wbs_s2m_dat;
    wire            wbs_s2m_ack;
    wire            wbs_s2m_err;
    wire            wbs_s2m_rty;

    wire      done;

    integer  TRANSACTIONS;

    generate
        if (AUTORUN) begin
            vlog_tb_utils vtu();
            vlog_tap_generator #("avalon_to_wb_bridge.tap", 1) vtg();

            initial begin
                run;
                vtg.ok("avalon_to_wb_bridge: All tests passed!");
                $finish;
            end
        end
    endgenerate

    task run;
        begin
//            transactor.bfm.reset;
            @(posedge wb_clk) wb_rst = 1'b0;

//            if($value$plusargs("transactions=%d", TRANSACTIONS))
//                transactor.set_transactions(TRANSACTIONS);
//            transactor.display_settings;
//            transactor.run();
//            transactor.display_stats;
        end
    endtask

    // We need a clock to drive the design
    always #5 wb_clk <= ~wb_clk;
    
    avalon_bfm_transactor
        #(.MEM_HIGH (MEM_SIZE-1),
            .AUTORUN (0),
            .VERBOSE (0),
            .AW(aw),
            .DW(dw))
        transactor
        (.wb_clk_i (wb_clk),                          // input wb_clk_i
         .m_av_address_o(m_av_address_o),             // output [AW-1:0]   m_av_address_o
         .m_av_byteenable_o(m_av_byteenable_o),       // output [DW/8-1:0] m_av_byteenable_o
         .m_av_read_o(m_av_read_o),                   // output            m_av_read_o
         .m_av_readdata_i(m_av_readdata_i),           // input   [DW-1:0]  m_av_readdata_i
         .m_av_burstcount_o(m_av_burstcount_o),       // output [7:0]      m_av_burstcount_o
         .m_av_write_o(m_av_write_o),                 // output            m_av_write_o
         .m_av_writedata_o(m_av_writedata_o),         // output [DW-1:0]   m_av_writedata_o
         .m_av_waitrequest_i(m_av_waitrequest_i),     // input             m_av_waitrequest_i
         .m_av_readdatavalid_i(m_av_readdatavalid_i), // input             m_av_readdatavalid_i
         //Test Control
         .done());
            
    avalon_to_wb_bridge
        #(.DW(aw),  // Data width
          .AW(dw))   // Address width
        dut
        (.wb_clk_i(wb_clk),                           // input            wb_clk_i
         .wb_rst_i(wb_rst),                           // input            wb_rst_i
         
         // Avalon Slave input
         .s_av_address_i(m_av_address_o),             // input [AW-1:0]   s_av_address_i
         .s_av_byteenable_i(m_av_byteenable_o),       // input [DW/8-1:0] s_av_byteenable_i
         .s_av_read_i(m_av_read_o),                   // input            s_av_read_i
         .s_av_readdata_o(m_av_readdata_i),           // output [DW-1:0]  s_av_readdata_o
         .s_av_burstcount_i(m_av_burstcount_o),       // input [7:0]      s_av_burstcount_i
         .s_av_write_i(m_av_write_o),                 // input            s_av_write_i
         .s_av_writedata_i(m_av_writedata_o),         // input [DW-1:0]   s_av_writedata_i
         .s_av_waitrequest_o(m_av_waitrequest_i),     // output           s_av_waitrequest_o
         .s_av_readdatavalid_o(m_av_readdatavalid_i), // output           s_av_readdatavalid_o

         // Wishbone Master Output
         .wbm_adr_o(wbs_m2s_adr),  // output [AW-1:0]   wbm_adr_o
         .wbm_dat_o(wbs_m2s_dat),  // output [DW-1:0]   wbm_dat_o
         .wbm_sel_o(wbs_m2s_sel),  // output [DW/8-1:0] wbm_sel_o
         .wbm_we_o (wbs_m2s_we),   // output            wbm_we_o
         .wbm_cyc_o(wbs_m2s_cyc),  // output            wbm_cyc_o
         .wbm_stb_o(wbs_m2s_stb),  // output            wbm_stb_o
         .wbm_cti_o(wbs_m2s_cti),  // output [2:0]      wbm_cti_o
         .wbm_bte_o(wbs_m2s_bte),  // output [1:0]      wbm_bte_o
         .wbm_dat_i(wbs_s2m_dat),  // input [DW-1:0]    wbm_dat_i
         .wbm_ack_i(wbs_s2m_ack),  // input             wbm_ack_i
         .wbm_err_i(wbs_s2m_err),  // input             wbm_err_i
         .wbm_rty_i(wbs_s2m_rty)); // input             wbm_rty_i
        
    wb_bfm_memory
        #(.DEBUG (0),
            .mem_size_bytes(MEM_SIZE))
        mem
        (.wb_clk_i    (wb_clk),
            .wb_rst_i (wb_rst),
            .wb_adr_i (wbs_m2s_adr),
            .wb_dat_i (wbs_m2s_dat),
            .wb_sel_i (wbs_m2s_sel),
            .wb_we_i  (wbs_m2s_we),
            .wb_cyc_i (wbs_m2s_cyc),
            .wb_stb_i (wbs_m2s_stb),
            .wb_cti_i (wbs_m2s_cti),
            .wb_bte_i (wbs_m2s_bte),
            .wb_dat_o (wbs_s2m_dat),
            .wb_ack_o (wbs_s2m_ack),
            .wb_err_o (wbs_s2m_err),
            .wb_rty_o (wbs_s2m_rty));

endmodule