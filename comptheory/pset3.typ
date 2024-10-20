#import "template.typ": *
#show: template.with(
  title: "PSET 3",
  subtitle: "18.404",
  pset: true,
  toc: false,
)

#set math.vec(delim: "[")

= Problem 1

Consider that we have the language:
$ L = { angle.l M, w angle.r | w "makes a left move at the leftmost position on" M } $

Now we show how to reduce $A_(T M)$ to $A_L$. Assume that $A_L$ decides the language $L$. Given $angle.l M, w angle.r$, we can construct a reduction with $A_(T M)$ as follows:

For convenience, I have called making a left move at the leftmost position an "illegal left move".

+ If $M$ makes any illegal left moves, then we can simply take them out. I work with the assumption that illegal left moves result in the head staying in its current position. Thus any time we make an illegal left move, we can replace in $M$ by not moving the head, or if we assert that a Turing Machine must move its head, we can turn it into a insignificant move to the right, then the left to achieve the same result. We know have a modified $M$ that does not make any illegal left moves. 
+ Next, take any accepting states in $M$ and replace them with state transitions that move the head all the way to the left, after which they make an illegal move. To note where the head is, we can use a special character so that this sequence of moves can recognize how far it needs to go so we don't move infinitely to the left.
+ We can then run $A_L$ on this modified $M$ and $w$. If $A_L$ accepts, then we know that $M$ makes an illegal left move, meaning that it must have accepted in the original $M$, and so we can also accept. If $A_L$ rejects, then we know that $M$ does not make an illegal left move, and thus we can reject since it does not reach an accepting state on the original $M$

Thus we have shown that $A_(T M)$ reduces to $A_L$, and with the contradiction of $A_(T M)$ being decidable,  $A_L$ is undecidable.


= Problem 2

== (a)

=== Forward Direction

*If $A$ is Turing-recognizable, then $A <=_m A_(T M)$*

Let us find a mapping function $f$ such that $A <=_m A_(T M)$. Given $A$, we can construct $A_(T M)$ as follows:

+ We have input $s$ to $A$
+ Since $A$ is Turing-recognizable, it must be the case that we can construct $M_A$ such that $L(M_A) = A$
+ Then, we can map this to input $angle.l M_A, s angle.r$, which we can feed into $A_(T M)$

If $s$ is in $A$, then $M_A$ will accept, and thus $A_(T M)$ will accept. If $s$ is not in $A$, then $M_A$ will reject, and thus $A_(T M)$ will reject.

=== Reverse Direction

*If $A <=_m A_(T M)$, then $A$ is Turing-recognizable*

If the left hand side is true, that means there exists some function $f$ such that it can map $A$ to $A_(T M)$. We can then use this to make a machine that recognizes $A$ as follows:

+ Given input $s$ to $A$, we can map this to $angle.l M, s angle.r$ using $f$
+ We can then run $A_(T M)$ on this input
+ If $A_(T M)$ accepts, then we know that $s$ is in $A$, and thus we can accept. If $A_(T M)$ rejects, then we know that $s$ is not in $A$, and thus we can reject.

We can consider this overall construction as a new machine $M$ that recognizes $A$, and thus $A$ is Turing-recognizable, since $A_(T M)$ itself is Turing-recognizable.

== (b)

=== Forward Direction

*If $A$ is decidable, then $A <=_m 0^*1^*$*

Because $A$ is decidable, it is quite easy to make a mapping function.

+ Given input $s$ for $A$, first check it with the finite time decider whether it is in $A$ or not.
+ If it is in $A$, then we can map it to $01$. If it is not in $A$, then we can map it to $10$.

Thus it must be the case that all inputs in the language $A$ are also in $0^*1^*$, and all inputs not in the language $A$ are not in $0^*1^*$ since we manually check with the decider.

=== Reverse Direction

*If $A <=_m 0^*1^*$, then $A$ is decidable*

If the left hand side is true, that means there exists some function $f$ such that it can map $A$ to $0^*1^*$. We can then use this to make a machine that decides $A$ as follows:

