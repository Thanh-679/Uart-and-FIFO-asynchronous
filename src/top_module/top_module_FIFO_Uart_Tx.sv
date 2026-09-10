`timescale 1ns / 1ps

`include "uart_config.vh"    
module top_module_FIFO_Uart_Tx(
input logic CLK_write,
    input logic CLK_read,
    input logic reset_write,
    input logic reset_read,

    input logic write_request,
    input logic read_request,
    input logic [`data-1:0]w_data,

    output logic write_full,
    output logic FIFO_nearly_full,
    output logic FIFO_nearly_empty,
    //

//Tx
output logic data_ack,
output logic data_enable,
//Rx
output logic error,
output logic end_of_frame,
output logic [`data-1:0] flipflop_for_peripheral
       );
    logic [`data-1:0] r_data;
    logic read_empty;
    
    logic data_busy;

FIFO_asy_topmodule DUT_topmodule_from_FIFO(.CLK_write(CLK_write),.CLK_read(CLK_read),.
reset_write(reset_write),.reset_read(reset_read),.write_request(write_request),.
read_request(read_request),.w_data(w_data),.write_full(write_full),.r_data(r_data)//fixed here/
,.read_empty(read_empty)/*fixed here*/,.FIFO_nearly_full(FIFO_nearly_full),.FIFO_nearly_empty(FIFO_nearly_empty));

top_module_Rx_Tx DUT_topmodule_from_UART_Tx(.internal_clk(CLK_read)/*fixed here*/,.reset_read(reset_read)
,.r_data(r_data)/*fixed here*/,.read_empty(read_empty)/*fixed here*/,.data_ack(data_ack),.data_busy(data_busy),.data_enable(
data_enable),.error(error),.end_of_frame(end_of_frame),.flipflop_for_peripheral(flipflop_for_peripheral));

    
    
endmodule
