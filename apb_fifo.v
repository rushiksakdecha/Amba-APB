`timescale 1ns / 1ps


module apb_fifo(
input clk,
input reset,
input [31:0]pwdata,
input [31:0]paddr,
input psel,
input penable,
input pwrite,


output reg prdata,
output reg pready

    );
    
    parameter size_of_fifo=16;
    parameter idle=0,op_select=1,write=2,read=3,sending=4;
    
    reg [2:0] state = idle;
    reg [31:0] addr,wdata,rdata;
    
    reg [31:0]mem[15:0]; //here address length is of 31:0 memery is of 16   
                         //but only 4 buts are associated with addres in paddr 
                         //and other bits define operation
    reg [3:0]pointer_write;
    reg [3:0]pointer_read;
    reg [4:0]count;
    reg [2:0]cwait;
    integer i;
    initial
    begin
        for(i=0 ; i<=15 ; i=i+1)
            begin
            mem[i]=0;
            end 
    end
    
    always@(posedge clk , negedge reset)
    begin
        if(!reset)
        begin
            
            count<=0;
            cwait<=0;
            pointer_write<=0;
            pointer_read<=0;
            state<=idle;
            addr<=0;
            wdata<=0;
            pready<=0;
            rdata<=0;
            prdata<=0;
        end
        else 
        begin
            case(state)
                idle:
                    begin
                    count<=0;
                    cwait<=0;
                    pointer_write<=0;
                    pointer_read<=0;
                    addr<=0;
                    wdata<=0;
                    pready<=0;
                    rdata<=0;
                    prdata<=0;
                                state<=op_select;
                    end
                    
                op_select:
                begin
                    if(psel && penable && pwrite && count<16)
                    begin 
                    state<=write;
                    addr<=paddr;
                    pointer_write<=addr;
                    pointer_read<=addr;
                    wdata<=pwdata;
                    end
                    
                    if(psel && penable && !pwrite && count>0)
                    begin 
                    state<=read;
                    addr<=paddr;
                    end
                end
                    
                write:
                begin
                    if(cwait<2)
                        cwait<=cwait+1;
                    else
                        begin
                           cwait<=0;
                           mem[pointer_write]<=pwdata;
                           state<=sending;
                           count<=count+1;
                           pointer_write<=1;
                           pready<=1;
                        end
                end
                
                read:
                begin
                    if(cwait<2)
                        cwait<=cwait+1;
                    else
                        begin
                           cwait<=0;
                           prdata<=mem[pointer_read];
                           state<=sending;
                           count<=count+1;
                           pointer_read<=1;
                           pready<=1;
                        end
                    end
                        
                sending:
                begin
                    state<=op_select;
                    pready<=0;
                end 
                  
         
            endcase
        end
    end
    
endmodule
