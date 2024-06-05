#import "template.typ": *
#show: template.with(
  title: "6.5081 PSET 5",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 2

Even with this new change, `add()` is still linearizable. We can set the linearization point to when `pred` is locked.

For an `add()` operation, this is completely fine, as we are only concerned with editing `pred`, which is locked by our new implementation. The concern might be that `curr` may be modified, but this is not an issue as `curr` can be assigned to arbitrarily point to anything, since `pred` will be linked to the new node, and the new node will be linked to `curr`. Nothing in `add()` can impact the stability of `pred` or `curr`, even without having a lock around `curr`

`delete()` seems to pose a more challenging threat to the linearizability of this new implementation. The question is whether it is possible for `curr` to be deleted, ruining our chain structure. Obviously `pred` is locked so we cannot touch it, meaning it is not a point of concern. Recalling the implementation of `delete()` in the fine-grained algorithm, `pred` is always locked before `curr` is deleted, meaning that it cannot interfere with the critical operation of `add()`

The last function `contains()` is not a point of concern as `add()` maintains the same functionality, and `contains()` does not modify the linked list in any way.

When the function fails there is nothing we have to worry about in this new implementation that the old one does not cover.

= Problem 3

In this new implementation, `contains()` would not be linearizable. Suppose we have the following scenario:

+ We have the list `a => b => c`
+ We call `remove(b)`, which manages to set the node as marked but nothing else.
+ We call `contains(b)`, which must return `true` by nature of the implementation.

Thus, there is no case where our abstract representation of the list is linearizable. The `contains()` function in this case will always return `true` without being able to distinguish that the abstract representation says the return should be `false`. There is no point at which it can be considered `true`, because the entire lifespan of the function `contains()` has `b` existing as marked.

= Problem 4

== a

This new implementation *does not* work. Considering the following execution in which it will cease to have proper functionality.

+ On line `6` we get `succ = curr.next`
+ Before line `7`, some other thread `curr.next` since there is no lock around it.
+ Because there is no way to check with this new function, line `7` will mark the node, even though it might be a new node that was inserted, and is not the desired node to be deleted. Thus we in this case our function utterly fails, as the check is discarded.

== b

This implementation *does not* work. However, I encourage the grader to read fully, as I believe the textbook may incorrectly assume the answer to be that it *does* work.

I do not think it works. This is because it provides the same set of functionality of `compareAndSet`, but misses a crucial feature. If `curr.next` has changed, then the update will fail (meaning it returns false according to the online API), which is the same behavior that should be expected from the original.

If `curr.next` is what we expect, and `mark = false`, then it will set the value to `true` and move into the if statement, which is the desired behavior. However, there is an edge case that needs to be covered. What if `curr.next` is what we expect, but `mark = true`? Even in this case, our function will set the mark as `true` (again), and proceed into the if statement.

