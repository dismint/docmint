#import "template.typ": *
#show: template.with(
  title: "PSET 3",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

Collaborators: Annie Wang

= 3.1.5

== (a)

Consider the subspace of $bold(M)$ that is described by all $2 times 2$ matrices such that:

$ mat(R, 0; 0, 0) $

This subspace would contain $bold(A)$ but not $bold(B)$

== (b)

Yes. If the subspace contains $bold(B)$, then it must also be the case that it contains:

$ -1 dot mat(0, 0; 0, -1) = mat(0, 0; 0, 1) $ 

And thus by addition of two matrices in the subspace, it must contain the identify matrix:

$ mat(1, 0; 0, 0) + mat(0, 0; 0, -1) = mat(1, 0; 0, 1) $

== (c)

We make a similar subspace as in *(a)* but with the following $2 times 2$ matrices:

$ mat(0, R; 0, 0) $

This is a valid subspace but with no non-zero diagonals in it.


= 3.1.20

Unless $b$ is a linear combination of already existing columns in $A$

== Increasing Column Space

$ mat(1, 1; 0, 0) mat(0; 1) $

== No Change Column Space

$ mat(1, 0; 0, 1) mat(1; 1) $

In order for $A x = b$ to be solvable, it must be the case that $b$ can be represented as a linear combination of the columns of $A$ (this is what $x$ represents). Of course, this means that adding $b$ would *not* increase the column space of $A$


= 3.2.4

== (a)

$
mat(1, 2, 2, 4, 6; 1, 2, 3, 6, 9; 0, 0, 1, 2, 3) &= mat(1, 2, 2, 4, 6; 0, 0, 1, 2, 3; 0, 0, 1, 2, 3)\
&= boxed(mat(1, 2, 2, 4, 6; 0, 0, 1, 2, 3; 0, 0, 0, 0, 0)) = R\
C &= boxed(mat(1, 0, 0; 1, 1, 0; 0, 1, 0))
$

== (b)

$
mat(2, 4, 2; 0, 4, 4; 0, 8, 8) &= boxed(mat(2, 4, 2; 0, 4, 4; 0, 0, 0)) = R\
C &= boxed(mat(1, 0, 0; 0, 1, 0; 0, 2, 0))
$


= 3.2.5

There are three free columns when $1$-indexing, $(2, 4, 5)$. Let us solve each of the systems by setting the variable we are looking for to $1$ and all other free variables to $0$:

== Free Column 2

We need to solve the system:

$ mat(1, 2, 2, 4, 6; 0, 0, 1, 2, 3; 0, 0, 0, 0, 0) times mat(a, 1, c, 0, 0)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a + 2c &= 2\
c &= 0\
$

Thus we have our solutions:

$
boxed(a = 2)\
boxed(c = 0)
$

== Free Column 4

We need to solve the system:

$ mat(1, 2, 2, 4, 6; 0, 0, 1, 2, 3; 0, 0, 0, 0, 0) times mat(a, 0, c, 1, 0)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a + 2c &= 4\
c &= 2\
$

Thus we have our solutions:

$
boxed(a = 0)\
boxed(c = 2)
$

== Free Column 5

We need to solve the system:

$ mat(1, 2, 2, 4, 6; 0, 0, 1, 2, 3; 0, 0, 0, 0, 0) times mat(a, 0, c, 0, 1)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a + 2c &= 6\
c &= 3\
$

Thus we have our solutions:

$
boxed(a = 0)\
boxed(c = 3)
$

Thus the nullspaces of $A$ are:

$
boxed(mat(2, 1, 0, 0, 0)^T)\
boxed(mat(0, 0, 2, 1, 0)^T)\
boxed(mat(0, 0, 3, 0, 1)^T)
$


= 3.2.13

We can rearrange the equation for the plane such that:

$ x = 3 y + z + 12 $

Thus all points on the plane take the form of:

$ boxed(vec(x, y, z) = vec(12, 0, 0) + y vec(3, 1, 0) + z vec(1, 0, 1)) $


= 3.2.27

For $bold(C)$, the nullspace would have to be a combination of the nullspaces of $bold(A)$ and $bold(B)$. One part of the $bold(C)$ nullspace would have to be the nullspace of $bold(A)$ (think the top half of any potential $bold(x)$ that satisfies the nullspace for $bold(C)$), and the bottom half would have to be a corresponding nullspace of $bold(B)$. Thus the nullspace of $bold(C)$ can be seen as the intersection between the two nullspaces, or:

