`timescale 1ns / 1ps


`include"uart_config.vh"

module WRITE_FULL(
input logic CLK_write,
input logic reset_write,
input logic write_request,//from peripheral
input logic [`ADDR_WIDTH:0] r_pointer_2ff_gray,//after 2ff and graycode from read/// (1)

output logic [`ADDR_WIDTH-1:0] w_addr, //addr of the ram
output logic [`ADDR_WIDTH:0]w_pointer, //calculating the place to write and comparing with(1)
output logic write_full,
output logic [`ADDR_WIDTH:0] w_gray,
output logic FIFO_nearly_full

);
logic [`ADDR_WIDTH:0]  w_full_gray;
logic [`ADDR_WIDTH:0] w_pointer_new;
logic full_new;
logic [`ADDR_WIDTH:0] w_gray_new;

assign w_addr = w_pointer[`ADDR_WIDTH-1:0];

//calculating nearly full flag
function automatic [`ADDR_WIDTH:0] gray_to_bin(input logic [`ADDR_WIDTH:0] gray);
gray_to_bin[`ADDR_WIDTH]=gray[`ADDR_WIDTH];
for(int i=`ADDR_WIDTH-1;i>=0;i--) begin
gray_to_bin[i]=gray_to_bin[i+1] ^ gray[i];
end
return gray_to_bin;
endfunction
////////

always_comb begin
    w_full_gray = gray_to_bin(r_pointer_2ff_gray);
end
///////
assign FIFO_nearly_full=((w_pointer-w_full_gray)>=`pointer-`almost_const)?1:0;
///////////////


always_ff @(posedge CLK_write or negedge reset_write) begin
if(!reset_write) begin
w_pointer<='0;
w_gray<='0;
end
else begin
w_pointer<=w_pointer_new;
w_gray<=w_gray_new;
end
end


always_comb begin
if(write_request && !write_full) begin
w_pointer_new=w_pointer+1;
end
else begin
w_pointer_new=w_pointer;
end
end

//calculating full flag
function automatic [`ADDR_WIDTH:0] bin_to_gray(input logic [`ADDR_WIDTH:0] bin);
bin_to_gray[`ADDR_WIDTH]=bin[`ADDR_WIDTH];
for(int i=0;i<`ADDR_WIDTH;i++) begin
bin_to_gray[i]=bin[i] ^ bin[i+1];
end
return bin_to_gray;
endfunction
//////

always_comb begin
    w_gray_new = bin_to_gray(w_pointer_new);
end

//calculating next full
always_comb begin
if(
(w_gray_new[`ADDR_WIDTH]^r_pointer_2ff_gray[`ADDR_WIDTH])
   && (w_gray_new[`ADDR_WIDTH-1] ^ r_pointer_2ff_gray[`ADDR_WIDTH-1])
   && (w_gray_new[`ADDR_WIDTH-2:0] == r_pointer_2ff_gray[`ADDR_WIDTH-2:0])) begin
full_new=1'b1;
end
else begin
full_new=1'b0;
end
end

//finalizing next full
always_ff @(posedge CLK_write or negedge reset_write) begin
if(!reset_write) begin
write_full<=0;
end
else begin
write_full<=full_new;
end
end
endmodule
