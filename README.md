# CORDIC Core in Verilog

A fixed-point CORDIC (COordinate Rotation DIgital Computer) core that computes sine, cosine, magnitude and angle using only shifts and adds, with no multipliers.

## Features
- Combinational rotation mode (`rtl/cordic_core.v`)
- Pipelined rotation mode, one result per clock (`rtl/cordic_pipe.v`)
- Vectoring mode: magnitude and angle from (x, y) (`rtl/cordic_vec.v`)
- 16-bit fixed point, scale 2^14 (1.0 = 16384)
- 14 iterations
- Self-checking: Python compares simulator output against the math library

## Results
- Rotation mode: worst error about 0.00027 (13 angles, -90 to 90 degrees).
- Vectoring mode: worst magnitude error about 0.0002, worst angle error about 0.012 degrees (18 test points).

## Project layout
- `rtl/` Verilog design files
- `tb/` testbenches
- `scripts/` Python table generator and result checkers
- `docs/` waveforms and notes
- `run.sh` build and test script

## How to run
Requires Icarus Verilog and Python 3.

    bash run.sh test     # both modes, checked automatically
    bash run.sh comb     # combinational core, prints results
    bash run.sh vec      # vectoring mode, prints results
    bash run.sh clean    # remove generated files

## How it works
Each stage rotates a vector by atan(2^-i) using only shifts and adds. In rotation mode the direction depends on the sign of the remaining angle z, and the starting x value 0.60725 cancels the CORDIC gain, so x and y end up as cos and sin. In vectoring mode the direction depends on the sign of y, which drives y to zero, so x holds the magnitude (scaled by the gain, corrected at the end) and z holds the angle.

## Pipeline timing
A new angle is accepted every clock cycle. Results appear 15 cycles later (latency), then one per cycle.

## Tools
Icarus Verilog, GTKWave, Python 3
