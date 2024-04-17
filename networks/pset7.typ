#import "template.typ": *
#show: template.with(
  title: "14.15 PSET 7",
  subtitle: "Justin Choi",
  pset: true,
)

= Problem 1

== (a)

Assume for this question that we have a uniform distribution of consumers within the range $[0, 1]$. A customer will choose the product if their willingness to pay is at least as great as the price:

$ (1-x) dot z >= 1 / 4 $

Because we want the system to be at equilibrium, we can assume that the equilibrium value will result in the proportion of buyers being the same as the cutoff for who is willing to buy the product (since the distribution is uniform). Thus we can turn this into a quadric and solve as follows:

$
(1-z) dot z &= 1 / 4\
0 &= z^2 - z + 1 / 4\
0 &= 4z^2 - 4 z + 1
$

The last step normalizes the numbers to make them easier to work with. Thus we solve with the quadratic formula where $a = 4, b = -4, c = 1$:

$
z &= (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a)\
&= (4 plus.minus sqrt(16 - 16)) / (8)\
&= (4 plus.minus sqrt(0)) / (8)\
&= boxed(1 / 2)
$

Thus in this first case where the cost of the good is $1/4$, there exists exactly one equilibrium number, which occurs at $z = 1/2$

== (b)

Let us now repeat the same process, but with a cost of $2/9$:

$
(1-z) dot z &= 2 / 9\
0 &= z^2 - z + 2 / 9\
0 &= 9z^2 - 9 z + 2
$

Again, we solve with the quadratic formula where $a = 9, b = -9, c = 2$:

$
z &= (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a)\
&= (9 plus.minus sqrt(81 - 72)) / (18)\
&= (9 plus.minus sqrt(9)) / (18)\
&= (9 plus.minus 3) / (18)\
&= boxed((1 / 3, 2 / 3))
$

Thus in this second case where the cost of the good is $2/9$, there exists two equilibrium numbers, which occur at $z = 1/3, 2/3$

== (c)

At a price of $1/4$, this seems to be the perfect price at which there is a clear and even split amongst the consumers for either purchasing or not purchasing the product. When the price lowers slightly to $2/9$, we see that there are now two equilibrium points instead of two. This happens because the price is lower, meaning that there is an interesting network effect from having more people be able to afford the good. Because the equilibrium point is below this critical mark of $1/4$, there is now a majority of people who want to partake in the purchase of this good. However, there is of course the related network effect $z$, which is why we see two different points of equilibrium.

== (d)

In *(a)*, if the proportion of people using the good slightly shifts, then so will the willingness to pay. Think about the middle person with value $1/2$. If the proportion of people using the good increases, then that persons willingness to pay will increase as well. The same goes in the opposite direction. Thus the equilibrium point found in *(a)* cannot be stable.

In general, this is also true for *(b)*. If the proportion of people using the good shifts, then the willingness to pay will also shift in the same direction. This is because the willingness to pay is directly related to the proportion of people using the good. Thus the equilibrium points found in *(b)* cannot be stable either.

= Problem 2

== (a)

Recall the potential functions presented in Lecture 14. I will be making use of this in my proof of this question. We can view any given latency function as the following sum:

$ l_(j)(x) = sum_(i=0)^(k) a_(j i)x^i $

Now let us define a potential function using the integral of the latency function:

$
phi(x) &= integral_(0)^(x) l_(j)(t) d t\
&= sum_(i=0)^(k) 1 / (k+1) a_(j i)  x^(t+1) >= 1 / (k+1) sum_(i=0)^(k) a_(j i) x^(t+1)\
&= 1 / (k+1) x dot l_(j)(x)\
&= 1 / (k+1) C_(j)(x) <= C_(j)^*(x)\
&= C_(j)(x) <= (k+1) dot C_(j)^*(x)
$

Thus we can see using the potential function that the latency function is bounded by a factor of $k+1$ for the price of anarchy.

== (b)

We can show that this bound is _asymptotically_ the best bound since there is a category of problems we have seen in the past that can force this worst case behavior. This question is the simple two path commuter problem with one constant value path and one path with a cost related to the proportion of people who are taking it. Formalize this statement as follows:

#define(
  title: "Simple Routing"
)[
  In this question, we have a simple routing question with two paths.

  + The first path has a constant cost of $1$.
  + The second path has a cost of $x^k$ for each person who takes it, where $x$ is the fraction of the total number of people who take the second path.
]

In this class of question, the price of anarchy is $infinity$. This is because the NE will once again take on the value of $1$, but the social equilibrium, especially at larger values of $k$, will near $0$. This means that the price of anarchy will be unbounded, and thus the it would be possible for us to find a POA of at least $k^alpha$ for sufficiently large $k$ when $alpha < 1$
