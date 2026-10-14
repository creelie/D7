import Mathlib

/-!
# Products of chains are sublattices

A family of finite sets is a sublattice when it is closed under union and
intersection.  If `𝒜` is a chain of subsets of `Y`, `ℬ` a chain of subsets of
`Z`, and `Y`, `Z` are disjoint, then the family of unions `A ∪ B` is a
sublattice with `|𝒜| * |ℬ|` members.  This is the family used for the lower
bound for random colourings, and its members have sizes `|A| + |B|`.
-/

namespace SizeLattices

open Finset

variable {α : Type*} [DecidableEq α]

/-- A family of finite sets closed under union and intersection. -/
def IsSublattice (L : Finset (Finset α)) : Prop :=
  ∀ A ∈ L, ∀ B ∈ L, A ∪ B ∈ L ∧ A ∩ B ∈ L

/-- The family of unions `A ∪ B` with `A ∈ 𝒜` and `B ∈ ℬ`. -/
def unions (𝒜 ℬ : Finset (Finset α)) : Finset (Finset α) :=
  (𝒜 ×ˢ ℬ).image fun p => p.1 ∪ p.2

lemma chain_union_mem {𝒜 : Finset (Finset α)} (h : IsChain (· ⊆ ·) (𝒜 : Set (Finset α)))
    {A A' : Finset α} (hA : A ∈ 𝒜) (hA' : A' ∈ 𝒜) : A ∪ A' ∈ 𝒜 ∧ A ∩ A' ∈ 𝒜 := by
  rcases h.total hA hA' with hle | hle
  · rw [Finset.union_eq_right.mpr hle, Finset.inter_eq_left.mpr hle]; exact ⟨hA', hA⟩
  · rw [Finset.union_eq_left.mpr hle, Finset.inter_eq_right.mpr hle]; exact ⟨hA, hA'⟩

/-- Unions of members of two chains on disjoint ground sets form a sublattice. -/
theorem unions_isSublattice {Y Z : Finset α} (hYZ : Disjoint Y Z)
    {𝒜 ℬ : Finset (Finset α)}
    (h𝒜 : IsChain (· ⊆ ·) (𝒜 : Set (Finset α))) (hℬ : IsChain (· ⊆ ·) (ℬ : Set (Finset α)))
    (h𝒜Y : ∀ A ∈ 𝒜, A ⊆ Y) (hℬZ : ∀ B ∈ ℬ, B ⊆ Z) :
    IsSublattice (unions 𝒜 ℬ) := by
  intro S hS T hT
  simp only [unions, Finset.mem_image, Finset.mem_product] at hS hT ⊢
  obtain ⟨⟨A, B⟩, ⟨hA, hB⟩, rfl⟩ := hS
  obtain ⟨⟨A', B'⟩, ⟨hA', hB'⟩, rfl⟩ := hT
  obtain ⟨hu, hi⟩ := chain_union_mem h𝒜 hA hA'
  obtain ⟨hu', hi'⟩ := chain_union_mem hℬ hB hB'
  refine ⟨⟨(A ∪ A', B ∪ B'), ⟨hu, hu'⟩, ?_⟩, ⟨(A ∩ A', B ∩ B'), ⟨hi, hi'⟩, ?_⟩⟩
  · ext x; simp only [Finset.mem_union]; tauto
  · have dAB' : Disjoint A B' := Finset.disjoint_of_subset_left (h𝒜Y A hA)
      (Finset.disjoint_of_subset_right (hℬZ B' hB') hYZ)
    have dA'B : Disjoint A' B := Finset.disjoint_of_subset_left (h𝒜Y A' hA')
      (Finset.disjoint_of_subset_right (hℬZ B hB) hYZ)
    ext x
    simp only [Finset.mem_union, Finset.mem_inter]
    constructor
    · rintro (⟨h1, h2⟩ | ⟨h1, h2⟩)
      · exact ⟨Or.inl h1, Or.inl h2⟩
      · exact ⟨Or.inr h1, Or.inr h2⟩
    · rintro ⟨h1 | h1, h2 | h2⟩
      · exact Or.inl ⟨h1, h2⟩
      · exact absurd h2 (Finset.disjoint_left.mp dAB' h1)
      · exact absurd h1 (Finset.disjoint_left.mp dA'B h2)
      · exact Or.inr ⟨h1, h2⟩

/-- The map `(A, B) ↦ A ∪ B` is injective on `𝒜 × ℬ`, so the family of unions
has `|𝒜| * |ℬ|` members. -/
theorem card_unions {Y Z : Finset α} (hYZ : Disjoint Y Z) {𝒜 ℬ : Finset (Finset α)}
    (h𝒜Y : ∀ A ∈ 𝒜, A ⊆ Y) (hℬZ : ∀ B ∈ ℬ, B ⊆ Z) :
    (unions 𝒜 ℬ).card = 𝒜.card * ℬ.card := by
  rw [unions, Finset.card_image_of_injOn, Finset.card_product]
  rintro ⟨A, B⟩ hAB ⟨A', B'⟩ hAB' heq
  simp only [Finset.coe_product, Set.mem_prod, Finset.mem_coe] at hAB hAB'
  simp only at heq
  have hA : A = (A ∪ B) ∩ Y := by
    ext x; constructor
    · intro h; exact Finset.mem_inter.mpr ⟨Finset.mem_union_left _ h, h𝒜Y A hAB.1 h⟩
    · intro h
      rcases Finset.mem_union.mp (Finset.mem_inter.mp h).1 with h1 | h1
      · exact h1
      · exact absurd (Finset.mem_inter.mp h).2
          (Finset.disjoint_right.mp hYZ (hℬZ B hAB.2 h1))
  have hA' : A' = (A' ∪ B') ∩ Y := by
    ext x; constructor
    · intro h; exact Finset.mem_inter.mpr ⟨Finset.mem_union_left _ h, h𝒜Y A' hAB'.1 h⟩
    · intro h
      rcases Finset.mem_union.mp (Finset.mem_inter.mp h).1 with h1 | h1
      · exact h1
      · exact absurd (Finset.mem_inter.mp h).2
          (Finset.disjoint_right.mp hYZ (hℬZ B' hAB'.2 h1))
  have hB : B = (A ∪ B) ∩ Z := by
    ext x; constructor
    · intro h; exact Finset.mem_inter.mpr ⟨Finset.mem_union_right _ h, hℬZ B hAB.2 h⟩
    · intro h
      rcases Finset.mem_union.mp (Finset.mem_inter.mp h).1 with h1 | h1
      · exact absurd (Finset.mem_inter.mp h).2
          (Finset.disjoint_left.mp hYZ (h𝒜Y A hAB.1 h1))
      · exact h1
  have hB' : B' = (A' ∪ B') ∩ Z := by
    ext x; constructor
    · intro h; exact Finset.mem_inter.mpr ⟨Finset.mem_union_right _ h, hℬZ B' hAB'.2 h⟩
    · intro h
      rcases Finset.mem_union.mp (Finset.mem_inter.mp h).1 with h1 | h1
      · exact absurd (Finset.mem_inter.mp h).2
          (Finset.disjoint_left.mp hYZ (h𝒜Y A' hAB'.1 h1))
      · exact h1
  simp only [Prod.mk.injEq]
  exact ⟨by rw [hA, hA', heq], by rw [hB, hB', heq]⟩

/-- Sizes of the members of the family of unions. -/
theorem card_union_of_disjoint {Y Z : Finset α} (hYZ : Disjoint Y Z) {A B : Finset α}
    (hA : A ⊆ Y) (hB : B ⊆ Z) : (A ∪ B).card = A.card + B.card :=
  Finset.card_union_of_disjoint
    (Finset.disjoint_of_subset_left hA (Finset.disjoint_of_subset_right hB hYZ))

/-- Adding a new element `x` above the down-set `D`: the down-sets of the new
poset are the old ones and the sets `E ∪ {x}` with `D ⊆ E`.  Their number grows
by the number `u` of old down-sets containing `D`, so a poset built one element
at a time has `1 + u₁ + ⋯ + u_h` down-sets. -/
theorem card_extend (𝒟 : Finset (Finset α)) (x : α) (hx : ∀ E ∈ 𝒟, x ∉ E)
    (D : Finset α) :
    (𝒟 ∪ (𝒟.filter (D ⊆ ·)).image (insert x)).card
      = 𝒟.card + (𝒟.filter (D ⊆ ·)).card := by
  rw [Finset.card_union_of_disjoint, Finset.card_image_of_injOn]
  · intro E hE F hF hEF
    have hE' : x ∉ E := hx E (Finset.mem_filter.mp hE).1
    have hF' : x ∉ F := hx F (Finset.mem_filter.mp hF).1
    rw [← Finset.erase_insert hE', ← Finset.erase_insert hF', hEF]
  · rw [Finset.disjoint_left]
    intro E hE hE2
    obtain ⟨F, -, rfl⟩ := Finset.mem_image.mp hE2
    exact hx _ hE (Finset.mem_insert_self x F)

omit [DecidableEq α] in
/-- A sublattice is monochromatic under a colouring by cardinality exactly when
the colouring is constant on the sizes of its members. -/
theorem mono_of_sizes {β : Type*} (g : ℕ → β) (c : β) (L : Finset (Finset α))
    (h : ∀ A ∈ L, g A.card = c) : ∀ A ∈ L, (fun S : Finset α => g S.card) A = c := h

end SizeLattices
