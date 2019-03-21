
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


// Copyright (C) 2017 Akira Higuchi. All rights reserved.
// See COPYRIGHT.txt for details.

module i2c_master(
input CLK,
input RESET_N,
inout I2C_SCL,
inout I2C_SDA,
output READY,
input VALID,
input [6:0] DEVADDR,
input [7:0] REGADDR,
input [31:0] WDATA,
input [2:0] WBYTES,
output [31:0] RDATA,
input [2:0] RBYTES,
output [2:0] ERROR,
output [7:0] DEBUG_OUT0,
output [7:0] DEBUG_OUT1,
output [1:0] DEBUG_OUT2
);
parameter IGNORE_ACK = 0;
parameter CLOCK_DIV = 250; // SCL_freq := CLK_freq / (CLOCK_DIV * 4)
parameter USE_RESTART = 1;
parameter RW_DELAY = 100;

reg [7:0] state;
reg scl;
reg sda;
reg [7:0] debug_out0;
reg [7:0] debug_out1;
reg busy;
reg [15:0] delay;
reg [7:0] value;
reg [3:0] value_count;
reg [7:0] rvalue;
reg [3:0] rvalue_count;
reg ack0;
reg ack1;
reg ack2;
reg [6:0] dev_addr;
reg [7:0] reg_addr;
reg [31:0] write_data;
reg [1:0] write_bytes;
reg [7:0] read_data[3:0];
reg [2:0] read_offset;
reg [2:0] read_bytes;
reg [15:0] rw_delay;

reg [15:0] ccnt;
reg [2:0] scl_in_sync;
reg [2:0] sda_in_sync;
reg scl_in;
reg sda_in;

// Need to set "IP Integrator -> Generate Block Design -> Synthesis Options" to "Global"
//assign SCL = scl ? 1'bz : 0;
//assign SDA = sda ? 1'bz : 0;

wire scl_in_async;
wire sda_in_async;
IOBUF buf_scl(.T(scl), .I(scl), .O(scl_in_async), .IO(I2C_SCL));
IOBUF buf_sda(.T(sda), .I(sda), .O(sda_in_async), .IO(I2C_SDA));

assign READY = !busy;
assign RDATA = { read_data[3], read_data[2], read_data[1], read_data[0] };
assign ERROR = { ack0, ack1, ack2 };
assign DEBUG_OUT0 = debug_out0;
assign DEBUG_OUT1 = debug_out1;
assign DEBUG_OUT2 = { scl_in, sda_in };

always @(posedge CLK) begin
    if (!RESET_N) begin
        ccnt <= 0;
    end else begin
        ccnt <= ccnt < CLOCK_DIV ? ccnt + 1 : 0;
    end
    scl_in_sync <= { scl_in_sync[1:0], scl_in_async };
    sda_in_sync <= { sda_in_sync[1:0], sda_in_async };
    scl_in <= scl_in_sync[2];
    sda_in <= sda_in_sync[2];
end

