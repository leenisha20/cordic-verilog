#!/bin/bash
set -e
case "$1" in
  test)
    iverilog -o pipe.out rtl/cordic_stage.v rtl/cordic_pipe.v tb/tb_pipe.v
    vvp pipe.out | python scripts/check.py
    ;;
  comb)
    iverilog -o sim.out rtl/cordic_stage.v rtl/cordic_core.v tb/tb_cordic.v
    vvp sim.out
    ;;
  clean)
    rm -f *.out *.vcd
    ;;
  *)
    echo "Usage: bash run.sh [test|comb|clean]"
    ;;
esac
