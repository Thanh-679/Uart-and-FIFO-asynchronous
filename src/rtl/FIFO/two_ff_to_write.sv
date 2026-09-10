`timescale 1ns / 1ps


`include "uart_config.vh"

module two_ff_to_write(
input logic CLK_write,
input logic reset_write,
input logic [`ADDR_WIDTH:0]r_gray,
output logic [`ADDR_WIDTH:0]r_pointer_2ff_gray 
);
logic [`ADDR_WIDTH:0] r_gray_middle;

always_ff @(posedge CLK_write or negedge reset_write) begin
if(!reset_write) begin
r_gray_middle<='0;
r_pointer_2ff_gray<='0;
end
else begin 
r_gray_middle<=r_gray;
r_pointer_2ff_gray<=r_gray_middle;
end
end
endmodule
