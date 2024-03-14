#import "template.typ": *
#show: template.with(
  title: "14.15 PSET 5",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (1)

#note(
  title: "Notation"
)[
  Note that for this question, $p(d)$ will be taken to mean the converged value of $p(d)$, or $p^*(d)$
]

WLOG, let us compute this value for some arbitrary node. We will start out by computing the pseudo-degree of each vertex.

Every node starts with $2k$ connections, and it can have an additional $n - 2k - 1$ edges added on top with probability $p / n$. Thus we arrive at the following equation, making a simplification of $x = d - 2k$, which gives us the additional edges that are added.

#set math.equation(numbering: "(1)")

$ PP(x) = binom(n - 2k - 1, x) (p / n)^x (1 - p / n)^(n - 2k - 1 - x) $ <initial>

#set math.equation(numbering: none)

From the hint in last week's PSET, the last term converges to $e^(-p)$. Also observe that we can manipulate the first two terms algebraically to simplify one of the terms:

$ binom(n - 2k - 1, x) (p / n)^x = binom((n - 2k - 1) dots (2 - 2k - 1 - x), n^x) (p^x / x!) $

Because of the leading terms, the first term in the simplified equation simplifies to $1$. Thus @initial simplifies to:

$ (p^x e^(-p)) / x! $

This gives us our very familiar Poisson form, meaning that the degree of each vertex eventually follows $"Poisson"(p, x)$

Now we want to show that the proportion of vertices with any given degree $d$ is equal to the distribution given above, $"Poisson"(p, d - 2k)$. If we denote $C_d$ as the count of the vertices with degree $d$, we get the following after applying Chebyshev's:

$ (1 / epsilon^2) (EE[C^2_d] / n^2 - p^2(d)) $

Thus, as long as we can show that the numerator in the first term is equal to $n^2 dot p^2(d) + o(n^2)$, then we have proven that there is no difference between $C_d / n$ and $p(d)$

To do this, let us define $I_i$ to be the indicator variable that node $i$ has degree $d$. We can now make the observation that:

$ EE[C^2_d] = sum_(i, j = 1)^n EE[I_i I_j] $

In order for this summation to equal our desired value, it must be the case that the inside $EE[I_i I_j]$ is equal to $p^2(d) + o(1)$. The complication that we must address in our evaluation of this inside value is whether the edges between $i$ and $j$ exists. Otherwise, the two events are completely independent following the Poisson distribution mentioned above. Let us denote $E_(i j)$ as the indicator variable there exists an edge between $i$ and $j$. Now we can finally make the following simplifications:

$
EE[I_i I_j] &= EE[I_i I_j | E_(i j)] dot PP[E_(i j)] + EE[I_i I_j | not E_(i j)] dot PP[not E_(i j)]\
&= p / n dot (p(d) + 1)^2 + p^2(d) dot (1 - p / n)\
&= p^2(d) + (p (2p(d) + 1)) / n\
&= p^2(d) + o(1)
$

Thus we conclude that the distribution of degrees equals the Poisson variable we found earlier:

$ boxed("Poisson"(p, d - 2k) = (p^x e^(-p)) / x! = p(d)) $

== (2)

We wish to find the value of the clustering coefficient when the probability of replacements is $p = 0$

We will first start by counting the number of triplets in the graph. For any given node, the number of possible triplets is equal to $(2k) (2k - 1)$. Thus, there are $n dot (2k) (2k - 1)$ total triplets.

Note that these triplets are *not* triangles, that is they are missing the last edge the connect the two arbitrary chosen edges of the given node above. Finding the total numbers of triangles is a slightly more difficult question.

