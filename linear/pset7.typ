#import "template.typ": *
#show: template.with(
  title: "PSET 7",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

Collaborators: Annie Wang


= 6.2.2

$
X &= mat(1, 1; 0, 1)\
lambda &= mat(lambda_1, 0; 0, lambda_2)\
X^(-1) &= mat(1, -1; 0, 1)\
X lambda X^(-1) &= mat(1, 1; 0, 1) mat(lambda_1, 0; 0, lambda_2) mat(1, -1; 0, 1)\
&= mat(lambda_1, lambda_2; 0, lambda_2) mat(1, -1; 0, 1)\
&= mat(lambda_1, lambda_2-lambda_1; 0, lambda_2)\
&= boxed(mat(2, 3; 0, 5))
$


= 6.2.8

$
mat(1, 1; 1, 0) &= mat(lambda_1, lambda_2; 1, 1) mat(lambda_1, 0; 0, lambda_2) X^(-1)\
&= mat(lambda_1, lambda_2; 1, 1) mat(lambda_1, 0; 0, lambda_2) boxed([1/(lambda_1 - lambda_2) mat(1, -lambda_2; -1, lambda_1)])\
&= mat(lambda_1, lambda_2; 1, 1) mat(lambda_1^k, 0; 0, lambda_2^k) [1/(lambda_1 - lambda_2) mat(1, -lambda_2; -1, lambda_1)] vec(1, 0)\
&= mat(lambda_1^(k+1), lambda_2^(k+1); lambda_1^k, lambda_2^k) [1/(lambda_1 - lambda_2) mat(1, -lambda_2; -1, lambda_1)] vec(1, 0)\
&= mat((lambda_1^(k+1) - lambda_2^(k+1))/(lambda_1 - lambda_2), (lambda_1 lambda_2^(k+1) - lambda_2 lambda_1^(k+1))/(lambda_1 - lambda_2); (lambda_1^(k) - lambda_2^(k))/(lambda_1 - lambda_2), (lambda_1 lambda_2^(k) - lambda_2 lambda_1^(k))/(lambda_1 - lambda_2)) vec(1, 0)\
&= boxed(vec((lambda_1^(k+1) - lambda_2^(k+1))/(lambda_1 - lambda_2), (lambda_1^(k) - lambda_2^(k))/(lambda_1 - lambda_2)))
$

Thus our final answer is:


$ boxed((lambda_1^k - lambda_2^k)/(lambda_1 - lambda_2)) $


= 6.2.33

$
mat(cos(theta), -sin(theta); sin(theta), cos(theta)) vec(1, i) = vec(cos(theta) - i sin(theta), sin(theta) + i cos(theta))
$

Thus for the first eigenvalue it must be $cos(theta) - i sin(theta)$

$
mat(cos(theta), -sin(theta); sin(theta), cos(theta)) vec(i, 1) = vec(i cos(theta) - sin(theta), i sin(theta) + cos(theta))
$

Thus for the second eigenvalue it must be $i sin(theta) + cos(theta)$

Now for the factoring:

$
X &= mat(1, i; i, 1)\
X^(-1) &= mat(1/2, -i/2; -i/2, 1/2)\
Lambda &= mat(cos(theta) - i sin(theta), 0; 0, i sin(theta) + cos(theta))\
X Lambda X^(-1) &= mat(1, i; i, 1) mat(cos(theta) - i sin(theta), 0; 0, i sin(theta) + cos(theta)) mat(1/2, -i/2; -i/2, 1/2)\
X Lambda^n X^(-1) &= mat(1, i; i, 1) mat(cos(theta) - i sin(theta), 0; 0, i sin(theta) + cos(theta))^n mat(1/2, -i/2; -i/2, 1/2)\
X Lambda^n X^(-1) &= boxed(mat(1, i; i, 1) mat(e^(-i n theta), 0; 0, e^(i n theta))^n mat(1/2, -i/2; -i/2, 1/2))\
$

Now we simplify:

