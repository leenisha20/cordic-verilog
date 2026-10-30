import re
import sys
import math
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

out = sys.argv[1] if len(sys.argv) > 1 else "docs/error.png"
TOL = 0.001
pat = re.compile(r"^(-?\d+) (-?\d+) (-?\d+)$")

deg, cos_v, sin_v, cos_e, sin_e = [], [], [], [], []
for line in sys.stdin:
    m = pat.match(line.strip())
    if not m:
        continue
    a, c, s = (int(g) for g in m.groups())
    rad = a / 16384.0
    deg.append(math.degrees(rad))
    cos_v.append(c / 16384.0)
    sin_v.append(s / 16384.0)
    cos_e.append(c / 16384.0 - math.cos(rad))
    sin_e.append(s / 16384.0 - math.sin(rad))

if not deg:
    print("FAIL: no data read")
    sys.exit(1)

worst = max(max(abs(e) for e in cos_e), max(abs(e) for e in sin_e))

fig, ax = plt.subplots(2, 1, figsize=(10, 7), sharex=True)
ax[0].plot(deg, cos_v, label="cos (CORDIC)")
ax[0].plot(deg, sin_v, label="sin (CORDIC)")
ax[0].set_ylabel("value")
ax[0].legend()
ax[0].grid(True)
ax[0].set_title(f"CORDIC sweep: {len(deg)} angles, worst error {worst:.5f}")
ax[1].plot(deg, cos_e, label="cos error", linewidth=0.8)
ax[1].plot(deg, sin_e, label="sin error", linewidth=0.8)
ax[1].set_ylabel("error (CORDIC - true)")
ax[1].set_xlabel("angle (degrees)")
ax[1].legend()
ax[1].grid(True)
fig.tight_layout()
fig.savefig(out, dpi=120)

if worst > TOL:
    print(f"FAIL: worst error {worst:.5f} over {len(deg)} angles")
    sys.exit(1)
print(f"PASS: {len(deg)} angles swept, worst error {worst:.5f}, saved {out}")
