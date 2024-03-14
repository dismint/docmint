#import "template.typ": *
#show: template.with(
  title: "Lecture 5",
  subtitle: "14.15"
)

= Title

#define(
  title: "Social Learning"
)[
  How do people learn from others, and what are the ultimate implications for society's beliefs, opinions, and behaviors?
]

The basic idea behind the DeGroot learning model is that in each time period, an agent's beliefs will be updated by a weighted average of their own opinion as well as their neighbors, controlled by fixed weights that are time-invariant. Therefore with the initial list of opinions and the matrix of weights, we will be able to determine the long term dynamics of the group.

In the updating matrix $bold(A)$, $bold(A)_(i j)$ represents how much agent $i$ trusts agent $j$. $bold(A)$ is a *row-stochastic* matrix, meaning that the sum of the weights for each node is equal to 1. Each agent's _initial_ belief $x_i$ is somewhere in $[0, 1]$. Therefore, on each time step, their opinion is updated as follows:

$ x_i (t + 1) = sum_(j=1)^n bold(A)_(i j) x_j (t) $

In matrix notation, this is:

$ x(t) = bold(A) x (t - 1) $

More generally for any time period $t$ we have:

$ x(t) = bold(A)^t x (0) $

#define(
  title: "Periodic Matrices"
)[
  A matrix is *periodic* if the powers of the matrix cycle without converging.
]

As can be seen with the formula, the graph of opinions will not converge if the matrix is periodic. On the other hand, it does if $bold(A)$ is *aperiodic*.

A matrix is aperiodic if the GCD of all directed cycle lengths are coprime to each other. Another simple conditions that makes $bold(A)$ aperiodic is if there exists any $i$ such that $bold(A)_(i i) > 0$

If the matrix is not strongly connected, opinions may not converge to the same thing. If the matrix is strongly connected however, then it must be the case that everyone's long term converged opinion is the same.

#define(
  title: "Long-Run Consensus Theorem"
)[
  Given a directed matrix $bold(A)$, if the network is strongly connected and aperiodic, then $"lim"_(t -> infinity) bold(A)^t = bold(A)^*$ exists. The matrix $bold(A)$ should have rows that are all exactly the same, resulting in the final belief matrix for each agent resulting in a consensus.
]

Each agents weight in the final consensus is the value of their weight in any $i$th column of $bold(A)^*$. This is called the *long-run influence*.

The list of long-run influences for each person is simply the unit eigenvector of $bold(A)^T$. This interestingly means that each agent's long-run influence is their eigenvector centrality!
