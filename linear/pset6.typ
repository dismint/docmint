#import "template.typ": *
#show: template.with(
  title: "PSET 6",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

Collaborators: Annie Wang


= 5.1.2

$
det(1/2 A) &= boxed(- 1/ 8)\
det(-A) &= boxed(1)\
det(A^2) &= boxed(1)\
det(A^(-1)) &= boxed(-1)
$

Now supposing that the $det(A) = 0$, all the values would now become $boxed(0)$ except for $det(A^(-1))$ which would be undefined.


= 5.1.9

$
A &= boxed(1)\
B &= boxed(2)\
C &= boxed(0)\
D &= boxed(0)\
$


= 5.2.2

$
det(A) &= boxed(-2)\
det(B) &= 1 (45 - 48) - 2 (36 - 42) + 3 (32 - 35)\
&= -3 + 12 - 9\
&= boxed(0)\
det(C) &= det(A) det(A)\
&= boxed(det(A^2))\
det(D) &= boxed(det(A B))
$

- $A$ has independent columns since the determinant is non-zero
- $B$ has dependent columns since the determinant is zero
- $C$ has independent columns as long as $A$ has a non-zero determinant
- $D$ has independent columns as long as both $A$ and $B$ have non-zero determinants


= 5.2.5

== (a)

First let us find the determinant of $A$:

$
det(A) &= det(mat(2, 5; 1, 4))\
&= 3
$

Now we will use Cramer's Rule:

$
x_1 &= det(B_1) / 3\
&= det(mat(1, 5; 2, 4)) / 3\
&= boxed(- 2)\
x_2 &= det(B_2) / 3\
&= det(mat(2, 1; 1, 2)) / 3\
&= boxed(1)
$

== (b)

First let us find the determinant of $A$:

$
det(A) &= det(mat(2, 1, 0; 1, 2, 1; 0, 1, 2))\
&= 2 (4 - 1) - 1 (2 - 0)\
&= 4
$

Now we will use Cramer's Rule:

$
x_1 &= det(B_1) / 4\
&= det(mat(1, 1, 0; 0, 2, 1; 0, 1, 2)) / 4\
&= boxed(3 / 4)\
x_2 &= det(B_2) / 4\
&= det(mat(2, 1, 0; 1, 0, 1; 0, 0, 2)) / 4\
&= boxed(- 1 / 2)\
x_3 &= det(B_3) / 4\
&= det(mat(2, 1, 0; 1, 2, 1; 1, 0, 0)) / 4\
&= boxed(1 / 4)
$


= 5.2.14

== (a)

$
det(mat(1, 2, 3, 0; 2, 6, 6, 1; -1, 0, 0, 3; 0, 2, 0, 7)) &= \
&= det(mat(1, 2, 3, 0; 0, 2, 0, 1; -1, 0, 0, 3; 0, 2, 0, 7))\
&= det(mat(1, 2, 3, 0; 0, 2, 0, 1; 0, 2, 3, 3; 0, 2, 0, 7))\
&= det(mat(1, 2, 3, 0; 0, 2, 0, 1; 0, 0, 3, 2; 0, 0, 0, 6))\
&= boxed(36)
$

== (b)

$
det(mat(1, -1, 0, 0; -1, 2, -1, 0; 0, -1, 2, -1; 0, 0, -1, 2)) &= \
&= det(mat(1, -1, 0, 0; 0, 1, -1, 0; 0, -1, 2, -1; 0, 0, -1, 2))\
&= det(mat(1, -1, 0, 0; 0, 1, -1, 0; 0, 0, 1, -1; 0, 0, -1, 2))\
&= det(mat(1, -1, 0, 0; 0, 1, -1, 0; 0, 0, 1, -1; 0, 0, 0, 1))\
&= boxed(1)
$


= 5.3.5

== (a)
$ det(mat(3, 1; 2, 4)) = 12 - 2 = boxed(10)\ $

== (b)
#twocola(
  [
    $
    "area" =  1 / 2 det(mat(3, 1; 2, 4)) = boxed(5)\
    $
  ],
  [
    #bimg("imgs/tri1.png", width: 60%)
  ]
)

== (c)
#twocola(
  [
    $
    "area" = 1 / 2 det(mat(3, -2; 2, 2)) = boxed(5)\
    $
  ],
  [
    #bimg("imgs/tri2.png", width: 60%)
  ]
)


= 5.3.7

$
abs(det(H)) &= abs(det(mat(1, 1, 1, 1; 1, 1, -1, -1; 1, -1, -1, 1; 1, -1, 1, -1)))\
&= abs(det(mat(1, 1, 1, 1; 0, 0, -2, -2; 0, -2, -2, 0; 0, -2, 0, -2)))\
&= abs(det(mat(1, 1, 1, 1; 0, 0, -2, -2; 0, 0, -2, 2; 0, -2, 0, -2)))\
&= abs(det(mat(1, 1, 1, 1; 0, -2, 0, -2; 0, 0, -2, -2; 0, 0, -2, 2)))\
&= abs(det(mat(1, 1, 1, 1; 0, -2, 0, -2; 0, 0, -2, -2; 0, 0, 0, 4)))\
&= boxed(16)
$

