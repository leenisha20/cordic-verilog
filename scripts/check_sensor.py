import re
import sys
import math

MAG_TOL = 0.001    # in Q2.14 units (1.0 = 16384)
ANG_TOL = 0.1      # degrees
pat = re.compile(r"a=\s*(\d+) b=\s*(\d+) \| mag =\s*(-?[\d.]+) \| angle =\s*(-?[\d.]+) deg")

count = 0
worst_mag = 0.0
worst_ang = 0.0
for line in sys.stdin:
    m = pat.match(line)
    if not m:
        continue
    a, b = int(m.group(1)), int(m.group(2))
    mag, ang = float(m.group(3)), float(m.group(4))
    exp_mag = math.hypot(a, b) / 8 / 16384
    exp_ang = math.degrees(math.atan2(b, a))
    em = abs(mag - exp_mag)
    ea = abs(ang - exp_ang)
    worst_mag = max(worst_mag, em)
    worst_ang = max(worst_ang, ea)
    count += 1
    if em > MAG_TOL or ea > ANG_TOL:
        print(f"FAIL at a={a} b={b}: mag err {em:.5f}, angle err {ea:.4f} deg")
        sys.exit(1)

if count != 10:
    print(f"FAIL: expected 10 results, got {count}")
    sys.exit(1)

print(f"PASS: {count} results checked, worst mag err {worst_mag:.5f}, worst angle err {worst_ang:.4f} deg")
