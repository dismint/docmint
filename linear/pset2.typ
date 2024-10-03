#import "template.typ": *
#show: template.with(
  title: "PSET 2",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")

Collaborators: Annie Wang

= Problem 2.1.3

You should subtract $-1/2$ times the first row to cancel out the $x$ in the second equation.

Thus in matrix form you will end up with:

$ mat(2, 4; 0, 3) = mat(6; 3) $

Which will solve out to $x, y = boxed((5, 1))$

If you switch the right side to $(-6, 0)$ then you will get:

$ mat(2, 4; 0, 3) = mat(-6; -3) $

Which will solve out to $x, y = boxed((-5, -1))$

= Problem 2.1.10

#bimg("pset2graph.png")

The line that goes through the solutions of the equations has an equation of $boxed(5x - 4y = 16)$

= Problem 2.2.1

== (a)

$ boxed(mat(5, 5, 5; 25, 1, 1; 0, 0, 1)) $

== (b)

$ boxed(mat(1, 1, 1; 0, 1, 1; 0, -7, 1)) $

== (c)

$ boxed(mat(0, 0, 1; 1, 0, 0; 0, 1, 0)) $

= Problem 2.2.3

$
E_(21) &= mat(1, 0, 0; -4, 1, 0; 0, 0, 1)\
E_(31) &= mat(1, 0, 0; 0, 1, 0; 2, 0, 1)\
E_(32) &= mat(1, 0, 0; 0, 1, 0; 0, -2, 1)\
$

Now we multiply all the elimination steps together to get the overall elimination matrix:

$
E &= E_(32)E_(31)E_(21)\
&= mat(1, 0, 0; 0, 1, 0; 0, -2, 1)mat(1, 0, 0; 0, 1, 0; 2, 0, 1)mat(1, 0, 0; -4, 1, 0; 0, 0, 1)\
&= mat(1, 0, 0; 0, 1, 0; 2, -2, 1)mat(1, 0, 0; -4, 1, 0; 0, 0, 1)\
&= boxed(mat(1, 0, 0; -4, 1, 0; 10, -2, 1))\
$

This leads to an inverse of:

$ E^(-1) = L = boxed(mat(1, 0, 0; 4, 1, 0; -2, 2, 1)) $

= Problem 2.2.12

== (left)

$ P^(-1) = boxed(mat(0, 0, 1; 0, 1, 0; 1, 0, 0)) $

== (right)

$ P^(-1) = boxed(mat(0, 0, 1; 1, 0, 0; 0, 1, 0)) $

= Problem 2.2.20

$
C &= A B\
A^(-1) C &= A^(-1) A B\
A^(-1) C &= B\
A^(-1) C C^(-1) &= B C^(-1)\
A^(-1) &= boxed(B C^(-1))\
$

= Problem 2.2.34

Subtract the second row from the last row, and the first row from the second row to get the following:

$
A &= mat(a, b, b; a, a, b; a, a, a)\
&= mat(a, b, b; a, a, b; 0, 0, a-b)\
&= mat(a, b, b; 0, a-b, 0; 0, 0, a-b)\
$

We have now shown that the pivots are not zero, meaning that the matrix must have an inverse. The pivots are $a, a-b, a-b$.

For matrix $C$, we can choose the numbers $boxed((0, 2, 7))$

These all work because we create matrices that are not linearly independent. The latter two simply create two identical rows and columns respectively, and having an entire row of zeros trivially means that the matrix is dependent. We know that in order for a matrix to be invertible, it must be the case that all of the rows / columns are linearly independent, thus these choices for $c$ will result in a matrix that cannot be inverted.

= Problem 2.3.3

$
E &= boxed(mat(1, 0, 0; 0, 1, 0; -3, 0, 1))\
E A &= mat(2, 1, 0; 0, 4, 2; 0, 0, 5)\
E^(-1) &= boxed(mat(1, 0, 0; 0, 1, 0; 3, 0, 1))
$

Now we factor $A$

$
E A &= U\
A &= E^(-1) U\
&= mat(1, 0, 0; 0, 1, 0; 3, 0, 1)mat(2, 1, 0; 0, 4, 2; 0, 0, 5)\
&= boxed(mat(2, 1, 0; 0, 4, 2; 6, 3, 5))\
$

= Problem 2.3.7

$
E_(43) &= mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, -1, 1)\
E_(32) &= mat(1, 0, 0, 0; 0, 1, 0, 0; 0, -1, 1, 0; 0, 0, 0, 1)\
E_(21) &= mat(1, 0, 0, 0; -1, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1)\
E_(43) E_(32) E_(21) = E &= mat(1, 0, 0, 0; -1, 1, 0, 0; 0, -1, 1, 0; 0, 0, -1, 1)\
E A = U &= boxed(mat(a, a, a, a; 0, b-a, b-a, b-a; 0, 0, c-b, c-b; 0, 0, 0, d-c))\
$

Calculating the inverse of $E$:

$ E^(-1) = L = boxed(mat(1, 0, 0, 0; 1, 1, 0, 0; 1, 1, 1, 0; 1, 1, 1, 1)) $

In order for all four pivots to exist, we require that the diagonal must be non zero. For this to happen, it must be the case that:

+ $a != 0$
+ $b != a$
+ $c != b$
+ $d != c$

= Problem 2.4.1

== (a)

$
A &= mat(1, 0; 9, 3)\
A^T &= mat(1, 9; 0, 3)\
A^(-1) &= mat(1, 0; -3, 1/3)\
(A^(-1))^T &= mat(1, -3; 0, 1/3)\
(A^T)^(-1) &= mat(1, -3; 0, 1/3)\
$

== (b)

$
A &= mat(1, c; c, 0)\
A^T &= mat(1, c; c, 0)\
A^(-1) &= mat(0, 1/c; 1/c, -1/c^2)\
(A^(-1))^T &= mat(0, 1/c; 1/c, -1/c^2)\
(A^T)^(-1) &= mat(0, 1/c; 1/c, -1/c^2)\
$
