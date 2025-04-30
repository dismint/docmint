#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 3",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
Since expectation is linear and the expected value is equal to the mean in this scenario, then we can consider the mean a linear combination. Thus, the mean of $Z$ is:
$ 2 X_m - 3 Y_m $
where $X_m,Y_m$ denote the respective means.

Variances add for independent variables, and we also know that $"Var"[a R]=a^2 "Var"[R]$. Thus the variance for $Z$ should be:
$ 4 "Var"[X] + 9 "Var"[Y] $

= Problem 2
== (a)
Let us calculate the sum of all possible inner values $x^2 + y^2$ and call it $z$. Then it should be the case that $z dot c = 1$
$
z &= \
&= 2 + 10 + 5 + 13 + 17 + 25 \
&= 72 \
c &= boxed(1/72)
$

== (b)
$
PP(Y < X) &= 1/72 dot (5+17+25) \
&= boxed(47/72) \
PP(Y > X) &= 1/72 dot (10+13) \
&= boxed(23/72) \
PP(Y = X) &= 1/72 dot (2) \
&= boxed(2/72) \
$

== (c)
Marginal PMFs for $p_X$:
$
p_X (1) &= (2+10)/72 = 12/72 = boxed(1/6) \
p_X (2) &= (5+13)/72 = 18/72 = boxed(1/4) \
p_X (4) &= (17+25)/72 = 42/72 = boxed(7/12) \
$
Marginal PMFs for $p_Y$:
$
p_Y (1) &= (2+5+17)/72 = 24/72 = boxed(1/3) \
p_Y (3) &= (10+13+25)/72 = 48/72 = boxed(2/3) \
$

== (d)
$
EE[X] &= 1/6 dot 1 + 1/4 dot 2 + 7/12 dot 4 \
&= 36/12 = boxed(3) \
EE[Y] &= 1/3 dot 1 + 2/3 dot 3 \
&= 36/12 = boxed(7/3) \
EE[X Y] &= 1 dot 2/72 + 3 dot 10/72 + 2 dot 5/72 + 6 dot 13/72 + 4 dot 17/72 + 12 dot 25/72 \
&= 488/72 = boxed(61/9) \
$

= Problem 3
== (a)
Oscar can pick up three pens in three ways:
+ 3 on the first trip
+ 1 on the first trip, 2 on the second
+ 2 on the first trip, 1 on the second
Thus $PP(A)$ is just the sum of these individual probabilities, which are (in order):
$ 1/3 + 1/3 dot 1/3 + 1/3 dot 1/3 = boxed(5/9) $

== (b)
$ PP(B|A) = PP(B inter A)/PP(A) $
In order to both get three pens as well as visiting the supply room twice, we must now discount the case where Oscar gets three pens on his first visit, thus $PP(B inter A) = 2/9$. Therefore:
$ PP(B inter A) = (2/9)/(5/9) = boxed(2/5) $

== (c)
Let us calculate the PMF, of which we have already calculated for $3$. The fewest $N$ can be is $2$, which only happens if we get a single pen on each visit. We can get $4$ pens if we get both $1$ and $3$ in that order, or $2$ on each visit. $5$ pens can happen if we get both $2$ and $3$ in that order. No other combinations are possible.
$
p_N (2) &= 1/3 dot 1/3 = 1/9 \
p_N (3) &= 5/9 \
p_N (4) &= 1/3 dot 1/3 + 1/3 dot 1/3 = 2/9 \
p_N (5) &= 1/3 dot 1/3 = 1/9 \
$
Thus we can calculate $EE[N]$ as:
$ EE[N] = 1/9 dot 2 + 5/9 dot 3 + 2/9 dot 4 + 1/9 dot 5 = 30/9 = boxed(10/3) $
Given $N>3$, there are $2$ parts chance that it is $4$, and $1$ parts chance that it is $5$, thus we get:
$ EE[N|N<3] = 2/3 dot 4 + 1/3 dot 5 = boxed(13/3) $

== Problem 4
Following the hint, it only takes $1$ box to reach $i=1$.

To get to $i=2$, there is a $2/3$ chance we get it on the next draw, then a $2/3 dot (1/3)$ chance it's the draw after, and so on. Thus this is a geometric distribution with $p=2/3$, meaning that the expected number of turns for $i=2$ is $3/2$

