#import "template.typ": *
#show: template.with(
  title: "PSET 6",
  subtitle: "18.404",
  pset: true,
  toc: false,
)

#set math.vec(delim: "[")

= Problem 1

== (a)

To show that $E_"CFG" in P$, we can use the following algorithm:

+ Use the context free grammar $G$
+ Mark all terminals as reachable
+ Mark new non-terminals as reachable if they have a production with all reachable symbols
+ Repeat until no new non-terminals are marked as reachable
+ If $S$ is marked not marked as reachable, then $E_"CFG" = emptyset$

We can imagine for this algorithm, that we build a graph representing the CFG. This would take polynomial time at worst to make all edges for all $O(n)$ nodes on the graph (terminals and non-terminals), with edges pointing in the "opposite" direction. Then we can use any multi-source graph searching algorithm from the terminal nodes to enact this exact procedure.

Thus this graph search will run in polynomial time, and since all steps run in polynomial time, then the entire algorithm runs in polynomial time and thus $E_"CFG" in P$

== (b)

Let us assume that $E_"CFG" in L$. Then if we can reduce $"PATH"$ to $E_"CFG"$, then we can show that $L = N L$ since $"PATH"$ is NL-complete, and thus all other NL problems can be reduced to be in $L$

To do this, we can use the following algorithm to reduce $"PATH"$ to $E_"CFG"$:

+ For all vertices $V$ in the graph, create a matching variable $V$ in the CFG
+ For all edges $(V, U)$ in the graph, create a matching production $V -> U$ in the CFG
+ The start symbol $S$ is the $V$ of the start vertex.
+ Allow one additional rule $V_"TERM" -> epsilon$, mapping the target vertex to a terminal, to allow for the end of a path.
+ Run this new CFG on the decider for $E_"CFG"$, and if it is false (i.e. the CFG is not empty), then the path exists, since it produces the $epsilon$ terminal. If it is true, then the path does not exist.

Let us show the space complexity of this approach. We iterate through all vertices and edges, which we can represent in logarithmic space (we can think about referring to the numerical id of a vertex or edge in the graph). We then for each of these iterations, output a new non-terminal or terminal, which we can also represent in logarithmic space, but do not need to save anyway, and can just be written on the output tape. The last $epsilon$ terminal can be represented in logarithmic space as well. Thus the space complexity of this algorithm is logarithmic in the transformation of $"PATH"$ to $E_"CFG"$

Thus, since the transformation is in $L$, we can say that $E_"CFG"$ is NL-complete, and thus since $E_"CFG"$ is in $L$, then $L = N L$. This is a good indication that perhaps $E_"CFG"$ is not in $L$

#pagebreak()

= Problem 2

To show that $E Q_"BP"$ is coNP-complete, we will reduce another well known coNP-complete problem, $overline("3-SAT")$, to $E Q_"BP"$. Note that $E Q_"BP"$ is in coNP, since we can test whether the inverse, that there exists some difference, in nondeterministic polynomial time by guessing the difference and checking if it is valid. $overline("3-SAT")$ is similarly trivially in coNP, and is also coNP-complete as we have shown in class.

To reduce $overline("3-SAT")$ to $E Q_"BP"$, we can use the following algorithm:

+ Create branching program $B$
+ For every clause $(x or y or z)$, create three query nodes $x, y, z$, as well as an additional node called $D$
  + $x$ branches to $D$ if $x$ is true, otherwise it branches to $y$
  + $y$ branches to $D$ if $y$ is true, otherwise it branches to $z$
  + $z$ branches to $D$ if $z$ is true, otherwise it branches to a terminal node $0$ (false)
+ Connect this subpart from the step before to the already existing branching program. If it is the first clause, there is nothing to do, otherwise connect it to the $D$ node of the previous clause. The $D$ node will have all branches connect to the $x$ node of the next clause.
+ Repeat for all clauses, and at the very end connect the $D$ node of the last clause to a terminal node $1$ (true)
+ This will be one half of the equality problem. The other half is to create a trivial branching program that always returns false
+ Run $E Q_"BP"$ on this branching program and $B$, and if it is true, then it means that we cannot satisfy the $"3-SAT"$ problem, and thus $overline("3-SAT")$ is true. If it is false, then it means that we can satisfy the $"3-SAT"$ problem, and thus $overline("3-SAT")$ is false

Note that in the construction above, $x, y, z$ might refer to different variables depending on the clause, but if the same variable does come up in multiple clauses, then the query should be for that same variable.

This reduction works trivially both ways, as it is just a transformation of the boolean algorithm. Since we look at all the variables in the original boolean formula, and create a constant number of props for each, the overall reduction is done in polynomial time. Thus since we can find this reduction in polynomial time, we can say that $E Q_"BP"$ is coNP-complete.

#pagebreak()

= Problem 3

To solve this problem, I will construct a reduction from the $"HAMPATH"$ problem to the $"SAT"$ problem. To accomplish this, let us use the following algorithm:

+ Given a graph $G$ defined by $V, E, s, t$ for the $"HAMPATH"$ problem:
+ Create variables $x_(i,j)$ for all $1 <= i,j <= |V|$
  - $i$ will represent the vertex
  - $j$ will represent the position in the solution path
+ For a given $i$, to constrain each vertex to exactly one appearance in the path, we can add the following clauses. The first makes sure at least the vertex is at one location in the path, and the second ensures that it is never in more than one.
  - $x_(i,1) or x_(i,2) or ... or x_(i,|V|)$
  - $overline(x_(i,j)) or overline(x_(i,k))$ for all $1 <= j,k <= |V|, j != k$
