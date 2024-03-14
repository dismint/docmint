#import "template.typ": *
#show: template.with(
  title: "14.15 Problem Set #2",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (1)

#align(center, [#raw-render(```
  digraph {
    layout = neato
    node[shape = circle]

    1 -> {2, 3}
    2 -> {1, 3}
    3 -> 1
  }
```)])

== (2)

=== Eigenvector Centrality

First let us solve for the eigenvalues of $g$, remembering to use $g'$ in calculations. I will show part of the full calculation for this first instance.

$
lr(|mat(delim: "[", 0, 1, 1; 1, 0, 0; 1, 1, 0;) - mat(delim: "[", lambda, 0, 0; 0, lambda, 0; 0, 0, lambda;)|) &=
lr(|mat(delim: "[", -lambda, 1, 1; 1, -lambda, 0; 1, 1, -lambda)|)\
&= -lambda (lambda^2 - 0) - 1 (-lambda - 0) + 1 (1 + lambda)\
&= -lambda^3 + lambda + 1 + lambda\
&= -lambda^3 + 2 lambda + 1
$

From this, we get that the positive eigenvalue is $(1 + sqrt(5)) / 2$, and as a result the eigenvector that follows is:

$ mat(delim: "[", 1; (sqrt(5) - 1) / 2; 1) $

However we want to normalize the results, so we take the overall sum which is $1 + (sqrt(5) - 1) / 2 + 1 = (sqrt(5) + 3) / 2$. We then divide each of the elements by this value to get the normalized vector of:

$ boxed(mat(delim: "[", 2 / (sqrt(5) + 3); (sqrt(5)-1) / (sqrt(5) + 3); 2 / (sqrt(5) + 3))) $

=== PageRank

Recall that PageRank is defined as follows:

$ c = (bold(I) - alpha g' D^(-1))^(-1) bold(1) $

$D$ is the diagonal array where the elements are either the out-degree, or 1 if the out-degree is 0. For this graph, we have:

$ D = mat(delim: "[", 2, 0, 0; 0, 2, 0; 0, 0, 1;) $

Substituing the values in, we then get the following results:

$
(alpha = 0.25) =& boxed(mat(delim: "[", 1 481/999; 1 185/999; 1 3/9;))\
(alpha = 0.5) =& boxed(mat(delim: "[", 2 2/5; 1 3/5; 2;))
$

== (3)

As we increase $alpha$, the PageRank values all go up. This makes sense since $alpha$ simply controls the discount on further paths, and as a result increasing its value will make all longer paths contribute more to the final score.

We can see that compared to the original score, nodes 1 and 3 increased greatly as many paths go through them, while node 2 suffers and does not increase as much since there is only one edge pointing inward.

== (4)

Recall the definition of Katz-Bonacich:

$ c = beta (bold(I) - alpha g')^(-1) bold(1) $

With the assumption that $beta = 1$, we end up with the following for $alpha = 0.5$

$ c = (mat(delim: "[", 1, 0, 0; 0, 1, 0; 0, 0, 1;) - 0.5 mat(delim: "[", 0, 1, 1; 1, 0, 0; 1, 1, 0;))^(-1) mat(delim: "[", 1; 1; 1;) = boxed(mat(delim: "[", 6; 4; 6;)) $

= Problem 3

The paper I will be reading is:

`Boehm and Pandalai-Nayar, “Input Linkages and the Transmission of Shocks: FirmLevel Evidence from the 2011 Tohoku Earthquake”`

== (1)

We consider a node / firm "big" in this study if they are heavily involved in international operations between many nations as well as their participation in input-output linkages. This lines up well with what the study hopes to achieve, as their primary focus is to provide "emperical evidence for the cross-country transmission of shocks via inelastic production linkages, primarily of multinational firms. The principal mechanism at work is not new; the idea that input-output linkages are a key channel through which shocks propagate through the economy dates back to at least Leontief" (Boehm and Pandali-Nayar, 1). Thus the given definition seems to fit well.

An easy reach for a coarser definition would be to say the size of a node is defined as *all* its connections, not just the international ones. This of course, might lead to some concealment of information as national transactions would be included as well, which is not the purpose of this paper.

== (2)

/ Supply-Chain Link: Inelastic production linkages that take place between multinational firms.

Once again, similar to above, this makes sense in the context of the paper as we don't necessarily need to consider the other edges, such as national links between firms. We also don't need to care about elastic productions, since they don't seem to greatly impact the propagation of shock. There is a point to be made that hidden data may be present in the edges we are leaving out, and thus the conclusion we come to might be a skewed or false one without the full graph.

== (3)

The most interesting and significant result that stood out to be was the conclusion made regarding the link from Japanese firms to affiliates in the United States. It was shown that for every 1% decrease in the amount of Japanese imports, there was an accompanying 0.2% drop in production of the firms that relied on those imports.

Along with the elasticity of 0.03 between Japanese international imports and nonmultinationals, this shows that there is surprisingly little substitutability.

== (4)

It's clear from the above as well as other parts of the paper that diversifying inputs is an extremely important endeavour. It's unlikely that all supply chains go down, while it is possible for your one supplier to endure a shock, leaving you (SpaceX) to feel the results as well. Alternatively, you could also opt to have a solid backup in the case of a disruption.

Another important outcome to take from the paper is that focusing on the *short-run* is very important. Although the paper does not mention a specific solution, it does beg the reader to think about the time frame within which these changes happen, so that firms might have a better chance at finding substitutes or otherwise deal with sudden shocks or shortages in supply chains.
