`timescale 1ns / 1ps


`include"uart_config.vh"

module READ_EMPTY(
input logic CLK_read,
input logic reset_read,
input logic read_request, //from peripheral
input logic [`ADDR_WIDTH:0] w_pointer_2ff_gray, //after 2ff and graycode from write (1)

output logic [`ADDR_WIDTH-1:0] r_addr, //addr of the ram
output logic [`ADDR_WIDTH:0]r_pointer,//calculating the place to write and comparing with(1)
output logic read_empty,
output logic [`ADDR_WIDTH:0] r_gray,
output logic FIFO_nearly_empty

);
logic [`ADDR_WIDTH:0] r_pointer_new;
logic empty_new;
logic [`ADDR_WIDTH:0] r_gray_new;
logic [`ADDR_WIDTH:0]  r_full_gray;

assign r_addr=r_pointer[`ADDR_WIDTH-1:0];
//////////////////////////////////////////

//calculating nearly empty flag
function automatic [`ADDR_WIDTH:0] gray_to_bin(input logic [`ADDR_WIDTH:0] gray);
gray_to_bin[`ADDR_WIDTH]=gray[`ADDR_WIDTH];
for(int i=`ADDR_WIDTH-1;i>=0;i--) begin
gray_to_bin[i]=gray_to_bin[i+1] ^ gray[i];
end
return gray_to_bin;
endfunction
////////
always_comb begin
   r_full_gray = gray_to_bin(w_pointer_2ff_gray);
end
////////
assign FIFO_nearly_empty=((r_full_gray-r_pointer)<=`almost_const)?1:0;

//////////////////////

always_ff @(posedge CLK_read or negedge reset_read) begin
if(!reset_read) begin
r_pointer<='0;
r_gray<='0;
end
else begin
r_pointer<=r_pointer_new;
r_gray<=r_gray_new;
end
end


always_comb begin
if(read_request && !read_empty) begin
r_pointer_new=r_pointer+1;
end
else begin
r_pointer_new=r_pointer;
end
end

//calculating empty flag
function automatic [`ADDR_WIDTH:0] bin_to_gray(input logic [`ADDR_WIDTH:0] bin);
bin_to_gray[`ADDR_WIDTH]=bin[`ADDR_WIDTH];
for(int i=0;i<`ADDR_WIDTH;i++) begin
bin_to_gray[i]=bin[i] ^ bin[i+1];
end
return bin_to_gray;
endfunction
////////

always_comb begin
    r_gray_new = bin_to_gray(r_pointer_new);
end
//////////calculating next empty
always_comb begin
if(
(r_gray_new == w_pointer_2ff_gray )
   ) begin
empty_new=1'b1;
end
else begin
empty_new=1'b0;
end
end

////finalizing next empty
always_ff @(posedge CLK_read or negedge reset_read) begin
if(!reset_read) begin
read_empty<=1;
end
else begin
read_empty<=empty_new;
end
end
endmodule
