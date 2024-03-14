#import "template.typ": *
#show: template.with(
  title: "Lecture 3",
  subtitle: "14.15"
)

= Eigenvector Centrality

In addition to the definitions of importance we got in the previous lectures for nodes in a graph, we will not introduce the new notion of *eigenvector centrality*.

#define(
  title: "Eigenvector Centrality"
)[
  A non-zero vector $c_i$ such that for the $i$th node and some scalar $lambda > 0$:

  $ lambda c_i = sum_(j != i) g_(j i)c_j $

  More simply, this means that the centrality of a node is proportional to the sum of the centrality of its neighbors.
]

The fact that this definition contains $g_(j i)$ instead of $g_(i j)$ is an important fact for directed graphs.

In general, centrality is also normalized so that the sum over all nodes is 1.

#example(
  title: "Eigenvector Centrality"
)[
  $
  g = mat(delim: "[",
    0, 1, 1;
    1, 0, 1;
    0, 0, 0;
  )
  $
  
  The eigenvector centrality is then then solution to the following set of equations:

  $
  lambda c_1 &= c_2\
  lambda c_2 &= c_1\
  lambda c_3 &= c_1 + c_2\
  c_1 + c_2 + c_3 &= 1
  $

  Solving the system yields

  $ lambda = 1, c_1 = c_2 = 1 / 4, c_3 = 1 / 2 $
]

It's not super clear when this measure of centrality exists, and if it does, whether it is unique or has multiple solutions.

For strongly connected graphs, eigenvector centrality is well-defined. In fact, we can write it as simply as:

$ lambda c = g'c $

Recall that we can solve for the eigenvalues of a matrix with the following equation:

$ |g - lambda bold(I)| = 0 $

#define(
  title: "Perron-Frobenius Theorem"
)[
  For every irreducible non-negative matrix, its largest eigenvalue is positive, and the corresponding eigenvector has all positive components.
]

= Katz-Bonacich

Obviously there are problems that arise when the entire graph is not strongly connected. In fact, the only nodes that will have a positive eigenvector centrality in an arbitrary directed graph are those who are either part of a strongly connected component, or lie in out-component of a SCC. All other nodes have an eigenvector centrality of 0.

To fix this, we introduce Katz-Bonacich Centrality, which works by giving each nodes some amount of centrality $beta$ for free.

#define(
  title: "Katz-Bonacich Centrality"
)[
  $ c_i = 1 / lambda sum_(j != i) g_(j i)c_j + beta $

  Solving this equation and simplifying yields the following form:

  $ c = beta (bold(I) - 1 / lambda g')^(-1) bold(1) $

  Where $bold(I)$ is the $n times n$ identity matrix and $bold(1)$ is a $n times 1$ vector of 1's. One last simplification is to write $1 / lambda$ as $alpha$, also called the decay parameter.

  $ c = beta (bold(I) - alpha g')^(-1) bold(1) $
]

The choice of $beta$ simply scales $c$, so we generally take $beta = 1$ for Katz-Bonacich centrality. This is *not* the same normalization as discussed before.

This definition of centrality only holds when $(bold(I) - alpha g')$ is invertible. This holds if and only if $alpha < lambda_1$

#define(
  title: "Leontief Inverse"
)[
  The term $(bold(I) - alpha g)^(-1)$, which appears in the definition of Katz-Bonacich is known as the Leontief inverse of $g$ with parameter $alpha$, and is notated with $Lambda$.

We can interpret some $Lambda_(i j)$ as the sum over all length $l$ paths from $i$ to $j$, with the value of a walk being the product of the weighs on the graph, discounted by $alpha^l$. Thus the longer the path, the less it is valued in the final weighting.
]

= PageRank

PageRank is the algorithm that Google uses to rank their websites. It is similar to Katz-Bonacich, except it attempts to remove the scenario where an obscure website linked by a popular website is considered popular as well (which is the case in Katz-Bonacich).

#define(
  title: "PageRank"
)[
  $ c_i = alpha sum_(i != j) g_(j i) / d_j^"out"c_j + 1 $

  We can see that the definition is very similar to Katz-Bonacich, except the free $beta$ is set to 1, and the value is normalized by $d_j^"out"$, the out-degree. If the out-degree is 0, then this value is 1.

  In matrix form we get the following:

  $ c = alpha g' D^(-1) c + bold(1) $

  Where $D$ is a diagonal matrix with $D_(i i) = "max"(d_i^"out", 1)$. Solving this matrix equation yields:

  $ c = (bold(I) - alpha g' D^(-1))^(-1) bold(1) $
]

Importantly, the value of $alpha$ controls how much weight is placed on an indirect link. In practice, Google sets this to be $alpha = 0.85$

