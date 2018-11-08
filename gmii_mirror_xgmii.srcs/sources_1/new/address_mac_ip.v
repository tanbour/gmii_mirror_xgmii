
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module address_mac_ip(
output [47:0] MAC_ADDR,
output [31:0] IP_ADDR
);
parameter IP0 = 192;
parameter IP1 = 168;
parameter IP2 = 200;
parameter IP3 = 3;

wire [7:0] ip0 = IP0;
wire [7:0] ip1 = IP1;
wire [7:0] ip2 = IP2;
wire [7:0] ip3 = IP3;
assign MAC_ADDR = { ip3, ip2, ip1, ip0, 16'h0002 };
assign IP_ADDR = { ip3, ip2, ip1, ip0 };

endmodule
