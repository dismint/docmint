#import "template.typ": *
#show: template.with(
  title: "PSET 5",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

Collaborators: Annie Wang

= 4.3.1

Let us do some calculations on the left side of the equation $A^T A hat(x) = A^T b$

$
A &= mat(1, 0; 1, 1; 1, 3; 1, 4)\
A^T &= mat(1, 1, 1, 1; 0, 1, 3, 4)\
A^T A &= mat(1, 1, 1, 1; 0, 1, 3, 4) mat(1, 0; 1, 1; 1, 3; 1, 4)\
&= mat(4, 8; 8, 26)\
$

Now we do the right side:

$
b &= mat(0; 8; 8; 20)\
A^T b &= mat(1, 1, 1, 1; 0, 1, 3, 4) mat(0; 8; 8; 20)\
&= mat(36; 112)\
$

Thus we end up with the equation:

$
mat(4, 8; 8, 26) mat(C; D) &= mat(36; 112)\
mat(4, 8; 0, 10) mat(C; D) &= mat(36; 40)\
$

Therefore $boxed(D = 4), boxed(C = 1)$

The four heights are then:
$ p_1, p_2, p_3, p_4 = 1, 5, 13, 17 $

And then the errors are:

$ vec(0, 8, 8, 20) - vec(1, 5, 13, 17) &= vec(-1, 3, -5, 3)\ $

And the sum of the squares of the errors is $ (-1)^2 + (3)^2 + (-5)^2 + (3)^2 = 1 + 9 + 25 + 9 = boxed(44) $


= 4.3.12

== (a)

Let us solve for $hat(x)$

$
a^T a hat(x) &= a^T b\
m hat(x) &= b_1 + dots + b_m\
hat(x) &= (b_1 + dots + b_m) / m\
$

Thus we have shown that $hat(x)$ is the average of the $b_i$

== (b)

Now let us solve for $e$

$
e &= b - a hat(x)\
&= b - a hat(x)\
&= boxed(vec(b_1 - hat(x), dots.v, b_m - hat(x)))\
$

Therefore the variance $||e||^2$ is:
$ ||e||^2 = boxed(sum_(i=1)^m (b_i - hat(x))^2)\ $

And the standard deviation $||e||$ is:
$ ||e|| = boxed(sqrt(sum_(i=1)^m (b_i - hat(x))^2))\ $

== (c)

The error vector must be:
$ vec(3, 3, 3) - vec(1, 2, 6) &= boxed(vec(2, 1, -3))\ $

And thus the dot product with $p = (3, 3, 3)$ is:
$ vec(2, 1, -3) dot vec(3, 3, 3) = 6 + 3 - 9 = boxed(0) $

Now we will find the projection matrix of $(1, dots, 1)$

$
P &= A (A^T A)^(-1) A^T\
&= vec(1, dots.v, 1) (vec(1, dots.v, 1)^T vec(1, dots.v, 1))^(-1) vec(1, dots.v, 1)^T\
&= (vec(1, dots.v, 1) vec(1, dots.v, 1)^T) / m\
&= mat(1/m, dots_m, 1/m; dots.v_m, dots.down_m, dots.v_m; 1/m, dots_m, 1/m)\
$

Thus for this specific $3 times 3$:

$ P &= boxed(mat(1/3, 1/3, 1/3; 1/3, 1/3, 1/3; 1/3, 1/3, 1/3))\ $


= 4.3.17

We have $b = (7, 7, 21)$ for $t = (-1, 1, 2)$

Our three equations for the line $b = C + D t$ are then:

$
7 &= C - D\
7 &= C + D\
21 &= C + 2D\
$

Then we will find the least squares solution for $C$ and $D$:

$
A &= mat(1, -1; 1, 1; 1, 2)\
A^T &= mat(1, 1, 1; -1, 1, 2)\
A^T A &= mat(3, 2; 2, 6)\
A^T b &= vec(35, 42)\
mat(3, 2; 2, 6) mat(C; D) &= vec(35, 56/3)\
mat(3, 2; 0, 14/3) mat(C; D) &= vec(35, 56/3)\
$

Thus we have $D = 4$ and $C = 9$

#bimg("imgs/lss.png")


= 4.3.18

The projection is equal to:

