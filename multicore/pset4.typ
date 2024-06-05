#import "template.typ": *
#show: template.with(
  title: "6.5081 PSET 4",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (a)

*Consensus Number*: $infinity$

Recall that using the regular FIFO queue raised problems for any $n > 2$ consensus number, as there was no possible combination of operations at the critical state that could guarantee a consensus. However, with this new `peek()` operation, we can now guarantee a consensus for any $n$. I will work under the assumption that `peek()` is atomic.

I propose the following algorithm:

```java
public class PeekQueueConsensus<T> extends ConsensusProtocol<T> {
  PeekQueue pq;
  public QueueConsensus() {
    // initialize queue
    pk = new PeekQueue();
  }
  public T decide(T Value) {
    propose(value);
    int i = ThreadID.get();
    // propose ourself as the candidate
    pq.enq(i);
    // see who the actual first place is
    int winner = pq.peek();
    return proposed[winner];
  }
}
```

The idea for this algorithm is that we will propose ourselves as the candidate, adding our ID to the `PeekQueue`. The advantage with this algorithm that a regular `Queue` does not have is that we have the ability to `peek()`, which does not modify the state of the queue. This fixes the main issue with the regular `Queue` algorithm, which is that threads past the first two cannot deduce who the winner is. There will be a first element in the queue, and every single thread can `peek()` to see who that winner was. Thus with this algorithm, we can support a consensus for any number of threads.

== (b)

*Consensus Number*: $2$

First I will show that the consensus number is at least $2$ for a `Stack`. Consider the following algorithm:

```java
public class StackConsensus<T> extends ConsensusProtocol<T> {
  private static final int WIN = 0; // first thread
  private static final int LOSE = 1; // second thread
  Stack stack;
  // initialize stack with two items
  public StackConsensus() {
    stack = new Stack();
    stack.push(LOSE);
    stack.push(WIN); // WIN is at the top of the stack
  }
  // figure out which thread was first
  public T decide(T Value) {
    propose(value);
    int status = stack.pop();
    int i = ThreadID.get();
    if (status == WIN) {
      return proposed[i];
    } else {
      return proposed[1-i];
    }
  }
}
```

This algorithm is almost the exact same as the simple `Queue` consensus implementation, except the elements are pushed in reverse order since it is a stack.

Now I will show that the consensus number is at most $2$. Consider an exhaustive list of all possibilities at the critical state, where we have threads `a,b,c` and thread `a` moves the protocol to a 0-valent state and thread `b` moves the protocol to a 1-valent state:

+ `push` and `push` - suppose `a` and `b` `push()` in that order. Then `a` and `b` both `pop()` the stack. The stack therefore returns to the original state, and there is no difference to the ordering where `b` went first. Thus for any threads that go after the first two, they are supposed to deduce somehow that either `a` or `b` went first, but they cannot do so.
+ `push` and `pop` - Suppose whichever thread goes first does a `push()` and the next thread does a `pop()`. In this case, the stack will be empty, and the next thread will not be able to deduce who went first. If the order is reversed, regardless of whether the stack starts out empty or not, the final state will be the same, except the top element of the stack, which will either be the result of `a` or `b` doing a `push()`. In both cases, there is another analogous ordering that thread `c` can be confused by. For example, if `a` does a `pop()` and `b` does a `push()`, `c` should deduce that it is `a`-valent, since `a` went first. However, this is functionally no different from the case where `b` does a `push()` by itself, in which case the system is `b`-valent.
+ `pop` and `pop` - Suppose `a` and `b` both `pop()`. There is no way for any thread that comes after them to observe what order they went in, since the stack will contain the same elements, as the `pop()` operations remove the same elements (if they exist).

== (c)

*Consensus Number*: $2$

The consensus number must be at least $2$, since we have all the operations from *(b)*. However, we now have an additional possibility from `peek()` that must be considered in the critical state. I will show an exhaustive list of all possibilities including `peek()` that can happen at the critical state:

+ `peek` and `peek` - Since `peeking` does not change the state of the system, there is no way for any thread that goes after to deduce who went first.
+ `peek` and `pop` - Because `peek()` does not change the state of the system, the stack will look the same after both operations - that is, it will be missing the top element, if there exists one. There is therefore no way for any thread that goes after to deduce who went first.
+ `peek` and `push` - If `a` does a `peek()` and `b` does a `push()`, the stack will contain the same elements, except the top element will be the result of `b` doing a `push()`. If the order is reversed, the stack will contain the same elements, except the top element will be the result of `a` doing a `peek()`. There is no way for any thread that goes after to deduce who went first, as the stack looks exactly the same for some thread `c`