$
X Lambda^n X^(-1) &= mat(1, i; i, 1) mat(e^(-i n theta), 0; 0, e^(i n theta)) mat(1/2, -i/2; -i/2, 1/2)\
&= mat(e^(-i n theta), i e^(i n theta); i e^(-i n theta), e^(i n theta)) mat(1/2, -i/2; -i/2, 1/2)\
&= mat((e^(-i n theta))/2 + e^(i n theta)/2, -i e^(-i n theta)/2 + i e^(i n theta)/2; i e^(-i n theta)/2 - i e^(i n theta)/2, i (e^(-i n theta))/2 + e^(i n theta)/2)\
&= mat(cos(n theta), -sin(n theta); sin(n theta), cos(n theta))
$


= 6.3.2

For $S$:

$
S &= mat(2, 2, 2; 2, 0, 0; 2, 0, 0)\
S - lambda I &= 0\
mat(2 - lambda, 2, 2; 2, -lambda, 0; 2, 0, -lambda) &= 0\
(2 - lambda)(lambda^2) - 2(2)(-lambda) + 2(2)(lambda) &= 0\
2 lambda^2 - lambda^3 + 4 lambda + 4lambda &= 0\
lambda^3 - 2 lambda^2 - 8 lambda &= 0\
lambda(lambda^2 - 2 lambda - 8) &= 0\
lambda(lambda - 4)(lambda + 2) &= 0\
lambda &= boxed((0, 4, -2))
$

Therefore we can get our eigenvectors from these eigenvalues.

For $lambda = 0$:

$
(S - lambda I) x &= 0\
mat(2, 2, 2; 2, 0, 0; 2, 0, 0) x &= 0\
mat(2, 2, 2; 0, -2, -2; 0, -2, -2) x &= 0\
mat(2, 2, 2; 0, -2, -2; 0, 0, 0) x &= 0\
x &= vec(0, sqrt(2) / 2, - sqrt(2) / 2)
$

For $lambda = 4$:

$
(S - lambda I) x &= 0\
mat(-2, 2, 2; 2, -4, 0; 2, 0, -4) x &= 0\
mat(-2, 2, 2; 0, -2, 2; 0, 2, -2) x &= 0\
mat(-2, 2, 2; 0, -2, 2; 0, 0, 0) x &= 0\
x &= vec(sqrt(6) / 3, sqrt(6) / 6, sqrt(6) / 6)
$

For $lambda = -2$:

$
(S - lambda I) x &= 0\
mat(4, 2, 2; 2, 2, 0; 2, 0, 2) x &= 0\
mat(4, 2, 2; 0, 1, -1; 0, -1, 1) x &= 0\
mat(4, 2, 2; 0, 1, -1; 0, 0, 0) x &= 0\
x &= vec(-sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3)
$

Thus we get our factorization:

$
X Lambda X^(-1) &= boxed(mat(0, sqrt(6) / 3, - sqrt(3) / 3; sqrt(2) / 2, sqrt(6) / 6, sqrt(3) / 3; - sqrt(2) / 2, sqrt(6) / 6, sqrt(3) / 3) mat(0, 0, 0; 0, 4, 0; 0, 0, -2) mat(0, sqrt(2) /2, - sqrt(2) / 2; sqrt(6) / 3, sqrt(6) / 6, sqrt(6) / 6; - sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3))\
$

For matrix $T$:

$
T &= mat(1, 0, 2; 0, -1, -2; 2, -2, 0)\
T - lambda I &= 0\
mat(1 - lambda, 0, 2; 0, -1 - lambda, -2; 2, -2, -lambda) &= 0\
(1 - lambda)((-1 - lambda)(-lambda) - 4) + 2(-2(-1-lambda)) &= 0\
(1 - lambda)(lambda^2 + lambda - 4) + 4 + 4 lambda &= 0\
-lambda^3 - lambda^2 + 4 lambda + lambda^2 + lambda - 4 + 4 + 4 lambda &= 0\
-lambda^3 + 9 lambda &= 0\
lambda(lambda^2 - 9) &= 0\
lambda &= boxed((0, 3, -3))
$

Therefore we can get our eigenvectors from these eigenvalues.

For $lambda = 0$:

$
(T - lambda I) x &= 0\
mat(1, 0, 2; 0, -1, -2; 2, -2, 0) x &= 0\
mat(1, 0, 2; 0, -1, -2; 0, -2, -4) x &= 0\
mat(1, 0, 2; 0, -1, -2; 0, 0, 0) x &= 0\
x &= vec(-2, -2, 1)\
x &= vec(2/3, 2/3, -1/3)
$