$
p &= mat(1, -1; 1, 1; 1, 2) vec(9, 4)\
&= vec(5, 13, 17)\
$

Then the error vector is:

$
e &= vec(7, 7, 21) - vec(5, 13, 17)\
&= vec(2, -6, 4)\
$

It must be the case that $P e = 0$ since we want to minimize the error, so thus, it must be the case that they are orthogonal, and the dot product is equal to zero.


= 4.4.2

The lengths of the vectors are $sqrt(4 + 4 + 1) = 3$ and $sqrt(1 + 4 + 4) = 3$. We then have our orthogonal vectors:

$
q_1 &= vec(2/3, 2/3, -1/3)\
q_2 &= vec(-1/3, 2/3, 2/3)\
$

Resulting in the matrix:
$ Q &= mat(2/3, -1/3; 2/3, 2/3; -1/3, 2/3) $

Now we will calculate the two matrix products:

$
Q^T Q &= mat(2/3, 2/3, -1/3; -1/3, 2/3, 2/3) mat(2/3, -1/3; 2/3, 2/3; -1/3, 2/3)\
&= boxed(mat(1, 0; 0, 1))\
$

$
Q Q^T &= mat(2/3, -1/3; 2/3, 2/3; -1/3, 2/3) mat(2/3, 2/3, -1/3; -1/3, 2/3, 2/3)\
&= boxed(mat(5/9, 2/9, -4/9; 2/9, 8/9, 2/9; -4/9, 2/9, 5/9))\
$


= 4.4.5

We want to find two orthogonal vectors in the plane $x + y + 2z = 0$

We can simply set one vector as:
$ vec(1, -1, 0) $

Thus we can find another vector simply by setting the first two to cancel out and the third to match the plane equation since we have a zero to work with in the first vector:
$ vec(1, 1, -1) $

To make them orthonormal, we can divide by the length of the vector, which are $sqrt(2), sqrt(3)$

Thus we have the two vectors:

$
v_1 &= boxed(vec(1/sqrt(2), -1/sqrt(2), 0))\
v_2 &= boxed(vec(1/sqrt(3), 1/sqrt(3), -1/sqrt(3)))\
$


= 4.4.7

We have $Q x = b$ where $Q$ is the matrix of orthonormal columns. Transforming this into the least squares solution form we get:
$ Q^T Q x = Q^T b $

But we know that the columns of $Q$ are orthonormal, so $Q^T Q = I$, and thus we have:
$ x = boxed(Q^T b) $


= 4.4.18

We have the three vectors:
$
a = (1, -1, 0, 0)\
b = (0, 1, -1, 0)\
c = (0, 0, 1, -1)\
$

Let us start by setting $A = a$. Then we can calculate $B$ as follows:

$
B &= b - (A^T b) / (A^T A) A\
A &= boxed(vec(1, -1, 0, 0))\
A^T &= mat(1, -1, 0, 0)\
A^T A &= mat(1, -1, 0, 0) vec(1, -1, 0, 0)\
&= 2\
A^T b &= mat(1, -1, 0, 0) vec(0, 1, -1, 0)\
&= -1\
B &= b + 1/2 vec(1, -1, 0, 0)\
&= vec(0, 1, -1, 0) + vec(1/2, -1/2, 0, 0)\
B &= boxed(vec(1/2, 1/2, -1, 0))\
$

Next let us solve for $C$:

$
C &= c - (A^T c) / (A^T A) A - (B^T c) / (B^T B) B\
A &= vec(1, -1, 0, 0)\
B &= vec(1/2, 1/2, -1, 0)\
A^T &= mat(1, -1, 0, 0)\
B^T &= mat(1/2, 1/2, -1, 0)\
A^T A &= 2\
B^T B &= 3/2\
A^T c &= mat(1, -1, 0, 0) vec(0, 0, 1, -1)\
&= 0\
B^T c &= mat(1/2, 1/2, -1, 0) vec(0, 0, 1, -1)\
&= -1\
C &= c + 2/3 vec(1/2, 1/2, -1, 0)\
&= vec(0, 0, 1, -1) + 2/3 vec(1/2, 1/2, -1, 0)\
C &= boxed(vec(1/3, 1/3, 1/3, -1))\
$

