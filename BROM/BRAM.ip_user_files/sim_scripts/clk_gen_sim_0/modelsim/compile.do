vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/clk_gen_sim_v1_0_0
vlib modelsim_lib/msim/xil_defaultlib

vmap clk_gen_sim_v1_0_0 modelsim_lib/msim/clk_gen_sim_v1_0_0
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work clk_gen_sim_v1_0_0 -64 -incr -sv \
"../../../ipstatic/hdl/clk_gen_sim_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -sv \
"../../../../BRAM.srcs/sources_1/ip/clk_gen_sim_0/hdl/clk_gen_sim_0.sv" \


vlog -work xil_defaultlib \
"glbl.v"

