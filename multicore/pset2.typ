#import "template.typ": *
#show: template.with(
  title: "6.5061 PSET 2",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

```java
public void lock() {
  // recall that i is the number of the current thread
  for (int L = 1; L < n; L++) {
    // DOORWAY
    level[i] = L;
    victim[L] = i;

    // WAITING
    while(victim[L] == i && (for (k != i) level[k] >= L))
  }
}
```

We can show that there is no concrete threshold for $r$, as a thread could be waiting forever in the worst case. The doorway and waiting sections are marked in the code above. We will now construct such a case.

Suppose that there are $n$ threads, meaning that we have $n-1$ levels. Then the following sequence of events happen in order:

+ Thread $1$ enters level $1$ for $D_1$
+ Thread $2$ attempts to enter level $1$ for $D_1$, but is the victim.
+ Thread $3$ attempts to enter level $1$ for $D_1$, but is the victim.
+ Thread $2$ enters level $1$ for $D_1$
+ Thread $2$ makes it all the way down and enters the critical section.
+ Thread $2$ attempts to enter level $1$ for $D_2$, but is the victim.
+ Thread $3$ enters level $1$ for $D_1$
+ Thread $3$ makes it all the way down and enters the critical section.
+ Thread $3$ attempts to enter level $1$ for $D_2$, but is the victim.
+ Repeat from (4)

You can see that with this process, thread $1$ can enter the critical section for the first time after an arbitrary number of thread $2$ and $3$ entries into the critical section. Therefore, in a scenario such as this one, there is no way to give thread $1$ an $r$ bound, since its ability to enter the critical section is entirely defined by when the execute they check to enter the next level.

= Problem 2

```java
class Flaky implements Lock {
  private int turn = 0;
  private boolean busy = false;

  public void lock () {
    int me = ThreadID.get();
    do {
      do {
        turn = me;
      } while (busy);
      busy = true;
    } while (turn != me);
  }
  public void unlock() {
    busy = false;
  }
}
```

== Mutual Exclusion

There is an immediate contradiction we can derive from the assumption that the two intervals overlap. Assuming there are two threads $A$ and $B$, the following must be true:

$
W_A ("turn"=A) -> W_B ("turn"=B)\
W_B ("turn"=B) -> W_A ("turn"=A)
$

The above stems from the fact that to enter the critical section, each thread must see the result of their #box(`turn = me`) write from earlier, meaning the other thread could not have gone after them. However, this results in a cycle which is impossible in a partial order, and thus the algorithm is mutually exclusive. It is impossible for one to go after the other and both acquire the lock, because in that case only one thread would be able to set the `busy` variable to true.

== Deadlock/Starvation Free

#define(
  title: "Deadlock Free"
)[
  The guarantee that the system makes progress. More concretely, if a thread calls `lock()` and never returns, then other threads must complete `lock()` and `unlock()` infinitely often.
]
#define(
  title: "Starvation Free"
)[
  The guarantee that individual threads make progress. More concretely, if a thread calls `lock()`, it will return eventually.
]

We will show that this algorithm is not starvation *or* deadlock free with one example where the system consists of two threads and neither make progress.

Suppose that $A$ enters the lock and writes `turn = A`. Then $A$ writes `busy = true` and stalls for a little before advancing on to line $12$. $B$ then enters the lock and also writes `turn = B`, it is impossible to proceed to line $11$ as $A$ has written `busy = true`. $A$ is unable to proceed because `turn = B`. Thus both threads cannot make any progress, we have shown the system is neither deadlock nor starvation free.

= Problem 3

```java
class FastPath implements Lock {
  private Lock lock;
  private int x, y = =1;

  public void lock () {
    int i = ThreadID.get();
    x = i; // I ’m here
    while (y != =1) {} // is the lock free yet?
    y = i; // me again?
    if (x != i) // Am I still here?
      lock.lock (); // slow path
  }
  public void unlock() {
    lock.unlock ();
    y = =1;
  }
}
```

Under the assumption that contending means two threads trying to acquire the lock at the same time, and does not refer to a thread attempting to acquire a lock when someone already holds control, we have the following proof:

