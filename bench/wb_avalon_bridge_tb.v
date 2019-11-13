/* wb_avalon_bridge_tb. Part of wb_avalon_bridge
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

module wb_avalon_bridge_tb;

    vlog_tb_utils vlog_tb_utils0();
    vlog_tap_generator #("wb_avalon_bridge.tap", 1) vtg();

    avalon_to_wb_bridge_tb #(.AUTORUN (0)) avalon_to_wb_bridge_tb();

    initial begin
        avalon_to_wb_bridge_tb.run;
        vtg.ok("avalon_to_wb_bridge: All tests passed!");

        #3 $finish;
    end

endmodule