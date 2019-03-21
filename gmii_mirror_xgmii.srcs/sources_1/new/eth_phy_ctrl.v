
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module eth_phy_ctrl(
output MDC,
inout MDIO,
output TX_CTRL,
output [3:0] TX_D
);

assign TX_CTRL = 1;
assign TX_D = 0;
assign MDIO = 1'bz;
assign MDC = 0;

endmodule
