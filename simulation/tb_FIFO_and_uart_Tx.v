`timescale 1ns / 1ps

`include "uart_config.vh"    

module tb_FIFO_and_uart_Tx(

    );
    reg CLK_write;
    reg CLK_read;
    reg reset_write;
    reg reset_read;

    reg write_request;
    reg read_request;
    reg [`data-1:0]w_data;

    wire write_full;
    wire FIFO_nearly_full;
    wire FIFO_nearly_empty;
    //

//Tx
wire data_ack;
wire  data_enable;
//Rx
wire error;
wire end_of_frame;
wire [`data-1:0] flipflop_for_peripheral;
top_module_FIFO_Uart_Tx test_FIFO_after_connecting_to_uart_Tx(.CLK_write(CLK_write),.
    CLK_read(CLK_read),.reset_write(reset_write),.reset_read(reset_read),.write_request
    (write_request),.read_request(read_request),.w_data(w_data),.write_full(write_full)
    ,.FIFO_nearly_full(FIFO_nearly_full),.FIFO_nearly_empty(FIFO_nearly_empty),.
    data_ack(data_ack),.data_enable(data_enable),.error(error),.end_of_frame(end_of_frame)
    ,.flipflop_for_peripheral(flipflop_for_peripheral));
    
        
initial begin
CLK_write =0;
forever #10 CLK_write=~CLK_write;
end
initial begin
CLK_read=0;
forever #20 CLK_read=~CLK_read;
end
//


//
initial begin
reset_write=1'b0;
reset_read=1'b0;
write_request=0;
read_request=0;
w_data=0;
#50;
reset_write=1;
reset_read=1;
#53;
write_request=1'b1;
read_request=1'b1;
w_data=8'd89;
#20;
w_data=8'd90;
#20;
w_data=8'd91;
#500;
$finish;
end

endmodule