Obviously, if something has been marked, then a remove should not succeed (unless we have duplicates but we don't consider that). Imagine a scenario where sometime after we run line `5` but before running any lines after, another `remove` successfully finishes its call, and removes the same node we wanted to remove (once again assuming no duplicates). In this case, our new function will fail, as it will not be able to distinguish there is a marked node already. `remove` itself doesn't physically remove the node, so there is no way to check if the node should be processed. Thus we will report the node as removed successfully, even though it was not (since someone else did it first), while re-setting the mark uselessly. It does not matter that only one of the inner `compareAndSet` calls can complete, what matters is that both functions in this case are going to return `true`, which is impossible as this element can only be deleted once.

I believe the textbook is incorrect and has a typo:

"Otherwise, `remove()` calls `attemptMark()` to mark `currA` as logically removed (Line 27). This call succeeds only if no other thread has set the mark first."

I do not think this quote is true. This is because the `attemptMark` API as described by the Java docs as well as the PSET indicates that the mark is set unconditionally of what the old value was, only conditional on the reference. This means that the mark will be set regardless of the old value, and thus the quote is incorrect. The textbook seems to use `attemptMark` as a shorthand for `compareAndSet`, which is not the case.

Thus, this implementation is also not correct, and there are many executions in which it fails.

= Report / Problems 5-8

== High Level

I chose to implement the first lock suggested - the Lock-Based, Closed-Address. Even with this one implementation, there were many interesting observations and challenges that I faced. I will first go over some design choices, show any relevant code, and then discuss some findings as well as display some figures.

Overall, my implementation followed the suggestions very closely, and there is no large feature that is surprising about my code. One thing that I did learn about Java was that objects are by default passed by value, unless some specific conditions are met. One of these is if it is a `public` field of a class. This fact was used in order to pass around various fields such as the Lamport queues.

I'm also inclined to believe that there may be a small error with the implementation due to reasons that will be covered in the last section. However, the overall functionality is stellar and yields an acceptable `ParallelHashTable`

== Code

The first major piece of code is the actual `ParallelHashTable` class. This class uses the suggested locks as well as the serial list that was given.

=== *`ParallelHashTable`*

```java
class ParallelHashTable<T> implements HashTable<T> {
    private SerialList<T,Integer>[] table;
    private int nLocks;
    private int maskShift;
    private final int maxBucketSize;

    // add a new field to store the readWriteLocks
    private ReentrantReadWriteLock[] locks;

    // constructor
    public ParallelHashTable(int maxBucketSize, int nThreads) {
        this.maxBucketSize = maxBucketSize;
        this.nLocks = 1;
        this.maskShift = 0;
        while (nThreads > nLocks) {
            this.nLocks *= 2;
            this.maskShift += 1;
        }
        // set initial size to be the number of locks
        this.table = new SerialList[nLocks];

        // make locks
        this.locks = new ReentrantReadWriteLock[nLocks];
        for (int i = 0; i < nLocks; i++) {
            this.locks[i] = new ReentrantReadWriteLock();
        }
    }

    public void resizeIfNecessary(int key) {
        // refactor to look a bit nicer
        while (true) {
            int index = key & ((1 << maskShift) - 1);
            if (table[index] == null) {
                break;
            } else if (table[index].getSize() < maxBucketSize) {
                break;
            } else {
                for (int i = 0; i < this.nLocks; i++) {
                    this.locks[i].writeLock().lock();
                }
                resize();
                for (int i = 0; i < this.nLocks; i++) {
                    this.locks[i].writeLock().unlock();
                }
            }
        }
    }

    private void addNoCheck(int key, T x) {
        int index = key & ((1 << maskShift) - 1);
        int lockIndex = index & (this.nLocks - 1);
        this.locks[lockIndex].writeLock().lock();

        if (table[index] == null) {
            table[index] = new SerialList<T,Integer>(key,x);
        }
        else {
            table[index].addNoCheck(key,x);
        }

        this.locks[lockIndex].writeLock().unlock();
    }

    public void add(int key, T x) {
        resizeIfNecessary(key);
        addNoCheck(key,x);
    }

    public boolean remove(int key) {
        resizeIfNecessary(key);

        int index = key & ((1 << maskShift) - 1);
        int lockIndex = index & (this.nLocks - 1);
        this.locks[lockIndex].writeLock().lock();

        if (table[index] != null) {
            boolean ret = table[index].remove(key);
            this.locks[lockIndex].writeLock().unlock();
            return ret;
        }
        else {
            this.locks[lockIndex].writeLock().unlock();
            return false;
        }
    }

    public boolean contains(int key) {
        int index = key & ((1 << maskShift) - 1);
        int lockIndex = index & (this.nLocks - 1);
        this.locks[lockIndex].readLock().lock();

        if (table[index] != null) {
            boolean ret = table[index].contains(key);
            this.locks[lockIndex].readLock().unlock();
            return ret;
        }
        else {
            this.locks[lockIndex].readLock().unlock();
            return false;
        }
    }

    public void resize() {
        this.maskShift += 1;
        SerialList<T,Integer>[] newTable = new SerialList[2*table.length];
        for (int i = 0; i < table.length; i++) {
            if (table[i] == null) {
                continue;
            }

            SerialList<T,Integer>.Iterator<T,Integer> iterator = table[i].getHead();

            while (iterator != null) {
                int index = iterator.key & ((1 << maskShift) - 1);
                if (newTable[index] == null) {
                    newTable[index] = new SerialList<T,Integer>(iterator.key, iterator.getItem());
                }
                else {
                    newTable[index].addNoCheck(iterator.key, iterator.getItem());
                }
                iterator = iterator.getNext();
            }
        }
        table = newTable;
    }
}
```

Of course, it is also needed to show the workers who use this hash table. Again, this implementation was widely the same as the given one, except there are some cleanups of taking out unused variables, as well as adding new features such as the `skip` parameter, as well as not taking in the generator itself, and rather taking in a Lamport queue.

=== *`ParallelHashPacketWorker`*

```java
class ParallelHashPacketWorker implements HashPacketWorker {

    PaddedPrimitiveNonVolatile<Boolean> done;
    final WaitFreeQueue<HashPacket<Packet>> source;
    final ParallelHashTable<Packet> table;
    long totalPackets = 0;
    boolean skip;

    public ParallelHashPacketWorker (
        PaddedPrimitiveNonVolatile<Boolean> done, 
        WaitFreeQueue<HashPacket<Packet>> source,
        ParallelHashTable<Packet> table,
        boolean skip) {
        this.skip = skip;
        this.done = done;
        this.source = source;
        this.table = table;
    }

    public void run() {
        HashPacket<Packet> pkt;
        while (!done.value) {
            try {
                pkt = source.deq();
                totalPackets++;
                if (skip) {
                    continue;
                }
                switch (pkt.getType()) {
                    case Add: 
                        table.add(pkt.mangleKey(),pkt.getItem());
                        break;
                    case Remove:
                        table.remove(pkt.mangleKey());
                        break;
                    case Contains:
                        table.contains(pkt.mangleKey());
                        break;
                }
            } catch (Exception e) {
                // could not find anything, try again
                continue;
            }
        }
    }  
}
```

The Lamport queue implementation as given in the textbook is listed below.

=== *`WaitFreeQueue`*

```java
// implemented from chapter 3
class WaitFreeQueue<T> {
    volatile int head = 0, tail = 0;
    T[] items;

    public WaitFreeQueue(int capacity) {
        items = (T[])new Object[capacity];
        head = 0; tail = 0;
    }

    public void enq(T x) throws Exception {
        if (tail - head == items.length) {
            throw new Exception();
        }
        items[tail % items.length] = x;
        tail++;
    }

    public T deq() throws Exception {
        if (tail - head == 0) {
            throw new Exception();
        }
        T x = items[head % items.length];
        head++;
        return x;
    }
}
```

Alongside that implementation is the `dispatcher` class, which is used to control the queues and overall flow of the testing.

=== *`Dispatcher`*

```java
class Dispatcher implements HashPacketWorker {

    PaddedPrimitiveNonVolatile<Boolean> done;
    final HashPacketGenerator source;
    long totalPackets = 0;
    WaitFreeQueue[] queues;

    public Dispatcher (
        PaddedPrimitiveNonVolatile<Boolean> done, 
        HashPacketGenerator source,
        WaitFreeQueue[] queues) {
        this.done = done;
        this.source = source;
        this.queues = queues;
    }

    public void run() {
        HashPacket<Packet> pkt;
        int tryThread = 0;

        while (!done.value) {
            pkt = source.getRandomPacket();
            while (true) {
                try {
                    queues[tryThread].enq(pkt);
                    totalPackets++;
                    break;
                } catch (Exception e) {
                    // full, could not put anything, try again
                    continue;
                }
            }

            // advance to the next one, we should send it to this one next
            tryThread = (tryThread + 1) % queues.length;
        }
    }  
}
```

One interesting thing to note is the approach that I took regarding how to distribute the packets. To ensure that all threads get an equal amount of attention, the `Dispatcher` cycles through all of them, and hangs on one if it cannot deliver it right now. Critically, this means that the `Dispatcher` is guaranteed to deliver one packet to each thread at a time before moving on, even at the expense of performance. I believed that this would be a better way to get consistent results for data.

The last piece of code is the testing framework itself.

=== *`ParallelHashPacket`*

```java
class ParallelHashPacket {
    // static public variables to pass around
    public static WaitFreeQueue[] queues;
    public static ParallelHashTable<Packet> table;

    public static void main(String[] args) {

        final int numMilliseconds = Integer.parseInt(args[0]);    
        final float fractionAdd = Float.parseFloat(args[1]);
        final float fractionRemove = Float.parseFloat(args[2]);
        final float hitRate = Float.parseFloat(args[3]);
        final int maxBucketSize = Integer.parseInt(args[4]);
        final long mean = Long.parseLong(args[5]);
        final int initSize = Integer.parseInt(args[6]);
        final int numWorkers = Integer.parseInt(args[7]); 

        boolean skip = false;
        if (args.length > 8) {
            if (Integer.parseInt(args[8]) == -1) {
                skip = true;
            }
        }

        StopWatch timer = new StopWatch();

        // allocate and initialize Lamport queues and hash tables (if tableType != -1)
        queues = new WaitFreeQueue[numWorkers];
        for (int i = 0; i < numWorkers; i++) {
            queues[i] = new WaitFreeQueue<HashPacket<Packet>>(8);
        }
        table = new ParallelHashTable<Packet>(maxBucketSize, numWorkers);

        HashPacketGenerator source = new HashPacketGenerator(fractionAdd,fractionRemove,hitRate,mean);

        // initialize your hash table w/ initSize number of add() calls
        for (int i = 0; i < initSize; i++) {
            HashPacket<Packet> pkt = source.getAddPacket();
            table.add(pkt.mangleKey(), pkt.getItem());
        }

        PaddedPrimitiveNonVolatile[] dones = new PaddedPrimitiveNonVolatile[numWorkers];
        ParallelHashPacketWorker[] workers = new ParallelHashPacketWorker[numWorkers];
        Thread[] workerThreads = new Thread[numWorkers];
        for (int i = 0; i < numWorkers; i++) {
            dones[i] = new PaddedPrimitiveNonVolatile(false);
            workers[i] = new ParallelHashPacketWorker(dones[i], queues[i], table, skip);
            workerThreads[i] = new Thread(workers[i]);
        }
        
        // call .start() on your Workers
        for (int i = 0; i < numWorkers; i++) {
            workerThreads[i].start();
        }

        timer.startTimer();

        // call .start() on your Dispatcher
        PaddedPrimitiveNonVolatile dispatcherDone = new PaddedPrimitiveNonVolatile(false);
        Dispatcher dispatcher = new Dispatcher(dispatcherDone, source, queues);
        Thread dispatcherThread = new Thread(dispatcher);
        dispatcherThread.start();

        try {
            Thread.sleep(numMilliseconds);
        } catch (InterruptedException ignore) {;}

        // assert signals to stop Dispatcher
        dispatcherDone.value = true;
        // call .join() on Dispatcher
        try {
            dispatcherThread.join();
        } catch (InterruptedException ignore) {;}

        // assert signals to stop Workers - they are responsible for leaving the queues empty
        for (int i = 0; i < numWorkers; i++) {
            dones[i].value = true;
        }
        // call .join() for each Worker
        for (int i = 0; i < numWorkers; i++) {
            try {
                workerThreads[i].join();
            } catch (InterruptedException ignore) {;}
        }

        timer.stopTimer();
        // report the total number of packets processed and total time
        final long totalCount = dispatcher.totalPackets;
        System.out.println("count: " + totalCount);
        System.out.println("time: " + timer.getElapsedTime());
        System.out.println(totalCount/timer.getElapsedTime() + " pkts / ms");
    }
}
```

== Findings

As detailed in Assignment 7, I ran some testing on the implementation to see how it performed.

#note(
  title: "Measurements"
)[
  Note that anytime I use a measurement, that is the average of 5 runs, where the lowest and highest are dropped. This means that for every single data point, there are actually 5 data points that make it in total. 
]

