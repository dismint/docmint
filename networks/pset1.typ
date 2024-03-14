#import "template.typ": *
#show: template.with(
  title: "14.15 Problem Set #1",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1
Let us the follow the convention for this problem that the first (top) row and (left) column specify the first node, and increase as they go down / right.

Since it is not explicitly stated, I will also make the assumption that there are no self-edges. This will be important in some calculations. 

== (a)
We can consider each row as conveying information about the neighbors of that specific node. Then, to find the degree of the $n$th node, it simply suffices to add all the values in the $n$th row of the adjacency matrix. Thus we can accomplish this with matrix multiplication as follows:

$ bold(d) = boxed(bold(g) times bold(1)) $

In the above equation we are multiplying a $n times n$ matrix by a $n times 1$ vector, giving us the desired $n times 1$ dimensions for the vector $bold(d)$

== (b) 
To get the total number of edges, we can take the sum of the degrees of each node, then divide by two to account for the fact that edges get double counted from both sides. Recall that the assumption has been made that there are no self-edges.

$ m = boxed(1/2 sum_(i,j) bold(g)_(i,j)) $

Alternatively we could have also notated this as $1^T dot (g times 1)$, or more simply $1^T dot bold(d)$

== (c)
Consider two rows in the $bold(g)$ matrix - by taking the dot product of binary vectors, we essentially determine how many positions both contain $1$, meaning that they have a shared edge. Thus to find the number of shared edges between two nodes $i, j$, simply take the dot product $bold(g)_i dot bold(g)_j$. Thus leads to our final formulation:

$ bold(N)_(i,j) = bold(g)_i dot bold(g)_j $

This of course, is the exact same thing as simply squaring the $bold(g)$ matrix.

$ bold(N) = boxed(bold(g) times bold(g)) $

Note that this has the consequence that the value of $bold(N)$ for a node and itself is its degree.

== (d)
Expanding off our answer from above, let us think about what happens when we further multiply by $bold(g)$, *cubing* the adjacency matrix.

Consider multiplying $bold(N)_i dot bold(g)_j$. For the $z$th element of each, we are essentially asking how many paths there are from $i$ to $z$ passing through some $x != i, z$ and then $z$ to $j$. What we really care about is the case where we loop back around and make a triangle, thus $j=i$. We should only care about the diagonal values of the resulting matrix as this is where that information lies.

Getting the answer by taking the trace would be an overestimate for a few reasons. Consider all the ways to count the triangle involving $a, b, c$

#enum(
  enum.item(1)[
    Fixing the starting point, we can run into both\
    $a arrow.r b arrow.r c arrow.r a$\
    $a arrow.r c arrow.r b arrow.r a$\
    This accounts for a doubling in the total number of counted triangles.
  ],
  enum.item(2)[
    The cycle can start from any of the three nodes, leading to a tripling in the total number of counted triangles.
  ]
)

Therefore we conclude that we must take a sixth of this final number to get the accurate number of triangles.

$ \#"Triangles" = boxed(1 / 6 "Tr"(bold(g)^3)) $

= Problem 2

== (a)
#define(
  title: "Betweenness Centrality"
)[
  Recall that we define Betweenness Centrality (*BC*) for a node as the fraction of shortest paths between two arbitrary nodes that pass through this node, averaged over all pairs.

  $ bold("BC")_k = sum_((i, j) : i != j, k != i, j) (P_k(i, j) \/ P(i, j)) / ((n-1)(n-2)) $
]

Since we are working with a tree, there are several nice simplifications that can be made.

As the graph is a tree, there is only one path between any two given nodes. Therefore $P(i, j)$ can be fixed to $1$

$ bold("BC")_k = sum_((i, j) : i != j, k != i, j) P_k(i, j) / ((n-1)(n-2)) $

With the new equation, we can now rephrase *BC* as "What fraction of paths contain $k$?". Alternatively this can also be phrased as $1 -$ "Fraction of paths that *don't* contain $k$". Let us work with this second definition, as that seems to be the rough form our desired answer takes.

For the disjoint regions, it is true that exactly one path existed in the original tree, so the path between one node in each region must have passed through $k$ previously. Conversely, it is also true that within the connected regions, $k$ did not impact the path between any two nodes since there already exists a path as the region is connected, and with exactly one path in a tree between two nodes, there cannot be an additional path passing through $k$. Therefore, it is sufficient to count the sum of pairs of nodes we can make with the restriction that both must be from the same region.

For the $m$th region, we can count the number of pairs of elements with $n_m (n_m-1)$, and we must take the total sum, leading us to:

$ sum_(m=1)^d n_m (n_m-1) $

However remember that we are taking the fraction of all paths so we end up with:

$ sum_(m=1)^d (n_m (n_m-1)) / ((n-1)(n-2)) $

And we finally remember that this is the inverse of the original desired quantity (the number of paths *including* $k$), so we must take the difference to $1$, resulting in the final form which matches the requested formula:

$ bold("BC")_k = boxed(1 - sum_(m=1)^d (n_m (n_m-1)) / ((n-1)(n-2))) $

== (b)
In a line graph, removing a node will always split the graph into at most $2$ pieces, depending on whether it is either the first / last node or one in the middle.

Let us assume that this graph contains at least two nodes and $i$ is zero-indexed. Then, the sizes of the two disjoins regions will be $i$ and $n-1-i$. Therefore the above formula can be simplified accounting for this new guarantee.


