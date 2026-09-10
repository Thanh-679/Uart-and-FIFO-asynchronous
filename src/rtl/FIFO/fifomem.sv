`timescale 1ns / 1ps

`include"uart_config.vh"

module fifomem(
input logic CLK_write,
input logic write_request,
input logic write_full,
input logic [`ADDR_WIDTH-1:0]w_addr,
input logic [`ADDR_WIDTH-1:0]r_addr,
input logic [`data-1:0] w_data,
output logic [`data-1:0] r_data
);
//shift 
localparam RAM_DEPTH =1<<`ADDR_WIDTH;
logic [`data-1:0] ram_fifo [0:RAM_DEPTH -1];//64 register,each has 8-bit 

always_comb begin
r_data=ram_fifo[r_addr];
end

always_ff@(posedge CLK_write) begin
if(!write_full && write_request) begin
ram_fifo[w_addr]<=w_data;
end
end
endmodule
