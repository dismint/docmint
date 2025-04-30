#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 1",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

_Collaborator: Annie Wang_

= Problem 1
== (a)
We can simplify to $A inter (B union C)$, and if $A$ is disjoint to $B$ and $C$ separately, then $A$ must also be disjoint to $B union C$, thus $boxed(PP=0)$

== (b)
We again simplify to $A inter (B union C)$, distributing, we get that $(A inter B) union (A inter C)$. Thus then
$ PP = 1/2 + 1/3 = boxed(5/6) $
== (c)
We have $(A^c union (B^c inter C^c))$, and if we take the complement of the whole thing, we can simplify using De Morgan's to:
$
(A^c union (B^c inter C^c))^c &= \
&= (A inter (B^c inter C^c)^c)
$
Thus, the complement is equal to the original expression, and $boxed(PP = 0.8)$

= Problem 2
Since $25%$ of the class is in neither category, then $75%$ must be in one of the two categories. The total sum of percentages is $130$, and thus there must be $55%$ on the intersection between the two, $5%$ geniuses, and $15%$ chocolate lovers. Thus, the chance that someone is in one group but not the other is equal to $PP = 0.05 + 0.15 = boxed(0.2)$

= Problem 3
To simplify this question, we can consider the question as two different probabilities. First, the probability that all three dice roll different numbers, and second, that $A > B > C$
$
PP("different") &= 1 dot 5/6 dot 4/6 = 20/36 = 5/9\
PP("increasing") &= 1/6
$

The second is $1/6$ because three different numbers have six unique permutations, and only one of them results in $A > B > C$. Thus $PP=boxed(5/54)$

= Problem 4
== (a)
The area is a rectangular strip that travels from $(0, 0)$ to $(1, 1)$ with a diagonal height of $1/3$. We can subtract off the area of the top left and bottom right empty areas, each of which are right triangles with base lengths of $2/3$, leading to an area of $2/9$. Thus the total area is $1 - 2/9 dot 2 = boxed(5/9)$

== (b)
Now the area is a square with corners at $(0, 0), (2/3, 2/3)$, and thus $PP = 2/3 dot 2/3 = boxed(4/9)$

== (c)
The shape is similar to *(a)*, but instead the triangles to remove have base lengths of $1/3$, meaning each has an area of $1/18$. Thus the total area is $4/9 - 1/18 dot 2 = boxed(1/3)$

== (d)
$
PP(A | B) &= PP(A inter B) / PP(B) \
&= (1/3)/(4/9) \
&= boxed(3/4)
$

== (e)
$
PP(B | A) &= PP(A inter B) / PP(A) \
&= (1/3)/(5/9) \
&= boxed(3/5)
$

= Problem 5
== (a)
$
"New York w/ Rain" &= 2/5 dot 1/5 dot 1/4 = 2/100 \
"New York w/o Rain" &= 2/5 dot 4/5 dot 3/4 = 24/100 \
"Boston w/ Rain" &= 3/5 dot 1/5 dot 1/4 = 3/100 \
"Boston w/o Rain" &= 3/5 dot 4/5 dot 1/3 = 12/75 \
"Running" &= 2/100 + 24/100 + 3/100 + 12/75 = (2 + 24 + 3 + 16)/100 = 45/100 = boxed(9/20)
$

== (b)
Let us calculate both probabilities, letting $R$ be the event that he is running, and $B, N$ the events that he is in Boston and New York respectively.
$
PP(B | R) = PP(B inter R) / PP(R) = (19/100)/(9/20) = 19/45\
PP(N | R) = PP(N inter R) / PP(R) = (13/50)/(9/20) = 26/45
$
Thus, given that he is running, it is more likely that he is in *New York*

= Problem 6
== (a)
$
"Probability Old" &= 75/500 dot 74/499 \
"Probability New" &= 75/1500 dot 74/1499 \
"Probability Defective" &= 1/2 dot 75/100 dot 74/499 + 1/2 dot 75/1500 dot 74/1499 approx boxed(0.0124)
$

== (b)
$
PP("old" | "both defective") = PP("old" inter "both defective") / PP("both defective") = (1/2 dot 75/500 dot 74/499)/(0.0123...) approx boxed(0.900)
$

= Problem 7
Since it is difficult to solve the problem with the given phrasing, I will instead consider two events, that I pull the last blue ball before the last red ball, and pull the last green ball before the last red ball.

This lets us consider two easy subproblems. Using De Morgan's, we can equate this to the original question. Considering these two events $B, G$ respectively, the original question is $PP(B^c inter G^c)$. This is equal to $PP(B union G)$. To find this, we need to determine the probabilities of each of them individually, then remove the overlap.

For either, imagine that we line up the green/blue and red balls in some random order. The chance that the last ball is red or green/blue is proportional to the number of them. That is, the chance that the last one is red is:
$
PP("blue before red") &= 10/30\
PP("green before red") &= 10/40\
$

Now we need to find the overlap so we can subtract it. This similar to above, except now we combine both green/blue balls for $PP = 10/60$

Thus:
$ PP = 10/30 + 10/40 - 10/60 = 25/60 = boxed(5/12) $
