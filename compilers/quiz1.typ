#import "template.typ": *
#show: template.with(
  title: "Quiz 1 Review",
  subtitle: "6.1100"
)

= Regular Expressions, NFA, DFA

An alphabet is represented by the symbol $Sigma$, and a *string* is created out of the atomic alphabet. A language is then a certain combination of strings.

Regular expressions, NFA, and DFA all have the same strength of representation. However, their use cases can vary depending on what information is being conveyed. The idea is that regular expressions can generalize what kind of words are in the language, whereas an automata can help determine if a given word is in the language.

#note(
  title: "Regex in Math / CS"
)[
  Keep in mind that we refer to regex in the context of Math, not necessarily the regex we see in programming, which has many more features than the simple operators of mathematical regex.
]

Conversion of NFA to DFA, results in exponential blowup - more specifically, $n$ states in NFA lead to at most $2^n$ states in DFA.

/ DFA: A deterministic finite automata which cannot contain $epsilon$ or have multiple transitions out of a state for a given token.

#define(
  title: "Thompson's Construction"
)[
  Thompson's defines a way to turn a regular expression into an NFA. Most rules are very simple, with the trickiest one being the star operator, which matches any number of times (including zero).

  #twocol(
    [
      The image on the right shows an example of Thompson's rule for a harder case. From the starting node $bold(q)$, it is possible to reach the end state $bold(t)$ by either:

      + Matching nothing and taking the bottom path.
      + Matching the pattern $N(s)$ once by going straight through.
      + Matching the pattern $N(s)$ more than once by taking the top loop repeatedly.
    ],
    bimg("img/star.png")
  )
]

== Converting NFA $->$ DFA

To systematically convert a NFA to a DFA, consider all the possible starting states, including taking empty ($epsilon$) paths. For example, this node might be labeled ${1, 2, 3}$. Then, from all the states of the node, considering every possible match, and draw the corresponding arrows to the new node which contains the set of states from the NFA that match.

= Context Free Grammars and Top-Down Parsing

Context free grammars are stronger than regex, since they have the power to match certain things that regex can't. For example, one traditional example is ${a^n b^n}$. Another example might be nester statements, which regex has a very hard time handling.

There are several common points of concern in context free grammars:

/ Ambiguity: When an expression has the possibility of multiple parse trees.
/ Left-Recursion: If an expression starts with itself, it can match and loop infinitely.
/ Operator Precedence: Order of operations.

#twocol(
  bimg("img/hack.png"),
  [
    The original grammar shown to the left has the possibility of an ambiguity for an expression like $1 - 2 + 3$, since it can either parse to the left or to the right. With the fix seen in the grammar in the right, we force the expression to generate to the left, by matching the `Int` on the right side.
  ]
)

To introduce order of operations into the mix, we can split a non-terminal into *layers* of non-terminals, which allow us to define a different order of precedence, with non-terminals closer to the `Start` non-terminal being of lower precedence.

== If Ambiguity

Another common example of ambiguity arises from a grammar which contains `if` statements.

#twocol(
  [
    If we try to parse a statement such as\
    `if x then if y then z else w`\
    with the grammar to the right, then it becomes uncertain whether this is\
    `if x then {if y then z} else w`\
    or alternatively\
    `if x then {if y then {z} else w}`
  ],
  bimg("img/if.png")
)

== Left Factoring

A solution to the above problem involves left factoring. We want to factor out any common prefixes to prevent ambiguity in the parsing. This can be seen on the left image below. In addition, we can extend a similar idea to perform *precedence climbing* to enforce order of operations. Consider the example on the right where we can use this concept to force a distinction between ${"plus", "minus"}$ and ${"div", "mul"}$
 
#twocol(
  bimg("img/fixif.png", width: 100%),
  bimg("img/oo.png", width: 100%)
)

#example(
  title: "Eliminating Left-Recursion"
)[
  In order to avoid matching ourselves on the left, we should always attempt to consume some token before moving forward.
]

= High Level IR and Semantics

Symbol tables

= Unoptimized Code Generation



