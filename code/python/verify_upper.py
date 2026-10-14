"""Independent check (dual search): no monochromatic sublattice with K members
under the cardinality colouring g.  Posets are built by adding minimal elements;
values are t - w(J minus D) for a fixed top value t."""
import sys
def has_mono(S, n, K):
    for t in range(n, -1, -1):
        if not S[t]: continue
        # list of (mask, value) for downsets; start: empty poset, one downset value t
        stack_found = dfs([(0, t)], 0, S, K)
        if stack_found: return stack_found
    return None
def dfs(ds, nel, S, K):
    if len(ds) >= K: return sorted(v for _, v in ds)
    cur = len(ds)
    for i in range(cur):
        D0 = ds[i][0]
        sub = [e for e in range(cur) if ds[e][0] & ~D0 == 0]
        minv = min(ds[e][1] for e in sub)
        for w in range(1, minv + 1):
            if all(S[ds[e][1] - w] for e in sub):
                bit = 1 << nel
                # old downsets D become D+x (mask|bit), kept ones are the old D inside D0
                new = [(m | bit, v) for m, v in ds] + [(ds[e][0], ds[e][1] - w) for e in sub]
                r = dfs(new, nel + 1, S, K)
                if r: return r
    return None
if __name__ == '__main__':
    bad = 0
    for line in sys.stdin:
        if not line.strip(): continue
        n, s, g = line.split(); n = int(n); s = int(s)
        assert len(g) == n + 1
        ok = True
        for c in 'RB':
            S = [ch == c for ch in g]
            r = has_mono(S, n, s + 1)
            if r: print(f"n={n} FAIL colour {c} values {r}"); ok = False; bad += 1
        if ok: print(f"n={n} g={g}: no monochromatic sublattice with {s+1} members", flush=True)
    sys.exit(1 if bad else 0)