For $lambda = 3$:

$
(T - lambda I) x &= 0\
mat(-2, 0, 2; 0, -4, -2; 2, -2, -3) x &= 0\
mat(-2, 0, 2; 0, -4, -2; 0, -2, -1) x &= 0\
mat(-2, 0, 2; 0, -4, -2; 0, 0, 0) x &= 0\
x &= vec(2, -1, 2)\
x &= vec(2/3, -1/3, 2/3)
$

For $lambda = -3$:

$
(T - lambda I) x &= 0\
mat(4, 0, 2; 0, 2, -2; 2, -2, 3) x &= 0\
mat(4, 0, 2; 0, 2, -2; 0, -2, 2) x &= 0\
mat(4, 0, 2; 0, 2, -2; 0, 0, 0) x &= 0\
x &= vec(-1, 2, 2)\
x &= vec(-1/3, 2/3, 2/3)
$

Thus we get our factorization:

$
Y Lambda Y^(-1) &= boxed(mat(2/3, 2/3, -1/3; 2/3, -1/3, 2/3; -1/3, 2/3, 2/3) mat(0, 0, 0; 0, 3, 0; 0, 0, -3) mat(2/3, 2/3, -1/3; 2/3, -1/3, 2/3; -1/3, 2/3, 2/3))\
$


= 6.3.4

== (a)

Let us find the eigenvalue of such a matrix:

$
A &= mat(1, b; b, 1)\
A - lambda I &= 0\
mat(1 - lambda, b; b, 1 - lambda) &= 0\
(1 - lambda)^2 - b^2 &= 0\
1 - 2 lambda + lambda^2 - b^2 &= 0\
$

Thus if we have $b = 2$ we have eigenvalues of $lambda = (3, -1)$ since those are the roots of the above equation. Thus we have found:

$ mat(1, 2; 2, 1) $

In fact we can go further by factoring the eigenvalues as $(b + 1)(b - 1)$ since the product must equal the determinant. This will come in handy later.

== (b)

It must be the case that since $b > 1$ (otherwise we have a non-zero determinant as shown above) that the RREF form of the matrix will result in a negative value along the pivot since $1 - b$ is negative.

== (c)

Because the sum of the eigenvalues must equal the trace, and the trace in this case is a positive number $2$


= 6.3.21

== (a)

Any matrix $A$ in this form can be written as:

$
mat(0, a, b; -a, 0, c; -b, -c, 0)
$

Since the diagonals must be zero and everything else must be the opposite sign of its reflection. Thus let us multiply this against $x$ to show that everything cancels:

$
mat(x_1, x_2, x_3) mat(0, a, b; -a, 0, c; -b, -c, 0) mat(x_1; x_2; x_3) &= 0\
mat(-a x_2 - b x_3, a x_1 - c x_3, b x_1 + c x_2) mat(x_1; x_2; x_3) &= 0\
-a x_2 x_1 - b x_3 x_1 + a x_1 x_2 - c x_3 x_2 + b x_1 x_3 + c x_2 x_3 &= 0\
0 &= 0
$

== (b)

Based on part *(a)* and the hint we know that the matrix $A$ as described in this question must not have any eigenvalues that are real. This is because from the previous part we know that $overline(z)^T A z$ has no non-real values. Thus when we have $lambda ||z||^2$, since the magnitude is a scalar, and these two things are equal, it must be the case that $lambda$ is not real in all scenarios.

== (c)

Since $A$ is a real matrix, it must be the cases that the eigenvalues come as complex conjugates. This is because the determinant of $A$ must be real, and the determinant is the product of the eigenvalues. Thus they should all multiply out to a real $x >= 0$ number.


= 6.3.30

