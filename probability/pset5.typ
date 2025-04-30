#import "template.typ": *
#show: template.with(
  title: "6.3702 PSET 5",
  subtitle: "Justin Choi",
  pset: true,
  toc: false,
)
#show figure: set block(breakable: true)

= Problem 1
== (a)
We can generate the CDF of $Y$, and differentiate it to get the PDF of $Y$:
$
F_y (y) &= PP(Y <= y)\
&= PP((X+1)^2 <= y)\
&= PP(-sqrt(y) <= X+1 <= sqrt(y))\
&= PP(-sqrt(y)-1 <= X <= sqrt(y)-1)\
&= F_X (sqrt(y)=1) - F_X (-sqrt(y)-1)
$
Now that we have $F_Y (y)$, we differentiate to get $f_Y (y)$:
$
f_Y (y) &= dif/(dif y) [F_X (sqrt(y)=1) - F_X (-sqrt(y)-1)]\
&= 1/(2 sqrt(y)) f_X (sqrt(y)-1) + 1/(2 sqrt(y)) f_X (sqrt(y)-1)\
&= boxed((f_X (sqrt(y)-1) + f_X (-sqrt(y)-1) ) / (2 sqrt(y)))
$
== (b)
The range of values that $Y$ can take on is now in $[1, 4]$, anything outside cannot happen since $Y = (X + 1)^2$. Since $X$ is uniformly distributed, $f_X = 1$ on the range of $[0, 1]$. Using our answer from *(a)*, notice that the second term in the numerator is $0$ since $f_X = 0$ outside of $[0, 1]$, while the first term must be $1$. Thus the new PDF given the uniform distribution is simply:
$
boxed(f_Y (y) = cases(
  1/(2 sqrt(y)) "if" y in [1, 4],
  0 "otherwise"
))
$

= Problem 2
== (a)
Let us list all of the possibilities for $(X, Y)$. For all future occurrences, I will use the random variable $S$ to represent $X+Y$
$
(0, 3) &= 3\
(0, 4) &= 4\
(1, 3) &= 4\
(1, 4) &= 5\
(2, 3) &= 5\
(2, 4) &= 6
$
Thus this gives us:
$
boxed(f_S = cases(
  1/6 "if" X+Y=3,
  1/3 "if" X+Y=4,
  1/3 "if" X+Y=5,
  1/6 "if" X+Y=6,
  0 "otherwise"
))
$
== (b)
Since the two variables are independent, we can represent the PDF of $S$ as:
$ f_S (s) = integral_(-infinity)^infinity f_X (x) f_Y (s - x) dif x $
However, in order to differentiate, we must consider the range of the integration on $x$ as a function of $s$. It should be the case that $0 <= x <= 2$, and also that $s-4 <= x <= s-3$. This naturally splits the integral into three interesting ranges on $[3, 4], [4, 5], [5, 6]$. Thus we integrate over the appropriate bounds on $x$. Since the original variables are uniformly distributed, we know that the values for the PDFs will be $1/2, 1$ respectively for $X, Y$

Essentially, we will evaluate the following 
$
f_S (s) &= integral_"lower"^"upper" f_X (x) f_Y (s - x) dif x\
&= integral_"lower"^"upper" 1/2 dif x\
&= 1/2 ["upper" - "lower"]
$
=== *$[3, 4]$ Integration*
$
f_S (s) &= 1/2 [(s-3)-0]\
&= (s-3)/2
$
=== *$[4, 5]$ Integration*
$
f_S (s) &= 1/2 [(s-3)-(s-4)]\
&= 1/2
$
=== *$[5, 6]$ Integration*
$
f_S (s) &= 1/2 [2-(s-4)]\
&= (6 - s)/2
$
Thus our final PDF is:
$
boxed(f_S (s) = cases(
  (s-3)/2 "if" s in [3, 4],
  1/2 "if" s in [4, 5],
  (6-s)/2 "if" s in [5, 6],
  0 "otherwise"
))
$

= Problem 3
In order to show that the two are uncorrelated, we must show that the covariance is equal to $0$. That is:
$ EE[X Y] - EE[X] dot EE[Y] = 0 $
The expectation of $X$ is trivially $0$ since it is uniformly distributed around $0$. Thus we only need to show that $EE[X Y] = 0$
$
EE[X Y] &= integral_(-1)^1 1/2 x^3 dif x\
&= [1/8 x^4]_(-1)^1\
&= 0
$
Thus the covariance is equal to 0 and $X, Y$ are *uncorrelated*

= Problem 4
== (a)
$PP(A < B)$ for two independent exponentially distributed variables is equal to:
$ lambda_A / (lambda_A + lambda_B) = (1/4) / (5/12) = boxed(3/5)  $
== (b)
Because exponential random variables are memoryless, this is no different than *(a)*:
$ boxed(3/5) $
== (c)
Let us compute both $PP(A <= B-1)$ and $PP(B <= A-1)$.
=== *Computing $PP(A <= B-1)$*
$
PP &= integral_1^infinity PP(A <= x-1) f_B (x) dif x\
&= integral_1^infinity [1 - e^(- (x-1)/4)] f_B (x) dif x\
&= integral_1^infinity [1 - e^(- (x-1)/4)] 1/6 e^(-x/6) dif x\
&= integral_1^infinity 1/6 e^(-x/6) dif x - integral_1^infinity e^(- (x-1)/4) 1/6 e^(-x/6) dif x\
&= 1/6 [-6 e^(-x/6)]_1^infinity - integral_1^infinity e^(- (x-1)/4) 1/6 e^(-x/6) dif x\
&= e^(-1/6) - integral_1^infinity e^(- (x-1)/4) 1/6 e^(-x/6) dif x\
&= e^(-1/6) - integral_1^infinity 1/6 e^(-(x-1)/4 -x/6) dif x\
&= e^(-1/6) - 1/6 e^(1/4) integral_1^infinity e^(-(5 x)/12) dif x\
&= e^(-1/6) - 2/5 e^(-5/12)
$

= Problem 5
To show a negative correlation, let us find the covariance between $X_1, X_2$. Note that these two are binomially distributed random variables with $n$ and $1/k$:
$
"Covar"(X_1, X_2) = EE[X_1 X_2] - EE[X_1]EE[X_2]
$
The individual expectations are trivially $n/k$, since we have an equal chance across all rolls. $X_1 X_2$ can be thought of as finding the number of pairs $(i, j)$ for all values where $i$ resulted in a $1$ and $j$ resulted in a $2$. There are $n dot (n-1)$ of these occasions, and each of them has a $1/k^2$ chance of happening as each have a $1/k$ chance of rolling the correct number. Thus, our probability is equal to:
$ (n(n-1))/k^2 $
Now that we have all the expected values, we can get the covariance:
$
"Covar" &= (n(n-1))/k^2 - n/k dot n/k\
&= (n(n-1)-n^2)/k^2\
&= -n/k^2\
$
Thus since the covariance is negative, we can conclude that there is a negative correlation between $X_1$ and $X_2$

= Problem 6
== (a)
If $Z=1$, then since $X$ is normal, it must be the case that $Y$ is normal as well. If $Z=-1$, then since $X$ is symmetric around $0$, it must be the case that $Y$ is normal as well, in fact being the same as $X$ except mirrored. Thus it must be the case that $Y$ itself is a standard normal. Formally we have that $f_Y (y) = 1/2 f_X (y) + 1/2 f_X (y) =  f_X (y)$
== (b)


