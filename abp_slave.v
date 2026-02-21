`timescale 1ns / 1ps


module abp_slave(
input pclk,
input presetn,
input pwrite,
input [7:0]pwdata,
//input [3:0]paddr, // for valid address but to check error we have give big range

input [15:0]paddr,
input psel,
input penable,
input swait,

output reg [7:0]prdata,
output reg pready,
output pslverr   // for checking error
    );
    
    localparam [1:0]idle=0, write=1, read=2;
    reg [7:0]mem[15:0]; // to get correct the size allocation we have to use reg [7:0]mem[2^16-1:0]
    
    reg state,nstate;
    reg addr_err,addr_value_err,data_value_err,setup_apb_err  ;
    
    
    initial@(posedge pclk)
    begin
            addr_err=0;
        addr_value_err=0;
        data_value_err=0;
        setup_apb_err=0;
    end
        always@(posedge pclk , negedge presetn)
    begin
        if(!presetn)
            state<=idle;
        else
            state<= nstate;        
    end
    always@(posedge pclk)
    case(state)
    idle:
    begin
        pready=0;
        prdata=0;

        if(psel==1 && pwrite == 1)
            nstate=write;
        else if (psel==1 && pwrite == 0)
            nstate=read;
        else
            nstate=idle;
    end
    
    write:
    begin
        if(psel==1 && penable==1)
        begin
            if (swait)
                nstate=write;
            else
            begin
            mem[paddr]=pwdata;
            pready=1;
            nstate=idle;
            end
        end
        else if (penable==0)// for enable error we did this
            begin 
            setup_apb_err=1;
            nstate=idle;
            end
        else
            nstate=idle;
    end
    
    read:
    begin
        if(psel==1 && penable==1)
        begin
            if (swait)
                nstate=read;
            else
            begin
            prdata=mem[paddr];
            pready=1;
            nstate=idle;
            end
        end
        else if (penable==0)// for enable error we did this
            begin
            setup_apb_err=1;
            nstate=idle;
            end
        else
            nstate=idle;
    end
    default : nstate = idle; 
    
    endcase
    
    
    
    
    // errors
    
    
    always@(posedge pclk)
    begin
        if(pready)
            if(pwdata >= 0)
            data_value_err=0;
            else
            data_value_err=1;
    end
    
    always@(posedge pclk)
    begin
        if(paddr >= 0)
        addr_value_err=0;
        else
        addr_value_err=1;
    end
    

    always@(posedge pclk)
    begin
        if(paddr <= 15)
        addr_value_err=0;
        else
        addr_err=1;
    end
    
    
    assign pslverr= addr_err|addr_value_err|data_value_err|setup_apb_err;
   
endmodule
