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

If a system is deadlock free, that means there at least one thread will make acquire the lock and progress the system. This does *not* mean that we can guarantee an infinite number of steps in the execution, simply because we had some number of steps in the infinite history $bold(H)$

== (c)

This does imply wait-free. We want to ensure that every thread will make some progress in a non-infinite amount of time (i.e. that no thread takes an infinite amount of steps by waiting without ever completing a method call), which is fulfilled by the statement's promise that no thread that takes an infinite amount of steps will not complete an infinite amount of method calls.

== (d)

These are not equivalent. Starvation freedom requires that every thread that tries to call the method will eventually complete it, and this statement is stronger than this requirement because it guarantees that every single thread in will eventually complete an infinite amount of method calls.

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

    Safe registers pose more of a threat, because they are not responsible for what happens when a `read` collides with a `write`. That is, they can return anything of their choosing when a `read` comes in during a `write`. As discussed above, this doesn't change much for the flag array, is the value does not matter until the statement is finished. However, the label array needs more consideration as other competeing threads may be trying to read this value, for example a thread might read a much lower value than what is actually present. Consider the following case:

    + Two threads attempt to acquire the lock, thread `1` has the previously maximal value.
    + Thread `1` attempts to write its new value as `label[1]+1`
    + Thread `2` writes its new value as `label[1]+1`
    + Thread `2` enters the critical section, since reads thread `1`s label as something much lower.
    + Thread `1` enters the critical section, since it has the same label, but lower id than `2`
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

    Suppose there is a thread in the critical section who has a label of $v$. If another thread comes in and tries to acquire the lock, they will succeed, as their label will be $0$ instead of $v+1$
  ],
  [
    === First-Come-First-Served

    Because the whole algorithm relies on continuously increasing label values, the wraparound register greatly interferes with this process. Suppose that $v = 5$ and we have the following operations at an empty state:

    + Thread `1` is the only thread with the label `5`, thread `2` has label `4`
    + Thread `2` attempts to secure the lock, and as a result, its label is set to `0`
    + Thread `1` attempts to secure the lock, and as a result, its label is set to `0`
    + Despite thread `2` finishing its process first, thread `1` will get let in earlier.
  ],
)

= Problem 8

We are able to use an almost identical solution from problem 5. The crux of the design will revolve around $3 dot log(M)$ registers.

When a `write()` happens, it will copy the binary representation of the number number into the first $log(M)$ registers, before repeating the same process for the other two blocks.

When a `read()` happens, it will read in reverse order in three batches, and employ the same algorithm found in problem 5, returning a consistent value of either the new or old register.

The correctness of this approach is the exact same as the aforementioned proof and stands for this problem as well. Because there is at most one write at a time, the solution does not functionally differ from that of the fifth problem. There are problems with multiple writes, but the premise of the question allows us to ignore this hindrance. 

= Problem 9

#note(
  title: "Code for Problem 9"
)[
  I have inserted appropriate code in their respective section, and any other miscellaneous files such as the tester have gone in at the end. All included comments have been omitted for brevity, but comments that I have added are left in to demonstrate understanding. I am still unsure whether this is allowed or not since I have yet to receive feedback on the last code submission.
]

== (a)

The implementation I provided is correct as it simply locks around each of the functions. The lock is shared between the entire instance, so once the snapshot begins, nothing else can possibly interrupt the snapshot. This *does not* mean however, that any pending changes are lost, as they will instead hand and wait for the `scan()` to be over.

The `scan` will necessarily pull from the latest `update()`, and since all values are initialized to `0` manually, if there are no updates, that position in the array will return as `0`.

*`AtomicSnapshot.java`*
```java
import java.util.concurrent.atomic.*;
import java.util.concurrent.locks.*;

class AtomicSnapshot implements Snapshot {
    protected final AtomicIntegerArray array;

    // added fields
    private Lock lock;
    private AtomicInteger n;

    public AtomicSnapshot(int numSlots) {
        this.n.set(numSlots);
        this.lock = new ReentrantLock();
        // initialize array and set all values to 0
        this.array = new AtomicIntegerArray(this.n.get());
        for (int i = 0; i < this.n.get(); i++) {
            this.array.set(i, 0);
        }
    }

    public int[] scan() {
        // lock the function
        this.lock.lock();

        // critical section, nothing can change
        int[] arrayCopy = new int[this.n.get()];
        for (int i = 0; i < this.n.get(); i++) {
            arrayCopy[i] = this.array.get(i);
        }
        // unlock the function
        this.lock.unlock();
        // return the generated copy
        return arrayCopy;
    }

    public void update(int index, int val) {
        // lock the function
        this.lock.lock();

        // critical section
        this.array.set(index, val);

        // unlock the function
        this.lock.unlock();
    }
}
```