$ boxed(bold(N)(C) = bold(N)(A) sect bold(N)(B)) $


= 3.2.35

$
A^T = mat(-1, 0, 1, -1, 0, 0; 1, -1, 0, 0, -1, 0; 0, 1, -1, 0, 0, -1; 0, 0, 0, 1, 1, 1) &=\
&= mat(1, 0, -1, 1, 0, 0; 1, -1, 0, 0, -1, 0; 0, 1, -1, 0, 0, -1; 0, 0, 0, 1, 1, 1)\
&= mat(1, 0, -1, 1, 0, 0; 0, -1, 1, -1, -1, 0; 0, 1, -1, 0, 0, -1; 0, 0, 0, 1, 1, 1)\
&= mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 1, -1, 0, 0, -1; 0, 0, 0, 1, 1, 1)\
&= mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, -1, -1, -1; 0, 0, 0, 1, 1, 1)\
&= mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1; 0, 0, 0, 1, 1, 1)\
&= mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1; 0, 0, 0, 0, 0, 0)\
&= mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1)
$

We have free 1-indexed columns in $(3, 5, 6)$

== Free Column 3

We need to solve the system:

$ mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1) times mat(a, b, 1, c, 0, 0)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a - 1 + c &= 0\
b - 1 + c &= 0\
c &= 0\
$

Thus we have our solutions:

$
boxed(a = 1)\
boxed(b = 1)\
boxed(c = 0)
$

== Free Column 5

We need to solve the system:

$ mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1) times mat(a, b, 0, c, 1, 0)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a + c &= 0\
b + c + 1 &= 0\
c + 1 &= 0\
$

Thus we have our solutions:

$
boxed(a = 1)\
boxed(b = 0)\
boxed(c = -1)
$

== Free Column 6

We need to solve the system:

$ mat(1, 0, -1, 1, 0, 0; 0, 1, -1, 1, 1, 0; 0, 0, 0, 1, 1, 1) times mat(a, b, 0, c, 0, 1)^T = mat(0, 0, 0)^T $

This leaves us with the equations:

$
a + c &= 0\
b + c &= 0\
c + 1 &= 0\
$

Thus we have our solutions:

$
boxed(a = 1)\
boxed(b = 1)\
boxed(c = -1)
$

Thus the nullspaces of $A^T$ are:

$
boxed(mat(1, 1, 1, 0, 0, 0)^T)\
boxed(mat(1, 0, 0, -1, 1, 0)^T)\
boxed(mat(1, 1, 0, -1, 0, 1)^T)
$


= 3.3.1

== Step 1

$
A = mat(2, 4, 6, 4; 2, 5, 7, 6; 2, 3, 5, 2) &= mat(2, 4, 6, 4; 0, 1, 1, 2; 2, 3, 5, 2)\
&= mat(2, 4, 6, 4; 0, 1, 1, 2; 0, -1, -1, -2)\
&= mat(2, 4, 6, 4; 0, 1, 1, 2; 0, 0, 0, 0)
$

Thus taking the same steps our $c$ becomes:

$ mat(4, -1, 0)^T $

== Step 2

$ b_3 - 2 b_1 + b_2 $

== Step 3

The column space of $A$ is the plane consisting of all the linear combinations of the columns in the pivots of $U$. That is, $(2, 2, 2)$ and $(4, 5, 3)$

== Step 4

The special solutions have the free variables in the third and forth column of the resulting matrix from step 1. Substituting in, we get that our two solutions are:

$
s_1 = mat(-1, -1, 1, 0)^T\
s_2 = mat(2, -2, 0, 1)^T\
$

Thus the nullspace is the span of these two vectors in $RR^4$

== Step 5

To get the reduced form, we can simplify to the following:

$ mat(1, 0, 1, 0; 0, 1, 1, 2; 0, 0, 0, 0) $

This gives us $d$ as:

$ mat(4, -1, 0)^T $

== Step 6

Thus this gives us the particular solution as:

$ x = mat(4, -1, 0, 0)^T $

Meaning that our complete solution is:

