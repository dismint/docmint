#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 7",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
The mean and variance of the original distribution is:
$
mu &= (1800+8600)/2=5200\
sigma^2 &= (8600-1800)^2/12 = 46240000/12 = 3853333.33
$
We then use the CLT to compute the distribution of a new normal with mean $52 dot 5200 = 270400$ and variance $52 dot 3853333.overline(3) = 200373333$
$
PP(S<250000) &=\
&= PP(S<(250000-270400)/sqrt(200373333))\
&approx PP(S < -1.44)\
&approx boxed(0.07493)
$

= Problem 2
== (a)
The mean and variance of the original distribution is:
$
mu &= 1/lambda = 1/2\
sigma^2 &= 1/lambda^2 = 1/4
$
We then use the CLT to compute the distribution of a new normal with mean $400 dot 1/2 = 200$ and variance $400 dot 1/4 = 100$. We are looking for a $w$ such that $1-0.8413=0.1587$ on a normal distribution falls before the curve. This corresponds to $-1$ on a normal distribution, giving us:
$
-1 &= (w-mu)/sigma\
&= (w-200)/10\
-10 &= w-200\
w &= boxed(190)
$
== (b)
Working backwards, let us first compute the mean for this probability to work:
$
-1 &= (200-mu)/sigma\
-1 &= (200-n/2)/sqrt(n/4)\
-1 &= (400-n)/sqrt(n)\
-sqrt(n) &= (400-n)\
160000 - 801n + n^2 &= 0\
n &= boxed(420.50625)
$

== Problem 3
Consider each as a separate binomial distribution with the attributes below:
$
mu_1 &= 120\
sigma^2 &= 72\
mu_1 &= 98\
sigma^2 &= 49\
$
Now we can consider a new distribution that is $"women" - "men"$, which will indicate under 0 whether there are more men than women who vote. Then the resulting distribution is a combination of these two with attributes:
$
mu_1 &= 98-120=-22\
sigma^2 &= 72+49=121\
$
Now we compute the approximation that there are more males which vote:
$
PP(X<0) &=\
&= PP(N < (0+22)/sqrt(121))\
&= PP(N < 2)\
&approx boxed(0.97725)
$

= Problem 4
== (a)
$
p_(X_1)(x) = cases(
  p q "if" x=1,
  1 - p q "if"  x=0,
  0 "else"
)
$
The PMF of $X$ then is a composition of these i.i.d random variables, resulting in a new binomial random variable.
$
p_(X)(x) = binom(3, x) (p q)^x (1-p q)^(3-x)
$
Note that the above is only defined on $x in {1, 2, 3}$, and is equal to $0$ elsewhere.
== (b)
When we condition on $Y_1=1$, we know where the bus went for sure, meaning the resulting PMF is:
$
p_(X_1)(x) = cases(
  1 "if"  x=0,
  0 "else"
)
$
On the other hand, if $Y_1=0$, we know either the bus came and went to Kendall ($p q$), or it didn't come at all ($1-p$):
$
p_(X_1)(x) = cases(
  (p q)/((1-p)+p q) "if"  x=1,
  (1-p)/((1-p)+p q) "if"  x=0,
  0 "else"
)
$
Conditioning on $Y_2$ does not change anything as each $i$ is independent, and thus we get the same answer from before:
$
p_(X_1)(x) = cases(
  p q "if" x=1,
  1 - p q "if"  x=0,
  0 "else"
)
$

= Problem 5
== (a)
A mosquito has a $0.1$ chance to bite each time. Thus we can consider this a geometric distribution with $p=0.1$. Thus we expect $boxed(10)$ seconds to pass between each bite, and the variance to be:
$
"Var" = (1-p)/p^2 = 0.9/0.01 = boxed(90)
$
== (b)
We have another distribution with $p=0.7$. This means there is a $0.1+0.07-0.007=0.163$ chance we get bitten by at least one bug each second, giving us yet another geometric distribution, yielding us:
$
EE &= 1/0.163\
&= boxed(6.13497)\
sigma^2 &= (1-0.163)/0.163^2\
&= boxed(31.50288)
$

= Problem 6
Let us compute the desired quantity with Poisson as:
$ 1 - PP(D = 0) - PP(D = 1) $
Thus we get this quantity as:
$
PP(D >= 2) &= 1 - PP(D = 0) - PP(D = 1)\
&= 1 - (e^(-2) 2^0)/0! - (e^(-2) 2^1)/1!\
&= 1 - e^(-2) - 2 e^(-2)\
&= 1 - 3 e^(-2)\
&= boxed(0.59399)
$

= Problem 7 [Grad]
For a uniform distribution, we have that $EE=0.5$ and $"Var"=1/12$ for each of the ten variables, leading to a total $EE=5$ and $"Var"=5/6$
== Markov
$
PP(X_S >= 7) &<= EE/7\
&<= boxed(5/14)
$
== Chebyshev's
$
PP(X_S >= 7) <= PP(|X-mu| >= 2) <= "Var"/k^2 <= (5/6)/4 <= boxed(5/24)
$
== CLT
$
PP(X_S >= 7) &= 1 - PP(X_S <= 7)\
&approx 1 - PP(N<(7-5)/sqrt(5/6))\
&approx 1 - PP(S <= 2.19089)\
&approx 1 - 0.98574\
&approx boxed(0.01426)
$

