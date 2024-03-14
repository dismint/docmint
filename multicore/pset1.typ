#import "template.typ": *
#show: template.with(
  title: "6.5081 Problem Set #1",
  subtitle: "Justin Choi",
  pset: true
)

_Collaborators: Annie Wang_

= Problem 1

/ Safety: Something bad will never happen.
/ Liveness: Something good will eventually happen.

I will consider "good" and "bad" to be placeholders for arbitrary events. 

+ *Liveness*: Eventually, a customer will be seated.
+ *Safety*: It is never the case that something that can go wrong, will not go wrong.
+ *Safety*: It is never the case that someone wants to die.
+ *Liveness*: Eventually, you will either die or be taxed.
+ *Liveness*: Eventually we will die.
+ *Liveness*: Eventually the error will be printed.
+ *Safety*: It is never the case that an interrupt occurs and a message is not printed.
+ *Safety*: It is never the case that something Darth Vader starts will not be finished.
+ *Safety*: It is never the case that the cost of living decreases.
+ *Safety*: It is never the case that you can't tell a Harvard man.

= Problem 2

== Initial Winning Strategy

Designate one person as the "counter". This person is the only person who is allowed to turn the switch off. In fact, if the switch is on when they enter the room, they will take note and turn it off. For every other person, they will turn the switch *on* when it is their first time visiting the room while the switch is *off*. Once the "counter" sees that the switch has been turned *on* $P-1$ times, they signal that everyone has visited at least once.

This strategy works since

- Each switch can only be turned on by a specific prisoner once.
- The switch is only off if it's the first visit ever, or the "counter" resets it, meaning that the "counter" never misses an instance of the switch being *on*.

Thus eventually with enough time passing the "counter" will realize that every other prisoner has visited the room after counting every other prisoner's first and only signal.

== Warden Interference

Assume $k$ is a number that the prisoners know ahead of time.

Now the Warden can interrupt and inject noise into our previous algorithm. In addition, the initial switch state can be viewed as another source of noise. It's possible for our "counter" to now see anywhere between $0$ to $k+1$ extra switches in the *on* state, or $0$ to $k$ less switches on the *on* state.

I propose the following changes to the previous algorithm:

- Each prisoner now turns the switch *on* the first $2 k + 2$ times they enter the room with the switch *off*.
- The "counter" follows a similar strategy as above, but instead only signals that everyone has visited the room at least once when the total count of *on* switches he has seen is at least $2 k P - 3 k + 2 P - 2$

To see why this works, let's think about one of the most adversarial cases - the highest number of *on* switches the "counter" can see without everyone having gone once. In this scenario, every other prisoner will have turned the switch on $3 k$ times, with some final prisoner not having been to the room a single time. If the switch starts on and the Warden manages to turn a previously *off* switch to *on* on every single one of the $k$ visits, then the highest count they can achieve is:

$
(2 k + 2)(P - 2) + k + 1 &= 2 k P - 4 k + 2 P - 4 + k + 1\
&= 2 k P - 3 k + 2 P - 3
$

And we can then show that:

$
2 k P - 3 k + 2 P - 3 &< 2 k P - 3 k + 2 P - 2\
-3 &< -2
$

Thus it is impossible for us to reach the desired number for the "counter" and still be tricked by the Warden.

There's one last case to consider, which is the possibility that the Warden can turn enough switches off to the point where we fail to hit the quota the "counter" expects. Let's compute how much the Warden can make this number fall. If the initial switch starts off, and the Warden manages to visit at $k$ times when the switch is *on* and turns it *off*, then he can achieve:

$
(2 k + 2)(P - 1) - k &= 2 k P - 2 k + 2 P - 2 - k\
&= 2 k P - 3 k + 2P - 2
$

We can show this is trivially at least as large as our desired target for the counter.

$
2 k P - 3 k + 2P - 2 &>= 2 k P - 3 k + 2P - 2\
0 &>= 0
$

And we can now conclusively say that with this strategy, it is still possible to beat the game, even with the Warden's interference.

= Problem 4

== Algorithm

Suppose there is another can on Bob's side since he cannot see. We then propose the following protocol:

- Assume we start in the state where food has just run out in the pond. If so, then Bob's can starts down and Alice's can starts up.
- When food in the pond runs out, Alice turns her can up and knocks Bob's can down.
- When Bob sees his can down, his fills the pond with food, then raises his can and knocks Alice's can down.

