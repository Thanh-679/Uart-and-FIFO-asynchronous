`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2026 12:02:49 AM
// Design Name: 
// Module Name: top_module_Rx_Tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include"uart_config.vh"


module top_module_Rx_Tx(
input logic internal_clk, //50 MHz
input logic reset_read,


//Tx
input logic [`data-1:0]r_data,
input logic read_empty,
output logic data_ack,
output logic data_busy,
output logic data_enable,
//Rx
output logic error,
output logic end_of_frame,
output logic [`data-1:0] flipflop_for_peripheral
    );
logic Tx_en;
logic Rx_en;
logic reset_middle_1;
//Tx
logic data_out_to_Rx;
logic ready_for_out_at_stop_bit;
logic reset_middle_2;

//avoid mestability
always_ff @(posedge internal_clk or negedge reset_read) begin
if(!reset_read) begin
reset_middle_1<=0;
reset_middle_2<=0;
end
else begin
reset_middle_2<=reset_middle_1;
reset_middle_1<=reset_read;
end
end

baud_rate DUT_baud_rate(.internal_clk(internal_clk),.reset_read(reset_middle_2),.Tx_en(Tx_en),.Rx_en(Rx_en));

UART_transmitter DUT_UART_transmitter(.internal_clk(internal_clk),.reset_read(reset_middle_2),.r_data(r_data),.
read_empty(read_empty),.Tx_en(Tx_en),.data_out_to_Rx(data_out_to_Rx),.data_ack(data_ack),.data_busy(data_busy),.
data_enable(data_enable));

uart_receiver DUT_uart_receiver(.internal_clk(internal_clk),.reset_read(reset_middle_2),.data_in(data_out_to_Rx)
,.Rx_en(Rx_en),.ready_for_out_at_stop_bit(ready_for_out_at_stop_bit),.error(error)
,.end_of_frame(end_of_frame),.flipflop_for_peripheral(flipflop_for_peripheral));

endmodule