$ bold("BC")_i = boxed(1 - (i(i-1) + (n-1-i)(n-2-i)) / ((n-1)(n-2))) $

This expression can cancel the $(n-2)$ term out according to Wolfram Alpha, but I will leave the above as a sufficiently concise solution. Of course it only applies when we choose a node in the middle, as otherwise the terms can become negative. Thus if we pick the end, we instead have the simplified formula.

$ bold("BC")_i = 1 - ((n-1)(n-2)) / ((n-1)(n-2)) $

Thus, the centrality of an edge node is actually $0$, which makes sense as no shortest path in a line graph would ever pass through an edge except paths starting or ending from that edge (which are excluded from the calculation).

= Problem 3

== (a)
We want to take the sum across each degree multiplied by its chance of happening:

$ sum_i d_i dot "Chance to get" d_i $

Let us define this chance as the probability of picking an edge that connects to a node with degree $d_i$, divided by two since we need to pick the correct side of the edge. This works out nicely, even for cases where both ends of the edge are $d_i$ as the edge will get counted twice to make up for the incorrect fractional chance of picking it. 

The chance we pick an edge that connects to a node with degree $d_i$ is tricker to derive:

+ $P(d_i) dot N$ is the number of nodes with degree $d_i$
+ $P(d_i) dot N dot d$ is the number of edges which have a $d_i$ degree endpoint.
+ $(P(d_i) dot N dot d_i) \/ M$ is the fraction of edges which have a $d_i$ degree endpoint.
+ $(P(d_i) dot N dot d_i) \/ (2 dot M)$ includes the likelihood of picking the correct end of the edge.

Therefore we now have the formula:

$ sum_i (d_i^2 dot P(d_i) dot N) / (2 dot M) $

We still need to get rid of the $M, N$ terms. To do this, observe that:

$ M = 1 / 2 sum_i P(d_i) dot d_i dot N $

Therefore we can make the following substitution in our equation:

$ M / N = (sum_i P(d_i) dot d_i dot N) / 2 $

And our equation now simplifies to:

$ sum_i (d_i^2 dot P(d_i) dot N dot 2) / (sum_i (P(d_i) dot d_i dot N) dot 2) = boxed(sum_i (P(d_i) dot d_i^2) / (sum_i P(d_i) dot d_i)) $

== (b)
The expected value in *(a)* was hard to calculate since a higher degree means there is an inherent higher chance to be picked, even more so than $P(d_i)$ would seem to indicate. Let us show that $E[D] >= E[X]$

We start with the fact that variance is always non-negative and work from there. Recall that $E[X] = sum_i P(d_i) dot d_i$

$ 0 <= "Var"[X] = sigma_X^2 = sum_i P(d_i)(d - E[X])^2 = sum_i P(d_i)(d^2+E[X]^2-2 dot d dot E[X]) $

Then notice the last step can be simplified as follows:

$
&= sum_i P(d_i) dot d^2 + sum_i P(d_i) dot E[X]^2 - sum_i P(d_i) dot 2 dot d dot E[X]\
&= sum_i P(d_i) dot d^2 + E[X]^2 - 2 dot E[X]^2\
&= sum_i P(d_i) dot d^2 - E[X]^2
$

After which we take the last couple steps to complete the proof:

$
0 &<= sum_i P(d_i) dot d^2 - E[X]^2\
E[X]^2 &<= sum_i P(d_i) dot d^2\
E[X] &<= sum_i (P(d_i) dot d^2) / (E[X])\
E[X] &<= E[D]
$

Thus we arrive at our desired conclusion, with the last step being made the same as the result of *(a)*

== (c)
We can simplify and show that:

$ sum_i d_i <= sum_i delta_i $

The left side can be reformatted since the sum of degrees is equal to two times the number of edges. The right side can be reformatted following a very similar style of logic, except this time instead of counting the edge twice back and forth, we need to count the ratio of degrees both ways.

$ sum_((i, j):i < j) 2 <= sum_((i, j):i < j) (d_i / d_j + d_j / d_i) $

Now all we need to do is to show $2 <= (d_i / d_j + d_j / d_i)$. Remember that since these are degrees, all numbers are positive. Let us start from a clearly true inequality and work onward.

$
(d_i - d_j)^2 &>= 0\
d_i^2 - 2 dot d_i dot d_j + d_j^2 &>= 0\
d_i^2 + d_j^2 &>= 2 dot d_i dot d_j\
d_i / d_j + d_j / d_i &>= 2
$

Thus we have shown that the inequality is satisfied for this problem. It turns out the last part of this proof actually works even if the numbers aren't always positive after graphing it on Desmos.

== (d)
Let us see how the idea of the friendship paradox is strengthened by the previous two parts.

*(b)* tells us that the expected degree of picking a random node is less than the expected value of picking an edge then picking a node. This speaks to the inherent bias there is in having more friends. You can only view your friends, and those friends are viewed through the connection (edge). As can be clearly seen in this part, there is a much heavier bias on being picked when you have a higher degree. This part can perhaps be summarized with the sentiment that the friendship paradox doesn't mean you have less friends than the average person, rather that you have less friends than *your* friends.

*(c)* tells us that the average degree of nodes in a graph is less than the average degree of its neighbors. This reinforces the fact that on average _your friends have more friends than you do_. Of course, this doesn't say anything about the magnitude of the difference, but nonetheless it is mathematically sound that there is a feeling of having less friends than your friends.
