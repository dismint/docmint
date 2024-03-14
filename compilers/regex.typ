#import "template.typ": *
#show: template.with(
  title: "RegEx and Context-Free Grammars",
  subtitle: "6.110"
)

= RegEx

We start off with some kind of alphabet $Sigma$, where the RegEx is built from 

- The empty string $epsilon$
- Any letter from the alphabet $Sigma$
- One RegEx followed by another $r_1 r_2$ (sequence)
- Either one RegEx or another $r_1|r_2$ (choice)
- Iterated sequence and choice $r^* = epsilon|r|r r|...$
- Parenthesis to indicate grouping precedence

= Finite-State Automata

We can also visualize the same thing as a FSA, where there are *Start* states and *Accept* / *End* states.

#define(
  title: "DFA vs NFA"
)[
  What is the difference between *Determinant* and *Non-Determinant* Finite Automata?

  / DFA: Only one possible transition at each state.
  / NFA: May have multiple possible transitions. This means that there could be two or more transitions with the exact same label on them, or transitions that are labeled with the empty string $epsilon$. A string is accepted if *any* execution matches.
]

#define(
  title: "Angelic vs Demonic Non-Determinism"
)[
  / Angelic: All decisions made to accept - try to help the string match.
  / Demonic: All decisions made to *not* accept - try to prevent the string from matching.
  
  NFA uses *Angelic* Non-Determinism.
]

Although they are technically the same thing, semantically RegEx is a *generative* form while Automata are a *recognition* form.