== (b)

The code for this question was generated almost verbatim from the suggested code, and thus all comments have been omitted.

*`SingleScanSnapshot.java`*
```java
import java.util.concurrent.atomic.*; // for AtomicXXX classes

class SingleScanSnapshot implements Snapshot {
    protected final AtomicInteger curSeq;
    protected final AtomicReferenceArray<Register> high;
    protected final AtomicReferenceArray<Register> low;

    public SingleScanSnapshot(int numScanners) {
        curSeq = new AtomicInteger(0);
        high = new AtomicReferenceArray<Register>(numScanners);
        low = new AtomicReferenceArray<Register>(numScanners);
        for (int i = 0; i < numScanners; i++) {
            high.set(i, new Register());
            low.set(i, new Register());
        }
    }

    public int[] scan() {
        int len = high.length();
        int[] view = new int[len];
        curSeq.set(curSeq.get() + 1);
        for (int j = 0; j < len; j++) {
            Register highReg = high.get(j);
            if (highReg.seq < curSeq.get()) {
                view[j] = highReg.val;
            } else {
                view[j] = low.get(j).val;
            }
        }
        return view;
    }

    public void update(int processNum, int val) {
        int seq = curSeq.get();
        Register highReg = high.get(processNum);
        if (seq != highReg.seq) {
            low.set(processNum, highReg);
        }
        high.set(processNum, new Register(val, seq));
    }
}
```

== (c)

The only modification that was made around the code from *(b)* was an instance lock that goes around the `scan` function. `update` is still wait free as it has not been tampered with. There is no need to provide any kind of extra security for `update` as it already ran independently, even when colliding with the `scan` calls.

It is necessary that the lock does not interfere with the functionality of the code. Since the `ReentrantLock` serves as an essentially infinite stall if another thread has already acquired the lock, we simulate concurrency and the power for two threads to freely call the `read` function, while retaining the actual functionality and stability of a single process `scan` implementation. 

*`DualScanSnapshot.java`*
```java
import java.util.concurrent.atomic.*;
import java.util.concurrent.locks.*;

class DualScanSnapshot implements Snapshot {
    protected final AtomicInteger curSeq;
    protected final AtomicReferenceArray<Register> high;
    protected final AtomicReferenceArray<Register> low;

    private Lock lock;

    public DualScanSnapshot(int numScanners) {
        // create new lock
        this.lock = new ReentrantLock();

        curSeq = new AtomicInteger(0);
        high = new AtomicReferenceArray<Register>(numScanners);
        low = new AtomicReferenceArray<Register>(numScanners);
        for (int i = 0; i < numScanners; i++) {
            high.set(i, new Register());
            low.set(i, new Register());
        }
    }

    public int[] scan() {
        // acquire the lock
        this.lock.lock();

        int len = high.length();
        int[] view = new int[len];
        curSeq.set(curSeq.get() + 1);
        for (int j = 0; j < len; j++) {
            Register highReg = high.get(j);
            if (highReg.seq < curSeq.get()) {
                view[j] = highReg.val;
            } else {
                view[j] = low.get(j).val;
            }
        }

        // release the lock before returning
        this.lock.unlock();
        return view;
    }

    public void update(int processNum, int val) {
        int seq = curSeq.get();
        Register highReg = high.get(processNum);
        if (seq != highReg.seq) {
            low.set(processNum, highReg);
        }
        high.set(processNum, new Register(val, seq));
    }
}

```

== (d)

The two implementations I chose to compare were:

+ A simple `AtomicInteger` counter which would be incremented by all threads simultaneously. 
+ The snapshot implementation from *(b)*, where no locks are needed.

I expected the simple `AtomicInteger` to be much faster, as the implementation is extremely simple, and doesn't use any kind of control mechanism. I thought this would lead to a low overall level of overhead, and perform significantly better than any other approach.

The results are graphed below:

#twocol(bimg("img/graph1.png"), bimg("img/graph2.png"))

Results were taken on $n = {1, 5, 10, 20, 40}$, using 10 trials and `500000` increments.

