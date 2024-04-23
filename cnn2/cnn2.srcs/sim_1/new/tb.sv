`timescale 1ns / 1ps
module tb();
reg clk;
wire [3:0]out;

top_module uut(clk,out);
always #0.0005 clk=~clk;
initial begin

clk=0;
#1000;

                                                            
$finish();

end
endmodule