= Problem 2

== (a)

This question can be reduced to a consensus problem using atomic registers. We wish to show that it is possible for a consensus number of $2$. However, we know from class that atomic registers have a consensus number of $1$. Each line can be thought of as a register that contains the integral value of the text in that line. Thus, there is no way that Alice and Bob can exactly coordinate their time under the wait-free condition, as that would require a consensus number of at least $2$, which we know atomic registers do not have.

== (b)

Yes, there is a way for them to reach an approximate closeness in a finite amount of time. We can give "ownership" of the first line to Alice, and "ownership" of the second line to Bob. The protocol then proceeds as follows for either Alice or Bob:

+ Write your time to your register.
+ Read the other person's register. If it is empty, return your time as the decided time.
+ If the other person's register is not empty, take the average of the two times and write that into your register.
+ Repeat *(3)* until you are within the desired $epsilon$

Because the two move toward each other by taking the average, they can only ever get closer to each other, and will never pass by each other. We can always reach an approximation in a finite number of time steps relative to $epsilon$

= Problem 3

== (a)

=== Consistent

Assume for the next sections that we have two threads `a` and `b`

Suppose that `a` sees it is "far behind" and returns `b`. Let us show that `b` must see it is "far ahead" and return itself. At the moment `a` returns, it has a smaller value than `b`. Let us suppose that `b` somehow thought `a` was ahead of it, and returned. If this was the case, then `b` would have a smaller value than `a` from that point onward, since both speeds are positive, and `b` has returned. However, the same logic applies for `a`. Essentially, the thread that returns it is behind first will forever be behind, and it is guaranteed that the other thread has not returned yet, and will eventually see it is ahead. Otherwise it would not have been possible for this thread to return it is less, since the other thread would have returned first.

Suppose that `a` sees it is "far ahead" and returns itself. Let us show that `b` must see it is "far behind" and returns `a`.  `a` can only make this claim if it is at least one full loop iteration ahead of `b`. If `b` were to have already returned, it could not have said that it was ahead of `a`. If this was the case, `a` would have seen that `b` returned, since `b` would only have done this if it had a one loop grace period on `a`. Thus, it must be the case that `b` has not returned yet, and since `a` has at least a one loop grace period on `b`, `b` must return `a`.

=== Valid

We only return a proposed value, and the only proposed values that are set are at the beginning of the function by two threads. There are no further modifications to the data structure, meaning we must return one of the two values that were set prior.

== (b)

If the 1-speed thread runs exactly three times faster than the 3-speed thread, then it is impossible for the 1-speed thread to ever be more than 3 ahead of the 3-speed thread. Conversely, the 3-speed thread will never catch up to the 1-speed thread. This will result in the two threads racing infinitely, and thus it cannot be wait free.

= Problem 4

== (a)

Consensus number: $2$

Recall that in an atomic register, this type of class of objects ran into the issue that issuing two writes would always favor the thread that went first. That is, at a critical section, there would be no way for the second thread to deduce who truly went first. This however, is not the case for both of these functions, as they both use the old value in the computation for the new one. First, I will show that the consensus number is at least $2$:

For the `FetchAndMultiply` class, consider the following algorithm. Two threads use a shared `FetchAndMultiply` object, with the initial value being $1$. Then suppose thread `a` calls `FetchAndMultiply(2)`, and thread `b` calls `FetchAndMultiply(3)`. If they see these exact values then they were the first to go, otherwise, they were the second to go, and should return the other element.

For the `FetchAndSquare` class, consider the following algorithm. Two threads use a shared `FetchAndSquare` object, with the initial value being $2$. Then suppose thread `a` calls `FetchAndSquare()`, and thread `b` calls `FetchAndSquare()`. If they see $4$, then they were the first to go, and otherwise, they will see $8$, meaning they should return the other element.

Now I will show that the consensus number is at most $2$:

There is only one combination of operations to consider for both, which is having two of the same calls. In both cases, it is impossible for a third thread `c` to observe any difference, as multiplication and squaring are both commutative operations. It would be impossible for `c` to deduce who went first in this one exhaustive case, and thus the greatest that the consensus number can be is $2$.

== (b)

= Problem 6

