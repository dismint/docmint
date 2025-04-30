#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 2",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
== (a)
Each event occurs by itself, and thus $PP(A)=PP(B)$, and we can calculate the probabilities together. The probability of getting heads is either $1/2$ or $1/4$, with a $1/2$ chance of being each, for a total chance of $1/2 dot 1/2 + 1/2 dot 1/4 = 3/8$

If the two events are independent, then $PP(A inter B) = PP(A) dot PP(B) = 9/64$. However, the chance for two heads is actually $1/4$ if the fair coin, and $1/16$ otherwise, for a total probability of $1/2 dot 1/4 + 1/2 dot 1/16 = 4/32 + 1/ 32 = 10/64$

Thus $10/64 != 9/64$, and these events are *not independent*.

== (b)
The probability from the first section remains the same at $3/8$, and as such $PP(A) dot PP(B) = 9/64$. However, when we now consider the actual probability of $PP(A inter B)$, because we now *repick* the coin, we can say that $PP(A inter B) = PP(A) + PP(B)$ since the chance of picking a new coin decouples the two events, and thus the two events *must* be independent.

= Problem 2
== (a)
There are $binom(52,26)$ ways to choose a given hand of cards. This will automatically choose the other $26$ cards as well. Now we ask how many ways there are to pick a *good* half of cards. We know that we need to select $binom(4,2)$ of the aces, and $binom(48,24)$ of the remaining cards that aren't aces. Thus we have our final probability which is:
$
(binom(4,2) binom(48,24))/binom(52,26) &= \
&= (4! dot 48! dot 26! dot 26!)/(2! dot 2! dot 24! dot 24! dot 52!) \
&= (6 dot 25^2 dot 26^2)/(52 dot 51 dot 50 dot 49) \
&approx boxed(0.390)
$

== (b)
Because there are an odd number of hearts ($13$), it must be the case that one stack always has more hearts than the other. However, due to symmetry, it is equally likely for either of the stacks to be greater than the other in number of hearts, as the two stacks always have a mirror for any state where the second stack has the cards in the first stack and vice versa. Thus, it must be the case that the probability the first stack contains more hearts is equal to the reverse, with $PP=boxed(1/2)$

= Problem 3
Consider laying out all the cards in a line, where the first 13 cards are given to the first person, the next to the second, and so on. There are $binom(52,4)$ possible locations to put the four aces in this line of $52$ cards. However, of those, we want to find the good combinations. We can pick one location from the first 13, one from the second 13, and so on, for a total number of possibilities of $13^4$. Thus the probability is:
$ 13^4/binom(52,4) approx boxed(0.105) $

= Problem 4
Because of symmetry, the chance that the dealers card is lower or higher than ours is the same at $1/2$. However, this is not the entire space, as there could be ties. After the first card is picked, one of the other three cards of that rank must be picked. Thus the probability is $3/51 = 1/17$ that there is a tie, and a $16/17$ probability that it is *not* a tie. Since either we or the dealer are equally likely to win, the chance that we win is:
$ 16/17 dot 1/2 = boxed(8/17) $

= Problem 5
The probabilities are proportional to their areas in relation to the whole. Thus the innermost circle has a probability of $1/100$, the middle $25/100-1/100$, and the outer $1-25/100$. Thus we get our PMF:
$
P(X=50) &= 1/100 \
P(X=20) &= 24/100=6/25 \
P(X=10) &= 75/100=3/4
$
We can multiple these together to find the expected value, which is:
$ 1/100 dot 50 + 6/25 dot 20 + 3/4 dot 10 = boxed(12.8) $

= Problem 6
== (a)
$
P(X=2) &= 1/9 \
P(X=3) &= 2/9 \
P(X=4) &= 3/9 \
P(X=5) &= 2/9 \
P(X=6) &= 1/9 \
E[X] &= 2 dot 1/9 + 3 dot 2/9 + 4 dot 3/9 + 5 dot 2/9 + 6 dot 1/9 = 36/9 = boxed(4) \
E[X^2] &= 2^2 dot 1/9 + 3^2 dot 2/9 + 4^2 dot 3/9 + 5^2 dot 2/9 + 6^2 dot 1/9 = 156/9 \
sigma^2 &= 156/9 - 4^2 = 12/9 = boxed(4/3)
$

== (b)
$
P(Z=4) &= 1/9 \
P(Z=9) &= 2/9 \
P(Z=16) &= 3/9 \
P(Z=25) &= 2/9 \
P(Z=36) &= 1/9 \
E[Z] &= 4 dot 1/9 + 9 dot 2/9 + 16 dot 3/9 + 25 dot 2/9 + 36 dot 1/9 = 156/9 = boxed(52/3)
$

== (c)
$
P(Y=4/2) &= 1/9 \
P(Y=9/2) &= 2/9 \
P(Y=16/2) &= 3/9 \
P(Y=25/2) &= 2/9 \
P(Y=36/2) &= 1/9 \
E[Y] &= 4/2 dot 1/9 + 9/2 dot 2/9 + 16/2 dot 3/9 + 25/2 dot 2/9 + 36/2 dot 1/9 = 78/9 = boxed(26/3)
P(W=1) &= 1/9 \
P(W=4) &= 2/9 \
P(W=9) &= 3/9 \
P(W=16) &= 2/9 \
P(W=25) &= 1/9 \
E[W] &= 1 dot 1/9 + 4 dot 2/9 + 9 dot 3/9 + 16 dot 2/9 + 25 dot 1/9 = 93/9 = boxed(31/3)
$

= Problem 7
Following the hint, let us create an indicator variable $X_i$, and compute its expected value. If we isolate an arbitrary card $i$, in a shuffled deck, it is equally likely that card appears first among itself and the aces - that is, there is a $1/5$ chance that the variable is $1$, and as such, is also its expected value. Then, the expected sum across all $48$ *non-ace* cards is $48/5$, which is the number of cards that we could expect to see *before* the ace. We then add one to offset the additional card we have to flip for the first ace, giving us a final expected value for the number of cards until our first ace as:
$
48/5 + 1 = boxed(53/5)
$

= Problem 8
Following the hint, let us create the Bernoulli random variable $X_i$. To find $p$ for this random variable, we need to determine the chance that a given box is empty after placing $b$ balls. On each ball placement, there is a $(k-1)/k$ chance of missing the box, which needs to happen $b$ times, meaning:
$ p=E[X_i]=((k-1)/k)^b $
$p$ is the same as the expected value since we multiply $1$ against $p$ to find the expected value. This is the expected number of empty boxes for this *one* box.

Since there are $k$ boxes, with the linearity of expectation the total number of expected empty boxes can be represented by:
$ E["empty"] = boxed(k dot ((k-1)/k)^b) $

