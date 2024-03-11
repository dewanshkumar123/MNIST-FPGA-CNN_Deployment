vlib work
vlib riviera

vlib riviera/clk_gen_sim_v1_0_0
vlib riviera/xil_defaultlib

vmap clk_gen_sim_v1_0_0 riviera/clk_gen_sim_v1_0_0
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work clk_gen_sim_v1_0_0  -sv2k12 \
"../../../ipstatic/hdl/clk_gen_sim_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 \
"../../../../BRAM.srcs/sources_1/ip/clk_gen_sim_0/hdl/clk_gen_sim_0.sv" \


vlog -work xil_defaultlib \
"glbl.v"

