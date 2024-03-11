`timescale 1ns / 1ps


module test_tb();

reg clk;
reg read,write,reset,enable;
reg [3:0]din;
wire [4:0]sum;
wire [3:0]dout;
test uut(clk,read,write,reset,enable,din,sum,dout);

initial
begin
clk=0;
forever #5 clk=~clk;
end


initial begin

read=0;write=0;reset=1;din=0;enable=1;
#10;
write=1;reset=0;
din=3;
#10;
din=7;
#10;
din=4;
#5;
din=5;
#5;
write=0;read=1;
#20;
#10;
#20;



read=0;
$finish();
end
endmodule