== Correctness

- *Mutual Exclusion*: Only one person's can is down at a time. The person whose can is down is the person who is allowed to act. The flipping of cans is an atomic operation and always results a similar state of one can up, one can down. This double flipping always occurs as the last action of either Alice or Bob.
- *No Starvation*: If Bob always has food to give out and the pets are always hungry, then the pets will eat infinitely often.
- *Producer/Consumer*: Bob only refills the food if his can is down, meaning that there is no food in the pool. Alice only lets her pets out to eat when her can is down, meaning Bob has finished stocking the pool.

= Problem 5

#define(
  title: "Amdahl's Law"
)[
  $ "Speedup" = 1 / (1 - p + p / n) $
]

== $n => infinity$

We need to solve for $p$ given the two pieces of information we have:

- 24 hours on 3 processors.
- 15 hours on 6 processors.

There is no way to tell how much the speedup was compared to the original, so we will instead have to use the two measurements against each other to derive this information. We will use the fact that:

$ "Speedup" = "Original Time" / "Concurrent Time" $

To achieve the two equations:

$
"Original" / 24 = 1 / (1 - p + p / 3)\
"Original" / 15 = 1 / (1 - p + p / 6)
$

Now to solve for $p$, we can simply divide two instances of Amdahl's together.

$
15 / 24 &= (1 - p + p/6) / (1 - p + p/3)\
15 - 15 p + 5 p &= 24 - 24 p + 4 p\
10 p &= 9\
p &= 9 / 10
$

Therefore using the first equation we can find the original time as well now.

$
"Original" / 24 &= 1 / (1 - p + p / 3)\
"Original" / 24 &= 1 / (1 - 9 / 10 + 9 / 30)\
"Original" / 24 &= 5 / 2\
"Original" &= 60\
$

As $n$ approaches $infinity$, the overall speedup for a model will be equal to:

$ 1 / (1 - p) = 1 / (1 - 9 / 10) = boxed(10) $

== Maximizing Profit

We view profit as:

$ "Profit"(t) = 54000 (1 - t / 48) - 0.05 dot "Processor Hours" $

How do we find the number of processor hours? Well, we know it is possible to find the amount of total time it takes given $n$ processors since we can use a modified version of Amdahl's with the constants we calculated above.

$
"Original" / "Concurrent" &= 1 / (1 - p + p / n)\
"Concurrent" &= "Original" dot (1 - p + p / n)\
"Concurrent" &= (6 n + 54) / n\
$

However, we should multiply this expression by an additional $n$, as we must get the *total* number of processor hours. Thus we end up with:

$ "Profit"(t) = 54000 (1 - t / 48) - 0.05 (6 n + 54) $

$t$ is really just a function of $n$ as we saw above, so we can make a further simplification:


$ "Profit"(n) = 54000 (1 - (6 n + 54) / (48 n)) - 5 (6 n + 54) $

Notice that we also multiplied the last term by 100 (the number of models). Solving this equation reveals that our optimal number of processors per machine is 45, meaning the total number we need is $n = boxed(4500)$

Thus we can maximize our profit at $4500$ processors as $\$44,547.3$

= Problem 6

#define(
  title: "Amdahl's Law"
)[
  $ "Speedup" = 1 / (1 - p + p / n) $
]

Similar to the before question, let us derive two equations and solve for the first unknown, $p$

$
S_3 &= 1 / (1 - p + p / 3)\
S_n &= 1 / (1 - p + p / n)
$

Let's solve for $p$ in the first equation.

$
S_3 &= 1 / (1 - p + p / 3)\
S_3 (1 - 2 / 3 p) &= 1\
2 / 3 p dot S_3 &= S_3 - 1\
p &= (3 (S_3 - 1)) / (2 dot S_3)\
$

Now plugging into the second equation, we get:

$
S_n &= 1 / (1 - (3 (S_3 - 1)) / (2 dot S_3) + (3 (S_3 - 1)) / (2 n dot S_3))\
S_n &= 1 / ((3 - S_3) / (2 dot S_3) + (3 (S_3 - 1)) / (2 n dot S_3))\
S_n &= boxed((2 n dot S_3) / (3 n - n dot S_3 + 3 dot S_3 - 3))\
$
