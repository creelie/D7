Beyond the LLM: BLLM and the Entropy Law of Sound Recursive Self-Improvement, by Deep Bhattacharjee and Ushashi Bhattacharya.

A BLLM is a language model that keeps a modification of itself only after a randomized check of soundness ε accepts it. The paper proves that the least cost of certifying modifications of total cost A with at most θ expected false acceptances is (A/log(1/ε))(H(p) + log 1/θ) up to an additive A, where H(p) is the entropy of the cost profile. Huffman codes give the exact optimum, Rényi entropies govern checks of polynomial order, and an infinite self-improvement of finite cost can be made sound exactly when Σ a_n log(1/a_n) converges. The results hold in a model with independent runs, perfect completeness and schedules fixed in advance; the paper does not claim that any existing system is sound.

Files:
- `BeyondTheLLM_final2.pdf`: the paper (27 pages).
- `BeyondTheLLM_final2-tex.zip`: the REVTeX source with PNG figures; `latexmk -pdf main.tex`, no BibTeX pass.
- `BeyondTheLLM_final2-arxiv.tar.gz`: the arXiv source.

Verification: `BLLM/lean` proves every finite inequality in 39 Lean 4 theorems with Mathlib, each depending only on propext, Classical.choice and Quot.sound; `BLLM/checks` runs 33,505 Python, C and C++ checks with no failure. `bash BLLM/checks/run_all.sh` runs them all.

Citation: Zenodo, release v1.0.0, https://doi.org/10.5281/zenodo.23449605 (all versions https://doi.org/10.5281/zenodo.23449604).
