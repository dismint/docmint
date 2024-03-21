#import "template.typ": *
#show: template.with(
  title: "Quiz 1 Notes", subtitle: "14.15")

  #set heading(numbering: "1.1")

  = Introduction

  This study guide will be based on the important equations given in class, and
  will step through each of them one at a time. Any miscellaneous information
  will be shown at the end of the notes.

  = Clustering

  Clustering measure the extent to which my friends are friends with each
  other.

  == Individual Clustering

  $ "Cl"_i(G) = (|(j, k) in N_i (G)^2 | (j, k) in E|) / (|(j, k) in N_i (G)^2 |
  j != k|) $

  In the above formula, $N_i (G)$ represents the neighbors of node $i$ in a
  graph $G$ with edges $E$

  The numerator can be interpreted as the number of triangles involving $i$,
  while the denominator is the number of potential triangles centered at $i$. A
  triangle is "potential" if $(i, j), (i, k) in E$, but not necessarily $(j, k)
  in E$. Conceptually this leads to this formula representing the chance that
  two of $i$s neighbors are also neighbors.

  == Overall Clustering

  The formula remains almost identical to the individual clustering algorithm
  above, however one notable change is that the numerator and denominator are
  both summed up across all possible nodes. This leads to the simpler formula:

$ "Cl"(G) = (3 dot "Triangles") / ("Connected Triples") $

= Centrality

== Betweenness Centrality

$ C_i^B (G) = binom(n - 1, 2)^(-1) sum_({k, j} in binom(V, 2) : i in.not {k, j}) (P_i (k, j)) / P(k, j) $

In the above notation, $P$ represents the shortest path and $P_i$ represents the shortest path including $i$. For the purposes of summation, $0 / 0 = 0$. This value can be taken as the average over all vertices, the proportion of shortest paths which pass through that given vertex.

== Eigenvector Centrality

#define(
  title: "Eigenvectors and Eigenvalues"
)[
  An eigenvalue $lambda$ for a matrix is a vector which satisfies the equation $|g - lambda bold(I)| = 0$

  An eigenvector $v$ with respect to an eigenvector is a scalar which satisfies the equation $g v = lambda v$
]

The eigenvector centrality of a node is equal to the sum of the values for its neighbors, and is usually normalized so the total sum is $1$. For strongly connected graphs, this measure will always exist, and is defined by:

$ g'C^e (G) = lambda C^e (G) $

Where $lambda$ is the largest eigenvalue of the adjacency matrix $A$. Because of what the Perron-Frobenius theorem says about irreducible non-negative matrices, the largest eigenvalue will always be positive, and its associated eigenvector will have all positive values as well.

#define(
  title: "DeGroot Learning Model"
)[
  In the DeGroot social learning model with matrix $T$, the eigenvector centrality of the transpose is equal to the long run influence vector $s$
]

== Katz-Bonacich Centrality

The centrality described above is not as well defined for nodes who are not part of an SCC nor an out-component of an SCC. Thus we solve this problem by giving each node some amount of centrality $beta$ for free. The final simplest form of this equation is listed below.

$ c = beta (I - alpha A^T)^(-1) bold(1) $

Where $alpha = 1 / lambda$, also known as the decay parameter. $beta$ is usually standardized so that it takes on the value of $beta = 1$

== PageRank

PageRank attempts to solve one of the core issues of Katz-Bonacich, which is that a unpopular page linked to by a very popular page is given too much importance compared to what it actually should be. 

$ c = (I - alpha A^T D^(-1))^(-1) bold(1) $

Where $D$ is the diagonal matrix whose $i$th entry is $max{d_i^("out"), 1}$

== Leontief Inverse

The Leontief inverse is part of both of the above equations, and represents:

$ Lambda = (I - alpha A)^(-1) $

We can $Lambda_(i j)$ as the sum over all length $l$ paths from $i$ to $j$, with the value of the walk being discounted by a factor of $alpha^l$. Therefore, the longer the path is, the less it counts towards the overall evaluation. We can express this intuition in a more formal sense by writing:

$ Lambda = bold(1) + alpha g bold(1) + alpha^2 g^2 bold(1) + dots $

= Random Graph Models

== Erdos-Renyi

Refers to the random graph model where each possible edge forms with independent probability $p$

The threshold at which a giant component (a connected component with more than half the nodes) appears in the graph is $p(n) = 1 / n$. The threshold at which the entire graph becomes connected is $p(n) = log(n) / n$. The expected fraction $q$ of nodes in the giant component is given by the following, assuming that $p = lambda / n$

$ q approx 1 - e^(-lambda q) $

The fraction of people who get sick in the SIR model is equal to the size of the giant component in this model where $lambda = R_0$. The assumption is that one of the initial people who are infected will eventually be a part of the giant component.

== Reproduction Number

$ EE[d^2] / EE[d] - 1 = (angle.l d^2 angle.r) / (angle.l d angle.r) - 1 $

This quantity represents the expected number of neighbors your neighbor has, other than you. A giant component only exists if this value is at least $1$

The *conditional mean degree* is equal to the left term, which is the expected degree of a node when we pick an edge uniformly at random, then pick one of its two constituent nodes uniformly at random. In the Erdos-Renyi model, the reproduction number is equal to $lambda$

= Diffusion Models

We refer to states of individuals as susceptible (*S*), infected (*I*), or recovered (*R*). The recovered state means that they person can no longer become infected, either because they have an immunity or because they have died.

== SI

#define(
  title: "Bass Model"
)[
  Define $p$ to be the innovation rate and $q$ to be the imitation rate. The total fraction of the population that have adopted the technology at time $t$ is given by $F(t)$. The model is then defined by:

  $ F(t + 1) - F(t) = (1 - F(t))(p + q F(t)) $

  This can be interpreted as, the difference between two timesteps is equal to the fraction people who have not yet adopted the invention, multiplied by the sum of

  + Those who adopt it by themselves (innovation)
  + Those who meet an adopter (imitator)
]

The SI model is a particular example of this case, where we have $p = 0$ since you can only get sick if you come into contact with someone else who is sick.

The sum of $p + q$ shapes how fast the innovation will diffuse, while the ration $q / p$ determines what the shape of the adoption curve looks like. If $p > q$ then the adoption curve is *concave*, otherwise it is *shaped* 

== SIR

The SIR model has two parameters:

- The transmission rate $beta$
- The recovery rate $gamma$

Thus the equation for the update of the infected population looks like:

$ I(t) = beta S(t) I(t) - gamma I(t) $

The basic reproduction number is $beta / gamma = R_0$

SIR defines the threshold for herd immunity of a homogeneous-agent SIR to be

$ S(t) = 1 / R_0 $

$R_0 (angle.l d^2 angle.r) / (angle.l d angle.r) < 1$ means that the infection cannot rise in a heterogeneous society. The opposite is also true if it is greater than $1$

== SIS

Susceptible-Infected-Susceptible (SIS) defines the steady-state infection level in a homogeneous-agent SIS mode to be:

$ I = cases(1 - 1 / R_0 "if" R_0 gt.eq 1, 0 "if" R_0 lt 1) $


