#import "template.typ": *
#show: template.with(
  title: "PSET 6",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (a)

#align(center)[
  #table(
    columns: 3,
    [], [`W`], [`R`],
    [`W`], [$100, 100$], [$50, 125$],
    [`R`], [$125, 50$], [$75, 75$]
  )
]

=== Pure

When we fix the other player's strategy, it becomes incentivized to pick `R` regardless of the other player's choice. Therefore:

/ `(W, W)`: Is *not* a pure strategy.
/ `(R, R)`: *Is* a pure strategy.
/ `(R, W)`: Is *not* a pure strategy.
/ `(W, R)`: Is *not* a pure strategy.

=== Mixed

We want to choose probabilities such that the other player is indifferent. Let $p$ be the probability of choosing `W` for P1 and $q$ be the probability of choosing `W` for P2.

$
u_2(W) &= p dot 100 + (1 - p) dot 50 = 50 + 50 p\
u_2(R) &= p dot 125 + (1 - p) dot 75 = 75 + 50 p
$

There is no way to satisfy $u_2(W) = u_2(R)$, so the only NE is the pure strategy of `(R, R)`.

== (b)

#align(center)[
  #table(
    columns: 3,
    [], [`S`], [`H`],
    [`S`], [$100, 100$], [$0, 10$],
    [`H`], [$10, 0$], [$10, 10$]
  )
]

=== Pure

Both players are incentivized to pick the same choice as the other player, since it will always strictly be a better choice. Therefore:

/ `(S, S)`: *Is* a pure strategy.
/ `(H, H)`: *Is* a pure strategy.
/ `(H, S)`: Is *not* a pure strategy.
/ `(S, H)`: Is *not* a pure strategy.

=== Mixed

Let $p$ be the probability of choosing `S` for P1 and $q$ be the probability of choosing `S` for P2.

#twocol(
  [
    $
    u_2(S) &= p dot 100 + (1 - p) dot 0 = 100 p\
    u_2(H) &= p dot 10 + (1 - p) dot 10 = 10\
    100 p &= 10\
    p &= 0.1
    $
  ],
  [
    $
    u_1(S) &= q dot 100 + (1 - q) dot 0 = 100 q\
    u_2(S) &= q dot 10 + (1 - q) dot 10 = 10\
    100 q &= 10\
    q &= 0.1
    $
  ]
)

Thus our mixed strategy NE is $(1 / 10 S + 9 / 10 H, 1 / 10 S + 9 / 10 H)$

== (c)

#align(center)[
  #table(
    columns: 3,
    [], [`C`], [`S`],
    [`C`], [$-10, -10$], [$1, 0$],
    [`S`], [$0, 1$], [$0, 0$]
  )
]

=== Pure

If one player picks `C`, the other is incentivized to pick `S` as well to avoid the large negative payoff. If one player picks `S`, the other is incentivized to pick `C`. Therefore:

/ `(C, C)`: Is *not* a pure strategy.
/ `(S, S)`: Is *not* a pure strategy.
/ `(S, C)`: *Is* a pure strategy.
/ `(C, S)`: *Is* a pure strategy.

=== Mixed

Let $p$ be the probability of choosing `C` for P1 and $q$ be the probability of choosing `C` for P2.

#twocol(
  [
    $
    u_2(C) &= p dot -10 + (1 - p) dot 1 = 1 - 11 p\
    u_2(S) &= p dot 0 + (1 - p) dot 0 = 0\
    0 &= 1 - 11 p\
    p &= 1 / 11
    $
  ],
  [
    $
    u_1(C) &= q dot -10 + (1 - q) dot 1 = 1 - 11 q\
    u_1(S) &= q dot 0 + (1 - q) dot 0 = 0\
    0 &= 1 - 11 q\
    q &= 1 / 11
    $
  ]
)

Thus our mixed strategy NE is $(1 / 11 C + 10 / 11 S, 1 / 11 C + 10 / 11 S)$

== (d)

#align(center)[
  #table(
    columns: 4,
    [], [`R`], [`P`], [`S`],
    [`R`], [$0, 0$], [$-1, 1$], [$1, -1$],
    [`P`], [$1, -1$], [$0, 0$], [$-1, 1$],
    [`S`], [$-1, 1$], [$1, -1$], [$0, 0$]
  )
]

=== Pure

There are no pure strategies that are NE in this game. Suppose P1 chooses option `A`. Then P2 is incentivized to choose the complement of `A`. However, P1 is then incentivized to choose the complement of P2's choice which is not `A`.

=== Mixed

Because all choices are equal, the best way to make players feel indifferent in a mixed strategy is to give equal weights to all options. Thus, the mixed strategy NA is $(1 / 3 R + 1 / 3 P + 1 / 3 S, 1 / 3 R + 1 / 3 P + 1 / 3 S)$

== (e)

#align(center)[
  #table(
    columns: 4,
    [], [`R`], [`P`], [`S`],
    [`R`], [$0, 0$], [$-2, 2$], [$10, -10$],
    [`P`], [$2, -2$], [$0, 0$], [$-5, 5$],
    [`S`], [$-10, 10$], [$5, -5$], [$0, 0$]
  )
]

=== Pure

There are no pure strategies that are NE in this game. Suppose P1 chooses option `A`. Then P2 is incentivized to choose the complement of `A`. However, P1 is then incentivized to choose the complement of P2's choice which is not `A`. There is nothing here that has changed from *(d)* that would allow for a pure strategy NE.

=== Mixed

Suppose a player chooses `R` with probability $p$ and `P` with probability $q$, and `S` with probability $1 - p - q$. 

