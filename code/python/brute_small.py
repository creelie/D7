"""Brute force for n <= 4: list every sublattice of the Boolean lattice 2^[n]
(nonempty families closed under union and intersection) and compute, over all
2-colourings of 2^[n], the least possible size of the largest monochromatic
sublattice.  The result is compared with the exact values 1, 2, 2, 3."""
import sys
import numpy as np

EXPECTED = {1: 1, 2: 2, 3: 2, 4: 3}

def sublattices(n):
    N = 1 << n
    out = []
    for fam in range(1, 1 << N):
        sets = [x for x in range(N) if fam >> x & 1]
        if all(fam >> (a | b) & 1 and fam >> (a & b) & 1 for a in sets for b in sets):
            out.append(fam)
    return out

def f(n):
    N = 1 << n
    subs = sorted(sublattices(n), key=lambda m: -bin(m).count('1'))
    sizes = np.array([bin(m).count('1') for m in subs])
    masks = np.array(subs, dtype=np.int64)
    full = (1 << N) - 1
    best = None
    for c in range(1 << N):
        red = (masks & c) == masks
        blue = (masks & (full ^ c)) == masks
        mono = red | blue
        largest = sizes[np.argmax(mono)]
        best = largest if best is None else min(best, largest)
    return best, len(subs)

bad = 0
for n in range(1, 5):
    val, count = f(n)
    ok = val == EXPECTED[n]
    bad += not ok
    print(f"n={n}: {count} sublattices, f({n}) = {val} ({'ok' if ok else 'MISMATCH'})", flush=True)
sys.exit(1 if bad else 0)
