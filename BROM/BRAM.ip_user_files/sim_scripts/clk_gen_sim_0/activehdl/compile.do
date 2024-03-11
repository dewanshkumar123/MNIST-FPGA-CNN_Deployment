vlib work
vlib activehdl

vlib activehdl/clk_gen_sim_v1_0_0
vlib activehdl/xil_defaultlib

vmap clk_gen_sim_v1_0_0 activehdl/clk_gen_sim_v1_0_0
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work clk_gen_sim_v1_0_0  -sv2k12 \
"../../../ipstatic/hdl/clk_gen_sim_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 \
"../../../../BRAM.srcs/sources_1/ip/clk_gen_sim_0/hdl/clk_gen_sim_0.sv" \


vlog -work xil_defaultlib \
"glbl.v"

