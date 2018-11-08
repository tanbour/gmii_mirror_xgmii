
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module eth_ctrl(
output wire mdc,
output wire mdio_w,
output wire [7:0] xgmii_txc,
output wire [63:0] xgmii_txd,
output wire [4:0] prtad,
output wire signal_detect,
input wire rx_loss,
output wire sim_speedup_control,
output wire [2:0] pma_pmd_type,
output wire tx_fault,
output wire clken
);

assign mdc = 0;
assign mdio_w = 0;
assign xgmii_txc = 0;
assign xgmii_txd = 0;
assign prtad = 0;
assign signal_detect = !rx_loss;
assign sim_speedup_control = 0;
assign pma_pmd_type = 5;
assign tx_fault = 0;
assign clken = 1;

endmodule
