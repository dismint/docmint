#import "template.typ": *
#show: template.with(
  title: "6.5081 Study Guide",
  subtitle: "Spring 2024"
)

= Chapter 1

#define(
  title: "Mutual Exclusion"
)[
  The property that no two processes are in their critical section at the same time. 
]

/ Deadlock Free: At least one thread will make progress.
/ Starvation Free: If a thread wants to enter the critical section, it will eventually do so.

/ Liveness Property: A property that states that something good will eventually happen.
/ Safety Property: A property that states that something bad will never happen.

#define(
  title: "Amdahl's Law"
)[
  $ 1 - p + p / n $ 
]

= Chapter 2

When we show something satisfies mutual exclusion, we want to show that assuming it doesn't, we can derive a contradiction.

```java
class LockOne implements Lock {
  private boolean[] flag = new boolean[2];
  public void lock() {
    int i = ThreadID.get();
    int j = 1 - i;
    flag[i] = true;
    while (flag[j]) {};
  }
  public void unlock() {
    int i = ThreadID.get();
    flag[i] = false;
  }
}
```

In this case, we know the following two precedence chains are true, assume they happened in the order listed WLOG:
- `write_a(flag[A] = true) -> read_a(flag[B] = false -> CS_a`
- `write_b(flag[B] = true) -> read_b(flag[A] = false -> CS_b`
Therefore it must also be the case that:
- `read_a(flag[B] = false) -> write_b(flag[B] = true) -> CS_a`
Then from this we can derive the precedence chain:
- `write_a(flag[A] = true) -> read_a(flag[B] = false) -> write_b(flag[B] = true) -> read_b(flag[A] = false)`
Which is a contradiction, since thread B could not possibly have read A as false.

/ Execution: A timeline of function calls and returns as ranges.
/ Quiescence: A state where no thread is in the critical section, a pause state.

Method calls should be linearizable, and should appear in their real time order of they are separated by a period of quiescence.

#define(
  title: "Quiescent Consistency"
)[
  Any time an object becomes quiescent, it should appear as if all operations have been executed in some sequential order, which have happened prior to that quiescence.
]

= Chapter 3

#define(
  title: "Libearizability"
)[
  Each method call should appear to take effect instantaneously at some moment between its invocation and return. 
]

History calls are written as: `<x.m(a*) A>`, where `x` is the object, `m` is the method, `a*` is the arguments, and `A` is the thread. History returns are written as `<x:t(r*) A>`, where `x` is the object, `t` is the return value of `ok` or `error`, `r*` is the return values, and `A` is the thread.

A *method call* in a history is a pair of a call and a return, where the call is before the return, and the return is for the call. The notation `complete(H)` is a history where we should throw out all pending method calls. We can also look at a `thread subhistory` or an `object subhistory`.

Two histories are *equivalent* if for every thread `A`, the `thread subhistorie`s are the same.

A method call in a history precedes another if the call finishes before the other starts.

A history *`H`* is *linearizable* if there is an extension *`H'`*, and there exists a sequential history `*S*` such that `complete(H')` is equivalent to `S` and if a method call precedes another in the original history, it also precedes it in the sequential history.

An overall history is linearizable if and only if each object in the history is linearizable.

/ Wait-Free: Every call finishes its execution in a finite number of steps. It becomes *bounded* wait-free if there is a bound on the number of steps a method call takes. This bound could be dependent on the number of threads. If it is not dependent on the number of threads, it is `population-oblivious`.
/ Lock-Free: At least one thread makes progress in a finite number of steps, infinitely often.

= Chapter 4

/ Atomic Register: A register that can be read and written atomically.
/ Safe Register: A `read()` that does not overlap with a `write()`, returns the value written by the most recent `write()` and if it does overlap, then the `read()` can return any valid value for the register.
/ Regular Register: A `read()` that does not overlap with a `write()`, returns the value written by the most recent `write()` and if it does overlap, then the `read()` can return either of the two values, either new or old.

A register is an `M`-valued register if it can store values from `0` to `M - 1`.

= Chapter 5

#define(
  title: "Consensus Numbers"
)[
  A consensus object provides a method `decide(v)` that each thread calls with a value at most once. The result must be:
  / Consistent: All threads that call `decide(v)` get the same value `v`.
  / Valid: The value `v` must be one of the values that was passed to `decide(v)`.

  You can only make an object with equal or lower consensus number from objects with a consensus number of `n`.
]

There is a special type of register called a `Common2` register, and any set of functions belongs to `Common2` if for two functions $f_1$ and $f_2$, either:

- $f_1$ and $f_2$ commute: $f_1(f_2(x)) = f_2(f_1(x))$
- One function overwrites another: $f_1(f_2(x)) = f_1(x)$ or $f_2(f_1(x)) = f_2(x)$