We can follow a similar path of logic for the last step, except now our success rate is $1/3$, meaning that it will take us on average $3$ boxes to reach $i=3$

Putting everything together, we get that we will reach $i=3$ coupons after collecting a number of boxes equal to:
$ 1 + 3/2 + 3 = boxed(11/2) $

== Problem 5
== (a)
The chance that we get $a$ is equal to $p_a$. Thus, we would expect that this fraction of the total rolls are $a$, and thus:
$ EE[N_a] = boxed(n dot p_a) $
Since each roll is independent, we can sum the variance over the individual variances of $n$ rolls. Because each roll is a Bernoulli random variable, the variance for each one comes out to $p_a (1 - p_a)$. Thus over all rolls, the total variance is:
$ "Var"(N_a) = boxed(n dot p_a (1 - p_a)) $

== (b)
At each of the $(n-1)$ positions before the last one, there is a $p_a^2$ chance that this position and the next are both $1$, and thus contribute one to the count of consecutive $a$ values. Since expectation is linear, we can sum over all of these slots, resulting in a total expectation of:
$ EE[N_(a a)] = boxed((n-1) dot p_a^2) $

== Problem 6
== (a)
$
P_(X|A)(x) &= boxed(binom(5,x) dot (3/5)^(x) dot (2/5)^(5-x)) \
P_(X|A^c)(x) &= boxed(binom(5,x) dot (1/10)^(x) dot (9/10)^(5-x)) \
$

== (b)
We can use the probabilities from *(a)*, with the knowledge that a randomly selected patient has the disease with probability $p=0.2$. Thus we get:
$
p_X (x) = &0.2 dot binom(5,x) dot (3/5)^(x) dot (2/5)^(5-x) +\
&0.8 dot binom(5,x) dot (1/10)^(x) dot (9/10)^(5-x)
$

== (c)
We can simply compute the expected value by using knowledge of the expectation of a binomial distribution, $n dot p$
$ EE[X] = 0.2 dot 5 dot 0.6 + 0.8 dot 5 dot 0.1 = boxed(1) $

== (d)
For a binomial distribution, the variance can be calculated with the formula $n dot p (1 - p)$. Thus, we calculate the variance for each of the two conditions, giving us:
$
"Var"(X|A) &= 5 dot 0.6 dot 0.4 = 1.2 \
"Var"(X|A^c) &= 5 dot 0.1 dot 0.9 = 0.45 \
$
Now we use the law of total variance. Let us compute each part separately, letting $S$ be the random even that the patient is sick. First:
$
EE["Var"(X|S)] &= 1.2 dot 0.2 + 0.45 dot 0.8 = 0.6 \
$
Then, for the other side, we start by computing the PMF for $EE[X|S]$:
$
EE[X|S] = cases(
  3 "if" S=A \
  0.5 "if" S=A^c
)
$
Then we compute the other half:
$
EE[EE[X|S]^2] &= 9 dot 0.2 + 1/4 dot 0.8 = 2 \
EE[EE[X|S]]^2 &= 1 \
"Var"(EE[X|S]) &= EE[EE[X|S]^2] - EE[EE[X|S]]^2 \
&= 1
$
Putting both halfs together, we now get the total variance of:
$ "Var"(X|S) = 0.6 + 1 = boxed(1.6) $

== (e)
We wish to find:
$
PP(A|X=3) = (PP(A) dot PP(X=3|A))/PP(X=3)
$
$PP(X=3)$ can be found by using our PMF from *(b)*, which when plugged in comes out to $0.0756$. Similarly, we can get $PP(X=3|A)$ by using one half of *(b)*, for the scenario where we only consider the sick person. This gives us $0.3456$. Thus, we can solve by plugging back into the original formula, giving:
$
PP(A|X=3) = (0.2 dot 0.3456)/0.0756 = boxed(0.914)
$

== Problem 7
As the hint suggests, the first $n$ rolls can be taken out since the head counts are independent and identically distributed. Thus by the $n$-th flip, neither player is likely to have more heads, and are expected to have the same number. Thus, whether or not $A$ has more heads is completely dominated by the last $n+1$-th coin flip, meaning there is a probability of $boxed(1/2)$ that $A$ gets *strictly* more heads than $B$
