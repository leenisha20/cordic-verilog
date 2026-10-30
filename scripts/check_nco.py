import sys
import math

FW = 1024
step = 2 * math.pi * FW / 65536
TOL_MAG = 0.002
TOL_STEP = 0.003

prev = None
n = 0
worst_mag = 0.0
worst_step = 0.0
for line in sys.stdin:
    parts = line.split()
    if len(parts) != 2:
        continue
    try:
        c, s = int(parts[0]) / 16384.0, int(parts[1]) / 16384.0
    except ValueError:
        continue
    worst_mag = max(worst_mag, abs(math.hypot(c, s) - 1.0))
    ph = math.atan2(s, c)
    if prev is not None:
        d = (ph - prev - step + math.pi) % (2 * math.pi) - math.pi
        worst_step = max(worst_step, abs(d))
    prev = ph
    n += 1

if n < 200:
    print(f"FAIL: only {n} samples")
    sys.exit(1)
if worst_mag > TOL_MAG or worst_step > TOL_STEP:
    print(f"FAIL: mag err {worst_mag:.5f}, phase-step err {worst_step:.5f} rad")
    sys.exit(1)
print(f"PASS: {n} samples, worst amplitude err {worst_mag:.5f}, worst phase-step err {worst_step:.5f} rad")
