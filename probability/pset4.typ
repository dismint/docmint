#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 4",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
Because we take the absolute value of $X$, instead of viewing the expected value as an integral from $-infinity$ to $infinity$, we can instead take twice the integral from $0$ to $infinity$, as our distribution's mean is centered around $0$
$
EE[|X|] &= 2 integral_(0)^(infinity) x f_X (x) dif x\
&= 2 integral_(0)^(infinity) x 1/(sigma sqrt(2 pi)) e^(-x^2/(2 sigma^2)) dif x\
&= 2/(sigma sqrt(2 pi)) integral_(0)^(infinity) x e^(-x^2/(2 sigma^2)) dif x\
&= sqrt(2)/(sigma sqrt(pi)) integral_(0)^(infinity) x e^(-x^2/(2 sigma^2)) dif x\
&= sqrt(2)/(sigma sqrt(pi)) sigma^2\
&= boxed(sigma sqrt(2/pi))
$

= Problem 2
== (a)
To get the PDF, we can weight each of the bulbs equally as an exponential random variable:
$
"PDF" &= boxed(1/2 (e^(-x)) + 1/2 (1/2 e^(-x/2)))
$
The mean can be calculated as:
$
overline(X) = 1/2 (1 + 2) = boxed(3/2)
$
In this case, the expected value is the same as the mean. To calculate the variance, we must find $EE[X^2]$:
$
"Var"(X) = EE[X^2] - EE[X]^2 = 1/2 (2 + 8) - 9/4 = boxed(11/4)
$
== (b)
We now want to take the minimum of the two distributions. Because the two events are independent, asking whether the min of two randomly distributed variables is below a certain threshold is the same as asking if *both* are below a certain threshold. Let $M$ be the random variable that represents the minimum.
$
PP(M > m) = PP(X > m) PP(Y > m) = e^(-x) e^(-x/2) = e^(-(3 x)/2)
$
Thus, this yields another exponentially distributed random variable with $lambda=3/2$. We then get the PMF as:
$ boxed(3/2 e^(-(3 x)/2)) $
The mean and expected value are:
$ boxed(2/3) $
The variance is:
$
"Var"(M) &= 1/lambda^2 = boxed(4/9)
$

= Problem 3
== (a)
Conditioning on $X-2$ is the same as the original distribution since it is memoryless. We simply adjust the original exponentially distributed random variable to account:
$
f_X = cases(
  e^(2-x) "if" x >= 2,
  0 "if" x < 2
)
$
== (b)
The joint PDF can be computed by taking the conditional distribution against the individual distribution:
$
f_(X,Y) (x, y) &= f_(Y|X) (y|x) f_X (x)\
&= x e^(-x (y+1))\
$
Thus we get the final distribution of:
$
boxed(cases(
  x e^(-x (y+1)) "if" (x,y) >= 0,
  0 "else"
))
$
== (c)
To calculate the marginal, we integrate out the unneeded variable:
$
f_Y (y) &= integral_0^infinity x e^(-x (y+1)) dif x\
&= x integral_0^infinity e^(-x (y+1)) dif x - integral_0^infinity (integral_0^infinity e^(-x (y+1)) dif x) dif x\
&= [-(x e^(-x (y+1)))/(y+1)]_0^infinity  + 1/(y+1) (integral_0^infinity e^(-x (y+1)) dif x)\
&= [-(x e^(-x (y+1)))/(y+1)]_0^infinity  + 1/(y+1) [-e^(-x (y+1))/(y+1)]_0^infinity\
&= [-e^(-x (y+1))/(y+1)^2]_0^infinity\
&= 1/(y+1)^2
$
Thus we get:
$
boxed(cases(
  1/(y+1)^2 "if" y >= 0,
  0 "else"
))
$
== (d)
To calculate this conditional distribution, we can relate it to the joint and marginal:
$
f_(X|Y)(y) &= (f_(X,Y)(x, y))/(f_Y (y))\
&= (x e^(-x (y+1)))/(1/(y+1)^2)\
&= 9 x e^(-3 x)\
$
Thus we get:
$
boxed(cases(
  9 x e^(-3 x) "if" x >= 0,
  0 "else"
))
$

= Problem 4
== (a)
To find the answer, we compute the following integral:
$
PP &= integral_0^1 x dif x\
&= [1/2 x]_0^1\
&= boxed(1/2)
$
== (b)
To compute the distribution, we need to compute the probability of seeing some number of active machines $m$. Given a certain $x$, this probability is binomially distributed:
$
PP(M) &= integral_0^1 binom(n, m) x^m (1-x)^(n-m)\
&= binom(n, m) (m! (n-m)!)/((n+1)!)
$
Thus we can use Bayes to get the final answer:
$
f_(X|M) (x) &= (PP(M | X=x))/(binom(n, m) (m! (n-m)!)/(n+1)!)\
&= boxed(((n+1)!)/(m! (n-m)!) x^m (1-x)^(n-m))
$

= Problem 5
First note that we have the symmetric side of ${X+Y <= 0, Y <= 0}$, which has the same probability, and also note the remaining upper-left quadrant is given by ${X <= 0, Y <= 0}$. These three events split the space into three partitions. The probability of the latter is $1/2 dot 1/2 = 1/4$, and since the other events are equal and just constitute the other probability, the chance of either is $(1-1/4)/2=3/8$. Thus using Bayes we get our final probability of:
$ (3/8)/(1/2) = boxed(3/4) $

= Problem 6

#pagebreak()

