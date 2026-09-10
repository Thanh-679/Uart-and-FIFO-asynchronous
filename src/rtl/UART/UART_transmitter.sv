`timescale 1ns / 1ps

`include"uart_config.vh"


package definition_Tx;
typedef enum logic [3:0]{
IDLE=4'b0001,
START=4'b0010,
TRANSMITTER=4'b0100,
STOP=4'b1000} states_t;
endpackage
/////

module UART_transmitter(
input logic internal_clk,
input logic reset_read,
input logic [`data-1:0]r_data,
input logic read_empty,
input logic Tx_en, // tick from baudrate

output logic data_out_to_Rx,
output logic data_ack, // flag that is on when receiving data from FIFO
output logic data_busy,// Uart is busy now,do not enter data(=0 sending,=1 do not send) 
//when it is 0,it always gets old value
output logic data_enable// flag that makes register shifting or with data_ack,to annouce to Tx, it is ready

);
import definition_Tx::*;
states_t state;
states_t next_state;
logic [`data+2:0] shift_reg; //(1 bit start+ 1 parity+1 bit stop)

always_ff @(posedge internal_clk or negedge reset_read) begin
if(!reset_read) begin
shift_reg<={1'b1, 1'b1 , 8'b0 , 1'b0};
state<=IDLE;
data_ack<='0;
end
else begin
state<=next_state;
data_ack<='0;

if((state==IDLE || state==STOP) && !read_empty && !data_busy && Tx_en) begin
shift_reg<={1'b1 , ^r_data , r_data[7:0] , 1'b0}; // In START or STOP state
// The operation is performed one clk cycle after Tx_en is asserted
// not one Tx_en period later
data_ack<=1'b1;
end


if((data_enable) && (state == START || state== TRANSMITTER))
shift_reg<={1'b0, shift_reg[`data+2:1]};
end
end

always_comb begin
data_busy=1'b0;
data_enable='0;
next_state=state;
unique case(state)

IDLE: begin
if(!read_empty && Tx_en) begin
next_state=START;
data_busy=1'b0;
end
else begin
next_state=IDLE;
data_busy=1'b0;
end
end

START: begin
data_busy=1'b1;
if(Tx_en) begin
data_enable=1'b1;
next_state=TRANSMITTER;
end
else begin
next_state=START;
end
end

TRANSMITTER: begin
data_busy=1'b1;
if(Tx_en) begin
data_enable=1'b1;

 if(shift_reg[`data+2:1]==1) begin // The expected pattern is 11'b000000001x
// The value of x (the parity bit) does not matter
// as long as the pattern matches, transition to STOP
// to output the stop bit 
 next_state= STOP;
 end
 else begin
 next_state=TRANSMITTER;
end
end
else begin
next_state=TRANSMITTER;
end
end

STOP:begin
if(Tx_en) begin

if(!read_empty) begin
data_busy=1'b0;
next_state=START;
end
else begin
next_state=IDLE;
data_busy=1'b0;
end
end else begin
next_state=STOP;
data_busy=1'b1;///////////////
end
end

default:begin
next_state=IDLE;
end
endcase
end
////
always_comb begin
data_out_to_Rx = 1'b1;
unique case(state)

IDLE: begin
data_out_to_Rx=1'b1;
end

START: begin
data_out_to_Rx=shift_reg[0];
end

TRANSMITTER: begin
data_out_to_Rx=shift_reg[0];
end

STOP: begin
data_out_to_Rx=shift_reg[0];
end
endcase
end
endmodule