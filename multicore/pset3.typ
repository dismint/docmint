#import "template.typ": *
#show: template.with(
  title: "6.5081 PSET 3",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

#define(
  title: "Sequential Consistency"
)[
  Recall that sequential consistency means that we can change the order of events between threads, but not within a thread. Thus, linearizability is a stronger guarantee than sequential consistency.
]

== Figure 1

#twocol(
  [
    *Sequentially Consistent*
    + `A r.write(1)`
    + `C r.read(1)`
    + `B r.write(2)`
    + `B r.read(2)`
  ],
  [
    *Linearizable*
    + `A r.write(1)`
    + `C r.read(1)`
    + `B r.write(2)`
    + `B r.read(2)`
  ]
)

== Figure 2

#twocol(
  [
    *Sequentially Consistent*
    + `A r.write(1)`
    + `C r.read(1)`
    + `B r.write(2)`
    + `B r.read(2)`
  ],
  [
    *Not Linearizable*

    There are only two reads `writes` to `r`, which happen with values of `1` from thread `A` and `2` from thread `B`. Similar, there are two `read`s that see different values. Additionally, both `write`s must happen before both `read`s. This means that in order for the operations to be linearizable, one of the `write`s must be the last executed `write`. Thus, it is impossible for two values to be `read`, and the history is not linearizable.
  ]
)

= Problem 2

== (a)

=== $S_1 => S_2$

If the system is lock-free, then it must be the case that some method call finishes in a finite number of steps, infinitely often. Thus in an infinite execution, there must be an infinite number of finite steps, meaning an infinite number of method calls finish.

=== $S_2 => S_1$

If infinitely many method calls are completed in an infinite execution, that means that each method call takes a finite number of steps. Thus we can definitively state that there are some method calls that finish in a finite number of steps, infinitely many times, and thus we have lock-freedom.

== (b)

=== $S_1 => S_2$



=== $S_2 => S_1$

= Problem 3

== (a)

Suppose we have two `enq()` calls named `enq1` and `enq2` for convenience. We will use a similar naming scheme for `deq()` method calls. Now consider the following sequence of events that happens at the beginning when the array is empty.

+ `enq1` runs line `14` and gets `i = 0`, setting `tail = 1`
+ `enq2` runs line `14` and gets `i = 1`, setting `tail = 2`
+ `enq2` runs line `15` and sets `items[1] = x2`
+ `deq1` runs with `tail = 2`, and finds item `x2` at `items[1]`

Thus we have created a scenario in which the value from `enq2` gets returned first from a `deq()` call, despite line `14` having run first for `enq1`. This happens because `enq1` fails to store its element as early as it claimed the numbering, meaning the `deq1` method call moved past it as it looks for the first available non-null value.

== (b)

Using a similar notation as above, consider the following sequence of events, once again happening from an empty array.

+ `enq1` runs line `14` and gets `i = 0`, setting `tail = 1`
+ `enq2` runs line `14` and gets `i = 1`, setting `tail = 2`
+ `enq2` runs line `15` and sets `items[1] = x2`
+ `enq1` runs line `15` and sets `items[0] = x1`
+ `deq1` runs with `tail = 2`, and finds item `x1` at `items[0]`

In this case, despite `enq2` executing line `15` first, `enq1` also managed to get their value stored in `items`, and as a result, `deq1` saw this value `x1` first, despite `enq2` executing the "linearization point" first.

== (c)

No, this is not true. The ability to assign a linearization point trivially proves that the method can be linearized, but it is not the only condition under which this is true. We are still able to linearize a method which does not contain a single point at which we can definitely say that method's "effect" has taken place. As in all the cases above, we can indeed find a way to linearize the two `enq` operations, however it does require more effort than simply assigning one point. It becomes necessary to consider when other competing `enq`s started their method call, as well as what has been completed before the next `deq()` starts to execute.

= Problem 4

== (a)

Yes, this implementation is regular. The premise guarantees that there is only a single writer, and any $P$ can only ever return its current value, or the new value that $P_i$ wants to write if the message has been received by them. It is impossible to generate any intermediate value or otherwise give an output that is not the new or old register value. When the operation is done, all $P$ will see the same value in the register.

== (b)

No, it is not atomic, because while the write is going on, different processors can see different values as the message gets passed around. Since it relies on going through all $P$, there is not an atomic point where the action happens. Thus, although there might be some executions in which we can linearize the event, if there is ever a point where a new value is read before an old value, then it automatically is ineligible to be linearizable. This of course, is possible since there is no global register, and each processor holds its own local copy, which it updates as soon as it receives the request to write the new value.

== (c)

By necessity, since multiple processors entails the possibility of a single processor, the above logic applies and this implementation also is not atomic.

= Problem 5

