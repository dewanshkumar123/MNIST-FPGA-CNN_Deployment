`timescale 1ns / 1ps



module test(
    input clk,
    input read,
    input write,
    input reset,
    input enable,
    input [3:0]din,
    output reg [4:0]sum,
    output reg [3:0]dout
    );
    
   reg [3:0]add_w=0;
   reg [3:0]add_r=0;
   reg [3:0]add_next1,add_next2;
   wire [3:0] dout;
   
   
blk_mem_gen_0 your_instance_name (
  .clka(clk),    // input wire clka
  .ena(enable),      // input wire ena
  .wea(write),      // input wire [0 : 0] wea
  .addra(add_w),  // input wire [3 : 0] addra
  .dina(din),    // input wire [3 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read),      // input wire enb
  .addrb(add_r),  // input wire [3 : 0] addrb
  .doutb(dout)  // output wire [3 : 0] doutb
);

always@(posedge clk)
begin
    add_r<=add_next1;
    add_w<=add_next2;
end
  
  //write operation
always@(*)
    begin
    if (reset)
        add_next2<=0;
    else if (write)
        begin
        if (add_next2==4'b1111)
            add_next2=add_w;
        else
            add_next2=add_w+1;
         end
    else
        add_next2=add_next2;
    end
 
 
 always@(*)
    begin
    if (reset)
        add_next1<=0;
    else if (read)
        begin
        if (add_next1==4'b1111)
            add_next1=add_r;
        else
            add_next1=add_r+1;
        end
    else
        add_next1=add_next1;
    end
   
//   wire [3:0]s;
//   wire c;
//sum(dout,dout,0,s,c);  
//assign sum={c,s};

always@(*)
begin
//    if (dout[0])
        sum=din+dout;
//    else
//        sum=0;
end


endmodule
