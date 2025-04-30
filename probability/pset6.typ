#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 6",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
== (a)
For each dice roll $d$, the expected number of heads is $d/2$. Since each $d$ has an equal $1/6$ chance of happening, the total expected value for the number of heads $N$ is equal to:
$
EE[N] &= 1/6 ((1+2+3+4+5+6)/2)\
&= 21/12 = boxed(7/4)
$
The variance can be computed using the law of total variance:
$ "Var"(N) = "Var"(EE[N|D]) + EE["Var"(N|D)] $
$"Var"(N|D)$ can be computed using the fact that $N|D$ is a binomial distribution with parameters $D, 1/2$. The variance for this distribution is $D dot 1/2 dot (1-1/2) = D/4$. Thus we get:
$ EE["Var"(N|D)] = EE[D/4] = 1/4 EE[D] = 1/4 dot 7/2 = 7/8 $
For the other term, we have:
$ "Var"(EE[N|D]) = "Var"(D/2) = 1/4 "Var"(D) $
We can compute the variance of $D$ as follows:
$
"Var"(D) &= EE[D^2] - EE[D]^2\
&= (1+4+9+16+25+36)/6 - (7/2)^2
&= 91/6 - 49/4\
&= 182/12 - 147/12 = 35/12
$
Thus $"Var"(EE[N|D]) = 35/48$, and the total variance is $7/8 + 35/48 = boxed(77/48)$
== (b)
The new expected value for the number of heads can be calculated as:
$ 1/2 EE[D_1 + D_2] = boxed(7/2) $
The variance is computed similarly using the law of total variance. $"Var"(N|D) = D/4$ and $EE[N|D] = D/2$ as before.
Thus we get:
$ EE["Var"(N|D)] = EE[D/4] = 1/4 EE[D] = 1/4 dot 7 = 7/4 $
Since the two rolls are independent, the variance of the total can be calculated additively:
$ "Var"(EE[N|D]) = "Var"(D/2) = 1/4 "Var"(D) = 1/4 dot 70/12 = 35/24 $
Thus the total variance is $7/4+35/24=42/24+35/24=boxed(77/24)$
