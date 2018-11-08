
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module axis_arbiter
#(
parameter WIDTH_DATA = 64,
parameter WIDTH_USER = 4,
parameter WIDTH_CAP = 12
)
(
input CLK,
input RESETN,
input IV0_TVALID,
output IV0_TREADY,
input [WIDTH_DATA-1:0] IV0_TDATA,
input [WIDTH_USER-1:0] IV0_TUSER,
input IV0_TLAST,
input [WIDTH_CAP-1:0] CAP_POP0,
input IV1_TVALID,
output IV1_TREADY,
input [WIDTH_DATA-1:0] IV1_TDATA,
input [WIDTH_USER-1:0] IV1_TUSER,
input IV1_TLAST,
input [WIDTH_CAP-1:0] CAP_POP1,
output OV_TVALID,
input OV_TREADY,
output [WIDTH_DATA-1:0] OV_TDATA,
output [WIDTH_USER-1:0] OV_TUSER,
output OV_TLAST,
output CUR_SOURCE
);

reg cur_source;
reg frame_start;
reg ov_tvalid;
reg [WIDTH_DATA-1:0] ov_tdata;
reg [WIDTH_USER-1:0] ov_tuser;
reg ov_tlast;

wire iv_tvalid = cur_source ? IV1_TVALID : IV0_TVALID;
wire [WIDTH_DATA-1:0] iv_tdata = cur_source ? IV1_TDATA : IV0_TDATA;
wire [WIDTH_USER-1:0] iv_tuser = cur_source ? IV1_TUSER : IV0_TUSER;
wire iv_tlast = cur_source ? IV1_TLAST : IV0_TLAST;

wire ov_ready = (ov_tvalid == 0) || (OV_TREADY && OV_TVALID);

assign IV0_TREADY = cur_source ? 0 : ov_ready;
assign IV1_TREADY = cur_source ? ov_ready : 0;
assign OV_TVALID = ov_tvalid;
assign OV_TDATA = ov_tdata;
assign OV_TUSER = ov_tuser;
assign OV_TLAST = ov_tlast;
assign CUR_SOURCE = cur_source;

always @(posedge CLK) begin
    if (!RESETN) begin
        cur_source <= 0;
        frame_start <= 0;
        ov_tvalid <= 0;
        ov_tdata <= 0;
        ov_tuser <= 0;
        ov_tlast <= 0;
    end else begin
        if (OV_TREADY && OV_TVALID) begin
            ov_tvalid <= 0;
        end
        if (ov_ready) begin
            if (iv_tvalid) begin
                frame_start <= 1;
                ov_tvalid <= 1;
                ov_tdata <= iv_tdata;
                ov_tuser <= iv_tuser;
                ov_tlast <= iv_tlast;
                if (iv_tlast) begin
                    frame_start <= 0;
                    if (CAP_POP0 > CAP_POP1) begin
                        cur_source <= 0;
                    end else if (CAP_POP1 > CAP_POP0) begin
                        cur_source <= 1;
                    end else begin
                        cur_source <= cur_source + 1;
                    end
                end
            end else if (frame_start == 0) begin
                cur_source <= cur_source + 1;
            end
        end
    end
end

endmodule