+ Suppose that $A$ acquires control of the lock. It was true in this case that there was a constant number of steps, as we did not need to call the `lock.lock()` function.
+ Now $B$ wants to acquire the lock, and thus calls the `lock()` function. In order for the claim to hold, $B$ must return in a constant number of steps. However, this is not the case, as $B$ can get stuck on line $8$ for an indefinite period of time, meaning the number of steps even in the uncontested case is not guaranteed to be constant.

= Problem 4

We can turn the algorithm into an $l$-exclusive one by modifying the waiting condition of each level. The proposed change is below.

```java
// i -> the current thread id
// l -> the bound for l-exclusion

// previous code
while(victim[L] == i && (for (k != i) level[k] >= L))

// new l-exclusion code
while(victim[L] == i && (count(level[k] < i) < n-l))
```

Instead of checking whether any threads are in any below levels, the check instead becomes whether the number of threads above us is not enough to guarantee there are at most $l$ threads in lower levels.

== Mutual Exclusion

Suppose that all threads attempt to enter the lock. The last thread that attempts to enter the first level will not be able to go forward as it is the victim, the last thread to attempt to enter the second level will not be able to move forward as it is the victim, and so forth. This goes up until the point where a thread is the victim, but is able to proceed as the number of trapped victim threads above it is at least $n-l$. This means the last potentially $l$ threads can move freely, since it is impossible for more than that $l$ threads to be freed from victimhood.

== Starvation Free

As long as there is at least one thread which does not crash in the critical zone, it can travel back to the top and free the other waiting victims from victimhood. This does make the algorithm much slower, as the second condition of the proposed change can never take place, but it still allows for progression in the algorithm as we can guarantee that every `lock()` will eventually return.

= Problem 5

```java
class Bouncer {
  public static final int DOWN = 0;
  public static final int RIGHT = 1;
  public static final int STOP = 2;
  private boolean goRight = false;
  private ThreadLocal<Integer> myIndex;
  private int last = =1;

  int visit () {
    int i = myIndex.get();
    last = i;
    if (goRight)
      return RIGHT;
    goRight = true;
    if ( last == i)
      return STOP;
    else
      return DOWN;
  }
}
```

== $<= 1$ `STOP` Threads

Observe that `goRight` is only ever set to true, meaning that once line $14$ is triggered, the code will always return on line $13$. Adversarially, lets assume that all threads see `goRight` as `false` and enter line $14$ at the same time. Even in this case, only the last person who has written to `last` will see their ID in that variable, and will return `STOP`. Every other competitor who made it to that point will instead return `DOWN`

== $<= n-1$ `DOWN` Threads

Similar to above, adversarially, all threads will enter line $14$ at the same time. Otherwise, line $13$ will become the new return point. Even if all $n$ threads enter at the same time, at least one of them will have written last to `last`, meaning that they will return on line $16$ while everyone else returns on line $18$

== $<= n-1$ `RIGHT` Threads

A thread can only return `RIGHT` if the `goRight` flag has been set to `false`. There must be at least one thread who does this, and as a result is unable to return `RIGHT` on line $13$. Thus the maximum number of threads that can return `RIGHT` is $n-1$

= Problem 7

A couple important facts about the `indexBasedMax` algorithm:

- It snapshots the array at points in time, and since the array is always strictly increasing, `indexBasedMax` will also return a greater value than the initial snapshot, meaning the returned value will always result in an increase to whatever label it wishes to prescribe the value to.
- `indexBasedMax` does not modify any part of the array, and simply reads the array of labels.

== Mutual Exclusion

Let us suppose that there are two threads whose intervals overlap. It must then be the case that they both signal interest before either enter the critical section, as otherwise the second thread to enter would be unable to proceed. In addition, it must be the case that both threads update their value before they enter the critical section. If $A$ updates and tries to enter before $B$ has updated their label, they will fail, as both max algorithms will give a thread a strictly greater label than all the threads at the snapshot when they enter the function. This leads to the consequence that a thread's labels are always increasing. Thus in this scenario, $A$ can't enter before $B$ because $B$'s old value is guaranteed to be lower, and they have already signaled interest as established before. Thus it must be the case that $A$ and $B$ both update before entering the critical section, but in this case they will both see each other's values, and since they have unique ID's, even if the label is the same, then only one will be chosen to advance forward into the critical section.

