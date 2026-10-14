# Monochromatic sublattices in random and cardinality colourings of the Boolean lattice

Paper and checks by Deep Bhattacharjee.

Let f(n) be the largest m such that every 2-colouring of the subsets of an
n-element set has a monochromatic sublattice with m members (Erdős Problem
1183). This work builds on the preprint of Bhattacharjee, Mandal and
Bhattacharya, arXiv:2610.02833, and its archive (Zenodo
10.5281/zenodo.23374973), whose lower bounds it uses.

## What is proved

* **Random colourings.** In a uniformly random k-colouring of 2^[n] the largest
  monochromatic sublattice has (1 ± o(1)) n log_k n members with high
  probability. Hence f(n) ≤ (1 + o(1)) n log_2 n. The proof is in the paper.
* **Cardinality colourings.** For colourings that depend only on the size of a
  set, the least largest monochromatic sublattice f_card(n) is found for every
  n ≤ 25 (values 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12,
  12, 13, 14, 14, 15).
* **Exact values.** f(n) = f_card(n) for n ≤ 22 and n = 24, by the lower
  bounds of the preprint. Also 13 ≤ f(23) ≤ 14 and 14 ≤ f(25) ≤ 15.
* The chain bound ⌊n/2⌋ + 1 equals f(n) exactly for n ∈ {1,…,10, 12, 14, 16, 18}.

## What is open

The order of growth of f(n) is not settled: the upper bound is n log_2 n and
the lower bound is linear, so this is **not** a full closure of the problem.
Also open: f(23), f(25), f(n) for n ≥ 26, and whether f_card(n) = O(n).

## Layout

| Path | Contents |
| --- | --- |
| `paper/` | LaTeX source (`SizeLattices.tex`), figures (TikZ sources and 300 dpi PNG) |
| `code/cpp/search.cpp` | primal search for monochromatic weighted posets |
| `code/python/cegar.py` | SAT-guided computation of f_card(n), writes `certs/` |
| `code/python/verify_lower.py` | checks the lower-bound certificates (two SAT solvers) |
| `code/python/verify_upper.py` | independent dual search: the words of `certs/word_n*.txt` have no larger monochromatic sublattice |
| `code/python/brute_small.py` | brute force over all colourings and all sublattices for n ≤ 4 |
| `certs/` | `word_n{n}.txt` (optimal words) and `unsat_n{n}_s{s}.txt` (proofs that f_card(n) > s) |
| `lean/` | Lean 4 with Mathlib: the product construction and the size bookkeeping |
| `run_all.sh` | runs every check |

## Lean

`lean/SizeLattices/Basic.lean` proves that the union family of two chains on
disjoint ground sets is a sublattice with |𝒜|·|ℬ| members (the construction of
the random lower bound), the down-set extension count, and that a family whose
sizes have one colour under a cardinality colouring is monochromatic. The
probabilistic estimates and the finite searches are not in Lean.

## Running the checks

Requirements: g++, Python 3 with `numpy` and `python-sat`, and elan for Lean.

```
./run_all.sh
```

## Citation

See `CITATION.cff`. Licence: MIT.