Note that even though we swapped two rows, since the rows are inside an absolute value, it does not matter.


= 5.3.15

Suppose it is the case that $e_1 = vec(a, b)$ and $e_2 = vec(c, d)$. Then we get:

$
||e_1|| &= sqrt(a^2 + b^2)\
||e_2|| &= sqrt(c^2 + d^2)\
||e_1|| ||e_2|| &= sqrt(a^2 + b^2) sqrt(c^2 + d^2)\
&= sqrt(a^2 c^2 + a^2 d^2 + b^2 c^2 + b^2 d^2)
$

Now let us calculate the determinant of $E$. WLOG assume that the determinant is positive, and all values are positive as well:

$
det(E) &= det(mat(a, c; b, d))\
&= a d - b c\
$

Now we square both sides:

$
a^2 c^2 + a^2 d^2 + b^2 c^2 + b^2 d^2 &= (a d - b c)^2\
a^2 c^2 + a^2 d^2 + b^2 c^2 + b^2 d^2 &= a^2 d^2 - 2 a b c d + b^2 c^2\
a^2 c^2 + b^2 d^2 &= - 2 a b c d\
$

Trivially, it must be the case that the left side is at least as big as the right since the right side is positive (because we assume WLOG that the determinant as well as the values are positive). Therefore, it must be the case that $abs(det(E)) <= ||e_1|| ||2_2||$

Intuitively, we can also understand this as the maximum area of a parallelogram with set side lengths being maximized when it is a rectangle, as the base will always be the same, but the height will be the tallest when it is a rectangle.


= 6.1.3

For $A$:

$
0 &= det(A - lambda I)\
&= det(mat(-lambda, 2; 1, 1 - lambda))\
&= lambda^2 - lambda - 2\
&= (lambda - 2)(lambda + 1)\
lambda &= boxed([2, -1])
$

Therefore we can get the eigenvalues as:

$
lambda_1 &= 2\
(A - 2 I) x &= 0\
mat(-2, 2; 1, -1) vec(x_1, x_2) &= vec(0, 0)\
e_1 &= boxed(vec(1, 1))\
lambda_2 &= -1\
(A + I) x &= 0\
mat(1, 2; 1, 2) vec(x_1, x_2) &= vec(0, 0)\
e_2 &= boxed(vec(-2, 1))
$

For $A^(-1)$:

$
0 &= det(A^(-1) - lambda I)\
&= det(mat(- 1 / 2 - lambda, 1; 1 / 2, -lambda))\
&= lambda^2 + lambda / 2 - 1 / 2\
&= (lambda + 1)(lambda - 1 / 2)\
lambda &= boxed([-1, 1 / 2])
$

Therefore we can get the eigenvalues as:

$
lambda_1 &= -1\
(A^(-1) + I) x &= 0\
mat(1 / 2, 1; 1 / 2, 1) vec(x_1, x_2) &= vec(0, 0)\
e_1 &= boxed(vec(-2, 1))\
lambda_2 &= 1 / 2\
(A^(-1) - 1 / 2 I) x &= 0\
mat(- 1, 1; 1 / 2, - 1 / 2) vec(x_1, x_2) &= vec(0, 0)\
e_2 &= boxed(vec(1, 1))
$

$A^(-1)$ has the same eigenvectors as $A$. When $A$ has eigenvalues $lambda_1$ and $lambda_2$, its inverse has eigenvalues $1 / lambda_1$ and $1 / lambda_2$


= 6.1.10

First we find the eigenvalues of $A$:

$
0 &= det(A - lambda I)\
&= det(mat(0.6 - lambda, 0.2; 0.4, 0.8 - lambda))\
&= (0.6 - lambda)(0.8 - lambda) - 0.08\
&= lambda^2 - 1.4 lambda + 0.40\
&= (lambda - 0.4)(lambda - 1)\
lambda &= boxed([0.4, 1])
$

Thus we can find the eigenvectors as:

$
lambda_1 &= 0.4\
(A - 0.4 I) x &= 0\
mat(0.2, 0.2; 0.4, 0.4) vec(x_1, x_2) &= vec(0, 0)\
e_1 &= boxed(vec(1, -1))\
lambda_2 &= 1\
(A - I) x &= 0\
mat(-0.4, 0.2; 0.4, -0.2) vec(x_1, x_2) &= vec(0, 0)\
e_2 &= boxed(vec(1, 2))
$

First we find the eigenvalues of $A^infinity$:

$
0 &= det(A^infinity - lambda I)\
&= det(mat(1/3-lambda, 1/3; 2/3, 2/3-lambda))\
&= (1/3 - lambda)(2/3 - lambda) - 2/9\
&= lambda^2 - lambda\
&= lambda(lambda - 1)\
lambda &= boxed([0, 1])
$

Thus we can find the eigenvectors as:

$
lambda_1 &= 0\
(A^infinity - 0 I) x &= 0\
mat(1/3, 1/3; 2/3, 2/3) vec(x_1, x_2) &= vec(0, 0)\
e_1 &= boxed(vec(1, -1))\
lambda_2 &= 1\
(A^infinity - I) x &= 0\
mat(-2/3, 1/3; 2/3, -1/3) vec(x_1, x_2) &= vec(0, 0)\
e_2 &= boxed(vec(1, 2))
$

It makes sense from the results that the eigenvectors are the same, after all this is what we would expect after taking a matrix to a power of itself. However, we can see that the eigenvalues have changed from $0.4$ and $1$ to $0$ and $1$. This makes sense as taking $1$ to any power is itself, and taking $0.4$ to the power of infinity approaches $0$. Thus it makes sense that at $A^100$, it looks close to $A^infinity$ since it is approaching the same eigenvalues.


= 6.1.11

Note that if we have:

$
(A - lambda_1 I) x_2 &= 0\
A x_2 - lambda_1 x_2 &= 0\
lambda_2 x_2 - lambda_1 x_2 &= 0\
(lambda_2 - lambda_1) x_2 &= 0\
$

We know that $(A - lambda_1 I)$ is singular since its determinant is $0$ (that's what we solve for), and since $(A - lambda_1 I) x_2$ is equal to a scalar times $x_2$, it must be the case that $x_2$ is in the column space of $(A - lambda_1 I)$. Since the matrix is also singular as mentioned before, it must be the case that the columns of $(A - lambda_1 I)$ are multiples of $x_2$ when $lambda_1 != lambda_2$


= 6.1.15

For the first case:

$
0 &= det(P - lambda I)\
&= det(mat(-lambda, 1, 0; 0, -lambda, 1; 1, 0, -lambda ))\
&= det(mat(-lambda, 1, 0; 0, -lambda, 1; 0, 1 / lambda, -lambda ))\
&= det(mat(-lambda, 1, 0; 0, -lambda, 1; 0, 0, 1 / lambda^2 - lambda ))\
&= -lambda^2 (1 / lambda^2 - lambda) = 1 - lambda^3\
$

Therefore we have solutions:

$ boxed(lambda = (1, - 1 / 2  plus.minus sqrt(3) / 2 i)) $

Then for the second case:

$
0 &= det(P - lambda I)\
&= det(mat(-lambda, 0, 1; 0, 1-lambda, 0; 1, 0, -lambda ))\
&= det(mat(-lambda, 0, 1; 0, 1-lambda, 0; 0, 0, 1/lambda-lambda ))\
&= det(mat(-lambda, 0, 1; 0, 1-lambda, 0; 0, 0, 1/lambda-lambda ))\
&= -lambda (1 - lambda) (1 / lambda - lambda)\
&= (lambda^2 - lambda) (1 / lambda - lambda)\
$

These are equal when $lambda^2 = 1$ and $lambda^2 = lambda$, and the answer cannot be zero as otherwise the second term would be undefined. However, there are two eigenvalues of $1$ as we see from this example, so thus it must be the case that we have another eigenvalue that is also equal to $1$. Additionally we also have an eigenvalue of $-1$ as well. Therefore we have new solutions:

$ boxed(lambda = (1, -1)) $


= 6.1.27

Since all the columns are the same, $A$ must have rank $boxed(1)$. Let us find the eigenvalues of $A$ now. Instead of finding the determinant, we can consider a smarter approach. Imagine the corresponding eigenvector for this eigenvalue. Since the array is all 1s, it must be the case that $sum x = lambda x_i$. There exists the trivial solution with $lambda = 0$, however we scan to find more solutions. The only other scenario where this would hold is if each of the $x_i$ are equal to each other. In that case, we end up with $lambda = 4$ since that is how many times the value gets duplicated. Thus these are our two answers to the first part, $boxed((0, 4))$.

Trivially the rank of the matrix $C$ is $boxed(2)$. Now let us find the eigenvalues of $C$:

$
C &= mat(1, 0, 1, 0; 0, 1, 0, 1; 1, 0, 1, 0; 0, 1, 0, 1)\
0 &= det(C - lambda I)\
&= det(mat(1 - lambda, 0, 1, 0; 0, 1 - lambda, 0, 1; 1, 0, 1 - lambda, 0; 0, 1, 0, 1 - lambda))\
&= det(mat(1 - lambda, 0, 1, 0; 0, 1 - lambda, 0, 1; 0, 0, 1 - lambda, 0; 0, 0, 0, 1 - lambda))\
$

And thus we end up with the unique eigenvalues of $boxed((0, 2))$


= 6.1.36

Notice the substitutions that we are given. We can then rewrite the given formula as:

$
x^T A^T B x + x^T B^T A x
$

We can then apply the Schwarz inequality on both terms, with $u = A x$ and $v = B x$ for the first term, and similar for the second term except switched. We then get:

$
x^T A^T B x + x^T B^T A x &<= ||A x|| ||B x|| + ||B x|| ||A x||\
&<= 2||A x||||B x||
$

And thus we have proven the transition to the right side of the inequality.
