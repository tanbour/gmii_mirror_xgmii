
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module err_counter(
input CLK,
input RESETN,
input CLEAR_ERR,
input IVAL,
output [7:0] OVAL
);

reg [7:0] oval;

assign OVAL = oval;

always @(posedge CLK) begin
    if (!RESETN || CLEAR_ERR) begin
        oval <= 0;
    end else begin
        if (IVAL) begin
            if (oval < 255) oval <= oval + 1;
        end
    end
end

endmodule
