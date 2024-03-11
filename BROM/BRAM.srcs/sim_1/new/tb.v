`timescale 1ns / 1ps


module tb();

reg [17:0]wrt_data;
reg clk,rst,wr_en;
reg [4:0]addr_w;
wire  [17:0]read_data;
wire  rd_en;


integer j;

bram dut1 (.wrt_data(wrt_data),
                .clk(clk),
                .rst(rst),
                .wr_en(wr_en),
                .addr_w(addr_w),
                .read_data(read_data),
                .rd_en(rd_en)
                
                ); 
 
 

 initial begin
  
  rst<=1;
  clk<=0;
  
  #20; 
  rst <=0;
  
  end
always@(posedge clk) begin
       if (rst) begin 
          wr_en<=0;
          wrt_data<=0;
          addr_w<=0;
       end 
       else begin 
         if (wr_en) begin
            for (j=0;j<23;j=j+1) begin
               wrt_data<=j;
               addr_w<=j;
            end 
          end   
         else begin 
             wrt_data<=0;
         end 
       end 
end    
 
always #10 clk=~clk;

endmodule