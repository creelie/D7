# Priority check: Erdős Problem 1183, f(n)

Question: had anyone shown that f(n) ≤ (1 + o(1)) n log₂ n, or found the size of the
largest monochromatic sublattice of a random colouring,, or computed f(n) exactly for 11 ≤ n ≤ 24,
before this work?

Checked 14 October 2026, 17:30–18:20 UTC.

| Source | Search | Result |
|---|---|---|
| erdosproblems.com/1183 and its forum thread (11 comments, 1 proof claim) | statement, history, comments | open; only f(n) ≥ (n+1)/2 on the page; no comment gives exact values for n ≥ 11 or an upper bound n log n with constant below 2 |
| arXiv:2610.02833 (Bhattacharjee, Mandal, Bhattacharya) and its v5 archive, Zenodo 10.5281/zenodo.23374973 | full text | lower bounds (Theorems 1.4, 7.6) and an upper bound with constant 2; asks whether f(n) = O(n) (Question 9.3); no exact values for n ≥ 11 |
| P. Chojecki, ulam.ai/research/erdos1183.pdf (18 Mar 2026) | full text | f(n) ≤ (3 + o(1)) n log₂ n |
| OpenRefute (the-omega-institute/trureturing) | issue #14535 | f(11) ≥ 7 (8–9 Oct 2026); nothing on random colourings |
| ndrorchestration PR #19 | f(8) | candidate f(8) = 5 (15 Sep 2026), agreeing with this work |
| Web and arXiv search | "monochromatic sublattice", "Erdős–Ulam", union and intersection closed families under colourings | no further results on f(n) |

Conclusion: as of 14 October 2026 we found no earlier statement of the random-colouring
asymptotics (1 ± o(1)) n log_k n, of f_card(n) for n ≤ 25, or of f(n) for 11 ≤ n ≤ 22 and n = 24.
The order of growth of f(n) remains open.