+ For a given $j$, to constrain each position to exactly one appearance in the path, we can add the following clauses. The first makes sure at least one vertex is at this location in the path, and the second ensures that there is no more than one vertex at this location.
  - $x_(1,j) or x_(2,j) or ... or x_(|V|,j)$
  - $overline(x_(i,j)) or overline(x_(k,j))$ for all $1 <= i,k <= |V|, i != k$
+ Ensure that all edges in the graph are the only valid connections between adjacent path positions. To accomplish this, consider all pairs $(i, j)$ that are *NOT* in the edge set $E$, and add the following clauses:
  - $overline(x_(i,j)) or overline(x_(k,j+1))$ for all $1 <= j <= |V| - 1$
+ Ensure that we start and end at the correct place:
  - $x_(s,1)$
  - $x_(t,|V|)$

First, let us consider how much time this mapping takes to create. Step 2 looks at a $|V|^2$ vertices, and creates a respective variable for each one. Step 3 looks at $|V|$ vertices, and adds a clause that contains $|V|$ variables (since the path length should be the same as the number of variables), and also creates a clause with two variables for each pair of $|V|$, thus this step comes out to $O(|V|^2)$ as well. Step 4 looks at $|E|$ edges with the exact same formulation as above for a total of $O(|E|)^2$ time. Step 5 looks at all pairs of vertices and creates a clause with two variables for each, meaning this step also happens in $O(|V|^2)$ time. Thus the total time complexity of this algorithm is $O(|V|^2 + |E|^2)$, which is polynomial time.

As for the correctness, we can see that if there is a Hamiltonian path in the graph, then the path will satisfy all the clauses, and thus the SAT problem will be true. If there is no Hamiltonian path, then the SAT problem will be false. Thus we can see that the reduction is correct. The reverse is also true as well, so the relation holds both ways.

We however need one more step, as we can only reduce to a version of the problem that tells us whether some path exists. To find the specific path, we can use the following algorithm:

+ Iterate through all edges in $G$
+ Try removing it from the graph and run the reduction with the oracle
+ If the oracle returns true, then we know that the edge is not part of the Hamiltonian path, and we can remove it from the graph
+ If the oracle returns false, then we know that the edge is part of the Hamiltonian path, and we should keep it in the graph

We continue in this way until we are left with $|V|-1$ edges, which is a Hamiltonian path. Thus we have created the polynomial time machine $M^"SAT"$ that solves the $"HAMPATH"$ problem given a $"SAT"$ oracle.

#pagebreak()

= Problem 4

== (a)

Suppose we have some member we wish to test for membership $A$. Then it must be the case that there exists CFLs $B, C$ such that $A = B sect C$. We know from lecture that CFLs are in $P$, and as such we can test for membership in polynomial time by simulating $B$ and $C$ in order, and checking to see if both accept. Thus we can say that IFCL is also in $P$ as well.

== (b)

We can use the hierarchy theorem to show that $P$ contains some language that is not in IFCL. To do this, note that ICFL must have a polynomial bound on its runtime since it is in $P$. Let us call this runtime $n^k$ for some $k$. Then we can construct a language $L$ that is not in ICFL but in $P$ by choosing any time class that is significantly larger than $n^k$, but is still polynomial, such as $n^(2k)$. The theorem guarantees that at least one language exists in purely in this class, and since we have bound ICFL, there are clearly languages that are not in ICFL but are in $P$. Thus we can say that $P$ is strictly larger than ICFL

#pagebreak()

= Problem 5

We will show that this problem is PSPACE-Hard, and thus PSPACE-Complete by reducing the TQBF problem to this problem. To do this, we can use the following algorithm:

+ Given a TQBF formula:
+ Map the TQBF problem to the $E Q_"NFA"$

Then we can show that this reduction is polynomial time. The TQBF problem is a boolean formula with quantifiers, and can be represented as a NFA with a polynomial number of states. Thus the reduction is polynomial time. Thus we have shown that this problem is PSPACE-Hard, and since we can solve it in polynomial space, it is PSPACE-Complete.

#pagebreak()

= Problem 6

== (a)

The total amount of randomness is $O(log(m))$, since we have $m$ variables, and the algorithm that was described has a branch depth of linear length since we cannot repeat variables (recall that the particular branching problems we consider are those that are read once, meaning we cannot repeat variables in a branch). Thus it must be the case that the total randomness is $O(log(m))$

== (b)

We have $"BPP"[log(n)]$. To show that it is in $P$, we must show that any problem in $"BPP"[log(n)]$ can be solved in polynomial time. To do this, we can use the following algorithm:

+ Given a problem $A$ in $"BPP"[log(n)]$
+ Because this means that there is a maximum randomness of $O(log(n))$, this means that there are at most $2^log(n)$ possible paths of randomness that this algorithm can take, meaning there a polynomial amount of strings that can be generated with this randomness
+ For each random potential string, run the algorithm and check if it is correct in non probabilistic polynomial time
+ Keep track of what results are returned for each string
+ If the majority of the strings return the same result, then return that result, simulating a probabilistic polynomial time algorithm

Since we have a polynomial number of possibilities, and each one can be checked in polynomial time, then the entire algorithm runs in polynomial time. Thus we can say that $"BPP"[log(n)] in P$


