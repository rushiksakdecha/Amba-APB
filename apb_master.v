`timescale 1ns / 1ps
module apb_master(

input pclk,
input presetn,
input [3:0]addin,
input [7:0]datain,
input [7:0]prdata,
input newd, // it is use for requesting , 
//             basicallyn if i want to enter new data this bit will bwcome one so that system will get some idea
input wr,
input penalbe,
input pready,

output reg psel,
output reg penable,
output reg slverr,
output reg [3:0]paddr,
output reg [7:0]pwdata,
output reg [7:0]dataout,
output reg pwrite

 );
    
 localparam [1:0]idle=0, setup=1, enable=2;
 reg [1:0]state,nstate;
 
 always@(posedge pclk , negedge presetn)
 begin 
    if (!presetn)
        begin
            state = idle;
        end
    else
        begin
            state = nstate;
        end
 end
 
 /////////////////               FSM for changing nstate
 
 
always@(*)
begin
case(state)

    idle:
    begin
        if(!newd)
            nstate<=idle; 
        else
            nstate<=setup;    
    end
    
    setup:
    begin
        nstate<= enable;
    end
    
    enable:
    begin
        if(newd)
        begin
             if(pready)
             begin
                nstate<=setup;
             end
             else
                nstate<= enable;
        end
        else
        nstate<= idle;
    end
  default : nstate = idle; 
 
  endcase
  end
    
    

//////////////////////////////////////// Address decoding
 
// always@(posedge pclk, negedge presetn)
//    begin
//        if(presetn == 1'b0)
//            begin
//              psel <= 1'b0;
//            end
//         else if (nstate == idle)
//            begin
//              psel <= 1'b0;
//            end
//         else if (nstate == enable || nstate == setup)
//            begin
//             psel <= 1'b1;
//            end
//         else 
//            begin
//             psel <= 1'b0;
//            end     
//    end
    

/////////////////////// Output controling
always@(posedge pclk)
begin
    if(state == idle)
    begin 
        pwrite<=0;
        pwdata<=0;
        paddr<=0;
        psel<=0;
        penable<=0;
     end
     
    else if(state == setup)
    begin 
        pwrite<=wr;
        paddr<=addin;
        psel<=1;
        penable<=0;
        
        if(wr==1)
            pwdata<=datain;
     end
     
     else if(state == enable)
     begin 
        penable<=1;
     end
     
     else
     begin 
        pwrite<=0;
        pwdata<=0;
        paddr<=0;
        psel<=0;
        penable<=0;
     end
//     dataout <= (penable == 1'b1 && wr == 1'b0) ? prdata : 8'h00;
 end 

    
    
    
endmodule
