import re
import sys
import math

TOL = 0.001   # allowed error (our fixed-point resolution is about 0.00006)
pat = re.compile(r"\s*(-?\d+) deg \| cos =\s*(-?[\d.]+) .*\| sin =\s*(-?[\d.]+)")

count = 0
worst = 0.0
for line in sys.stdin:
    m = pat.match(line)
    if not m:
        continue
    deg = int(m.group(1))
    c, s = float(m.group(2)), float(m.group(3))
    err = max(abs(c - math.cos(math.radians(deg))),
              abs(s - math.sin(math.radians(deg))))
    worst = max(worst, err)
    count += 1
    if err > TOL:
        print(f"FAIL at {deg} deg: error {err:.5f}")
        sys.exit(1)

if count != 13:
    print(f"FAIL: expected 13 results, got {count}")
    sys.exit(1)

print(f"PASS: {count} results checked, worst error {worst:.5f}")
