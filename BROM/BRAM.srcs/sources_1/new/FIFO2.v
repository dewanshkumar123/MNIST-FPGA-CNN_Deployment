`timescale 1ns / 1ps

module FIFO2(
    input clk_1,
    input reset,
    input [7:0] din,
    output full,
    output empty,
    output almost_empty,
    output almost_full,
    output [7:0] data_count,
    output [7:0] dout,
    input read,
    input write
    );
    
    
    wire clk_5M, clk_200H,clk_pulse;
    
   clk_gen_sim_0 your_instance_name (
  .axi_clk_in_0(axi_clk_in_0),      // input wire axi_clk_in_0
  .axi_rst_in_0_n(axi_rst_in_0_n),  // input wire axi_rst_in_0_n
  .axi_clk_0(axi_clk_0),            // output wire axi_clk_0
  .axi_rst_0_n(axi_rst_0_n)        // output wire axi_rst_0_n
);
endmodule
