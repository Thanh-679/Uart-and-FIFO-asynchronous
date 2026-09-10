`timescale 1ns / 1ps


`include"uart_config.vh"

module two_ff_to_read(
input logic CLK_read,
input logic reset_read,
input logic [`ADDR_WIDTH:0]w_gray,
output logic [`ADDR_WIDTH:0]w_pointer_2ff_gray   
);
logic [`ADDR_WIDTH:0] w_gray_middle;

always_ff @(posedge CLK_read or negedge reset_read) begin
if(!reset_read) begin
w_gray_middle<='0;
w_pointer_2ff_gray<='0;
end
else begin 
w_gray_middle<=w_gray;
w_pointer_2ff_gray<=w_gray_middle;
end
end
endmodule
