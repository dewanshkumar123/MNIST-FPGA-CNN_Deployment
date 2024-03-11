`timescale 1ns / 1ps

module brom2(clk,max,min);
input clk;
output reg [3:0]max=0;
output reg [3:0]min=100;
wire [3:0]dout;

reg [3:0] addr_reg=0;
reg [3:0] addr_next;


always@(posedge clk)
    addr_reg<=addr_next;

always@(*)
    begin
    if (addr_reg==4'b1111)
        addr_next=addr_reg;
    else
        addr_next=addr_reg+1;
    end
   

blk_mem_gen_2 your_instance_name (
  .clka(clk),    // input wire clka
  .addra(addr_reg),  // input wire [3 : 0] addra
  .douta(dout)  // output wire [3 : 0] douta
);
always@(*)
begin

    if (dout>max)
        max=dout;
    else
        max=max;
end

always@(*)
begin

    if (dout<min)
        min=dout;
    else
        min=max;
end

endmodule
