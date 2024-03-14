#import "template.typ": *
#show: template.with(
  title: "14.15 PSET 3",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

#define(
  title: "Aperiodic Conditions"
)[
  One important condition that renders a matrix $A$ automatically aperiodic, is if there exists for some $i$, a value $A_(i i) > 0$. This automatically means that $A$ will converge as we take higher and higher powers.
]

== (a)

The matrix is aperiodic, meaning that the limit is well defined. The reason that we know it is aperiodic is because we can see that there are multiple $T_(i i)$ entries that are greater than 0. There only needs to be one such entry for the matrix to be aperiodic. Thus, we can compute $s$ as the eigenvector of $T'$

$ mat(5 / 9; 8 / 9; 1;) $

However we need to normalize, so thus we divide by $5 / 9 + 8 / 9 + 1 = 22 / 9$ 

$ mat(5 / 22; 8 / 22; 9 / 22;) $

Therefore we can compute $x*$ as:

$ x^* = mat(5 / 22, 8 / 22, 9 / 22) mat(x_1(0); dots.v; x_N(0)) = mat(5 / 22, 8 / 22, 9 / 22) times x(0) $

All values are of course, the same once the values converge.

== (b)

Similar to above, the limit exists as all $T_(i i) > 0$. We can see that the top left and bottom right $3 times 3$ values are mostly filled while the top right and bottom left quadrants are completely zeroed out. This indicates to us that there are two connected components. One with agents $[1, 2, 3]$, and another with $[4, 5, 6]$.

Therefore we expect two different values of convergence, with the first group of $[1, 2, 3]$ converging to the same value and $[4, 5, 6]$ converging to another different value. In essence, we can think of this as running the DeGroot model on two distinct graphs of size $N=3$

== (c)

Once again remember the property mentioned at the start of this problem. Since agent $i$ places weight $1$ on themselves, then the DeGroot learning model will end up converging over time. In addition, since the sum of weights for an agent is equal to $1$, it must be the case that agent $i$ never changes from their initial opinion $x_i (0)$ since they don't take influence from anyone else.

However, this is not enough to show that everyone else also converges to this same value, since it can be the case where a graph converges under the DeGroot learning model, but not to the same value unless it is strongly connected. We have no such guarantee in this graph, but there is an even easier way to show all agents will eventually each $x_i (0)$

Since it is given that for all $j != i$, it is the case that $A_(j i) > 0$, this lets us see that every other agent takes some amount of influence from $i$. Thus along with the previous observation, we can make the following steps:

+ The graph converges under the DeGroot learning model.
+ The value of $i$ never changes, that is it always values itself and nothing else for all of time.
+ Every other agent values $i$ some amount.
+ If agent $j$ has a different opinion than $i$, it will change in the next time period since it values $i$ some amount.
+ The graph converges, meaning all values stabilize.
+ Since all agents take influence from $i$, they must all stabilize to $x_i (0)$, or else the value would be continuously changing and the matrix would be periodic.

= Problem 2

#note(
  title: "Notation"
)[
  While I am consistent throughout this question with $i$ and $j$, the notation is mostly backwards from the question statement.
]

Let us start the proof for this problem by showing why it is true the $j$th column of $T^(t)$ is all zero if for any previous $t' < t$, it is true that the $j$th column of $T^(t')$ was all zeros.

If we view $T$ as an adjacency matrix, recall that $T^t$ conveys information about paths of length $t$ in the graph. Although traditionally the weights are binary, we can generalize to this problem by saying there is a length $t$ path between $i$ and $j$ as long as $T^t_(i j) > 0$

Now suppose there is some $t$ for which the $j$th column in $T^t$ is all zeros. This means that there is no path from any node $i$ to $j$ of length $t$. Then, this also implies that there are no paths of length $t+1$ to $j$, as that would require at least one node having a path length $t$ to $j$. Therefore, there are also no paths of length $t+2, t+3, dots$ to $j$

We can now conclude that if at some point the $j$th column of $T^(t)$ is all zeros, then for any future $t' > t$, $T^(t')$ also has the $j$th column filled with zeros.

Thus in context of the original question, this means that the $j$th agent is uninvolved in the final opinions of any agent. However, this does not mean they are uninfluenced by the others - an observation whose consequences we will see shortly.

It is then the case that the rest of the DeGroot model develops independently when taking the limit, and it must be true that given $x$ and $accent(x ,hat)$ are the same except the $j$th entry, then the limit will result in the exact same value for both as well. Recall that we are given that both limits exist.

However, we still need to show the $j$th entry will be the same for both. Why can it not be the case for example, that $x_j$ and $accent(x, hat)_j$ are different values, since the rest of the graph does not get impacted by them? 

The reason stems from the fact that this is a relation under the DeGroot model, which guarantees us that the matrix $T$ is row-stochastic. Therefore, agent $j$ must place some value on someone else. Agent $j$ *can't* place a weight of $1$ on themselves, because this would mean that $T_(j j)$ could never be $0$, which we know to be true from the premise of the question. It must then be the case that they take influence from some other nodes, and their value is not independent of the rest of the graph.

In short, the values of $x_j$ nd $accent(x, hat)_j$ are completely independent of $x_j (0)$ and $accent(x, hat)_j (0)$, and instead rely on the rest of the agents, for which we know the starting values are exactly the same. We can now say that these values will also converge under these conditions.

Thus we conclude that the limits are the same under the given conditions, despite the potential starting values of $x_j (0)$ and $accent(x, hat)_j (0)$ differing.
