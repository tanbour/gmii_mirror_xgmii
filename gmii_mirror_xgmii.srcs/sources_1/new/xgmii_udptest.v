
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_udptest(
input CLK,
input RESET,
input [47:0] LOCAL_MAC,
input [31:0] LOCAL_IP,
input CE,
input [3:0] RXLEN_IN,
input [63:0] RXD_IN,
output [3:0] TXLEN_OUT,
output [63:0] TXD_OUT,
output [15:0] DEBUG_OUT
);

// 22:00:00:00:00:01, 192.168.200.3
// localparam LOCAL_MAC = 48'h010000000022;
// localparam LOCAL_IP = { 8'd3, 8'd200, 8'd168, 8'd192 };

//reg [15:0] rxoffset;
//reg [47:0] rx_src_mac;
//reg [47:0] rx_dest_mac;
//reg rx_is_ipv4;
//reg rx_is_udp;
//reg [31:0] rx_src_ip;
//reg [31:0] rx_dest_ip;
//reg [15:0] rx_src_port;
//reg [15:0] rx_dest_port;
//reg [15:0] rx_iplen;
reg [15:0] txoffset;
reg [63:0] txd;
reg [3:0] txlen;
reg [64*5-1:0] rxd_shiftreg;
reg [4*5-1:0] rxlen_shiftreg;
reg [15:0] tx_ipv4_sum;

wire [63:0] rxd_copy = rxd_shiftreg[64*3+63:64*3];
wire [3:0] rxlen_copy = rxlen_shiftreg[4*3+3:4*3];

function [15:0] ipv4_sum;
input [15:0] x;
input [15:0] y;
reg [16:0] z;
begin
    z = x + y;
    ipv4_sum = z[15:0] + z[16];
end
endfunction

function [15:0] bswap;
input [15:0] x;
begin
    bswap = { x[7:0], x[15:8] };
end
endfunction

function [15:0] ipv4_sum_32lsb;
input [15:0] x;
input [31:0] y;
begin
    ipv4_sum_32lsb = ipv4_sum(x, ipv4_sum(bswap(y[15:0]), bswap(y[31:16])));
end
endfunction

wire [15:0] ipv4_sum_base =
    ipv4_sum(16'h4500, // version, headerlen, tos
    ipv4_sum_32lsb(16'h8011, // ttl, udp
        LOCAL_IP));

assign TXD_OUT = txd;
assign TXLEN_OUT = txlen;
assign DEBUG_OUT = tx_ipv4_sum;

always @(posedge CLK) begin
    if (RESET) begin
//        rxoffset <= 0;
        txoffset <= 0;
        txd <= 0;
        txlen <= 0;
    end else if (!CE) begin
        // do nothing
    end else begin
        rxd_shiftreg <= { rxd_shiftreg, RXD_IN };
        rxlen_shiftreg <= { rxlen_shiftreg, RXLEN_IN };
        txoffset <= txoffset + 1;
        if (txoffset == 0) begin
            txoffset <= 0;
            if (RXLEN_IN == 8) begin
                txd <= { LOCAL_MAC[15:0], 48'hffffffffffff };
                txlen <= 8;
                txoffset <= 1;
                tx_ipv4_sum <= ipv4_sum_32lsb(ipv4_sum_base, 32'hffffffff);
            end
        end else if (txoffset == 1) begin
            txd <= { 32'h00450008, LOCAL_MAC[47:16] };
            txlen <= 8;
        end else if (txoffset == 2) begin
            tx_ipv4_sum <= ipv4_sum(tx_ipv4_sum, bswap(16'h0044));
            txd <= { 32'h11800000, 16'h0000, 16'h0044 };
            txlen <= 8;
        end else if (txoffset == 3) begin
            txd <= { 32'hffffffff, LOCAL_IP[31:0],
                bswap(tx_ipv4_sum) ^ 16'hffff };
            txlen <= 8;
        end else if (txoffset == 4) begin
            txd <= { rxd_copy[63:48], 16'h1234, 16'h1234,
                32'hffffffff };
            txlen <= 8;
        end else if (txoffset == 5) begin
            txd <= { (rxd_copy[63:16] ^ 48'h202020202020), 16'h0000 };
            txlen <= rxlen_copy;
            if (rxlen_copy != 8) begin
                txoffset <= 0;
            end
        end else begin
            txd <= rxd_copy ^ 64'h2020202020202020;
            txlen <= rxlen_copy;
            if (rxlen_copy != 8) begin
                txoffset <= 0;
            end
        end
    end
end

endmodule
