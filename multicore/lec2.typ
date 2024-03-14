#import "template.typ": *
#show: template.with(
  title: "Lecture 2", 
  subtitle: "6.5081"
)

= Definitions

#define(
  title: "Precedence"
)[
  $A_0$ precedes $B_0$, or $A_0 -> B_0$ if the endpoint of $A_0$ happens before $B_0$
]

#define(
  title: "Ordering"
)[
  A partial order is an ordering that has three properties:
  
  / Irreflexive: It is never true that $A -> A$
  / Antisymmetric: It is never true that $A -> B$ and $B -> A$
  / Transitive: If $A -> B$ and $B -> C$ then $A -> C$

  A total order adds the additional constraint that for any given $A$ and $B$, either $A -> B$ or $B -> A$
]

#define(
  title: "Mutual Exclusion"
)[
  Suppose we have:

  - $"CS"_i^n$ is thread $i$'s $n$th critical exclusion.
  - $"CS"_j^m$ is thread $j$'s $m$th critical exclusion.

  Then it must be the case that either $"CS"_i^n -> "CS"_j^m$ or $"CS"_j^m -> "CS"_j^n$
]

#define(
  title: "Deadlock / Starvation Free"
)[
  / Deadlock Free: If some thread is failing to make progress after acquiring the lock, then other threads must be going infinitely often. That is, the system is still making progress even if it isn't.
  / Starvation Free: If some thread acquires a lock, it will finish eventually.
]

= Two Threads

== LockOne

```java
class LockOne implements Lock {
  private boolean[] flag = new boolean[2];

  public void lock() {
    flag[i] = true;
    while (flag[j]) {}
  }
}
```

For this lock suppose that each of the two threads have a flag associated with them.

We can show that the above satisfies mutual exclusion since we can derive a conclusion if the two critical sections were to overlap. By getting a list of orderings, we can create a cycle, which should be impossible in a partial order.

It is *not* deadlock free however, since both of them can set their lock to true before waiting, meaning that they are both spinning forever and waiting for the other to release. Sequentially, this is still fine.

== LockTwo

```java
public class LockTwo implements Lock {
  private int victim;

  public void lock() {
    victim = i;
    while (victim == i) {};
  }
  public void unlock() {}
}
```

This satisfies mutual exclusion since the condition to enter the critical section is a shared variable, which cannot possibly take on both values at the same time.

Interestingly, compared to LockOne, this execution will deadlock sequentially but will run concurrently. This is because the first person who enters the lock is waiting for the other to grant them permission to go.

== Peterson's Algorithm

```java
public void lock() {
  flag[i] = true;
  victim = i;
  while (flag[j] && victim == i) {};
}
public void unlock() {
  flag[i] = false;
}
```

We can show that the above algorithm combines the best parts of LockOne and LockTwo, and as a result is mutually exclusive, deadlock free, and starvation free.

= N Threads

== Filter Algorithm

The filter algorithm works by having $n-1$ waiting rooms called *levels*. The idea is that with $n-1$ levels, each level filters a thread, meaning that at the end we are left with one thread in the critical section.
```java
class Filter implements Lock {
  int[] level; // level[i] for thread i
  int[] victim; // victim[L] for level L

  public Filter(int n) {
    level = new int[n];
    victim = new int[n];
    for (int i = 1; i < n; i++) {
      level[i] = 0;
    }
  }

  public void lock() {
    // recall that i is the number of the current thread
    for (int L = 1; L < n; L++) {
      level[i] = L;
      victim[L] = i;
      while(victim[L] == i && (for (k != i) level[k] >= L))
    }
  }

  public void unlock() {
    level[i] = 0;
  }
}
```

Let us prove that this works. We want to show that it is not the case we have all threads traveling to the next level. At each level, there must be a last thread to write. 

#define(
  title: "Fairness",
)[
  Is the locking fair? That is, we want to make sure that one thread is not overtaken more than another. The problem is that its hard to define when something starts before another thing, because its inherently impossible to get an order for requesting access of locks.
]

One potential solution is to use Bounded Waiting, by dividing `lock()` into two parts:

- Doorway interval ($D_A$), which finishes in a finite number of steps.
- Waiting interval ($W_A$), which can take an unbounded number of steps.

== r-Bounded Waiting

For two threads $A$ and $B$:

- If $D_A^i -> D_B^j$, that is the $A$'s $i$th doorway precedes $B$'s $j$th doorway
- Then then $"CS"_A^i -> "CS"_B^(j + r)$, that is $B$ cannot overtake $A$ more than $r$ times.

In world that lives by "first come first served", then we would have $r = 0$

It turns out that the Filter lock works, but has very weak fairness. In fact, any thread can be taken over an arbitrary number of times.

== Bakery Algorithm

```java
class Bakery implements Lock {
  boolean[] flag;
  Label[] label;

  public Bakery (int n) {
    flag = new boolean[n];
    label = new Label[n];
    for (int i = 0; i < n; i++) {
      flag[i] = false; label[i] = 0;
    }
  }

  public void lock() {
    flag[i] = true;
    label[i] = max(label[0], ...,label[n-1])+1;
    while (for(k) flag[k] && (label[i],i) > (label[k],k));
  }

  public void unlock() {
    flag[i] = false;
  }
}
```

In the `lock`, the new label is given as the greatest unavailable one. Then, as long as there exists some other thread which has signaled interest with the `flag` and their label is less than ours, we will defer from going.
