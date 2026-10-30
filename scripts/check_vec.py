import re
import sys

TOL_MAG = 0.001   # magnitude error allowed
TOL_ANG = 0.05    # angle error allowed, in degrees
pat = re.compile(
    r"m=\s*([\d.]+)\s+(-?\d+) deg in \| mag =\s*(-?[\d.]+) .*\| angle =\s*(-?[\d.]+) deg")

count = 0
worst_m = 0.0
worst_a = 0.0
for line in sys.stdin:
    m = pat.match(line)
    if not m:
        continue
    mag_exp = float(m.group(1))
    deg = int(m.group(2))
    mag = float(m.group(3))
    ang = float(m.group(4))
    em = abs(mag - mag_exp)
    ea = abs(ang - deg)
    worst_m = max(worst_m, em)
    worst_a = max(worst_a, ea)
    count += 1
    if em > TOL_MAG or ea > TOL_ANG:
        print(f"FAIL at m={mag_exp} angle={deg}: mag err {em:.5f}, angle err {ea:.4f}")
        sys.exit(1)

if count != 18:
    print(f"FAIL: expected 18 results, got {count}")
    sys.exit(1)

print(f"PASS: {count} results checked, worst mag err {worst_m:.5f}, worst angle err {worst_a:.4f} deg")
