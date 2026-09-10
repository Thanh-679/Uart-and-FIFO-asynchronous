`timescale 1ns / 1ps


`include "uart_config.vh"    

module tb_FIFO(

    );
reg CLK_write;
reg CLK_read;
reg reset_write;
reg reset_read;
reg write_request;
reg read_request;
reg [`data-1:0]w_data;
    
wire [`data-1:0]r_data;
wire write_full;
wire read_empty;
wire FIFO_nearly_full;
wire FIFO_nearly_empty;

FIFO_asy_topmodule tb_FIFO_asy(.CLK_write(CLK_write),.CLK_read(CLK_read),.reset_write(reset_write)
,.reset_read(reset_read),.write_request(write_request),.read_request(read_request),.w_data(w_data)
,.r_data(r_data),. write_full(write_full),.read_empty(read_empty),.FIFO_nearly_full(FIFO_nearly_full)
,.FIFO_nearly_empty(FIFO_nearly_empty));

initial begin
CLK_write =0;
forever #10 CLK_write=~CLK_write;
end
initial begin
CLK_read=0;
forever #20 CLK_read=~CLK_read;
end

task automatic check_full();
integer write_count;
reg [`ADDR_WIDTH:0] wptr_before;
begin
write_count = 0;
read_request = 1'b0;
while (!write_full) begin
@(posedge CLK_write);
write_request <= 1'b1;
w_data<= write_count + 1;
write_count=write_count + 1;
end
@(posedge CLK_write);
write_request <= 1'b0;
read_request<=1'b1;
#500;
end
endtask


initial begin
//test reset
reset_write=0;
reset_read=0;
write_request=1;
read_request=1;
w_data=8'd0;
#25;
reset_read=1;
reset_write=1;
#100;
write_request=1;
read_request=1;
w_data=8'd9;
#100;
write_request=1;
w_data=8'd10;
#20;
w_data=8'd11;
#20;
w_data=8'd12;
#10;
check_full;
#500;
$finish;

end


endmodule