```java
public int read() {
  // read last chunk
  boolean[] last = new boolean[N];
  for (int i = N-1; i >= 0; i++) {
    last[i] = b[(2*N)+i].read();
  }
  // read middle chunk
  boolean[] middle = new boolean[N];
  for (int i = N-1; i >= 0; i++) {
    middle[i] = b[N+i].read();
  }
  // read first chunk
  boolean[] first = new boolean[N];
  for (int i = N-1; i >= 0; i++) {
    first[i] = b[i].read();
  }

  // turn into ints
  int l = booleanArrayToInt(last);
  int m = booleanArrayToInt(middle);
  int f = booleanArrayToInt(first);
  // return first unless it is the "conflict" block
  if (m == l && f != m && f != l) {
    return m;
  } else {
    return f;
  }
}
```
#note(
  title: "Leftmost"
)[
  The term leftmost is used to refer to the first block, rightmost would then refer to the last block.
]

The key idea here is that the `read()` function will go in the opposite direction of the `write()`, starting in the back and moving towards the front, also reading the values within each block backwards. This ensures that there will be at most one point of "conflict", if a `write()` is happening at the same time as a `read()`. In order to explain why this register is atomic with the `read()` provided, consider a linearization point for `write()` as line `10` in the initial code. That is, after we have finished our first round of copying the value `x`.

Since there are no complications if a `read` and `write` don't overlap, let us focus on that specific case. In the case where the two overlap, there will be a point of conflict where the read and write cross each other. Intuitively, we want to say that if `write()` has finished copying to the first block of the array, we can now use this value to serve the read. Otherwise, we don't have complete information and must serve the old value. Therefore, when possible, we want to prioritize taking the leftmost value (the one which `read()` accesses last), to serve an accurate `read()` as soon as possible with respect to `write()`.

In the case where all three of `l, m, f` are the same, then we can choose to return any of them, we we will choose to return the leftmost value. If all three are different from each other, that means that the conflict happened in the middle block, thus the middle block is split, the left block has the new values, and the right block has the old values. We should therefore return the leftmost value.

The other two cases happen when the conflict occurs in either the first or last block. If the conflict happens in the first block, we should return either the middle or last block, since the first block was in the middle of being updated. If the conflict is in the last block, that means the leftmost block was already updated, and we can safely return the leftmost block again. Therefore, the only real case where we return anything except the leftmost block is when the middle and right blocks match each other, but the leftmost block does not match either of them.

This ensures atomicity because once we start returning the leftmost value (which can only happen if it is the new value), due to the way we read in reverse order, we can never return the old value again. Strictly, the sequence of events for an overlap looks something like:

+ `write()` just started but hasn't done anything, `read()` the old value.
+ `write()` is in the middle of writing the first block, `read()` the old value.
+ `write()` is in the middle of writing the middle block, `read()` the new value.
+ `write()` is in the middle of writing the last block, `read()` the new value.
+ `write()` has finished writing, `read()` the new value.

This of course, is synonymous to saying our linearization point for `write()` occurs after we have finished writing to the first block.

= Problem 7

== Regular

#twocol(
  [
    === Mutual Exclusion

    The main point of interest when considering regular registers is the fact that they have the potential to return either the old or new value when a `read` collides with a `write`. When it comes to the labels, this holds little importance, as the value continues to go up, and any ties are broken by the id of the thread. For the flag array, as long as the value holds after the statement, it doesn't matter if the `read` during the `write` returns `false`. This is because the main purpose of the flag is to signal interest, and it is impossible for a thread to even begin to attempt top enter the critical section if it is not done with the flag of its interest. There are no negative side effects of observing this from another thread's point of view either. 
  ],
  [
    === First-Come-First-Served

    Initially, the label was not updated until the end of the of the statement anyway, so the regular register provides an insignificant difference to the regular operation of the algorithm. The FCFS nature of the algorithm is unchanged insofar as the original algorithm regards fairness. Because you snapshot your position in line with the label, and the label still continuously goes up in the case of the regular register, nothing changes.
  ],
)

== Safe

#twocol(
  [
    === Mutual Exclusion

    Safe registers pose more of a threat, because they are not responsible for what happens when a `read` collides with a `write`. That is, they can return anything of their choosing when a `read` comes in during a `write`. As discussed above, this doesn't change much for the label array, is the value does not matter until the statement is finished. However, the label array needs more consideration as other competeing threads may be trying to read this value, for example a thread might read a much lower value than what is actually present. All this does however, is potentially give too low of a label to any given thread. This does not impact the mutual exclusion.
  ],
  [
    === First-Come-First-Served

    As shown on the left, it is possible to read too low of a value, and therefore a thread who goes later may end up going in front of another thread who came first if the previously maximal value thread is also competing, meaning they are writing to their label, and can return anything from a read. Therefore, there is no longer a FCFS guarantee.
  ],
)

== Wraparound

#twocol(
  [
    === Mutual Exclusion

    Similarly to the discussion in the mutual exclusion section of the safe register, there is no significant danger to the mutual exclusion of the algorithm.
  ],
  [
    === First-Come-First-Served

    Because the whole algorithm relies on continuously increasing label values, the wraparound register greatly interferes with this process. Suppose that $v = 5$ and we have the following operations at an empty state:

    + Thread `1` is the only thread with the label `5`, thread `2` has label `4`
    + Thread `2` attempts to secure the lock, and as a result, its label is set to `0`
    + Thread `2` attempts to secure the lock, and as a result, its label is set to `5`
  ],
)

= Problem 8