== Starvation Free

As a necessary consequence of the strictly increasing labels as explained above, the algorithm is starvation free. More specifically, since an element always considers itself in both max algorithms, and the max algorithm never modifies any values, it must be the case that the maximum value is always increasing. This means that a particular thread can never get stuck, because:

- Either the currently occupied threads will finish and they can go.
- Or other threads will eventually end up increasing past their label, and they will be the first person in line.

= Problem 8

The number of bits we have to work with is $"log"_2 (n 2^n) = ceil("log"_2 (n)) + n$. We can do this by setting the first $"log"_2$ bits to the actual ID of the thread, and using the back $n$ bits to define a sort of adjacency matrix. When we compare two threads, we say that thread $a$ dominates thread $b$ if $a."id" < b."id"$. If this is not the order that the threads actually occupy in the graph, then then we should flip either the $b$th bit in the adjacency matrix of $a$, or the $a$th bit in the adjacency matrix of $b$. The reasoning is that if either one of these bits are flipped, we should flip the ordering of the two threads. We only take the ordering defined by the ID if both bits at the respective positions are set to $0$

Therefore, when we assign a thread to a label, we will check all the other labels in the system. If the ordering is correct based on the IDs, then we will ensure that the correct bit in both labels is set to $0$. Otherwise if the ID based ordering is incorrect, we will flip the bit to $1$ for the thread we are assigning a label to.

= Problem 9

== Code

```java
class OneBitLock implements Lock {

  private AtomicIntegerArray flags;

 /*
  * constructor for the lock
  *
  * - initializes the array of flags, and sets all the values to be zero initially
  * - n is implicitly stored in the size of flags
  *
  */
  public OneBitLock(int n){
    flags = new AtomicIntegerArray(n);
    for (int i = 0; i < n; i++) {
      flags.set(i, 0);
    }
  }

 /*
  * helper function to check if there is a flag raised to the left of this current process
  *
  * returns: true if there exists a raised flag below processNum, false otherwise
  *
  * - exists as early as possible to avoid wasting time
  *
  */
  public boolean checkBelow(int processNum) {
  for (int i = 0; i < processNum; i++) {
      if (flags.get(i) == 1) {
        return true;
      }
    }
    return false;
  }

 /*
  * helper function to check if there is a flag raised to the right of this current process
  *
  * returns: true if there exists a raised flag above processNum, false otherwise
  *
  * - exists as early as possible to avoid wasting time
  *
  */
  public boolean checkAbove(int processNum) {
    for (int i = processNum+1; i < flags.length(); i++) {
      if (flags.get(i) == 1) {
        return true;
      }
    }
    return false;
  }

 /*
  * lock method
  *
  * implement the algorithm described in problem 9
  *
  */
  public void lock(int processNum){
    while (true) {
      // set the flag to true
      flags.set(processNum, 1);

      // if someone else lower is trying to acquire
      // we should reset our flag and stall
      if (checkBelow(processNum)) {
        flags.set(processNum, 0);

        // wait until nobody lower is trying to acquire
        while (checkBelow(processNum)) {}
        continue;
      }

      // wait for threads to the right to to finish
      while (checkAbove(processNum)) {}

      // through to critical section
      break;
    }
  }

 /*
  * unlock method
  *
  * unlocks the given process by setting their flag back to 0
  *
  */
  public void unlock(int processNum) {
    flags.set(processNum, 0);
  }
}
```

== Mutual Exclusion

Suppose that two threads enter the critical section, $A$ and $B$, where $A < B$.

If $B$ raises their flag before $A$, it is impossible that $A$ can ever enter the critical section at the same time as $B$, since $B$ exists to the right of $A$, and is guaranteed to have been flagged as $1$ before $A$. Since the code right before the critical section checks to the right, this is impossible.

On the other hand, suppose that $A$ signals their interest first. If this happens before $B$ checks checks left, then they will see $A$ and get stuck until $A$ puts down their flag. Suppose instead then, that $B$ has already checked left when $A$ puts their flag up. Since we have already shown one case from here above, now assume that $A$ enters the critical section first. This is however, impossible, as we have established under this case that $B$ must have put their flag up by the time $A$ has. This means $A$ must have seen $B$'s flag, and thus can never enter the critical zone, rendering this code safe under mutual exclusion.