+ Given input $s$ to $A$, we can map this to $f(s)$
+ We can then check if $f(s)$ is in $0^*1^*$. This is decidable since the right side is a regular expression, and all regular expressions are decidable.

Thus we have shown that $A$ is decidable, since we can construct a decider for it using the fact that regular expressions are always decidable. This doesn't always mean that $A$ is a regular language, as we showed in $5.4$ however.


= Problem 3

== (a)

Let us create a decider for this language. Assume all inputs are CFGs, otherwise trivially reject them. I propose the following decider $D$, that tells whether a CFG $G$ contains an infinite, non-empty loop:

+ Make a graph with all the non-terminals of $G$ as nodes. For each rule that maps $A -> B$ in $G$, add a directed edge from $A$ to $B$
+ Find all cycles in the graph that we create. There are ways for us to bound this, but worst case we must process $O(n)$ such possibilities, where $n$ is the number of non-terminals.
+ The presence of a cycle means that $G$ contains an infinite loop. However, if the loop consists of empty terminals only, then it is possible that the language is finite. Thus we must check every loop, and if one exists that has a non-empty terminal, then we can accept. If all loops are empty, then we can reject.
+ There are simpler ways to do this, for example we can simplify $G$ such that it only contains non-empty terminals, so that we can create this decider by simply finding whether any cycle exists in the graph. However for simplicity I have provided a general solution.

Then, we can use this decider for the original language. If $D$ rejects a CFG, then we know that it does not contain an infinite, non-empty loop, and thus we can accept. If $D$ accepts a CFG, then we know that it contains an infinite, non-empty loop, and thus we can reject. This is done in a finite amount of time as these graph algorithms have a known time complexity and bound.

== (b)

We will use a reduction from $overline(H)$ (the complement of the Halting language)  to show that it is not the case that this language is Turing-recognizable. Recall that the complement of the Halting language is not Turing-recognizable.

Assume that a recognizer $R$ *does* exist for this finite language. Given $angle.l M, w angle.r$, we can construct a reduction to use the recognizer to make a recognizer for $overline(H)$ as follows:

+ We will start by constructing a machine that simulates $M$ with input $w$. This machine will take in as input how many steps it should run for. Suppose the input is $x$. If the $M$ halts after $x$ steps, then accept $x$. Otherwise, reject $x$.
+ This language is infinite if $M$ halts, since any $x$ greater than the number of steps it takes for $w$ to halt on $M$ will also be accepted. If $M$ does not halt, then the language is finite since it contains $epsilon$
+ Feed this machine into $R$ and see if it is finite. If it is, then we know that $M$ does not halt on $w$, and thus we can accept. If it is infinite, then we know that $M$ halts on $w$, and thus we can reject.

Thus we have shown that we reach a contradiction if we assume that this language is Turing-recognizable, and thus it is not the case that this language is Turing-recognizable.


= Problem 4

Let us use the reduction from PCP as suggested. Let us assume that we have a decider for the DISJOINT language. I will show how we can reduce PCP to DISJOINT and use the decider to make PCP decidable as well.

Using the formulation given on the PSET, we can construct a way to transform a PCP instance to a DISJOINT instance. I will discuss why the approach works. Below is a summary of what this looks like:

$
P = {vec(t_1, b_1), vec(t_2, b_2), ..., vec(t_k, b_k)}\
G: T -> t_1 T a_1 | t_2 T a_2 | ... | t_k T a_k | t_1 a_1 | t_2 a_2 | ... | t_k a_k\
H: B -> b_1 B a_1 | b_2 B a_2 | ... | b_k B a_k | b_1 a_1 | b_2 a_2 | ... | b_k a_k\
$

The key here lies in the new terminals $a_i$ that are introduced. The first and back half of $G$ and $H$ are nearly identical, except the first half allows for further building through repeated non-terminals, while the back half are all terminals. Let us think about what happens when either $G$ or $H$ fully produce a string. The first half will either be a string of $t_i$ or $b_i$, while the second half will be a string of $a_i$