Somewhat surprisingly, over time, the increments per second actually got better for the snapshot. I believe this is because the read operations happen sparingly, and paying the price of Atomicity on the primary data structure *all the time* is rather taxing compared to a completely independent updating system as is the case for the snapshot. Unsurprisingly however, the reads always remained better for the `AtomicInteger` implementation.

Attached below are the two `Counter.java` files, followed by `CounterTest.java` and `Register.java`. The only notable changes in the other files are in the tester, where I added some convenient print statements to check my correctness.

*`Counter.java`* (_AtomicInteger_)
```java
import java.util.concurrent.atomic.*;

public class Counter implements Reader {
    private AtomicInteger counter;

    public Counter(int numServers) {
        this.counter = new AtomicInteger(0);
    }

    public int read() {
        return this.counter.get();
    }

    public void update() {
        this.counter.incrementAndGet();
    }
}

class CountingServer implements Server {
    private Counter counter;

    public CountingServer(Counter counter, int processNum) {
        this.counter = counter;
    }

    public void inc() {
        this.counter.update();
    }
}

```

*`Counter.java`* (_Snapshot_)
```java
import java.util.concurrent.atomic.*;

public class Counter implements Reader {
    protected final AtomicInteger curSeq;
    protected final AtomicReferenceArray<Register> high;
    protected final AtomicReferenceArray<Register> low;

    public Counter(int numServers) {
        curSeq = new AtomicInteger(0);
        high = new AtomicReferenceArray<Register>(numServers);
        low = new AtomicReferenceArray<Register>(numServers);
        for (int i = 0; i < numServers; i++) {
            high.set(i, new Register());
            low.set(i, new Register());
        }
    }

    public int read() {
        int len = high.length();
        // view is now a cumulative sum instead of being an array
        int viewCum = 0;
        curSeq.set(curSeq.get() + 1);
        for (int j = 0; j < len; j++) {
            Register highReg = high.get(j);
            if (highReg.seq < curSeq.get()) {
                viewCum += highReg.val;
            } else {
                viewCum += low.get(j).val;
            }
        }
/**
 * An immutable pair of integers: a value and a sequence number (aka timestamp).
 */
public class Register {
    /**
     * The value of the register.
     */
    public final int val;
    /**
     * The sequence number (aka timestamp) of the register.
     */
    public final int seq;
    
    /**
     * Constructs a Register with zeros.
     */
    public Register() {
        val = 0;
        seq = 0;
    }
    /**
     * Constructs a Register with the given value and sequence number.
     */
    public Register(int v, int s) {
        val = v;
        seq = s;
    }
}

        return viewCum;
    }

    public void inc(int processNum) {
        int seq = curSeq.get();
        Register highReg = high.get(processNum);
        if (seq != highReg.seq) {
            low.set(processNum, highReg);
        }
        high.set(processNum, new Register(highReg.val + 1, seq));
    }
}

class CountingServer implements Server {
    private Counter counter;
    private int processNum;

    public CountingServer(Counter counter, int processNum) {
        this.counter = counter;
        this.processNum = processNum;
    }

    public void inc() {
        this.counter.inc(processNum);
    }
}
```