They would both cease working as both implementations contain a prerequisite check to make sure the current node was not previously added to the list. We could end up in a scenario where the node was not considered part of the list due to the fact that sentinel number is 0, and does not behave properly at the check each of the implementations have. Thus, this could lead to a catastrophic failure later in the algorithm with this assumption.

= Problem 7

Suppose that other edit happen to a thread's head while they are processing some other function. If we assign this value locally instead of consulting what happened in the rest of the system, we might miss out on critical updates. If this were to happen, the control flow might be altered, and a thread might be confused on where the head as supposed to be. This would lead to a nonlinearizable construction, as the head would not be consistent across all threads. Thus, it would become impossible to get a consistent sequence of operations, and thus the construction would not work anymore.

= Problem 9

Both code snippets were adapted almost verbatim from the textbook sections as linked.

*`CLHLock.java`*

```java
import java.util.concurrent.atomic.*;

public class CLHLock implements Lock {
    volatile AtomicReference<QNode> tail = new AtomicReference<QNode>(new QNode());
    ThreadLocal<QNode> myPred;
    ThreadLocal<QNode> myNode;

    public CLHLock() {
        // set the initial values for all fields
        tail = new AtomicReference<QNode>(new QNode());
        myNode = new ThreadLocal<QNode>() {
            protected QNode initialValue() {
                return new QNode();
            }
        };
        myPred = new ThreadLocal<QNode>() {
            protected QNode initialValue() {
                return null;
            }
        };
    }

    public void lock() {
        QNode qnode = myNode.get();
        qnode.locked = true;
        // set up the chain of nodes
        QNode pred = tail.getAndSet(qnode);
        myPred.set(pred);
        // spin until our predecessor is done
        while (pred.locked) {}
    }

    public void unlock() {
        QNode qnode = myNode.get();
        // im no longer busy!
        qnode.locked = false;
        // move to new node
        myNode.set(myPred.get());
    }

    class QNode {
        boolean locked = false; 
    }
}
```

*`MCSLock.java`*

```java
import java.util.concurrent.atomic.*;

public class MCSLock implements Lock {
    AtomicReference<QNode> tail;
    ThreadLocal<QNode> myNode;

    public MCSLock() {
        // init all fields
        tail = new AtomicReference<QNode>(null);
        myNode = new ThreadLocal<QNode>() {
            protected QNode initialValue() {
                return new QNode();
            }
        };
    }

    public void lock() {
        QNode qnode = myNode.get();
        QNode pred = tail.getAndSet(qnode);
        if (pred != null) {
            qnode.locked = true;
            pred.next = qnode;
            // wait until predecessor gives up the lock
            while (qnode.locked) {}
        }
    }

    public void unlock() {
        QNode qnode = myNode.get();
        if (qnode.next == null) {
            if (tail.compareAndSet(qnode, null))
                return;
            // wait until predecessor fills in its next field
            while (qnode.next == null) {}
        }
        qnode.next.locked = false;
        qnode.next = null;
    }

    class QNode {
        boolean locked = false;
        QNode next = null;
    }
}
```

= Problem 10

== (a)

The speedups are listed below:

/ TASLock: 0.1830
/ BackoffLock: 0.2012
/ ReentrantLock: 0.1581
/ CLHLock: 0.8923
/ MCSLock: 0.9041

Yes it does make sense given the complexity of the paths. The implemented locks seem to do much better, since they are able to almost instantly acquire the lock. I was a little surprised by the fact that the more complex locks, such as the CLHLock and the MCSLock went so much faster than their competition, despite having to create and edit objects constantly.

== (b)

#bimg("img/m1.png")

/ Green: TASLock
/ Purple: BackoffLock
/ Blue: ReentrantLock
/ Red: CLHLock
/ Black: MCSLock

It looks like the more complex algorithms start worse, which is to be expected. However they quickly outscale and outperform the simpler algorithms. The TASLock and BackoffLock are the worst performing, which is to be expected since they are the simplest. The ReentrantLock is a little better, but still not as good as the CLHLock and MCSLock. The CLHLock and MCSLock are the best performing, which is to be expected since they are the most complex.

== (c)

#bimg("img/m2.png")

Yes, the correlation matches somewhat with the previous part. However, it is important to notice that there was an incredible amount of variety in the results, and the standard standard deviation deviated by orders of magnitude. I averaged the value over multiple runs to get the best possible average value.

However, with this take into mind, we can see that my tuning of BackoffLock was perhaps a little too good, as it saw an almost out of character placement in the graph. Everything else seemed to follow a reasonable trend through, with the more complex locks having generally lower standard deviation.
