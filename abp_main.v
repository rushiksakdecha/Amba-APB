`timescale 1ns / 1ps


module abp_main(
input clk, 
input rstn,
input [7:0]datain,
input [3:0]addin,
input wr,newd,

output reg [7:0]dataout
    );
    
    wire penable,psel,pready,pwrite;
    wire [7:0]pwdata,prdata;
    wire [3:0]paddr;
    
apb_master master(
        .pclk(clk),
        .presetn(rstn),
        .addin(addin),
        .datain(din),
        .wr(wr),
        .newd(newd),
        .prdata(prdata),
        .pready(pready),
        .psel(psel),
        .penable(penable),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .dataout(dout)
);

abp_slave slave (
        .pclk(clk),
        .presetn(rstn),
        .paddr(paddr),
        .psel(psel),
        .penable(penable),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .prdata(prdata),
        .pready(pready)
    );
endmodule
