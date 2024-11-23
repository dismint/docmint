#import "template.typ": *
#show: template.with(
  title: "PSET 5",
  subtitle: "18.404",
  pset: true,
  toc: false,
)

#set math.vec(delim: "[")

= Problem 1

First let us create a new NP-Complete problem called *NE6CNF* (Not Equal 6CNF). In this problem, we see whether there exists a satisfying assignment of variables in a boolean formula such that each clause contains at least one true and one false. This problem is NP-Complete as we can create a simple reduction from any regular 3CNF.

When I refer to a true variable, $alpha = "false" arrow.double not alpha$ is considered true.

For a given clause $phi$ in a 3CNF:

+ We want to consider a variable $phi_i$ true *iff* two related variables $x_i, y_i$ are different truth values.
+ To enforce this, we create new 6CNF clauses that replace each 3CNF clause. In particular:
  - Replace each $(phi_1 or phi_2 or phi_3)$ with
    + $(x_1 or y_1 or x_2 or y_2 or x_3 or y_3)$
    + $(not x_1 or not y_2 or x_2 or y_2 or x_3 or y_3)$
    + $(x_1 or y_1 or not x_2 or not y_2 or x_3 or y_3)$
    + $(x_1 or y_1 or x_2 or y_2 or not x_3 or not y_3)$
  - If one of the $phi_i$ is true the 1st and one of the 2nd-4th will guarantee that the corresponding $x_i, y_i$ are different truth values, and thus each of the four clauses will be true while containing at least one true and one false. If none of the pairs are different, one of the bottom three clauses will be false. I will leave out further details of proving both sides of the *iff* for brevity.

Now we create a reduction from this *NE6CNF* problem to the $"SET-SPLITTING"$ problem. 

+ For each variable in the input NE6CNF create a corresponding $s_i, s'_i$ and add the ${s_i, s'_i}$ subset to $C$ 
+ For each clause $phi$ in the input, create a corresponding set in $C$ that contains:
  - $s_i$ if the variable $phi_i$ is included as $phi_i$
  - $s'_i$ if the variable $phi_i$ is included as $not phi_i$
+ Run set splitting on $angle.l S, C angle.r$

== Forwards Direction

