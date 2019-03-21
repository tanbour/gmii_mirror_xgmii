
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module accumulate_no_wraparound(
  CLK, RESETN, CLEAR_VAL, IVALUE, OVALUE
);
parameter WIDTH_IN = 1;
parameter WIDTH_OUT = 8;
input CLK;
input RESETN;
input CLEAR_VAL;
input [WIDTH_IN-1:0] IVALUE;
output [WIDTH_OUT-1:0] OVALUE;

reg [WIDTH_OUT-1:0] ovalue;

assign OVALUE = ovalue;

always @(posedge CLK) begin
    if (!RESETN) begin
        ovalue <= 0;
    end else begin
        if (CLEAR_VAL) begin
            ovalue <= 0;
        end else if (IVALUE != 0) begin
            if (ovalue + IVALUE < (1 << WIDTH_OUT)) begin
                ovalue <= ovalue + IVALUE;
            end else begin
                ovalue <= (1 << WIDTH_OUT) - 1;
            end
        end
    end
end

endmodule
