#import "template.typ": *
#show: template.with(
  title: "PSET 4",
  subtitle: "18.404",
  pset: true,
  toc: false,
)

#set math.vec(delim: "[")

= Problem 1

I will first provide an algorithm to do $"MODEXP"$, after which I will do a time complexity analysis.

#walkthrough(title: "Algorithm")[
  Notice that we can quickly take $a^b$ using $log(b)$ multiplications. Consider the $i$-th digit in the binary representation of $b$ as $b_i$. Then we can use the following algorithm:

  + Start out with our result $t = 1$
  + Iterate $i$ from $1 dots log(b)$
  + If $b_i = 1$, then $t = a t^2$
  + If $b_i = 0$, then $t = t^2$
  + Repeat

  However, it is crucial that this question takes place in context of modular operations. If there was no modulo, $t$ could potentially grow unbounded of the input size $n$, which I will define as the size of the input in its binary notation. However, by taking the mod by $p$ after each step of the algorithm, we can ensure that $t$ remains bounded by the same size as $p$. Thus we make a slight modification to our algorithm:

  + Start out with our result $t = 1$
  + Iterate $i$ from $1 dots log(b)$
  + If $b_i = 1$, then $t = a t^2 (mod p)$
  + If $b_i = 0$, then $t = t^2 (mod p)$
  + Repeat

  Once we have the result, compare with $c$ and accept if they are the same and reject otherwise.
]

On the input length $n$, this algorithm takes $O(n)$ iterations since we must go through each binary digit of $b$, which has length $<= n$. On each step of the algorithm, we do one or two multiplications and one modulo operation. These are polynomial time operations as given to us, and since we have bound the size to which the numbers can grow by using the modulo, each step will take a polynomial amount of time in $n$. For the sake of convenience, let us assume each step takes $O(n^3)$. Then, the overall runtime will also be polynomial since we have a polynomial number of steps with polynomial work per step. Roughly, this algorithm would take $O(n^4)$ time.

Thus we show that the $"MODEXP" in P$


= Problem 2

The proof for $"SUBSET-SUM"$ breaks because of the lack of a higher base in the representation of the numbers. In the original proof, it was pivotal that the base of the target was at least $4$, since we needed to be able to sum up each digit to potentially $3$ to represent the $"3SAT"$ problem that was given. However, this type of reduction is not possible when we have unary, since we cannot encode any information in the number beyond its length. We are unable to use the value at each digit to mean anything other than as a count.

When we consider the $"UNARY-SUM"$ problem, it is indeed in $P$ since the input size being the actual number itself rather than some binary representation means we now have the power to enumerate all numbers in range in polynomial time. Let us show how this can be used to show that $"UNARY-SUM" in P$

#define(title: "Input Size")[
  Define the input size $n$ in the $"UNARY-SUM"$ problem as the length of the input string, the number of $1$s in the input. Shortly, $n$ is the sum of all the numerical values in all of the inputs.
]

We will use dynamic programming to solve this question. Define $"DP"[i][j]$ as the whether it is possible to sum up to $i$ using the first $j$ numbers. We can then fill out the table in the following way:

+ Set all values to false except for $"DP"[0][0] = "true"$
+ Iterate $j$ from $0 dots m$ where $m$ is the number of input numbers excluding the target
+ Iterate $i$ from $0 dots t$ where $t$ is the target
+ If $"DP"[i][j] = "false"$, then move onto the next iteration
+ Otherwise, set $"DP"[i + x][j + 1] = "true"$ and $"DP"[i][j + 1] = "true"$, for the value $x$ of the $j$-th number

Once done, the answer will be contained in $"DP"[t][m]$. We visit each of the $"DP"$ states once, of which there are $m t$. WLOG assume that each number is nonzero, then $m < t$. Thus, there are $O(n^2)$ states to visit. At each of the states we make a constant ($2$) number of operations in updating the table. Thus, the overall runtime of this algorithm is $O(n^2)$, and there exists a polynomial algorithm to show that $"UNARY-SUM" in P$

Intuitively we can think about this as starting with an empty set and moving through the list of numbers, at each step growing the list of possibilities depending on whether we "take" the current number or not for each of the possibilities in our set. This set can only get as large as $t$ as otherwise we wouldn't have to consider those values. With $m$ steps we once again arrive at the $O(n^2)$ runtime.


= Problem 3

In order to show that every language $A in P$ is $"NP-COMPLETE"$, we must show that every language $L in N P$ is polynomial time reducible to $A$

Suppose we have some arbitrary language $L in N P$ such that it is not $emptyset, Sigma^*$. Because we know that $P = N P$, we can check in polynomial time whether some input $w in L$ or not. Let us pick two strings $x$ and $y$ from $A$, where $x in A$ and $y in.not A$. We can then define a polynomial time reduction from $L$ to $A$ as follows:

+ If $w in L$, then output $x$
+ If $w in.not L$, then output $y$

Thus we show that we can reduce all languages in $N P$ to $A$, and thus $A$ is $"NP-COMPLETE"$

It cannot be the case however that these languages are either $emptyset$ or $Sigma^*$ as assumed above. If $A = emptyset$, then we would not be able to make the mapping as described above as there would be nothing to map. In the case of $Sigma^*$, we have the opposite problem. Simply put, $emptyset$ means that there are no strings inside the language, and $Sigma^*$ means there are no strings outside of the language, and thus we cannot create an accurate mapping and reduction from $L$ to $A$ in these cases.


