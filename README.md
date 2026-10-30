\# CORDIC Core in Verilog



A fixed-point CORDIC (COordinate Rotation DIgital Computer) core that computes sine and cosine using only shifts and adds, with no multipliers.



\## Features

\- Combinational version (`rtl/cordic\_core.v`)

\- Pipelined version, one result per clock (`rtl/cordic\_pipe.v`)

\- 16-bit fixed point, scale 2^14 (1.0 = 16384)

\- 14 iterations, input range -90 to +90 degrees

\- Self-checking flow: Python compares output against `math.sin` / `math.cos`



\## Results

Worst-case error over the test angles: about 0.00027 (13 angles, -90 to 90 degrees in 15 degree steps).



\## Project layout

\- `rtl/` Verilog design files

\- `tb/` testbenches

\- `scripts/` Python table generator and result checker

\- `docs/` waveforms and notes

\- `run.sh` build and test script



\## How to run

Requires Icarus Verilog and Python 3.



&#x20;   bash run.sh test     # pipelined core, checked automatically

&#x20;   bash run.sh comb     # combinational core, prints results

&#x20;   bash run.sh clean    # remove generated files



\## How it works

Each stage rotates a vector by atan(2^-i) in the direction that reduces the remaining angle. The stages use only shifts and adds. The starting x value 0.60725 pre-compensates the CORDIC gain, so the final x and y are cos and sin directly.



\## Pipeline timing

A new angle is accepted every clock cycle. Results appear 15 cycles later (latency), then one per cycle.



\## Tools

Icarus Verilog, GTKWave, Python 3

