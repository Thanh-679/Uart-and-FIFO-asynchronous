`timescale 1ns / 1ps

`include"uart_config.vh"

package definition_Rx;
typedef enum logic[2:0] {
IDLE_to_start_bit=3'b001,
START=3'b010,
COMPLETE=3'b100
} states_t;
endpackage


module uart_receiver(
input logic internal_clk,
input logic reset_read,
input logic data_in,
input logic Rx_en,

output logic ready_for_out_at_stop_bit,// This flag indicates the middle of the Tx STOP bit
// It is used to transfer the register value to flipflop_for_peripheral
output logic error,// check even parity bit or stop bit
output logic end_of_frame,
output logic [`data-1:0] flipflop_for_peripheral );
logic bit_done;

import definition_Rx::*;

logic[4:0] next_counter; 
logic [4:0] bit_counter;
logic [3:0]counter_for_stop;
logic [8:0] shift_reg;
logic [8:0] next_reg;
logic next_error;

states_t state,next_state;

always_ff @(posedge internal_clk or negedge reset_read) begin
if(!reset_read) begin
state<=IDLE_to_start_bit;
next_counter<=0;
counter_for_stop<=0;
flipflop_for_peripheral <= 0;
shift_reg<='0;
error<=0;
end
else begin
state<=next_state;
next_counter<=bit_counter;
error<=next_error;

if(ready_for_out_at_stop_bit) begin
    counter_for_stop <= 0;
   if(!next_error) begin
    flipflop_for_peripheral <= next_reg[7:0];
end else
 if(next_error) begin
flipflop_for_peripheral<='0;
end
end
else if(bit_done) begin
    counter_for_stop <= counter_for_stop + 1;
end

shift_reg<=next_reg;

end
end

always_comb begin
bit_done=0;
bit_counter=next_counter;
ready_for_out_at_stop_bit=0;
next_state=state;
next_reg=shift_reg;
next_error=error;
end_of_frame=0;

unique case(state) 

IDLE_to_start_bit: begin
next_error=0;
if(Rx_en) begin

if(data_in==0) begin 

if(next_counter==4'd7) begin
bit_counter='0;
next_state= START;
end

else begin
bit_counter=next_counter+1;
end
end

else begin
bit_counter='0;
end
end
end
START: begin
next_error=0;
if(Rx_en) begin

if(next_counter==4'd15) begin
bit_done=1'b1;
bit_counter='0;
///
if(counter_for_stop<=4'd8) begin
next_reg={data_in,shift_reg[8:1]}; /// SOLVING shift register
end

if(counter_for_stop==4'd9) begin //// 9 bits are available at this point (before the rising edge).
// The next_reg is updated with the 9th bit only at this edge,
// so before the rising edge, counter_for_stop has only counted 8 bits.

ready_for_out_at_stop_bit=1'b1; //At the middle of stop bit(from Tx)


if(data_in==1'b0 || (shift_reg[8] != ^shift_reg[7:0])) begin
next_error=1'b1;
end
else begin
next_error=1'b0;
end      
                       
next_state=COMPLETE;
end
else begin
next_state=START;
end
end

else begin
bit_counter=next_counter+1;
end

end
end


COMPLETE: begin

if(Rx_en) begin
if(next_counter==4'd15) begin
bit_counter='0;
end_of_frame=1'b1;

if(data_in ==1'b1) begin
next_state=IDLE_to_start_bit;
end

if(data_in==1'b0) begin
next_state=START;
end
end else begin
bit_counter=next_counter+1;
end
end
end
default: begin
next_state=IDLE_to_start_bit;
end
endcase
end
endmodule