`timescale 1ns / 1ps


module brom_tb1();
reg clk=0;
wire [3:0]max;
wire [3:0]min;


brom2 uut(clk,max,min);

always #5 clk=~clk;


endmodule