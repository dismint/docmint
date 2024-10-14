#import "template.typ": *
#show: template.with(
  title: "PSET 4",
  subtitle: "18.06",
  pset: true,
  toc: false,
)

#set math.mat(delim: "[")
#set math.vec(delim: "[")

Collaborators: Annie Wang


= 3.5.31

For the incidence matrix, the columns from left to right are the vertices and the rows from top to bottom are the edges:

$
mat(-1, 1, 0, 0; -1, 0, 1, 0; 0, -1, 1, 0; 0, -1, 0, 1; 0, 0, -1, 1; -1, 0, 0, 1)
$

To find the nullspace $bold(N)(A)$, we can see that using the incidence matrix as $A$ in $A x = b$ and setting $b$ to equal $0$, it must be the case that $x_1 = x_2, x_1 = x_3, x_2 = x_3, x_2 = x_4, x_3 = x_4, x_1 = x_4$, meaning that all of the values must be the same. Therefore, the nullspace is defined by $(c, c, c, c)$ vectors.

Thus we know that the rank of the matrix must be equal to $4 - 1 = boxed(3)$

This is an example of a vector in the nullspace:

$ mat(1, 1, 1, 1)^T $

This is an example of a vector in the column space:

$ mat(-1, -1, 0, 0, 0, -1)^T $

This is an example of a vector in the row space:

$ mat(-1, 1, 0, 0) $

This is an example of a vector in the left nullspace:

$ mat(1, 1, 0, 1, 1, -2) $


= 4.1.7

We can use the multipliers $boxed((1, 1, -1))$

$
x_1 - x_2 &= 1\
x_2 - x_3 &= 1\
x_3 - x_1 &= -1
$

Adding all the equations together cancels out the variables on the left side and we are left with $0 = 1$ as desired.


= 4.1.9

If $A^T A x$ = 0 then $A x = 0$. Reason: $A x$ is in the nullspace of $A^T$ and also in the *column space* of $A$ and those spaces are *Orthogonal*. Conclusion: $A x = 0$ and therefore $A^T A$ has the same nullspace as $A$. This key fact will be repeated when we need it.

It must be the case that it is in the column space since the rows of $A$ are just the columns of $A^T$. The nullspace of $A^T$ is orthogonal to the column space of $A^T$


= 4.1.21

We can solve this with $A x = 0$ for:

$ A = mat(1, 2, 2, 3; 1, 3, 3, 2) $

We know that nullspace of a matrix is orthogonal to the row space. The row space in this case is the plane that was desire. Thus by solving this equation we can find the nullspace of the matrix.

$
mat(1, 2, 2, 3; 1, 3, 3, 2) &=\
&= mat(1, 2, 2, 3; 0, 1, 1, -1)\
$

We solve for both free variables.

When $x_3 = 1$ and $x_4 = 0$ we get the vector $boxed(mat(0, -1, 1, 0))$

When $x_3 = 0$ and $x_4 = 1$ we get the vector $boxed(mat(-5, 1, 0, 1))$

Thus these are the two vectors that are orthogonal to the plane, and are also the nullspace of the aforementioned matrix.


= 4.1.30

It must be the case that $dim("row space") + dim("nullspace") = "#rows"$. Thus we know that the most either of the left hand quantities can be is equal to $3$. However, we know that the row space must be at least $1$ assuming that the matrix is not empty. Therefore, the nullspace must be at most $2$, the same can be said about the nullspace to the row space. Thus, since each of them are capped by $2$, it must be the case that $"rank"(A) = "rank"(B) <= 4$.

However, it is also possible that the matrices are zero. If this is the case, we know that because $A$ is a $3 times 4$ matrix, the highest dimension that the row space can be is $3$. Thus if the nullspace is zero, the row space is at most $3$, and the sum of ranks is still at most $4$. Similarly on the other side, if the row space is zero, the nullspace is at most $4$ since $B$ is a $4 times 5$ matrix, and the sum of ranks is still at most $4$.


= 4.2.10

The projection is equal to:

$ p = (1, 2) dot ((1, 0) dot (1, 2)) / ((1, 2) dot (1, 2)) = (1/5, 2/5) $

Then projecting back to $(1, 0)$:

$ p = (1, 0) dot ((1/5, 2/5) dot (1, 0)) / ((1, 0) dot (1, 0)) = (1/5, 0) $

Now let us find the two projection matrices:

$
P_1 &= A (A^T A)^(-1) A^T\
&= mat(1; 0) times mat(1, 0) = mat(1, 0; 0, 0)\
$

Now to find the other projection matrix:

$
P_2 &= A (A^T A)^(-1) A^T\
&= (mat(1; 2) times mat(1, 2)) / 5 = mat(1/5, 2/5; 2/5, 4/5)\
$

Now let us multiply the two projection matrices:

$
P_1 P_2 &= mat(1, 0; 0, 0) times mat(1/5, 2/5; 2/5, 4/5)\
&= mat(1/5, 2/5; 0, 0)\
$

The resulting matrix is NOT a projection matrix because squaring it does not yield itself.

This is the image of all the projections:

#bimg("imgs/projection.png")


= 4.2.14

The projection matrix is equal to:

$
A^T A &= mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0;) times mat(1, 0, 0; 0, 1, 0; 0, 0, 1; 0, 0, 0) = mat(1, 0, 0; 0, 1, 0; 0, 0, 1)\
(A^T A)^(-1) &= mat(1, 0, 0; 0, 1, 0; 0, 0, 1)\
A (A^T A)^(-1) A^T &= mat(1, 0, 0; 0, 1, 0; 0, 0, 1; 0, 0, 0) times mat(1, 0, 0; 0, 1, 0; 0, 0, 1) times mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0)\
&= mat(1, 0, 0; 0, 1, 0; 0, 0, 1; 0, 0, 0) times mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0)\
&= mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 0)\
$

Thus the projection of $(1, 2, 3, 4)^T$ onto this matrix is:

$
mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 0) times mat(1, 2, 3, 4)^T = mat(1, 2, 3, 0)^T
$

P is a projection matrix that does amazing things and has a shape of $4 times 4$. Its most notable achievements include projecting vectors onto $RR^3$.


= 4.2.27

If the square of matrix $A$ is itself, then it must be the case that $A (A x) = A x$

Thus, $A$ acts as a projection matrix. We know that $A$ also has a rank equal to its number of rows and columns. Therefore, it must be the case that this projection matrix is of full rank. If that is the case, it *must* be the identity matrix, since it is the only matrix that is of full rank and is a projection matrix.
