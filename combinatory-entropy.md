<!-- common entropic values for different combinations of character sets -->

# Character Set Combinatorics for Next‑Symbol Prediction 🚀

In sequence modeling and language generation research, the choice of the underlying alphabet has profound implications for model complexity, predictive entropy, and algorithmic strategies such as **top‑k sampling**, **temperature scaling**, and **constrained decoding**. This document provides a technical foundation for reasoning about character‑set combinatorics from the perspective of next‑symbol prediction rather than authentication.

> **Key formulae:**
> - Alphabet size: \(S\)
> - Number of possible length‑*L* sequences: \(S^L\)
> - Entropy per symbol: \(H = \log_2 S\) bits
> - Cross‑entropy or prediction difficulty scales with \(\log_2 S\)

## Primitive Alphabets

| Name       | Representation                    | Size |
|------------|-----------------------------------|------|
| lowercase  | a–z                               | 26   |
| uppercase  | A–Z                               | 26   |
| digits     | 0–9                               | 10   |
| symbols    | Common ASCII punctuation          | 32   |

By adjusting the alphabet, one controls the **baseline perplexity** of an unconstrained model. An 8‑bit encoder (size 256) has 8 bits/symbol of entropy; ASCII printable (≈94) ~6.55 bits/symbol.

## Useful Combinations

Working with hybrid sets lets researchers trade off granularity against vocabulary size. Table below shows combinations used in language models and compression algorithms:

| Combination        | Sets                     | S   | Bits/symbol |
|--------------------|--------------------------|-----|-------------|
| letters            | lowercase + uppercase    | 52  | 5.70        |
| alphanumeric       | letters + digits         | 62  | 5.95        |
| printable ASCII    | alphanumeric + symbols   | 94  | 6.55        |
| extended (base64)  | letters + digits + +/
|                    |                          | 64  | 6.00        |

> Custom sets (e.g. 16‑way hex, 256‑byte) are common in compression and audio codecs; simply apply \(\log_2\) to obtain bits per symbol.

## Entropy & Prediction Length

When evaluating next‑symbol predictors (RNNs, Transformers, Markov models), total entropy of a sequence of length *L* is:

```
entropy_total = L * log2(S)
```

A predictor's cross‑entropy loss in bits/symbol approximates \(\log_2 S\) for a uniform distribution. Increasing *S* forces models to distribute probability mass across more candidates, which in turn impacts:

1. **Top‑K sampling** – larger *S* means top‑k covers a smaller fraction of probability, requiring larger *k* to achieve a given coverage.
2. **Lagrangian inference** – when enforcing constraints (e.g. grammar rules), the Lagrangian multipliers adjust to offset the logarithmic cost of excluded symbols.
3. **Beam search width** – expected width grows with alphabet size; i.e. complexity roughly \(O(k \, S)\) per timestep.

## Algorithmic Considerations

### Top‑K & Nucleus Sampling

For alphabet size *S*, the probability mass of the top‑k symbols is
\(P_{topK} = \sum_{i=1}^{k} p_{(i)}\).  With uniform assumptions, \(P_{topK} \approx k/S\).  Thus, to maintain coverage ρ, choose \(k ≈ ρ S\).

### Temperature & Softmax

Temperature scaling modifies logits \(z_i\) via \(z'_i = z_i / T\).  Entropy of the resulting distribution increases with \(T\), asymptotically approaching \(\log_2 S\) as \(T → ∞\).  Character‑set size sets the ceiling.

### Constraint Handling & Lagrangian

When applying hard constraints (forbidden tokens), one can incorporate a Lagrangian penalty \(λ\) to the log‑probabilities.  The regret per step is bounded by \(\log_2(S/(S - |F|))\) where \(|F|\) is the forbidden subset size.

### Markov & N‑gram Models

The transition matrix is \(S × S\); memory and computation scale quadratically in alphabet size, motivating techniques like **factorized embeddings** or **shared sub‑alphabets** (e.g. decomposing into case/char).  For subword tokenizers, the effective S is the vocabulary size derived from BPE or unigram models.

## Practical Matrix 📐

```
Sets        | S   | Bits/symbol | Example Use-cases
------------|-----|-------------|-------------------
lower        | 26  | 4.70        | simple language models
letters      | 52  | 5.70        | case-sensitive text
digits       | 10  | 3.32        | numeric prediction
symbols      | 32  | 5.00        | programming language modeling
alnum        | 62  | 5.95        | general text data
printable    | 94  | 6.55        | text+punctuation models
base64       | 64  | 6.00        | encoding/decoding tasks
unicode BMP  | 65536| 16.0       | full multilingual models
```

Quantitative reasoning about *S* helps when comparing architectures or predicting computational cost.

---

> 🧠 *Philosophical note:* the choice of character set is akin to selecting the alphabet of a formal language; it defines the **search space** for the predictor. Modelers must balance expressiveness against the curse of dimensionality.

You can adapt this document to include programmatic snippets or reference implementations of top‑k, beam search, etc., depending on the needs of your paper.