If there exists a satisfying assignment for the *NE6CNF* problem, then we can create a set splitting solution. If some variable $x$ is true in the original *NE6CNF* problem, then we can set $s_x = "blue"$ and $s'_x = "red"$. Otherwise, if it is false, we can set $s_x = "red"$ and $s'_x = "blue"$. This will ensure that each clause in the *NE6CNF* problem with form ${s_i, s'_i}$ is satisfied since they are different colors, and each of the other clauses that were transformed from the input also contain two colors since it came from a *NE6CNF* problem, meaning it must contain a true and a false, and thus one blue and one red.

== Backwards Direction

If there exists a set splitting, then we can create a satisfying assignment for the *NE6CNF* problem. If a variable $x$ is blue, then we can set $x = "true"$, otherwise we can set $x = "false"$. Since each subset contains two colors, this means that each clause in the original *NE6CNF* problem must contain a true and a false, and thus be satisfied.

Thus by reducing $"SET-SPLITTING"$ to *NE6CNF*, we have shown that *NE6CNF* is NP-Complete as well.


= Problem 2

== (a)

The steps of the proof are almost good, except one small flaw in the second step. We *are* allowed to guess the formula, since we have an NTM. However, it is not possible that verification can happen in polynomial time.

In particular, this issue arises because we must ensure that two boolean formulas are equivalent. However, to do this we would need to test all possible assignments of variables, which is on the order of $2^n$ where $n$ is the number of variables. We would have to compare both the old formula to this one, making sure that all possible assignments agree on the truth value outputted. On the worst case, we will have to check this many cases. Therefore because the certificate cannot be verified in polynomial time, the proof does not work as given.

== (b)

Consider a slightly different problem where we try to determine whether two boolean formulas differ at some assignment $alpha$. This is in NP as we can simply guess $alpha$ and check by plugging it into each formula in polynomial time.

However, if $"P" = "NP"$ then that means this check can be done in polynomial time, whether there exists there exists some assignment $alpha$ such that the two formulas differ. Now we use to this to solve the original problem.

Going back to the proof from before, we can now do the verification that the two are equal by checking whether they differ at some assignment. If they do not differ at any assignment, then they must be equal. Since this check can now be done in polynomial time, it must be the case that $"MIN-FORMULA"$ is in NP. More formally, we solve the $"MIN-FORMULA"$ problem by asking whether there exists some formula that is smaller for an input. We then guess this formula, and verify it in polynomial time using the procedure described above.

Now we have shown that $"MIN-FORMULA"$ is in NP, and thus we have shown that given $"P" = "NP"$, we have that $"MIN-FORMULA" in "P"$.


#pagebreak()


= 3

To show that $T T T_k in "PSPACE"$, we can make use of a common algorithm called min-max.

In short, we want to show that for $X$, they can make a step at each point in the game tree when it is their turn to force the game into a winning position. We can generalize this to both players, where $"MINMAX"(b)$ finds the optimal move for the future for the player whose turn it is on board $b$

Given a board state $b$, we can verify whether it belongs in $T T T_k$ by running the $"MINMAX"$ procedure as follows:

+ Run a check on the game state, if it is an ending state (a definitive win or draw), return that result. For concreteness, assume that $0$ is a draw, $1$ is a win for player $X$, and $-1$ is a win for player $O$.
+ Recursively calculate the $"MINMAX"$ value for each possible move by repeating from $1$, and call that list of values $M$. For the current player, return $"MAX"(M)$ if they are $X$, and $"MIN"(M)$ if they are $O$.

If $"MINMAX"$ returns $1$, then this input is a member of $T T T_k$, and otherwise it is not. Let us conservatively show why this algorithm is in $"PSPACE"$

The deepest that the recursion can go is the number of moves that can be made, which is at maximum $k^2$. Let us say generously that each recursion stores the board its at for a $k^2$ overhead. It also keeps track of the $"MINMAX"$ values of all of its children, which there are $k^2$ of in the worst case, since that is the maximum number of possible next moves. Thus the total amount of space that we need for each level is $O(k^2 + k^2) = O(k^2)$. Thus the overall space complexity of this algorithm is $O(k^4)$, and we have therefore shown that $T T T_k in "PSPACE"$


#pagebreak()


= Problem 4

If we consider Savitch's theorem, we can see immediately that $A_"LBA"$ is in $"PSPACE"$. There is only a polynomial amount of tape (linear) that is used in comparison to the input to the machine. We now know that there is some machine $M$ that accepts $A_"LBA"$ that uses at most $O(n)$.

I will now show that $A_"LBA"$ is $"PSPACE-Complete"$ by showing a reduction, not just from another $"PSPACE-Complete"$ problem, but from all of $"PSPACE"$. 

Any problem in $"PSPACE"$ can be solved by a deterministic Turing machine that uses at most $O(n^k)$ space for some $k$. We can simulate this machine by using a polynomial amount of space, and thus we can simulate this machine on a linear bounded automaton. However, recall that the linearly bounded automaton has exactly that - only linear space to its input, not polynomial.

This won't be a problem however, as we can easily *pad* the input to an LBA to be large enough such that can simulate the input with sufficient space. In particular, for some decider of a $"PSPACE"$ problem on input $w$ that uses at most $O(n^k)$ space, we can pad the input to be $w' = angle.l w,  0^(n^k) angle.r$, and then simulate the machine of the $"PSPACE"$ language $w$ came from on this LBA. We essentially make the input the polynomial size that the machine would have used, allowing us to simulate it on an LBA.

Thus since *every* problem in $"PSPACE"$ can be reduced to $A_"LBA"$, we have shown that $A_"LBA"$ is $"PSPACE-Complete"$