$ x = boxed(mat(4, -1, 0, 0)^T + c_1 mat(-1, -1, 1, 0)^T + c_2 mat(2, -2, 0, 1)^T) $


= 3.3.3

== (a)

$
mat(1, 3, 7; 2, 6, 14) &= mat(1, 3, 7; 0, 0, 0)\
$

Our nullspace solutions are therefore:

$ mat(-3, 1)^T $

The particular solution at the end will be:

$ mat(7, 0) $

Meaning that our complete solution is:

$ x = boxed(mat(7, 0)^T + c mat(-3, 1)^T) $

== (b)

$
mat(1, 3, 3, 1; 2, 6, 9, 5; -1, -3, 3, 5) &= mat(1, 3, 3, 1; 0, 0, 3, 3; -1, -3, 3, 5)\
&= mat(1, 3, 3, 1; 0, 0, 3, 3; 0, 0, 6, 6)\
&= mat(1, 3, 3, 1; 0, 0, 3, 3; 0, 0, 0, 0)\
&= mat(1, 3, 0, -2; 0, 0, 1, 1; 0, 0, 0, 0)\
$

Our nullspace solutions are therefore:

$ mat(-3, 1, 0)^T $

The particular solution at the end will be:

$ mat(-2, 0, 1) $

Meaning that our complete solution is:

$ x = boxed(mat(-2, 0, 1)^T + c mat(-3, 1, 0)^T) $


= 3.3.10

Start off with a matrix that needs one of each column for the nullspace (or any similar multiple of each):

$
A = boxed(mat(1, 0, -1; 1, -1, 0))
$

Then to construct $b$ such that the particular solution is $(2, 4, 0)$, we can make $A$ into RREF:

$
mat(1, 0, -1; 1, -1, 0) &= mat(1, 0, -1; 0, -1, 1)\
&= mat(1, 0, -1; 0, 1, -1)\
$

Thus a particular solution leaves us with a $d$ of:

$ mat(2, 4)^T $

Then to get the original $b$, we need to undo our steps, leading to:

$ b = boxed(mat(2, -2)^T) $


= 3.3.28

== (a)

Such matrix exists when:

$ A = boxed(mat(1, 1; 1, 2; 1, 3)) $

== (b)

No, such a matrix $bold(B)$ does not exist because if it did, the dimensions would have to be $2 times 3$. In a matrix with such dimensions resulting in a $3 times 1$ solution, it would cause a problem as it is impossible for the column space of $bold(B)$ to be more than $RR^2$. Thus, it must be the case that with three column vectors, there is not one unique solution, and there exist infinitely many solutions. We use column space here as the $x$ in $A x = b$ results in us doing a linear combination of the three column vectors.


= 3.4.1

Putting the first three vectors together, we get:

$
mat(1, 1, 1; 0, 1, 1; 0, 0, 1)
$

Which is an upper triangular matrix that we know has one unique solution as it is invertible. Thus it *must* be the case that the columns (and rows!) are linearly independent.

It is impossible that adding a fourth vector in $RR^3$ would still leave the columns linearly independent because vectors of $RR^3$ can at most represent a vector space of $RR^3$ - $v_4$ would have to be a linear combination of the previous column vectors.

Let us solve for when this is equal to $0$:

$
mat(1, 1, 1, 2; 0, 1, 1, 3; 0, 0, 1, 4) times mat(a, b, c, d)^T = mat(0, 0, 0)^T
$

We can start by setting the last free variable equal to $1$, leaving us with $v_3 = -4$, $v_2 = 1$, and $v_1 = 1$. This our final solution is:

$ x = boxed(mat(1, 1, -4, 1)^T) $


= 3.4.16

== (a)

$
boxed(mat(1; 1; 1; 1));
$

== (b)

$
boxed(mat(1, 1, 1; -1, 0, 0; 0, -1, 0; 0, 0, -1));
$

== (c)

$
boxed(mat(1, 1; -1, -1; -1, 0; 0, -1));
$

== (d)

$
boxed(mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1));
$


= 3.4.29

== Column Basis

$
mat(1, 0, 0; -1, 0, 0), mat(0, 1, 0; 0, -1, 0), mat(0, 0, 1; 0, 0, -1)
$

== Row Basis Too

$
mat(1, -1, 0; -1, 1, 0), mat(1, 0, -1; -1, 0, 1)
$
