vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/clk_gen_sim_v1_0_0
vlib questa_lib/msim/xil_defaultlib

vmap clk_gen_sim_v1_0_0 questa_lib/msim/clk_gen_sim_v1_0_0
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work clk_gen_sim_v1_0_0 -64 -sv \
"../../../ipstatic/hdl/clk_gen_sim_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv \
"../../../../BRAM.srcs/sources_1/ip/clk_gen_sim_0/hdl/clk_gen_sim_0.sv" \


vlog -work xil_defaultlib \
"glbl.v"

