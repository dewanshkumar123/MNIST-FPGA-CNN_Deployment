onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_gen_sim_0_opt

do {wave.do}

view wave
view structure
view signals

do {clk_gen_sim_0.udo}

run -all

quit -force
