#!/bin/bash
set -e
case "$1" in
  test)
    iverilog -o pipe.out rtl/cordic_stage.v rtl/cordic_pipe.v tb/tb_pipe.v
    vvp pipe.out | python scripts/check.py
    iverilog -o vec.out rtl/cordic_vstage.v rtl/cordic_vec.v tb/tb_vec.v
    vvp vec.out | python scripts/check_vec.py
    iverilog -o sensor.out rtl/cordic_vstage.v rtl/cordic_vec.v rtl/sensor_cordic.v tb/tb_sensor.v
    vvp sensor.out | python scripts/check_sensor.py
    ;;
  sweep)
    iverilog -o sweep.out rtl/cordic_stage.v rtl/cordic_core.v tb/tb_sweep.v
    vvp sweep.out | python scripts/plot_error.py docs/error.png
    ;;
  comb)
    iverilog -o sim.out rtl/cordic_stage.v rtl/cordic_core.v tb/tb_cordic.v
    vvp sim.out
    ;;
  vec)
    iverilog -o vec.out rtl/cordic_vstage.v rtl/cordic_vec.v tb/tb_vec.v
    vvp vec.out
    ;;
  sensor)
    iverilog -o sensor.out rtl/cordic_vstage.v rtl/cordic_vec.v rtl/sensor_cordic.v tb/tb_sensor.v
    vvp sensor.out
    ;;
  clean)
    rm -f *.out *.vcd
    ;;
  *)
    echo "Usage: bash run.sh [test|sweep|comb|vec|sensor|clean]"
    ;;
esac