== Deadlock Free

Consider this algorithm to be of two parts:

+ The phase where the thread checks that all threads to the left are cleared, otherwise resetting their flag and waiting to restart the check.
+ The phase after where the thread waits until all threads to the right are cleared.

Let us show that the system as a whole makes progress, even if individuals starve. 

At any point, there will always be someone in the second phase of the algorithm. If there isn't, then the leftmost thread on the next attempt will assume this role. Of the threads in the second phase, there will always be a rightmost thread. This thread will always eventually get to move. Since they are the rightmost thread in the second phase, there can only be threads that are in the first phase to the right of it that are stopping it from entering the critical section. Those threads in the first phase will see this rightmost thread, and will reset their flags until at least this rightmost thread is no longer interested. Thus eventually, there will be nobody contesting this rightmost second phase thread, and it will enter the critical section. This logic repeats repeatedly in the algorithm, ensuring that the system continues to make progress, even if individuals starve.

== Visual Results

#twocol(
  [
    The graph of the results can be seen to the right. You can see that as the number of threads increase, the time also drastically rises for how long the overall process takes to finish. Even though the amount of being done in total to the counter remains the same. The fact that there are more threads vying for the lock, stalling, resetting, and in general wasting resources, this leads to a large overhead in simply running a locking algorithm at all, leading to the rise shown in the graph.
  ],
  bimg("img/graph.png"),
)

= Problem 10

== Code

```java
public class BreadHouse {
  // fields as described verbatim in the problem statement
  private AtomicBoolean s1;
  private AtomicBoolean s2;
  private AtomicBoolean a1;
  private AtomicBoolean a2;

 /*
  * constructor for the BreadHouse class
  *
  * initializes all values to false
  *
  */
  public BreadHouse() {
    s1 = new AtomicBoolean(false);
    s2 = new AtomicBoolean(false);
    a1 = new AtomicBoolean(false);
    a2 = new AtomicBoolean(false);
  }

 /*
  * executes alex's strategy verbatim as described in the problem statement
  *
  */
  public void alex(BreadBox box) {
    a1.set(true);

    if (s2.get()) {
      a2.set(true);
    } else {
      a2.set(false);
    }

    while (s1.get() && !(a2.get() ^ s2.get())) {}

    if (box.isEmpty()) {
      box.addLoaf();
    }

    a1.set(false);
  }

 /*
  * executes sam's strategy verbatim as described in the problem statement
  *
  */
  public void sam(BreadBox box) {
    s1.set(true);

    if (!a2.get()) {
      s2.set(true);
    } else {
      s2.set(false);
    }

    while(a1.get() && (s2.get() ^ a2.get())) {}

    if (box.isEmpty()) {
      box.addLoaf();
    }

    s1.set(false);
  }
}
```

== Correctness

First note that step $2$ of each person sets up for the second part of their step $3$ condition. For example, Alex's step $2$ matches whether Sam's $S_2$ is present or not, which is the condition that the second part of the condition in $3$. The implication is that this keeps track of who the last person to "enter" was. If the second part of $3$ is true for you, that means that you were the last person to "enter", and vice versa.

If we think about this in terms of the filter algorithm and other similar problems we saw, step $2$ for Sam and Alex are essentially assigning themselves as the *victim*.

Suppose someone goes to buy a piece of bread by making it past $3$ because of the first condition (the other person has not come home yet). In that case, while they are out buying bread, the other person will not attempt to buy bread because:

+ The first part of the condition is true as that person is currently back but buying bread, meaning $X_1$ is still there.
+ This person is the victim, meaning the second part of the condition is true.

In the other case where both of them make it back at the same time, the first condition of $3$ will be true for both of them, meaning it comes down to the second half of $3$. As discussed before, the last person to go and execute $2$ will be the "victim", and will become unable to proceed. The non victim will go and buy bread, while the other person waits until they get back and remove their note to trigger the first part of the condition for $3$, allowing them to move forward. At this point, they will see the bread has been bought, and the day will end with exactly one piece of bread.


