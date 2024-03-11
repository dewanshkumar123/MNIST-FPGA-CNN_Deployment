`timescale 1ns / 1ps

module bram(wrt_data,addr_w,rst,clk,wr_en,read_data,rd_en);

input [17:0]wrt_data;
input clk,rst,wr_en;
input [4:0]addr_w;
output [17:0]read_data;
output  rd_en;

reg [17:0]ram[0:17];
integer i;

always@(posedge clk) begin
    if(rst)begin 
       for (i=0;i<17;i=i+1)begin  
          ram[i]<={18{1'b0}};    // Initializing memory to 0, 
          //can be initialized to some other value as well
       end 
     end 
     else 
       if(wr_en) begin
          ram[addr_w]<=wrt_data;
       end 
end 

assign read_data=rd_en ? ram[addr_w]:0;
    
endmodule