In other words, the first half of the string generates the actual string that is produces from the dominoes, while the back half of each string essentially encodes which set of dominoes from the original $P$ were used. It would not be enough for the two CFGs to produce the end result strings, because we must also ensure that they are tiled using the same set of dominoes. The last encoding ensures that not only are the two strings equal, but that they were matched using a set of dominoes from $P$ by the rules that PCP defines.

Thus, now that we have this transformation, we can compare the two grammars on $R$. If $R$ accepts, then we know that there does not exist a matching and thus we can reject. If $R$ rejects, then we know that there exists a matching and thus we can accept. This is a decider for PCP, and thus we have shown that the DISJOINT language is undecidable since this forces PCP to be decidable as well, which we know is not the case.


= Problem 5

== (a)

The key insight to make here is that the length of the tape is finite along with the fact that it is read only. This means that there are a finite set of possible configurations of the machine. Suppose there are $q$ states, and that the length of the tape is $n$. The only things to keep track of are:

+ The current state of the machine
+ The position of the first head
+ The position of the second head

This means that there are $q n^2$ possible configurations of the machine. We can then construct a decider for this language as follows:

+ Given input $angle.l M, w angle.r$, make a machine $M'$ that simulates $M$ on $w$ for $q n^2$ steps
+ If $M$ halts, then $M'$ will halt in $q n^2$ steps. If $M$ does not halt, then $M'$ will not halt in $q n^2$ steps.
+ Thus after $q n^2$ steps, we will accept if we reached an accept state, and reject if we did not (either we got rejected or there was an infinite loop)

Thus we have shown that this language is decidable as we can create a decider for the language.

== (b)

We can use a reduction similar to what we saw in class. For this question, we will reduce from $E_(T M)$ using the following steps:

+ Given $M$ for $E_(T M)$, we construct a new machine $M'$ that recognizes all accepting computation histories of $M$. We do this with the encoding discussed in class with '\#' delimiters.
+ We can use one pointer head at the $i$-th configuration, and the other pointer head at the $i+1$-th configuration. We can then use the pointer heads to check whether each step of the configuration is a valid one by $M$
+ Now that we have $M'$, we feed it into the $D$, the decider for $E_"2DFA"$. If $D$ accepts then it must be the case that $M$ is also empty, and thus we can accept. If $D$ rejects, then it must be the case that $M$ is not empty, and thus we can reject.

Thus we have shown that this language is decidable as we have reduced from $E_(T M)$, which we know is undecidable. Therefore it must be the case that this language is undecidable as well.


= Problem 6

== Code / Output

Unfortunately lines `12` and `15` are relatively long so they don't render on the PSET as one line. However, if you copy paste it will yield the correct text. This program prints itself exactly, including the quotes, so the output would be the exact same as this code block below.

```python
# 18.404 PSET 3 Q6
sq = "'"
dq = '"'
nl = '\n'
bs = '\\'
f1 = "def f(s, s1, s2, s3):"
f2 = "    print(s+'1 = '+dq+s1+dq+nl+s+'2 = '+dq+s2+dq+nl+s+'3 = '+dq+s3+dq)"
f3 = "    print(s1+nl+s2+nl+s3)"
def f(s, s1, s2, s3):
    print(s+'1 = '+dq+s1+dq+nl+s+'2 = '+dq+s2+dq+nl+s+'3 = '+dq+s3+dq)
    print(s1+nl+s2+nl+s3)
p1 = "print('# 18.404 PSET 3 Q6'+nl+'sq = '+dq+sq+dq+nl+'dq = '+sq+dq+sq+nl+'nl = '+sq+bs+'n'+sq+nl+'bs = '+sq+bs+bs+sq)"
p2 = "f('f', f1, f2, f3)"
p3 = "f('p', p1, p2, p3)"
print('# 18.404 PSET 3 Q6'+nl+'sq = '+dq+sq+dq+nl+'dq = '+sq+dq+sq+nl+'nl = '+sq+bs+'n'+sq+nl+'bs = '+sq+bs+bs+sq)
f('f', f1, f2, f3)
f('p', p1, p2, p3)
```

