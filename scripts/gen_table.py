import math

FRAC = 14          # angle scale: 1 radian = 2**14
ITER = 16

print("Iteration, atan(2^-i) in radians, fixed-point value")
for i in range(ITER):
    ang = math.atan(2 ** -i)
    fx = round(ang * (1 << FRAC))
    print(f"{i:2d}  {ang:.6f}  {fx}")

# CORDIC gain correction constant K = product of 1/sqrt(1+2^-2i)
K = 1.0
for i in range(ITER):
    K /= math.sqrt(1 + 2 ** (-2 * i))
print("K =", K, " fixed (Q1.15):", round(K * (1 << 15)))
