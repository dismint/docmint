#import "template.typ": *
#show: template.with(
  title: "Lecture 6-7",
  subtitle: "14.15"
)

= Random Graphs

A reason to study random graphs is the idea that once we go beyond a couple nodes, it is often times not very meaningful or feasible to analyze the exact structure of a network. However, taking the entire graph as a whole, random graph studies make it very possible to better understand large graphs and trends within them.

= Erdos-Renyi (ER) Random Grpahs

#define(
  title: "Erdos-Renyi"
)[
  The Erdor-Renyi model simply studies a graph with $n$ nodes, where each possible undirected edge forms with *independent* probability $p$
]

#define(
  title: "Bernoulli Random Variable"
)[
  A random variable that either takes on the value $1$ with probability $p$, or $0$ with probability $1-p$ 
]

The expected number of links is equal to:

$ EE[sum_(i != j) I_(i j)] = [(n (n + 1)) / 2]p $

Where $I$ is the Bernoulli random variable. As the graph gets larger and larger, the number of edges, although random, becomes very tightly centered around its mean (the expected value).

The mean degree of an ER graph is $(n-1) p approx n p = lambda$. The graph density is then $lambda / (n-1) = p$

Usually, we will fix $lambda$ in ER graphs. We can think of this as people have a similar number of Facebook friends, regardless of whether they live in a small or large country.

#define(
  title: "Poisson Limit Theorem"
)[
  As $n -> infinity$, the distribution of degrees, $D$, converges to a Poisson random variable:

  $ PP(D = d) = (e^(-lambda) lambda^d) / (d !) $

  This degree distribution falls off *faster* than exponential.
]

Interestingly, think about what happens when we consider how many other friends a friend of ours has, not including us. This amount is simply $1 + (n - 2) p$. Over the long run, this simply converges to $1 + lambda$ - another example of the friendship paradox.


The branching approximation previously mentioned is very good in this type of scenario, since the graph ends up being rather sparse. Under this assumption in a tree-like structure, the average path length and diameter of the graph ends up being $"log"(n) slash "log"(lambda)$

#define(
  title: "Threshold Function"
)[
  If both of the following are true, then we have a threshold function:

  $ PP(A) -> 0 "if" lim_(n -> infinity) p(n) / t(n) = 0 $
  $ PP(A) -> 1 "if" lim_(n -> infinity) p(n) / t(n) = infinity $

  Where:

  - $p(n)$ is a function for $p$
  - $t(n)$ is the threshold function.
  - $A$ is the property that we desire to track.

  The point of the threshold is called a *phase transition*.
]

#example(
  title: "Phase Transition: Edges"
)[
  $ A = {"number of edges" > 0} $

  The claim is that the function $t(n) = 1 / n^2$ is a threshold function for this property of having at least one edge.

  Thus we need to show that:

  + If $n^2 p(n) -> 0$ then $PP(A) -> 0$
  + If $n^2 p(n) -> infinity$ then $PP(A) -> 1$

  We can notice that the expected number of edges is roughly $n^2 / 2 p$, which gives us a good intuition to prove this.
]

It's actually more likely that we see a tree of arbitrary size than a cycle. This is because a cycle must choose an already visited node, while a tree has the opposite, much easier restriction at the beginning. This leads to the intuition that the threshold for a cycle emerging is the same as seeing a *giant component*.

#define(
  title: "Giant Component"
)[
  A component with a positive fraction of all the nodes in the network.
]



