#import "template.typ": *
#show: template.with(
  title: "14.15 PSET 4",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (a)

To solve, let us find the number of total possible triangles, then multiply by the probability that any given one exists. The number of triangles can be enumerated as:

$ (n (n+1) (n+2)) / 6 = binom(n, 3) $

Then for any given triangle, the chance that it exists is contingent on all three edges being present, which has a $p(n)^3 = lambda^3 / n^3$ chance. Therefore our answer comes out to:

$ lim_(n -> infinity) [(n (n+1) (n+2)) / 6 dot lambda^3 / n^3] = boxed(1 / 6 lambda^3) $

== (b)

This result might seem odd as an increase in nodes would surely indicate an increase in the number of triangles. However, the interaction that causes this irrelevance of $n$ is the balancing of the increasing in nodes and the decreasing in the chance for a triangle. The number of *potential* triangles scales by $n^3$, but the chance for any triangle to exist scales down by $lambda^3 / n^3$. Thus to the two work against each other, and the end result becomes completely independent of $n$ for large $n$

== (c)

Similar to *(a)*, the number of triangles is:

$ (n (n+1) (n+2)) / 6 = binom(n, 3) $

However, the conditions are looser in this case, as we only require two out of the three edges. We can think of one edge as being irrelevant, of which there are three possible orientations. This leaves us with the probability for a given triple existing as $3 dot p(n)^2 = 3 dot lambda^2 / n^2$

$ lim_(n -> infinity) [(n (n+1) (n+2)) / 6 dot 3 dot lambda^2 / n^2] = boxed(1 / 2 n lambda^2) $

This of course, is an approximation since we count the triangle case too many times, leading to an overestimate.

== (d)

We compute this quantity as the number of triangles over the number of triples. This translates directly into the problem statement, which is asking for the chance that a triple is actually a triangle.

$ 1 / 6 lambda^3 slash 1 / 2 n lambda^2 = (2 lambda^3) / (6 n lambda^2) = boxed(lambda / (3 n)) $

= Problem 2



= Problem 3

== (a)

Recall from lecture that we were given:

$ lambda = - ln(1-q) / q $

Thus we want to find $lambda$ for $q = 1 / 2$. This evaluates to around:
$ -2 dot ln(1 / 2) = boxed(1.386)$

== (b)

The Poisson random variable can be used here:

$
PP(d) &= (e^(-lambda) lambda^d) / d!\
PP(5) &= (e^(-1.386) 1.386^5) / 5!\
PP(5) &= boxed(1.06 dot 10^(-2))
$

== (c)

We already know that $Pr(d_i = 5)$ from the previous part, as well as the fact that $Pr(i "in giant component")$ is equal to $1 / 2$ from the exposition to this question. The only remaining quantity that we must calculate is the conditional.

Let us approximate this by saying the chance a node with degree $5$ is not in the giant component is dependent on none of its neighbors being in the component. Thus there is a $1 - (1 / 2)^5 = 31 / 32$ chance this node is in the giant component.

With this in mind, the fraction of nodes in the giant component that have degree $5$ can be approximated as:

$ (1.06 dot 10^(-2) dot 31 / 32) / (1 / 2) = boxed(2.07 dot 10^(-2)) $

== (d)

One might expect the giant component to look demographically like the rest of the graph when it comes to its degrees. However, the critical observation to make here is that the degree of a graph directly impacts the likelihood that a node is in the giant component.

As shown in the calculations for *(c)*, it is far more likely for a node with a higher degree to be a part of the giant component, as it has more linkages, and therefore more chances to be roped into the giant component. This is the reason for the difference in values between *(b)* and *(c)* - the demographic makeup of the giant component will skew towards the higher degree nodes compared to the original graph.

= Problem 4

== (a)

Expanding the sum we get:

$ sum_(d = 0)^infinity 2^(-(d + 1)) = 1 / 2 + 1 / 4 + ... $

This is an infinite geometric series with a starting value of $1 / 2$ and a common ratio of $1 / 2$, meaning the sum converges to $(1 / 2) / (1 - 1 / 2) = 1$

== (b)

To solve for the average node degree, we can take the sum from earlier, and multiply the inside probability by the degree:

$ sum_(d = 0)^infinity d dot 2^(-(d + 1)) = 0 + 1 / 4 + 2 / 8 + 3 / 16 + ... $

Let us call this series $S$. Now consider what $S - S / 2$ looks like:

$ S - S / 2 = 0 + 1 / 4 + 1 / 8 + 1 / 16 $

The right side of the equation is easy to calculate as it's another geometric sum. This time, it evaluates to $(1 / 4) / (1 - 1 / 2) = 1 / 2$. Therefore we have the expected value as:

$
S - S / 2 &= 0 + 1 / 4 + 1 / 8 + 1 / 16\
S / 2 &= 1 / 2\
S &= boxed(1)
$

Thus our average degree on a node is equal to *1*

== (c)

We saw from lecture that the expected number of distance-2 neighbors from any starting node is equal to:

$ angle.l d^2 angle.r - angle.l d angle.r $

Using a similar process from above, we can calculate the mean squared degree $angle.l d^2 angle.r$ to be 3. Thus we expect that there are *2* distance-2 neighbors from any starting node.

== (d)

A giant component exists if and only if:

$ (angle.l d^2 angle.r) / (angle.l d angle.r) >= 2 $

Using the values from above, we can see that this inequality holds, as the fraction evaluates to 3. Therefore, it *is* the case that this network has a giant component.


