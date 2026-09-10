`timescale 1ns / 1ps

`include"uart_config.vh"

module baud_rate(
input logic internal_clk, //50 MHz
input logic reset_read,
output logic Tx_en,
output logic Rx_en
);
localparam TX_before=(`internal/`baud_rate_select);
localparam RX_before=(`internal/(`baud_rate_select*16));
localparam TX=(`internal/`baud_rate_select)-1;
localparam RX=(`internal/(`baud_rate_select*16))-1;
logic [$clog2(TX_before)-1:0]counter_Tx;
logic[$clog2(RX_before)-1:0] counter_Rx;
//Tx_clk
always_ff @(posedge internal_clk or negedge reset_read) begin
if(!reset_read) begin
counter_Tx<=0;
end
else if(counter_Tx==TX) begin
counter_Tx<=0;
end
else begin
counter_Tx<=counter_Tx+1;
end
end
assign Tx_en=(counter_Tx==TX)?1'b1:1'b0;
////////
// Rx_CLK
always_ff @(posedge internal_clk or negedge reset_read) begin
if(!reset_read) begin
counter_Rx<=0;
end
else if(counter_Rx==RX) begin
counter_Rx<=0;
end
else begin
counter_Rx<=counter_Rx+1;
end
end
assign Rx_en=(counter_Rx==RX)?1'b1:1'b0;
endmodule
