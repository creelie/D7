BLLM: The Entropy Cost of Sound Self-Improvement and a Typed Crossing Network Tested on Five Open Problems, by Deep Bhattacharjee and Ushashi Bhattacharya.

Version 2.0.1 corrects one value of version 2.0.0: for Erdős problem 1183 it gives f(20) = 12, not 11 or 12. The upper bound is the paper's level colouring 000101100111001011100, and the lower bound is Theorem 7.6 of the fifth version of Bhattacharjee, Mandal and Bhattacharya, Resolving Erdős–Ulam monochromatic union-closed family conjectures (https://doi.org/10.5281/zenodo.23374973), whose proof ends in a finite check. Theorem XV.2 now gives f(n) exactly for n ≤ 20, and the introduction, the benchmark table, the status section and Fig. 18(a) say so.

The paper proves that certifying self-modifications of total cost A with at most θ expected false acceptances costs (A/log(1/ε))(H(p) + log 1/θ) up to an additive A, where H(p) is the entropy of the cost profile; that a sound infinite self-improvement of finite cost exists exactly when Σ a_n log(1/a_n) converges; and that a proposer needs at least e^{H_{1/2}(π)} proposals, a bound that language models miss by factors of 1.5 to 4.3. It then measures a typed crossing network with shared memory on five open problems (the Yang–Mills mass gap, the Hodge conjecture, the standard conjecture of Lefschetz type, Chowla's conjecture and Erdős problem 1183). The network reaches what its libraries can reach with half the checks, Hebbian boosters add nothing, and none of the five problems is solved. The lattice mass gap m ≥ −log(3β_W) for four-dimensional SU(2) on β_W < 1/3 is proved in the paper and has not been refereed.

Files:
- `BeyondTheLLM_final2.pdf`: the paper (60 pages).
- `BeyondTheLLM_final2-tex.zip`: the REVTeX source with PNG figures; `latexmk -pdf main.tex`, no BibTeX pass.
- `BeyondTheLLM_final2-arxiv.tar.gz`: the arXiv source.

Verification: `BLLM/lean` proves the finite inequalities in 59 Lean 4 theorems with Mathlib, each depending only on propext, Classical.choice and Quot.sound; `BLLM/checks` runs 55,271 Python, C and C++ checks with no failure. `bash BLLM/checks/run_all.sh` runs them all. The benchmark, the crossing network and the logs of every run are in eBLLM 2.0.1, https://doi.org/10.5281/zenodo.23456124.

Citation: Zenodo, all versions https://doi.org/10.5281/zenodo.23449604.