$
u_2(R) &= q dot -2 + (1 - q - p) dot 10 = 10 - 12 q - 10 p\
u_2(P) &= p dot 2 + (1 - q - p) dot -5 = - 5 - 5 q - 3 p\
u_2(S) &= p dot -10 + q dot 5 = 5 q - 10 p\
$

These equations hold true when $p = 5 / 17, q = 10 / 17$. Thus our mixed NE is held at $(5 / 17 R + 10 / 17 P + 2 / 17 S, 5 / 17 R + 10 / 17 P + 2 / 17 S)$

= Problem 2

== (a)

The NE is for a candidate to choose $x = 0.5$ all the time. This will result in both candidates splitting the vote, and one of them being elected with probability $1 / 2$

There is no other pure strategy, as any other choice results in a $< 1 / 2$ chance of winning the election. Similarly, there is no mixed strategy that will result in a higher probability of winning the election, as we can always swap over to $x = 0.5$ to increase our chances. Because there are two candidates, the probability of winning the election is always capped at $1 / 2$, assuming that the other candidate is playing optimally as well.

== (b)

In order to maximize the payoff, each candidate wants to get as close to their side as possible. However, if they get too close, they will lose the election. Thus, the optimal strategy is to choose $x = 0.5$ all the time. This will result in a $1 / 2$ chance of winning the election.

If we were to choose any other value rather than $x = 0.5$, the other candidate still holds the $0.5$ position, meaning the actual payoff does not change. Moving from the center does not incur any payoff benefits, and only serves to decrease the probability of winning the election.

== (c)

Because there are three candidates, there are many such cases where we reach a NE. One such case might be if $(x_1, x_2, x_3) = (0.2, 0.3, 0.6)$

In this case, fixing P1 and P2, P3 will always win if they choose $0.6$, so they are at an equilibrium. P1 and P2 are incentivized not to move, as moving to the right of P3 will result in the other of P1 or P2 winning. If the move to the center of the other two, they can earn at most $0.2$ of the vote, and if they move to the far left, the most they can earn is $0.3$ of the total vote. Therefore, there is no possible scenario where any of the players want to move from the given NE.

= Problem 3

== (a)

We reach equilibrium when all players take link 1. There is no reason to take the second link, as the cost of link 1 is then $x^k$, which is guaranteed to be less than $1$, meaning they will switch.

The socially optimal routing happens on depth $x$ when:

$ min x dot x^k + (1 - x) $

Where $x$ is an indicator variable of whether we choose to take link 1 or not (2). We can take the derivative of this function to get the min condition:

$ k + x^k - 1 = 0 $

Which is achieved when:

$ x = (1 / (k + 1))^(1 / k) $

The total cost can be represented by $1 + x dot (x^k - 1)$, meaning our overall cost is:
(1 / (k + 1))^(1 / k)

$
1 + (1 / (k + 1))^(1 / k) dot (((1 / (k + 1))^(1 / k))^k - 1) &=\
&= 1 + (1 / (k + 1))^(1 / k) dot ((1 / (k + 1))^(1 / k) - 1)\
&= 1 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k)\
$

In this scenario, the price of anarchy and stability are the same, and equal to the inverse of the last computed value.

$ boxed((1 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k))^(-1)) $

== (b)

Our new minimization function is:

$ min x dot x^k + (2 - x) $

This gives the same first order minimization condition as before in *(a)*. The optimal answer is still therefore:

$ x = (1 / (k + 1))^(1 / k) $

But our cost now changes, as the overall cost increases by 1. The new cost is:

$ 2 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k) $

And then price of anarchy and stability is:

$ boxed((2 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k))^(-1)) $

== (c)

We would like to prove the following:

$ 1 < 2 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k) $

Note that it must be the case $(1 / (k + 1))^(1 / k) < 1$ since $k > 0$, meaning $1 / (k + 1) < 1$. Therefore, we can say that:

$ 1 = 2 - 1 < 2 - 1 / (k + 1) dot (1 / (k + 1))^(1 / k) $

Thus, *halving* the traffic will result in a better equilibrium cost. This could be achieved through ridesharing in Uber or Lyft, or getting bigger cars to transport more people at once.

= Problem 4

== (a)

In any case, it is the best policy to always choose the car. Even if everyone takes a car, the commuting time is fixed at $1$. If people take the train, it will take at least one hour, with a possibility of two hours. The payoff for everyone is therefore $-1$

== (b)

All the people with strict deadlines should use a car, since the worst case assumption will hurt if they take the train. If they don't have a strict deadline, then we should split it based on $epsilon$. Want want to minimize the expression $(1 / 2 + f)^2 + 2(1-f)(epsilon)(1 / 2) + (1-f)(1-e)(1 / 2)$, where $f$ is the proportion of flexible schedule havers who use a car.

To accomplish this, we should pick $f = epsilon$, and thus $epsilon/2$ flexible people take a car, and the rest $1/2-epsilon/2$ take the train.

== (c)

No, everyone will want to take a car greedily, even those who have a flexible schedule. There is no way to enforce this policy if people can lie.

== (d)

We could possibly set the cap to the $1/2+epsilon/2$ number discussed in *(b)*, but there is no guarantee that the people we want will take those slots. For example, we intended for the hard deadline havers to get all car slots, but if it is first come first served, there is no guarantee that this will happen. We would need some additional way of enforcing this guarantee, so this approach is not feasible.

== (e)

On the opposite side of the argument from *(c)* and *(d)*, there is also no guarantee that we can force $epsilon/2$ of the flexible schedule havers to take a car. Even if it is the better option, we have no way of enforcing this policy, and so unless the government actively enforces this ratio, there is no world where even a toll can be enforced if people with flexible schedules choose to take the train when conditions are semi equal to the road. Either all flexible schedule havers will want to take the train, or all of them will want to take the car. There is no way to enforce a particular ratio.

