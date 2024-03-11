-makelib ies_lib/clk_gen_sim_v1_0_0 -sv \
  "../../../ipstatic/hdl/clk_gen_sim_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib -sv \
  "../../../../BRAM.srcs/sources_1/ip/clk_gen_sim_0/hdl/clk_gen_sim_0.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

