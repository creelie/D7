"""Check the lower-bound certificates f_card(n) > s.
Each witness line gives a colour c, a base b and a weighted poset (element j:
strict down-set mask D_j, weight w_j).  We recompute the down-sets of the poset
from scratch, check there are at least s+1 of them, that b + total weight <= n,
and collect the set T of sizes b + w(D).  A cardinality colouring g with g
constant on T has a monochromatic sublattice with at least s+1 members.  We
then check with two SAT solvers that no word g avoids being constant on every T."""
import sys, glob, re, itertools, os
CERTS=os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','..','certs')
from pysat.solvers import Glucose4, Minisat22
def downsets(elts):
    h=len(elts)
    for j,(D,w) in enumerate(elts):
        assert D < (1<<j), "labels must be natural"
        for i in range(j):              # D_j must be closed downward
            if D>>i & 1: assert elts[i][0] & ~D == 0
    out=[]
    for mask in range(1<<h):            # brute force over all subsets
        if all(not(mask>>j & 1) or (elts[j][0] & ~mask)==0 for j in range(h)):
            out.append(mask)
    return out
def check_file(path):
    n,s=map(int,re.search(r'unsat_n(\d+)_s(\d+)',os.path.basename(path)).groups())
    clauses=[]
    for line in open(path):
        head,_=line.split('|'); p=head.split()
        b=int(p[1]); k=int(p[2]); elts=[(int(p[3+2*i]),int(p[4+2*i])) for i in range(k)]
        assert all(w>=1 for _,w in elts)
        assert b+sum(w for _,w in elts)<=n
        ds=downsets(elts); assert len(ds)>=s+1, (path,line)
        T=sorted({b+sum(elts[j][1] for j in range(k) if m>>j&1) for m in ds})
        clauses.append([t+1 for t in T]); clauses.append([-(t+1) for t in T])
    for S in (Glucose4,Minisat22):
        sol=S()
        for i in range(n+1): sol.add_clause([i+1,-(i+1)])
        for c in clauses: sol.add_clause(c)
        assert not sol.solve(), path
    return n,s,len(clauses)//2
for path in sorted(glob.glob(os.path.join(CERTS,'unsat_*.txt')), key=lambda p:tuple(map(int,re.findall(r'\d+',os.path.basename(p))))):
    n,s,m=check_file(path)
    print(f"f_card({n}) > {s}: {m} witnesses checked, both solvers UNSAT",flush=True)
