.RECIPEPREFIX := >
SRC = rtl/cordic_stage.v rtl/cordic_core.v rtl/cordic_pipe.v

.PHONY: test comb pipe clean

test: pipe
> vvp pipe.out | python scripts/check.py

comb:
> iverilog -o sim.out rtl/cordic_stage.v rtl/cordic_core.v tb/tb_cordic.v
> vvp sim.out

pipe:
> iverilog -o pipe.out rtl/cordic_stage.v rtl/cordic_pipe.v tb/tb_pipe.v

clean:
> rm -f *.out *.vcd