= Problem 4

Let us define the language $F = {angle.l n, l, r angle.r | n "has a factor" l <= f <= r}$

This language is in $N P$ since we can simply take the factor as the certificate and verify it in polynomial time with respect to the length of the number in binary representation. Since $P = N P$, it must be the case that there exists a polynomial time decider for this language. Let us call this decider $D$. We can then show that this decider can be used to show that factorization of a number is in $P$

First consider getting a single factor of a number. We can use binary search on the range of our desired number $n$ and run $D$ on it. This will take a linear number of steps with respect to the binary representation of the number. Each step will run in polynomial time since we possess the decider, and thus the overall runtime of this algorithm will be polynomial.

To completely factor the entire number, we simply apply this algorithm over and over again on both:

+ The factor that is found $f$
+ The factor that is found $n / f$

Because each step will cut the work in half (since the smallest factor we can find is $2$), we will have a logarithmic number of steps to factor the entire number. Thus again, it is linear to the binary representation of the number, and the overall algorithm to find the prime factorization of a number is polynomial. Thus it must be the case that if $P = N P$, then the factorization of a number is in $P$


= Problem 5

If every variable appears at most twice, then there are some heavy simplifications that we can make about $"CNF"_2$

#define(title: "Correct Value")[
  In the proof below, I will use the term correct value to mean the only value that clearly satisfies the formula. For example the correct value of $x$ is true and the correct value of $not x$ is false.
]

+ If a variable appears only once, then we can simply set it to the correct value.
+ If a variable appears twice with the same sign, then we can set it to the correct value.
+ If a variable appears twice with different signs:
  + Consider we have two clauses with $(x or A) and (not x or B)$ 
  + This can in fact be simplified down to just $(A or B)$, if one of $A, B$ is true, we can pander $x$ to match the one that is true.

Thus in this way we can reduce the problem quickly through a set of definitive steps to get a concrete answer quickly. Let us analyze the time complexity of an algorithm that might implement this procedure.

+ For each variable in the input
+ Loop over the input $"CNF"$ and see which of the cases the variable matches. Either set the variable in the first two case, or remove the variable in the third case and create the new $(A, B)$ clause.

This algorithm takes $O(n)$ steps to go through all of the variables, since the length of the input is bounded by the number of variables as they can only appear a maximum of two times. On each step, we do a constant amount of work. You could perhaps consider the third case to be a linear operation where creating the new clause takes linear time. Even in that worst case, the overall runtime of the algorithm is $O(n^2)$, which is polynomial. Therefore, we have shown that $"CNF"_2 in P$


= Problem 6

Let us show a reduction from $"3SAT"$ to $"CNF"_3$

On a given input to $"3SAT"$:

+ Take each variable in the input and create a new variable in $"CNF"_3$. *Importantly*, different occurrences of the same variable in the input will be mapped to different variables in the $"CNF"_3$ output.
+ Recreate the clauses in the input to the $"CNF"_3$ output. Thus we should have a similarly looking $"CNF"$ except now each variable is unique.
+ We will now "link" together variables that are references to each other in the original input to the $"3SAT"$ problem. Suppose we had three instances of $x$ in the original input that were turned into $x_1, x_2, x_3$. We would like to make sure that each of these take on the same value. To force this, we can add a set of cyclic clauses that look like the following:
  $ (x_1 or not x_2) and (x_2 or not x_3) and (x_3 or not x_1) $
  This will force the variables to take on the same value, as otherwise it will propagate a chain that will lead to a contradiction if one of the instances has a different value than the rest. Thus we can simulate having the same variable without referring to it by the same name every single time. In this construction, we follow the rule that each variable can only occur three times. In the original set of equations, each variable appears once. Then in this forced relational graph, each variable will appear at most twice in the cyclic chain as can be seen. Thus each variable appears no more than three times in the created $"CNF"_3$ output.

This reduction is polynomial in time, since the variables can all be created in linear time, and the forced dependence clauses are $O(n)$ in time as well. Fundamentally, because we can only have three of each variable, and the number of variables is $O(n)$ in $"CNF"_3$ in relation to the input size in $"3SAT"$, we have a polynomial time reduction from $"3SAT"$ to $"CNF"_3$

Now we will show both sides of the *iff*

== Forwards (If $"3SAT"$ then $"CNF"_3$)

Suppose there exists some solution for $"3SAT"$. For each variable in the solution, set all corresponding variables including the aliases of each variable to the correct value. Trivially, the clauses that were converted from the original $"3SAT"$ will be satisfied. In addition, the cyclic condition to force the variables to take on the same value will also be satisfied. 

== Backwards (If $"CNF"_3$ then $"3SAT"$)

Suppose there exists some solution for $"CNF"_3$. We can look at each forced cyclic cluster, which will have the same value, and use that to set the variable in the initial $"3SAT"$ problem. Trivially, thus must also satisfy the original clauses in the $"3SAT"$ problem.

Thus we have shown that $"CNF"_3$ is $"NP-COMPLETE"$ with a reduction from $"3SAT"$