#note(
  title: "Numbers"
)[
  In order to keep consistency, I ran the tests with the following parameters fixed unless otherwise noted:

  - $M => 2000$
  - $P_+ => 0.25$
  - $P_- => 0.25$
  - $p => 0.8$
  - $B => 20$
  - $W => 1$
  - $s => 100$
]

=== *(a) Dispatcher Rate*

$7469.617228942681$ pkts / ms

=== *(b) Speedup*

#twocol(
  bimg("imgs/1.png"),
  bimg("imgs/2.png"),
)

The three colors on each of the plots represent the different values of $p$ that could be taken on.

The two tests for part *(b)* are shown above, with the first set of three tests being condensed on the left and the second three on the right. You can see that the second set of tests where there were many more adds did significantly worse, which is to be expected. The speedup is not as high as I would have liked, but it is still a significant improvement over the serial implementation regardless. Both graphs seem to follow a trend of surprisingly dipping when $n=2$, which I did not expect, since I expected there to be a steady rise with the overhead of $n=1$ being the most. It appears that I was wrong, and the overhead is not quite as great as I thought, and the locking overhead really only materializes when there are at least two threads.

== *(c) Specific*

#bimg("imgs/3.png")

The above is the image for part *(c)* of this question. There was not as much interesting data since I did not implement anything specific for this. However, it is still worth noting that there are two very low points at 16 and 32, the last of which I did not include for resolution purposes. It appears that something in my implementation went wrong, and high threads err. However, the rest is promising, as it looks like it follows mostly the same pattern as in the previous part, where there is a slight dip at two threads, and then a payoff as it gets to higher threads.

I also discovered while doing all these tests, that the idea number for the bucket sizes seems to be $20$, as previously listed above. Perhaps I did not test a wide enough selection of numbers, but this was the one that seemed to work the best across all tests, no matter what I was doing.

Overall I wish I could have done more implementations, as well as potentially fixed any lingering bugs, although it does look like overall everything is working fine. I am happy with the results, and I believe that the implementation is solid, and the results are promising.
