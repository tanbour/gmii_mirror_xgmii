
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_arp_resp(
input CLK,
input RESET,
input [47:0] LOCAL_MAC,
input [31:0] LOCAL_IP,
input CLOCK_EN,
input [3:0] RXLEN_IN,
input [63:0] RXD_IN,
output [3:0] TXLEN_OUT,
output [63:0] TXD_OUT,
output [15:0] DEBUG_OUT
);

// 22:00:00:00:00:01, 192.168.200.3
// localparam LOCAL_MAC = 48'h010000000022;
// localparam LOCAL_IP = { 8'd3, 8'd200, 8'd168, 8'd192 };

reg [15:0] rxoffset;
reg [47:0] rx_src_mac;
reg [47:0] rx_dest_mac;
reg rx_is_arp;
reg rx_is_arpreq;
reg [31:0] rx_src_ip;
reg [31:0] rx_dest_ip;
reg [15:0] txoffset;
reg [63:0] txd;
reg [3:0] txlen;
reg [64*5-1:0] rxd_shiftreg;
reg [4*5-1:0] rxlen_shiftreg;

wire [63:0] rxd_copy = rxd_shiftreg[64*4+63:64*4];
wire [3:0] rxlen_copy = rxlen_shiftreg[4*4+3:4*4];

function [15:0] bswap;
input [15:0] x;
begin
    bswap = { x[7:0], x[15:8] };
end
endfunction

assign TXD_OUT = txd;
assign TXLEN_OUT = txlen;
assign DEBUG_OUT = 8'hff;

always @(posedge CLK) begin
    if (RESET) begin
        rxoffset <= 0;
        txoffset <= 0;
        txd <= 0;
        txlen <= 0;
    end else if (!CLOCK_EN) begin
        // do nothing
    end else begin
        rxd_shiftreg <= { rxd_shiftreg, RXD_IN };
        rxlen_shiftreg <= { rxlen_shiftreg, RXLEN_IN };
        rxoffset <= RXLEN_IN == 8 ? rxoffset + 1 : 0;
        if (rxoffset == 0) begin
            // rx_src_mac[15:0] <= RXD_IN[63:48];
        end else if (rxoffset == 1) begin
            // rx_src_mac[47:16] <= RXD_IN[31:0];
            rx_is_arp <= (RXD_IN[63:32] == 32'h01000608);
        end else if (rxoffset == 2) begin
            rx_is_arpreq <= (RXD_IN[47:0] == 48'h010004060008);
            rx_src_mac[15:0] <= RXD_IN[63:48];
        end else if (rxoffset == 3) begin
            rx_src_mac[47:16] <= RXD_IN[31:0];
            rx_src_ip <= RXD_IN[63:32];
        end else if (rxoffset == 4) begin
            rx_dest_mac <= RXD_IN[47:0];
            rx_dest_ip[15:0] <= RXD_IN[63:48];
        end else if (rxoffset == 5) begin
            rx_dest_ip[31:16] <= RXD_IN[15:0];
        end else begin
        end
        txoffset <= txoffset + 1;
        if (txoffset == 0) begin
            txd <= 0;
            txlen <= 0;
            txoffset <= 0;
            if (rxoffset == 5 && rx_is_arp && rx_is_arpreq &&
                { RXD_IN[15:0], rx_dest_ip[15:0] } == LOCAL_IP) begin
                txd <= { LOCAL_MAC[15:0], rx_src_mac };
                txlen <= rxlen_copy;
                txoffset <= 1;
            end
        end else if (txoffset == 1) begin
            txd <= { 32'h01000608, LOCAL_MAC[47:16] };
            txlen <= rxlen_copy;
        end else if (txoffset == 2) begin
            txd <= { LOCAL_MAC[15:0], 48'h020004060008 };
            txlen <= rxlen_copy;
        end else if (txoffset == 3) begin
            txd <= { LOCAL_IP, LOCAL_MAC[47:16] };
            txlen <= rxlen_copy;
        end else if (txoffset == 4) begin
            txd <= { rx_src_ip[15:0], rx_src_mac };
            txlen <= rxlen_copy;
        end else if (txoffset == 5) begin
            txd <= { 48'h0, rx_src_ip[31:16] };
            txlen <= rxlen_copy;
            if (rxlen_copy !=8) begin
                txoffset <= 0;
            end
        end else begin
            txd <= 0;
            txlen <= rxlen_copy;
            if (rxlen_copy != 8) begin
                txoffset <= 0;
            end
        end
    end
end

endmodule