The consensus number of `Common2` is `2`.

= Chapter 6

Universal objects are those that given sufficiently many of them, we can construct a wait-free linearizable implementation of any concurrent object. These objects must have consensus number `n` for `n` threads.

We can make any sequential object into a lock-free linearizable concurrent object by wrapping it in a queue of nodes, where you add your method to the head, and then walk from tail to head, executing it for your own local copy. Each node keeps a copy of the last thread that it used.

How exactly the consensus algorithm works is a bit questionable, and is one of the hard parts of implementation in a practical setting.

In order to make this construction wait-free, we need to add a new `announce` array, where you store it into this array during the `apply` function. During the main loop, try help another announced object, indexed based on the current sequence number of the head. The particular reason that the algorithm does not add a given node twice now is due to the specific ordering of the operations.

= Chapter 7

Locking stuff, maybe study later?

= Chapter 9

/ Coarse-Grained Synchronization: Locking the entire data structure.
/ Fine-Grained Synchronization: Lock only the parts of the data structure that are being accessed.
/ Optimistic Synchronization: Assume that there are no conflicts, and then check for conflicts later, locking after you unsure you have what you expect.
/ Lazy Synchronization: Delay synchronization until it is absolutely necessary, allowing `contains` and such to be wait-free.

We can see an example of this with the `LinkedList` and the `marked` construct.

We can finally extend this idea into non-blocking synchronization, where we can use `compareAndSet` to atomically update a value if it is what we expect.

= Chapter 10

#define(
  title: "Pool"
)[
  A `Pool` is an object that is similar to a set, but does not provide the `contains` method to test membership, and allows items to appear more than once. 
]

`Pool` methods can be:
/ Total: Any method call immediately returns without waiting for something to happen.
/ Partial: May wait for certain conditions to hold.
/ Synchronous: The method call returns only after another method directly overlaps it.

A queue is an example of a `Pool`.

#define(
  title: "ABA Problem"
)[
  Suppose we implement the memory recycling with the local pools of freed nodes. The following sequence could happen:

  + Thread A attempts to deq, but freezes right before the compare and set of `B <- A`
  + Threads B and C deq `A` and `B` respectively.
  + Then Thread A wakes up and compares `A` to `B`, and sees that they are the same, and then proceeds to set the head equal to `B`, a recycled node. 

  This is why it is called ABA, because it flops between those three values. To fix this problem, we could use a stamp, that increments the object every time it is modified.
]

= Chapter 11

Now we take a look at stacks, which are another type of `Pool`

#define(
  title: "Exponential Backoff"
)[
  The idea with exponential backoff is that if you fail to get a lock, you wait for a random amount of time, and then try again. If you fail again, you wait for a longer amount of time, and so on. This is a way to avoid the thundering herd problem. Generally the base amount of waiting is multiplied by two up to a certain maximum cap.
]

#define(
  title: "Elimination"
)[
  The idea with elimination in a stack is to get rid of the serial bottleneck of using the `compareAndSet` method. The idea is to have a `push` and `pop` method that can be used to exchange values between threads, eliminating the other. 

  In order to ensure that there is not more that one match, we must use a coordination structure called an *exchanger* to ensure that exactly two threads and no more can exchange values.
]

= Chapter 12

#define(
  title: "Combining Trees"
)[
  The idea behind combining trees is that we have a tree with at most two threads per leaf, and we traverse the tree upward, and if two threads meet each other, only one of them will continue upward to update the value. This will minimize contention on the lock. There are some bad cases, for example after a node gets locked, a lot of other guys arrive late There are some bad cases, for example after a node gets locked, a lot of other guys arrive late.
]

- Tree width, length (why this could be better), construction

#define(
  title: "Diffracting Tree"
)[
  Uses a branching log depth algorithm and uses a `Prism` to eliminate things. 
]

You can also use these things to sort.

= Chapter 13

Bucket threshold versus global threshold, don't always want to resize locks.

#define(
  title: "Lock Striping"
)[
  The number of locks is fixed, and we coarse grain based on the mod. 
]


= Chapter 16

Work, Critical Path, and Parallelism analysis and using the master theorem.
/*
= there are a couple things here
Consensus numbers
0 valent means that that is point where it will decide 0
fetch negate and add with a, b, c and c, b, a example 0 0 1 1, a b c, then d can't tell the difference between a and c
for 3 => 222, , fna of 1, 10, 100
-212 if 10 goes first
213 if 1 then goes
113, but it doesn't ge tthis

if somethig has a consensus number of n, then you can only use it to make consensus number of n 

skip lists

learn about universal construction
counting networks - balancers, mergers, step property

linearization when something happens
*/

hierarchical spin locks short / long critical shared no shared

wf linear qobj 2 deq r/w reg

volatile

linea rseq consistency

parallelism

aba

wakeup

regiers

work
