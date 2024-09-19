#import "template.typ": *
#show: template.with(
  title: "PSET 1",
  subtitle: "18.404",
  pset: true,
)

= Problem 1

== (a)

#twocola(
  bimg("imgs/graph.png", width: 80%),
  [
    We have five states, each representing the `mod 5` of the number we have accepted up until now. Notably the accept state and the start state are the same since we start with $0$ and can also accept the empty string as the value $0$ which is divisible by $5$
  ]
)

== (b)

It is possible to construct a DFA for $"MFIVE"_d$ for any $d >= 2$ by using the following steps:

+ All such DFAs can be constructed with $5$ states, one for each possible remainder when divided by $5$
+ The start state is the same as the accept state, since any number conceptually starts with a value of $0$ and the desired behavior is to accept numbers that are divisible by $5$, and the empty string is accepted as a value of $0$
+ Draw transitions out of each state $q$. To do this, assume that the number so far has as remainder of $q$ when divided by $5$. Then, for each possible digit $x$ in the base $d$ that we are working with, you can calculate the new remainder with

  $ delta(q, x) = (d dot q + x) mod 5 = r $

  Then draw a transition from state $q$ to state $r$ labeled with $x$. Conceptually, when we add a new digit the entire number shifts to the left, which can be thought of as as multiplication of the old number by the base $d$.
+ Repeat for all modularities and digits. It does not matter what order the transitions are drawn.

= Problem 2

To show that the class of regular languages is closed under the $N_1$ operation, I will construct a NFA that recognizes it.

Construct the NFA as follows:

+ Let $M$ be the NFA that recognizes $A$. We know this must exist since $A$ is regular.
+ Create a copy of $M$ called $M_2$. Keep all accept states for both $M$ and $M_2$ but remove the start states for $M_2$. Right now, this NFA recognizes $A$ since it is the same as $M$ and there is no way to get to $M_2$
+ For every possible transition in $M$, add a new transition of the opposite type ($1 => 0, 0 => 1$) that starts at the same state in $M$, but instead points to the corresponding destination $r$ in $M_2$ instead. This new compound NFA recognizes $N_1(A)$

What I have done is constructed a NFA that recognizes the original language, but allows the automata to jump to an alternate version when it makes a singular 'mistake'. This is the one Hamming difference that the new language allows. Because a Hamming distance of $0$ is also allowed, it is important that we keep the original accept states in $M$ as accept states in the new NFA as well as the accept states in $M_2$.

= Problem 3

Suppose that $D$ is regular. Then since regular languages are closed under the complement as shown in $1.14$ where we swapped the accept and reject states, we know that the regular language of *palindromes* is also regular.

Now let us apply the Pumping Lemma and show that $D$ cannot be regular through a proof by contradiction.

#example(title: "Pumping Lemma")[
  + Let $p$ be the pumping length.
  + Consider the palindrome $0^p 1 0^p$
  + Since $|x y| <= p$ it must be the case that $y$ contains all $0$s
  + Pumping $y$ will result in a string that is not a palindrome, since the central $1$ will be surrounded by a greater number of $0$s on the left side.

  Therefore, it cannot be the case that the regular language of palindromes is regular.
]

Because the regular language of palindromes is not regular, we have a contradiction. Therefore, $D$ cannot be regular.

= Problem 4

== (a)

The language that $"TUT"$ accepts can actually easily be represented by the regular expression $Sigma^*$. This occurs because $t, u in Sigma^*$, meaning that *any* string can be accepted by the language $"TUT"$ since we can set $t = epsilon$ and set $u$ to the entire string itself.

Thus, since we can find a regular expression for the language, it must be the case that the language $"TUT"$ is regular.

== (b)

To show that the language $"TUTU"$ is not regular, use the Pumping Lemma.

#example(title: "Pumping Lemma")[
  + Let $p$ be the pumping length.
  + Consider the string $0^p 1^p 0^p 1^p$
  + Since $|x y| <= p$ it must be the case that $y$ contains all $0$s.
  + In the language $"TUTU"$, the right half and left half of the string must be the same ($t u$). It is also true that the corresponding halves of each half must also be the same, but that is not essential to this proof.
  + Pumping $y$ will result in a string that is not in the language $"TUTU"$, since the right half will always contain more $1$s than the left half because the pumped $0$s will push the rightmost $1$s on the left half to the right half, or will cause an odd length which cannot be in the language.

  Therefore, it cannot be the case that the language $"TUTU"$ is regular.
]
