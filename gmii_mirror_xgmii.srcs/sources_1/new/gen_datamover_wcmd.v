
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module gen_datamover_wcmd(
  CLK, RESETN,
  WORDCNT_TDATA, WORDCNT_TVALID, WORDCNT_TREADY,
  WCMD_TDATA, WCMD_TVALID, WCMD_TREADY,
  ERR_FATAL, CUR_ADDR, DEBUG_SIZE, DEBUG_SIZE_REM);
parameter WORDCNT_WORD_SIZE_LOG2 = 4;
parameter ADDR_WIDTH = 64;
parameter ADDR_MOD_WIDTH = 32;
input CLK;
input RESETN;
input [15:0] WORDCNT_TDATA;
input WORDCNT_TVALID;
output WORDCNT_TREADY;
output [ADDR_WIDTH+40-1:0] WCMD_TDATA;
output WCMD_TVALID;
input WCMD_TREADY;
output [1:0] ERR_FATAL;
output [ADDR_WIDTH-1:0] CUR_ADDR;
output [22:0] DEBUG_SIZE;
output [22:0] DEBUG_SIZE_REM;

reg [3:0] wcmd_tag;
reg [ADDR_WIDTH-1:0] wcmd_addr;
reg [31:0] wcmd_addr_wrap;
reg [22:0] wcmd_size;
reg [22:0] wcmd_size_rem;
reg wcmd_tvalid;
reg [1:0] err_fatal;

wire [22:0] wordcnt_bytes = WORDCNT_TDATA << WORDCNT_WORD_SIZE_LOG2;
wire [ADDR_WIDTH-1:0] wcmd_addr_mod = wcmd_addr & ((1 << ADDR_MOD_WIDTH) - 1);

assign WORDCNT_TREADY = (wcmd_tvalid == 0);
assign WCMD_TDATA = { 4'b0, wcmd_tag, wcmd_addr_mod, 8'h40, 1'b1, wcmd_size };
assign WCMD_TVALID = wcmd_tvalid;
assign ERR_FATAL = err_fatal; // 回復不可能なエラー
assign CUR_ADDR = wcmd_addr;
assign DEBUG_SIZE = wcmd_size;
assign DEBUG_SIZE_REM = wcmd_size_rem;

always @(posedge CLK) begin
  if (!RESETN) begin
    wcmd_tag <= 0;
    wcmd_addr <= 0;
    wcmd_size <= 0;
    wcmd_size_rem <= 0;
    wcmd_tvalid <= 0;
    err_fatal <= 0;
  end else begin
    if (WORDCNT_TVALID && WORDCNT_TREADY) begin
      wcmd_tag <= wcmd_tag + 1;
      if (wcmd_addr_mod + wordcnt_bytes >= (1 << ADDR_MOD_WIDTH)) begin
        wcmd_size <= (1 << ADDR_MOD_WIDTH) - wcmd_addr;
        wcmd_size_rem <= wcmd_addr_mod + wordcnt_bytes - (1 << ADDR_MOD_WIDTH);
      end else begin
        wcmd_size <= wordcnt_bytes;
        wcmd_size_rem <= 0;
      end
      wcmd_tvalid <= 1;
    end
    if (WCMD_TVALID && WCMD_TREADY) begin
      wcmd_addr <= wcmd_addr + wcmd_size;
      if (wcmd_size_rem != 0) begin
        wcmd_tvalid <= 1;
        wcmd_size <= wcmd_size_rem;
        wcmd_size_rem <= 0;
      end else begin
        wcmd_tvalid <= 0;
        wcmd_size <= 0;
      end
    end
  end
end

endmodule

