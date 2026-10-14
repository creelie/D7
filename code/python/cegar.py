"""Compute f_card(n) by counterexample-guided search and write certificates.
A SAT solver proposes a word g in {R,B}^(n+1); the C++ search (cpp/search)
looks for a monochromatic weighted poset with s+1 down-sets; each one found
becomes a clause.  If the solver runs out of words, certs/unsat_n{n}_s{s}.txt
lists the witnesses that prove f_card(n) > s.  Usage: python3 cegar.py LO HI"""
import sys, subprocess, os
HERE=os.path.dirname(os.path.abspath(__file__))
CERTS=os.path.join(HERE,'..','..','certs')
from pysat.solvers import Cadical153
chk=subprocess.Popen([os.path.join(HERE,'..','cpp','search')],stdin=subprocess.PIPE,stdout=subprocess.PIPE,text=True,bufsize=1)
def query(n,K,g):
    chk.stdin.write(f"{n} {K} {g}\n"); chk.stdin.flush()
    line=chk.stdout.readline().strip()
    if line=='OK': return None,None
    T=[int(x) for x in line.split('|')[1].split()]
    return T,line
def run(n,s,log):
    K=s+1; sol=Cadical153()
    for i in range(n+1): sol.add_clause([i+1,-(i+1)])
    while True:
        if not sol.solve(): return None
        m=sol.get_model(); g=''.join('R' if m[i]>0 else 'B' for i in range(n+1))
        T,line=query(n,K,g)
        if T is None: return g
        log.write(line+'\n')
        v=[x+1 for x in T]; sol.add_clause(v); sol.add_clause([-x for x in v])
os.makedirs(CERTS,exist_ok=True)
lo,hi=int(sys.argv[1]),int(sys.argv[2])
for n in range(lo,hi+1):
    s=(n+2)//2
    while True:
        with open(os.path.join(CERTS,f'unsat_n{n}_s{s}.txt'),'w') as log:
            g=run(n,s,log)
        if g:
            os.remove(os.path.join(CERTS,f'unsat_n{n}_s{s}.txt'))
            open(os.path.join(CERTS,f'word_n{n}.txt'),'w').write(f"{n} {s} {g}\n")
            print(f"n={n} fcard={s} g={g}",flush=True); break
        print(f"n={n} fcard>{s}",flush=True); s+=1
