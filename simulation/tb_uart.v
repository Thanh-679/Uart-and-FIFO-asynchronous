`timescale 1ns / 1ps
`include "uart_config.vh"    

module tb_uart(

    );

reg internal_clk;
    reg reset;
    reg [7:0] r_data;
    reg empty;
    wire data_ack;
    wire data_busy;
    wire data_enable;
    wire error;
    wire end_of_frame;
    wire [7:0] flipflop_for_peripheral;
///
top_module_Rx_Tx testbench_Rx_Tx(.internal_clk(internal_clk),.reset(reset),.r_data(r_data),.empty(empty),.data_ack(data_ack)
,.data_busy(data_busy),.data_enable(data_enable)
,.error(error),.end_of_frame(end_of_frame),.flipflop_for_peripheral(flipflop_for_peripheral));

initial begin
    internal_clk = 1'b0;
    forever #10 internal_clk = ~internal_clk;
end

/////////////////////////////////////////
initial begin
// TEST_RESET SIGNAL

reset  = 1'b0;
r_data = 8'h00;
empty  = 1'b1; // do not enter data(FIFO is empty)

@(posedge internal_clk);
#1;
reset=1'b1;
r_data = 8'h45;
empty=1'b0;
////////////////////

#500;
//test 1: entering data
$display("\n[%0t] TX BAT DAU TRUYEN DATA: 8'h2D...", $time);
r_data = 8'h2D;
empty  = 1'b0; // Tx read this
// Test 2: entering data
#2000;
@(posedge data_busy);
#2;
$display("\n[%0t] TX BAT DAU TRUYEN DATA THU 2: 8'hA5...", $time);
r_data = 8'hA5;
empty  = 1'b0;

repeat (2) @(posedge top_module_Rx_Tx.Tx_en);
@ (negedge data_busy);
#1;
r_data = 8'h85;
empty  = 1'b0;
#5000;
        
$finish;
end
endmodule