    `timescale 1ns / 1ps

`include "uart_config.vh"    
    module FIFO_asy_topmodule(
    input logic CLK_write,
    input logic CLK_read,
    input logic reset_write,
    input logic reset_read,
    input logic write_request,
    input logic read_request,
    input logic [`data-1:0]w_data,
    
    output logic [`data-1:0]r_data,
    output logic write_full,
    output logic read_empty,
    output logic FIFO_nearly_full,
    output logic FIFO_nearly_empty
    );
    logic [`ADDR_WIDTH-1:0] w_addr;
    logic [`ADDR_WIDTH:0]w_pointer;
    
    logic [`ADDR_WIDTH-1:0]r_addr;
    logic [`ADDR_WIDTH:0]r_pointer;
    
    logic [`ADDR_WIDTH:0] r_pointer_2ff_gray;
    logic [`ADDR_WIDTH:0] w_pointer_2ff_gray;
    logic [`ADDR_WIDTH:0] r_gray;
    logic [`ADDR_WIDTH:0] w_gray;
    logic reset_middle_write;
    logic reset_middle_read;
    
    logic reset_after_2ff_write;
    logic reset_after_2ff_read;
    
    //using reset for avoiding mestability
    always_ff @(posedge CLK_write or negedge reset_write) begin
    if(!reset_write) begin
    reset_middle_write<='0;
    reset_after_2ff_write<='0;
    end
    else begin
    {reset_after_2ff_write,reset_middle_write}<={reset_middle_write,1'b1};
    end
    end
    
    always_ff @(posedge CLK_read or negedge reset_read) begin
    if(!reset_read) begin
    reset_middle_read<='0;
    reset_after_2ff_read<='0;
    end
    else begin
    {reset_after_2ff_read,reset_middle_read}<={reset_middle_read,1'b1};
    end
    end
    
    
    fifomem DUT_mem(.CLK_write(CLK_write),.write_request(write_request),
    .write_full(write_full),.w_addr(w_addr),.r_addr(r_addr),
    .w_data(w_data),. r_data( r_data));
    
    two_ff_to_write DUT_read_gray_to_write(.CLK_write(CLK_write),.reset_write(reset_after_2ff_write)
    ,.r_gray(r_gray),.r_pointer_2ff_gray(r_pointer_2ff_gray));
    
     two_ff_to_read DUT_write_gray_to_read(.CLK_read(CLK_read),.reset_read(reset_after_2ff_read),.w_gray(w_gray),
     .w_pointer_2ff_gray(w_pointer_2ff_gray));
     
     WRITE_FULL DUT_FULL(.CLK_write(CLK_write),.reset_write(reset_after_2ff_write),.write_request(write_request)
     ,.r_pointer_2ff_gray(r_pointer_2ff_gray),. w_addr( w_addr),.w_pointer(w_pointer)
     ,.write_full(write_full),.w_gray(w_gray),.FIFO_nearly_full(FIFO_nearly_full));
     
    READ_EMPTY DUT_EMPTY(.CLK_read(CLK_read),.reset_read(reset_after_2ff_read),.read_request(read_request)
    ,. w_pointer_2ff_gray( w_pointer_2ff_gray),.r_addr(r_addr),.r_pointer(r_pointer),.read_empty(read_empty)
    ,.r_gray(r_gray),.FIFO_nearly_empty(FIFO_nearly_empty));
    
    
    endmodule