$
S &= mat(a, b, c; b, d, e; c, e, f)\
x^T S x &= mat(x_1, x_2, x_3) mat(a, b, c; b, d, e; c, e, f) mat(x_1; x_2; x_3)\
x^T S x &= mat(a x_1 + b x_2 + c x_3, b x_1 + d x_2 + e x_3, c x_1 + e x_2 + f x_3) mat(x_1; x_2; x_3)\
x^T S x &= mat(a x_1^2 + b x_1 x_2 + c x_1 x_3, b x_1 x_2 + d x_2^2 + e x_2 x_3, c x_1 x_3 + e x_2 x_3 + f x_3^2)\
S &= mat(2, -1, 0; -1, 2, -1; 0, -1, 2)
$

Since the determinant is positive, it must be the case that $S$ is positive definite.

$
T &= mat(a, b, c; b, d, e; c, e, f)\
x^T T x &= mat(x_1, x_2, x_3) mat(a, b, c; b, d, e; c, e, f) mat(x_1; x_2; x_3)\
x^T T x &= mat(a x_1 + b x_2 + c x_3, b x_1 + d x_2 + e x_3, c x_1 + e x_2 + f x_3) mat(x_1; x_2; x_3)\
x^T T x &= mat(a x_1^2 + b x_1 x_2 + c x_1 x_3, b x_1 x_2 + d x_2^2 + e x_2 x_3, c x_1 x_3 + e x_2 x_3 + f x_3^2)\
T &= mat(2, -1, -1; -1, 2, -1; -1, -1, 2)
$

Since the determinant is zero, it must be the case that $T$ is positive semi-definite.


= 6.4.2

$
S &= mat(1, 1 + i; 1 - i, 2)\
S - lambda I &= 0\
mat(1 - lambda, 1 + i; 1 - i, 2 - lambda) &= 0\
(1 - lambda)(2 - lambda) - (1 + i)(1 - i) &= 0\
2 - 3 lambda + lambda^2 = 2 &= 0\
lambda^2 - 3 lambda &= 0\
lambda(lambda - 3) &= 0\
lambda &= boxed((0, 3))
$

Then we can get the eigenvectors from this information.

For $lambda = 0$:

$
(S - lambda I) x &= 0\
mat(1, 1 + i; 1 - i, 2) x &= 0\
mat(1, 1 + i; 0, 0) x &= 0\
x &= vec(-(1+i), 1)
$

For $lambda = 3$:

$
(S - lambda I) x &= 0\
mat(-2, 1 + i; 1 - i, -1) x &= 0\
mat(-2, 1 + i; 0, 0) x &= 0\
x &= vec(1+i, 2)
$


= 6.4.3

If we take the norm of both sides of the equation then we get that:

$
||Q x|| = ||lambda||||x||
$

We know that $Q$ must preserve the norm of the thing it multiplies, and thus it must be the case that $||lambda|| = 1$


= 6.4.15

The eigenvalues of $P$ are $1, i, -1, -i$. Therefore we we plug into $C = 2 I - P - P^3$ we get:

For $1$:
$ 2 - 1 - 1^3 = 0 $
For $i$:
$ 2 - i - i^3 = 2 $
For $-1$:
$ 2 - (-1) - (-1)^3 = 4 $
For $-i$:
$ 2 - (-i) - (-i)^3 = 2 $


= 6.5.3

== (a)

If every column adds to $0$, then it must be the case that the matrix has dependent rows, and as such since it is not invertible it must be the case that the there exists an eigenvalue equal to $0$

== (b)

Let us first find the eigenvalues and the eigenvectors. Since we know that the matrix is dependent and there are two eigenvalues, it must be the case that the two eigenvalues are $0$ and $-5$. Now let us find the eigenvectors

For $0$:

$
A &= mat(-2, 3; 2, -3)\
A - lambda I &= 0\
mat(-2, 3; 2, -3) x &= 0\
mat(-2, 3; 0, 0) x &= 0\
x &= vec(3, 2)
$

For $-5$:

$
A &= mat(-2, 3; 2, -3)\
A - lambda I &= 0\
mat(-2 + 5, 3; 2, -3 + 5) x &= 0\
mat(3, 3; 2, 2) x &= 0\
x &= vec(1, -1)
$

Therefore we can write $u(0)$ as the following:

$
u(0) = vec(4, 1) = 1 vec(3, 2) + 1 vec(1, -1)
$

And therefore we have that $u(t)$ is:

$
boxed(u(t) = e^(0 t) vec(3, 2) + e^(-5 t) vec(1, -1))
$