Similar to above, let us fix some arbitrary node and see how many triangles there are. For any distance between $1$ and $k$, there exists exactly two nodes with this distance (one on either side of our fixed node). Let us take one of these neighbors as an example. Let us say that node $x$ has a distance of $d$ from our fixed node $n$. All $k - 1$ other nodes on the same side as $x$ become candidates, and on the other side the $k - d$ valid nodes fill the other half of possible connections. Thus, for both sides, we have $2(2k - 1 - x)$ potential triangles. We will now sum this up over all possible values (recall we were looking at a fixed $d$

$
sum_(d = 0)^k 2 (2k - 1 - d) &=\
&= 4k^2 - k(k + 1) - 2k\
&= k (3k - 3)
$

Thus the total number of triangles is $n dot k (3k - 3)$, and our given answer can be confirmed:

$ (n dot k (3k - 3)) / (n dot (2k) (2k - 1)) = boxed((3k - 3) / (4k - 2)) $

= Problem 2

== (1)

Plugging into Wolfram Alpha, the second derivative of $F$ comes out to the following:

$ F''(t) = ((p + q)^3 dot e^(-(p+q)) dot p(q e^(-t(p+q))) - p) / (q e^(-t(p + q)) + p)^3 $

Suppose $p > q$. Then it must be the case that the $q e^(-t(p+q)) - p$ term is always negative no matter what the value of $t$ is, and thus the function is concave. 

Suppose $q > p$. We then notice that $p e^(-t(p + q)) - p$ is positive before $t = ln(q / p) / (p + q)$, and negative after, leading to the desired convex before concave shape described.

== (2)

The adoption rate is highest when $t^*(p, q) = ln(q / p) / (p + q)$. This is the same break point that we defined above in *(1)*. This is because we wish to find the point at the when the second derivative is equal to zero, which is exactly the expression we found earlier.

== (3)

Let us take the derivative with respect to both $p$ and $q$.

WRT $p$:

$ ln(p / q) / (p + q)^2 - 1 / (p (p + q)) $

WRT $q$:

$ ln(p  q) / (p + q)^2 + 1 / (p (p + q)) $

We don't have to consider the case where $p > q$ since $t^*$ is fixed, so instead we focus on when $q > p$. Under this condition, the derivative WRT $p$ is always negative, meaning the value is constantly decreasing. The numerator of the first function must be negative since $q > p$, and the second function only takes more away.

On the other hand, there does not exist such an observation for the derivative WRT $q$, and the direction is completely dependent on the specific values of $p$ and $q$

== (4)

Conceptually, the innovation rate is an independent rate, and thus it makes sense that it is not ambiguous. It represents a simple and straightforward metric of how likely an individual is to adopt a new product, completely disregarding any external opinions. 

However, on the other side, the imitation rate $q$, depends very heavily on the innovation rate, and cannot stand as a metric by itself. My theory is that the imitation rate acts as a sort of balance on the heavy sway that the innovation rate creates. For example, if there is an extremely high innovation rate $p$, the imitation rate can work to quench (or boost) the initial momentum.

Regardless of the importance of $q$, its ambiguity stems intuitively from the fact that it relies on external factors, such as $p$, the innovation rate.

== Problem 3

== (1)

Dynamic Equations:

$
S(t) &= -gamma dot R_0 dot S(t) dot I(t)\
I(t) &= gamma dot R_0 dot S(t) dot I(t) - I(t)\
R(t) &= gamma dot I(t)
$

Initial Conditions:

$
S(0) &= 1 - iota - pi\
I(0) &= iota\
R(0) &= pi
$

== (2)

We start by solving the differential equation $S(t) / S(t) = -R_0 dot R(t)$. Plugging the given values in, this comes out to a solution of $S(t) = (1 - iota - pi) dot e^(-R_0 (R(t) - pi))$. From lecture we have the following:

$ lim_(t = infinity) R(t) = 1 - lim_(t = infinity) S(t) = 1 - (1 - iota - pi) dot e^(-R_0 (lim_(t = infinity) R(t) - pi)) $

Thus we can combine the information above as well as the other limits of the dynamic equations to get a simplified form for the number of disease holders $D$:

$ lim_(t = infinity) D(t) = 1 - pi - (1 - iota - pi) dot e^(-R_0 dot lim_(t = infinity) D(t)) $

== (3)

Results of graphing the above equation on Desmos after making the $iota approx 0$ approximation are shown below:

#bimg("img/graph.png")

The red line represents the testing, while the blue line represents increasing vaccinations instead. Right before $4.5$, the graph crosses, and it becomes more valuable to test rather than vaccinate.

