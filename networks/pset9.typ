#import "template.typ": *
#show: template.with(
  title: "14.15 PSET 9",
  subtitle: "Justin Choi",
  pset: true,
)

= Problem 1

== (a)

*No*, it is not the case that the prices are not market-clearing. In order for this to be the case, it would have to be that the price each buyer receives is adequate enough for them to prefer the good. We can see that at a price of $1$, both $x$ and $z$ will choose $c$ over the other choices, thus the set of prices overall is not market-clearing.

== (b)

Suppose we run a bipartite graph auction procedure. I will show what happens at the end of each round in terms of pricing during the auction, as well as the final price at the end of the procedure. I will use the hint and choose a reasonable constricted set.

=== Round 1

*Price*: $a=0, b=0, c=0$

*Payoffs*
/ $x$: $(7, 7, 7)$
/ $y$: $(7, 6, 3)$
/ $z$: $(5, 4, 3)$

$(y, z)$ is constricted since they both prefer $a$

=== Round 2

*Price*: $a=1, b=0, c=0$

*Payoffs*
/ $x$: $(6, 7, 7)$
/ $y$: $(6, 6, 3)$
/ $z$: $(4, 4, 3)$

We can see here that no possible buyer set is constricted and thus we have the following final assignments of:

$a => z, b => y, c => x$

= Problem 2

== (a)

The equation that shows the optimal response for firm $i$ is as follows:

$ (q_i (1 - q_i - q_j)) $

Taking the derivative with respect to $q_i$ yields the optimality equation of:

$ 1 - 2 q_i - q_j = 0 $

Thus the firm has the best response when $q_i = (1 - q_j) / 2$. The solution for the best values of $q$ are therefore:

$ q_1 = q_2 = 1 / 3 $

This is the unique solution to the PNSE since it follows logically from the optimization equation, and it is mathematically only one solution. The reason we are able to use this type of equation in the first place to model an optimal response is because the payoff if $i$ is concave with relation to $q_i$, thus we can use the aforementioned equation to find the solutions, yielding the one solution we found.

== (b)

Using part of the answer from above where we found the best response relation, as well as the fact that firm $2$ will best respond, our new equation is:

$ q_1 (1 - q_1 - (1 - q_1) / 2) $

Again we take the derivative with respect to $q_1$ to find the optimal response:

$ 1 / 2 - q_1 $

Therefore firm $1$ should choose $q_1 = 1 / 2$ and firm $2$ should choose $q_2 = (1 - q_1) / 2 = 1 / 4$ 

== (c)

The idea of a first-movers advantage exists because allowing firm $1$ to move first means they can choose the optimal response of $1 / 2$ paired with $1 / 4$ from firm $2$. This same kind of logic does not work otherwise, because when firm $2$ does not consider firm $1$, then the optimal value of $q_1$ would deviate to a slightly lower value.

= Problem 3

== (a)

I will show that neither choice has a particular advantage of profit for the seller.

If we assume that the seller accepts, they will get an immediate payoff of:

$ delta_S (1 / 2 p_S + 1 / 2 p_B) $

Suppose instead that they decline, meaning control is over to the buyer with $1 / 2$ chance. Similarly, it then becomes the sellers turn, where control is handed over with a $1 / 2$ chance as well. Thus we end up with the same payoff of:

$ delta_S (1 / 2 p_S + 1 / 2 p_B) $

Therefore there is no deviation for the seller that benefits them more for either choice.

== (b)

Again, this will follow a similar logical progression as the previous part. If the buyer accepts, then their expected payoff is:

$ (1 - p_S) $

Now suppose that the buyer declines, meaning we move to the seller. This happens with probability $1 / 2$, where either it shifts to the buyer again with probability $1 / 2$ or remains with the seller. The prices offered are $p_B$ and $p_S$ respectively. Thus the expected payoff is:

$ delta_B (1 - 1 / 2 p_S - 1 / 2 p_B) $

Which is the exact same as the $(1 - p_S)$ we found earlier as given in the problem statement. Thus once again, there is no deviation for the buyer that benefits them more for either choice.

== (c)

Let us look at the two mentioned equations in *(a)* and *(b)*, and solve for the price of the buyer and seller respectively. We have:

$
p_B &= delta_S (1 / 2 p_S + 1 / 2 p_B)\
1 - p_S &= delta_B (1 - 1 / 2 p_S - 1 / 2 p_B)
$

Solving the system of equations give us the following relative solutions:

$
p_S &= ((2 - delta_S) dot (1 - delta_B)) / (2 - delta_S - delta_B)\
p_B &=  (delta_S dot (1 - delta_B)) / (2 - delta_S - delta_B)
$

Therefore we can obviously conclude that $p_B < p_S$, and therefore it must be the case that the advantage of being the first mover is larger. This makes sense, because even if you make an offer now, there is still a chance you can make an offer later, meaning you will always have a marginal advantage as a first mover.

= Problem 4

== Left Graph

In this graph, all nodes are perfectly matched, thus we expect that the payoff of every single node is the same at $boxed(0.5)$

== Right Graph

In this graph, we can see that the bottom left seller is over-demanded, meaning its payoff will be $1$. No other seller is over-demanded, as every single person they sell to has at least one other option to buy from. Thus the payoff of every other seller is $0$

The buyers follow a very similar pattern, with the two rightmost buyers being over-demanded, and thus their payoff is $1$. The other buyers have only one other option to buy from, and thus their payoff is $0$

Thus the top row of buyers from left to right has payoff $boxed((0, 0, 1, 1))$

Thus the bottom row of sellers from left to right has payoff $boxed((1, 0, 0, 0))$