*`CounterTest.java`*
```java
import java.util.concurrent.atomic.*;
import java.util.concurrent.locks.*;

interface Snapshot {
    /**
     * Gets an atomic snapshot of the values in Snapshot.
     * 
     * This method is called by "scanner" threads. This method
     * returns the values in each slot of the Snapshot object.
     * 
     * @return
     *         The value of the Snapshot.
     */
    public int[] scan();

    /**
     * Updates the value of the Snapshot in the slot for a given thread.
     * 
     * This method is called by "updater" threads. This method sets the slot
     * in the snapshot at location index to have value val.
     * 
     * @param index
     *              The index in the array to update.
     * @param val
     *              The value to be written.
     */
    public void update(int index, int val);
}

interface Reader {
    public int read();
}

interface Server {
    public void inc();
}

////////////////////////////////////////////////////////////////////////////////

class ServerRunner implements Runnable {
    public final AtomicBoolean done;
    private final Server server;
    private final int processNum;
    private final int numIncs;

    public ServerRunner(Counter counter, int processNum, int numIncs) {
        done = new AtomicBoolean(false);
        this.server = new CountingServer(counter, processNum);
        this.processNum = processNum;
        this.numIncs = numIncs;
    }

    public void run() {
        for (int i = 0; i < numIncs; i++) {
            server.inc();
        }
        done.set(true);
    }
}

class ReaderRunner implements Runnable {
    public final AtomicBoolean done;
    private final Reader reader;
    public int scanCount;
    public int[] recentSnapshots;

    public ReaderRunner(Reader reader) {
        this.done = new AtomicBoolean(false);
        this.reader = reader;
        this.scanCount = 0;
        this.recentSnapshots = new int[10];
    }

    public void run() {
        while (!done.get()) {
            final int curVal = reader.read();
            scanCount++;
            recentSnapshots[scanCount % recentSnapshots.length] = curVal;
        }
    }
}

class StopWatch {
    private long startTime;

    public StopWatch() {
        startTime = System.nanoTime();
    }

    public void reset() {
        startTime = System.nanoTime();
    }

    public double peek() {
        return (System.nanoTime() - startTime) / 1000000.0; // milliseconds
    }
}

public class CounterTest {
    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println("ERROR! Usage: java CounterTest [numTrials] [numIncs] [serverCount]");
            return;
        }

        final int numTrials = Integer.parseInt(args[0]);
        final int numIncs = Integer.parseInt(args[1]);
        final int serverCount = Integer.parseInt(args[2]);

        StopWatch sw = new StopWatch();

        final int readerCount = 1;
        final int numThreads = serverCount + readerCount;

        double incPerMS[] = new double[numTrials];
        double readsPerMS[] = new double[numTrials];

        ServerRunner[] server = new ServerRunner[serverCount];
        ReaderRunner reader;
        Thread[] workerThread = new Thread[numThreads];

        for (int t = 0; t < numTrials; t++) {
            Counter counter = new Counter(numThreads);

            reader = new ReaderRunner(counter);
            workerThread[serverCount] = new Thread(reader);

            for (int i = 0; i < serverCount; i++) {
                server[i] = new ServerRunner(counter, i, numIncs);
                workerThread[i] = new Thread(server[i]);
            }

            sw.reset();

            for (int i = 0; i < numThreads; i++) {
                workerThread[i].start();
            }

            // wait until each server is done
            boolean allDone = false;
            while (!allDone) {
                allDone = true;
                for (int i = 0; i < serverCount; i++) {
                    if (server[i].done.get() == false) {
                        allDone = false;
                    }
                }
            }

            // notify all of the readers to stop
            reader.done.set(true);

            // join every thread
            for (int i = 0; i < numThreads; i++) {
                try {
                    workerThread[i].join();
                } catch (InterruptedException ignore) {
                    ;
                }
            }
            double ms = sw.peek();

            incPerMS[t] = numIncs * serverCount * 1.0 / ms;

            readsPerMS[t] = 0.0;
            readsPerMS[t] += reader.scanCount;
            readsPerMS[t] /= ms;

            if (counter.read() != numIncs * serverCount) {
                System.out.printf("%s != %s\n", counter.read(), numIncs * serverCount);
            } else {
                System.out.println("Test Passed");
            }
        }

        System.out.print(serverCount + " servers, " + readerCount + " readers :\n\tIncs/ms = [");
        double incAvg = 0;
        for (int t = 0; t < numTrials; t++) {
            incAvg += incPerMS[t];
            System.out.print(" " + String.format("%.2f", incPerMS[t]));
        }
        System.out.print(" ]\n\tReads/ms = [");
        double readsAvg = 0;
        for (int t = 0; t < numTrials; t++) {
            readsAvg += readsPerMS[t];
            System.out.print(" " + String.format("%.2f", readsPerMS[t]));
        }
        System.out.println(" ]");
        System.out.printf("\nincAvg = %s\nreadsAvg = %s", incAvg / numTrials, readsAvg / numTrials);
    }

}

```

*`Register.java`*
```java
/**
 * An immutable pair of integers: a value and a sequence number (aka timestamp).
 */
public class Register {
    /**
     * The value of the register.
     */
    public final int val;
    /**
     * The sequence number (aka timestamp) of the register.
     */
    public final int seq;
    
    /**
     * Constructs a Register with zeros.
     */
    public Register() {
        val = 0;
        seq = 0;
    }
    /**
     * Constructs a Register with the given value and sequence number.
     */
    public Register(int v, int s) {
        val = v;
        seq = s;
    }
}
```
