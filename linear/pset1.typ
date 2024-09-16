#import "template.typ": *
#show: template.with(
  title: "Typst",
  subtitle: "Justin Choi",
  pset: true,
)

- $sum_(i=0)^20$

Collaborators: Annie Wang


= 1.1 (4)

#bimg("4.png")

= 1.1 (14)

#set enum(numbering: "a.")

+ The sum of twelve vectors is $boxed(0)$ because for each vector there is an opposite negative vector that cancels it out, for example the 2:00 vector is cancelled out by the 8:00 vector.
+ Similar to above, since nothing cancels 8:00 out but all other vectors cancel each other out, the result will be the 8:00 vector.
+ $boxed(theta = 30 degree)$

= 1.1 (24)

+ *Corners*: $2^4 = boxed(16)$ 
+ *Volume*: $2^4 = boxed(16)$
+ *3D-Faces*: $2 dot n = boxed(8)$
+ *Edges*: Each vertex has $4$ possible edges, and each edge is overcounted twice, so there are $(16 dot 4) / 2  = boxed(32)$ edges.
+ *Example Edge*: $(-1, -1, -1, -1)$ to $(-1, -1, -1, 1)$

= 1.2 (1)

- $bold(u) dot bold(v) = boxed(0)$
- $bold(u) dot bold(w) = boxed(1)$
- $bold(u) dot (bold(v) + bold(w)) = boxed(1)$
- $bold(w) dot bold(v) = boxed(10)$

= 1.2 (2)

- $||u|| = boxed(1)$
- $||v|| = boxed(5)$
- $||w|| = boxed(sqrt(5))$

Schwarz Inequalities 

- $boxed(0 <= 5)$
- $boxed(10 <= 5 dot sqrt(5))$

= 1.2 (24)

Suppose our sides are of length $x, y, a, b$. Now say that we have one side of the parallelogram $bold(v) = (a, b)$ and the other side $bold(w) = (x, y)$. Then we have that $c = (v + w) = (a+x, b+y)$ and $d = (v - w) = (a-x, b-y)$.

The squared diagonal lengths are:
- $||bold(c)||^2 = a^2 + 2a x + x^2 + b^2 + 2b y + y^2$
- $||bold(d)||^2 = a^2 - 2a x + x^2 + b^2 - 2b y + y^2$

Thus we have that $||bold(v) + bold(w)||^2 + ||bold(v) + bold(w)||^2 = boxed(2a^2 + 2x^2 + 2b^2 + 2y^2)$

Now let us calculate the sum of the four squared side lengths:

$
2||bold(v)||^2 + 2||bold(w)||^2&=\
&= 2(a, b)^2 + 2(x, y)^2\
&= 2(a^2+b^2+x^2+y^2)\
&= boxed(2a^2 + 2x^2 + 2b^2 + 2y^2)
$

Thus the two results are equal and we have shown the squared diagonal lengths are equal to the sum of the four squared side lengths.


= 1.3 (8)

- $A$: All of $boxed(bb(R)^3)$
- $B$: Since they are multiples of each other, it describes a line $boxed(bb(R)^1)$.
- $C$: Because there is no set of three vectors that are linearly independent, it describes $boxed(bb(R)^2)$, since two of them are linearly independent.

= 1.3 (17)

#let bbx(x) = box(outset: (y: 200pt))[$#x$]

- *Rank 0* $A = bbx(vec(1, 1)), B = vec(-1, -1), A + B = vec(0, 0)$
- *Rank 1* $A = vec(1, 1), B = vec(1, 1), A + B = vec(2, 2)$
- *Rank 2* $A = mat(1, 1; 1, 1), B = mat(2, 4; 3, 6), A + B = mat(3, 5; 4, 7)$

Imagine that $A$ and $B$ are infinite lines. The matrices $A$ and $B$ simply contain possible vectors in that infinite line. Therefore, the columns of of $A+B$ must all be vectors that lie in the plane defined by these infinite lines. Thus, if all columns of $A+B$ lie in the same plane, it is impossible for the rank to be greater than 2.

= 1.3 (21)

$
y_1 &= boxed(c_1)\
y_1 + y_2 &= c_2\
y_1 + y_2 + y_3 &= c_3\
y_2 &= boxed(c_2 - c_1)\
y_3 &= boxed(c_3 - c_2)
$

$
boxed(A dot c = vec(c_1, c_2-c_1, c_3-c_2))
$

The columns of $S$ are independent because no pair are dependent. In addition, the inverse matrix exists, which means that the matrix is independent.

= 1.4 (3)

== First Case

$
boxed(mat(1, 0, 0; 0, 1, 0; 1, 0, 1))
$

== Second Case

$ boxed(mat(32)) $

== Third Case

$ boxed(mat(4, 8, 12; 5, 10, 15; 6, 12, 18)) $

= 1.4 (14)

== Rank One

$ boxed(mat(3, 6; 5, 10)) $

== Orthogonal

$ boxed(mat(6, 7; 7, -6)) $

== Rank 2

$ boxed(mat(2, 0; 3, 6)) $

== Identity

$ boxed(mat(3, 4; -2, -3)) $

= 1.4 (17)

== a

$
A = mat(1, 2, 3; 1, 2, 3;1, 2, 3)\
B = mat(1, 1, 1;1, 1, 1;-1,-1,-1)
$

In the above case, the matrix $A B$ is zeroed out, and so the rank is $boxed(0)$

#boxed("False")

== b

If $A$ and $B$ have rank 3, then it must be the case that there is no such $A x$ or $B x$ where $x$ is a non-zero vector and the result is of the multiplication is zero. That is, they are linearly independent. If $A B$ were not rank 3, then $A B x$ must have a non-zero solution that equals zero. However, we know that there is no $B x$ such that it is equal to zero, and same for $A x$, so it is impossible for the rank to be anything but 3.

#boxed("True")

== c

Let us find some $B$s such that they impose restrictions on $A$. Suppose $A = mat(a, b; c, d)$

$
B &= mat(1, 0; 0, 0)\
A B &= mat(a, 0; c, 0)\
B A &= mat(a, b; 0, 0)\
mat(a, 0; c, 0) &= mat(a, b; 0, 0)\
$

We learn that it must be the case that $a=a$ (trivial) and that $b, c=0$

$
B &= mat(0, 1; 0, 0)\
A B &= mat(0, a; 0, c)\
B A &= mat(c, d; 0, 0)\
mat(0, a; 0, c) &= mat(c, d; 0, 0)\
$

We learn that it must be the case that $c=0$ and that $a=d$

Thus we have arrived with these conditions that $A = mat(c, 0; 0, c)=c I$. It is impossible to impose more restrictions on $A$ since any other conditions without $0$ would have unresolvable equations. Thus, only these matrices of $A$ can commute with every $B$

#boxed("True")
