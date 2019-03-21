
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module fifo_read_throttle(
input CLK,
input RESET,
input VALID_IN,
output READ_EN_OUT,
input [7:0] DATA_IN,
output CTRL_OUT,
output [7:0] DATA_OUT,
output [3:0] DEBUG_OUT
);

reg read_en;
reg [3:0] cnt;

assign READ_EN_OUT = read_en;
assign CTRL_OUT = (read_en && VALID_IN);
assign DATA_OUT = CTRL_OUT ? DATA_IN[7:0] : 0;
assign DEBUG_OUT = cnt;

always @(posedge CLK) begin
    if (RESET) begin
        read_en <= 0;
        cnt <= 0;
    end else begin
        if (cnt < 5) begin
            cnt <= VALID_IN ? (cnt + 1) : 0;
            read_en <= (cnt == 4);
        end begin
            if (!VALID_IN) begin
                read_en <= 0;
                cnt <= 0;
            end
        end
    end
end

endmodule