always @(posedge CLK) begin
    if (!RESET_N) begin
        state <= 0;
        delay <= 0;
        busy <= 0;
        scl <= 1;
        sda <= 1;
        ack0 <= 1;
        ack1 <= 1;
        ack2 <= 1;
        rvalue <= 0;
        reg_addr <= 0;
        write_bytes <= 0;
        write_data <= 0;
        read_bytes <= 1;
        read_offset <= 0;
        read_data[0] <= 0;
        read_data[1] <= 0;
        read_data[2] <= 0;
        read_data[3] <= 0;
    end else if (scl == 1 && scl_in == 0) begin
        // clock stretching
        delay <= delay + 1;
    end else if (ccnt != 0) begin
        // 
    end else begin
        scl <= !(busy && state[1]);
        state <= state + 1;
        case (state)
        3:  if (VALID) begin
                dev_addr <= DEVADDR;
                reg_addr <= REGADDR;
                write_data <= WDATA;
                write_bytes <= WBYTES;
                read_offset <= 0;
                read_bytes <= RBYTES;
                read_data[0] <= 0;
                read_data[1] <= 0;
                read_data[2] <= 0;
                read_data[3] <= 0;
                rw_delay <= RW_DELAY;
                ack0 <= 0;
                ack1 <= 0;
                ack2 <= 0;
            end else begin
                state <= state;
            end
        4:  begin busy <= 1; sda <= 1; end
        5:  begin sda <= 0; end  // start condition
        6:  begin value <= { dev_addr[6:0], 1'b0 }; value_count <= 8; end // device address (wr)
        7:  begin sda <= value[7]; end
        8:  begin end
        9:  begin value <= value << 1; value_count <= value_count - 1; end
        10: if (value_count != 0) begin
                state <= state - 3;
            end
        11: begin sda <= 1; end
        12: begin end
        13: begin ack0 <= (sda_in != 0); end
        14: if (ack0 != 0 && !IGNORE_ACK) begin
                state <= state + 29;
            end else begin
                value <= reg_addr; value_count <= 8;  // register address
            end
        15: begin sda <= value[7]; end
        16: begin end
        17: begin value <= value << 1; value_count <= value_count - 1; end
        18: if (value_count != 0) begin
                state <= state - 3;
            end
        19: begin sda <= 1; end
        20: begin end
        21: begin ack1 <= (sda_in != 0); end
        22: if (ack1 != 0 && !IGNORE_ACK) begin
                state <= state + 29;
            end else if (write_bytes > 0) begin
                value <= write_data[7:0]; value_count <= 8;
                write_data <= write_data >> 8; write_bytes <= write_bytes - 1;
                state <= state - 7;
            end else if (read_bytes == 0) begin
                state <= state + 29;
            end else if (USE_RESTART) begin
                state <= state + 9;
            end
        23: begin sda <= 0; end
        24: begin end
        25: begin sda <= 1; end // stop condition
        26: if (rw_delay > 0) begin
                rw_delay <= rw_delay - 1;
                state <= state;
            end else begin
                state <= state + 5;
            end
        27: begin end
        28: begin end
        29: begin end
        30: begin end
        31: begin sda <= 1; end
        32: begin end
        33: begin sda <= 0; end // start condition
        34: begin value <= { dev_addr[6:0], 1'b1 }; value_count <= 8; end // device address (rd)
        35: begin sda <= value[7]; end
        36: begin end
        37: begin value <= value << 1; value_count <= value_count - 1; end
        38: if (value_count != 0) begin
                state <= state - 3;
            end
        39: begin sda <= 1; end
        40: begin end
        41: begin ack2 <= (sda_in != 0); end
        42: if (ack2 != 0 && !IGNORE_ACK) begin
                state <= state + 9;
            end else begin
                rvalue <= 0; rvalue_count <= 8; // register value
            end
        43: begin sda <= 1; end
        44: begin end
        45: begin rvalue <= { rvalue[6:0], (sda_in != 0) }; rvalue_count <= rvalue_count - 1; end
        46: if (rvalue_count != 0) begin
                state <= state - 3;
            end
        47: begin sda <= (read_bytes == 1); end
        48: begin read_data[read_offset] = rvalue; read_bytes <= read_bytes - 1; read_offset <= read_offset + 1; end
        49: begin end // send ack or nack
        50: if (read_bytes != 0) begin
                rvalue <= 0; rvalue_count <= 8;
                state <= state - 7;
            end
        51: begin sda <= 0; end
        52: begin end
        53: begin busy <= 0; sda <= 1; end // stop condition
        54: begin end
        55: begin state <= 0; end
        endcase
    end
    debug_out0 <= { 1'b0, ack0 | ack1 | ack2, state[5:0] };
    debug_out1 <= read_data[0];
//    debug_out1 <= { 5'b0, (ack0 == 0 ? 1'b1 : 1'b0), (ack1 == 0 ? 1'b1 : 1'b0), (ack2 == 0 ? 1'b1 : 1'b0) };
//    debug_out0 <= state; // read_data[7:0]; // rvalue; // state; // delay
end

endmodule
