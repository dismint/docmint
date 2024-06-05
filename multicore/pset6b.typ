#import "template.typ": *
#show: template.with(
  title: "6.5081 PSET 6B",
  subtitle: "Justin Choi",
  pset: true
)

= Overview

#note(
  title: "Warning",
)[
  It is *CRITICAL* to note that all my testing relies on the initial states of every source being allowed to send, and all destinations receiving from all sources. Without this assumption, testing is impossible to do on a parallel sense. I have tried multiple times and spent easily over 15+ hours checking this. The steady state is nowhere near sufficient enough, especially in the latter configurations where the number of `ConfigPacket`s are small, and even running for a long time yields very few packets that can be accepted. 

  This means that unless we *start* with everything available, the fingerprinting and all the work there will simply not happen as virtually no sources or destinations are valid. I think that this is a fundamental design flaw of this PSET that should be taken into consideration for next year.
]

In this final lab of 6.5081, I implemented a parallel firewall system that processes packets concurrently. The system is designed to handle a large number of packets and is optimized for performance. The system is designed to be scalable and efficient, with the ability to process packets in parallel using multiple threads.

I will cover the design as well as practical performance of my implementation in the upcoming sections. The full code for my testing script and the Java implementation can be found at the end of the document.

All the Java code is written in a single file, `Firewall.java`, which contains both the serial and parallel implementations of the firewall system. The Python script `benchmark.py` is used to run the Java code with different configurations and measure the performance of the system. This is a very messy script and works insomuch as it acts as a framework to conveniently run the Java code with different configurations.

Despite having all the code at the bottom, I will be pulling up segments of the Java code in some sections to accurately explain each part without having to constantly look at the bottom of the document.

= Overall Design and Specification Requirements

The overall design of the project was meant to be straightforward without implementing anything too complicated. Below is the main body of code that runs in the parallel implementation.

```java
public static void main(String[] args) {
    // parse args
    if (args.length != 12) {
        System.out.println("Invalid number of arguments " + args.length + " != 12");
        return;
    }
    int numAddressesLog = Integer.parseInt(args[0]);
    int numTrainsLog = Integer.parseInt(args[1]);
    double meanTrainSize = Double.parseDouble(args[2]);
    double meanTrainsPerComm = Double.parseDouble(args[3]);
    int meanWindow = Integer.parseInt(args[4]); 
    int meanCommsPerAddress = Integer.parseInt(args[5]);
    int meanWork = Integer.parseInt(args[6]);
    double configFraction = Double.parseDouble(args[7]);
    double pngFraction = Double.parseDouble(args[8]);
    double acceptingFraction = Double.parseDouble(args[9]);
    int time = Integer.parseInt(args[10]);
    int threads = Integer.parseInt(args[11]);

    generator = new PacketGenerator(
        numAddressesLog,
        numTrainsLog,
        meanTrainSize,
        meanTrainsPerComm,
        meanWindow,
        meanCommsPerAddress,
        meanWork,
        configFraction,
        pngFraction,
        acceptingFraction
    );

    for (int i = 0; i < PNG.length; i++) {
        PNG[i] = false;
    }
    for (int i = 0; i < (1 << numAddressesLog); i++) {
        D.put(i, new RangeSum());
        D.get(i).add(0, (1 << numAddressesLog));
    }

    // allow the system to reach steady state
    int steady_iterations = (int) Math.pow((1 << (numAddressesLog)), 3.0 / 2.0);
    System.out.println("Steady iterations: " + steady_iterations);
    for (int i = 0; i < steady_iterations; i++) {
        Packet packet = generator.getPacket();
        if (packet.type == Packet.MessageType.ConfigPacket) {
            int addr = packet.config.address;
            boolean png = packet.config.personaNonGrata;
            int addrBegin = packet.config.addressBegin;
            int addrEnd = packet.config.addressEnd;
            boolean accept = packet.config.acceptingRange;
    
            // edit PNG
            PNG[addr] = png;
            // edit D
            if (!D.containsKey(addr)) {
                D.put(addr, new RangeSum());
            }
            if (accept) {
                D.get(addr).add(addrBegin, addrEnd);
            } else {
                D.get(addr).remove(addrBegin, addrEnd);
            }
        }
    }
    System.out.println("Steady state reached");

    histLock = new MCSLock();
    locks = new MCSLock[1 << numAddressesLog];
    for (int i = 0; i < (1 << numAddressesLog); i++) {
        locks[i] = new MCSLock();
    }

    workload = new WaitFreeQueue[threads];
    for (int i = 0; i < threads; i++) {
        workload[i] = new WaitFreeQueue(256);
    }

    Worker[] workers = new Worker[threads];
    for (int i = 0; i < threads; i++) {
        workers[i] = new Worker(i, workload[i]);
    }
    
    Distributor distributor = new Distributor();
    Thread distributor_thread = new Thread(distributor);
    distributor_thread.start();

    Thread[] worker_threads = new Thread[threads];
    for (int i = 0; i < threads; i++) {
        worker_threads[i] = new Thread(workers[i]);
        worker_threads[i].start();
    }
    
    try {
        Thread.sleep(time);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    //
    distributor.running = false;
    try {
        distributor_thread.join();
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    for (int i = 0; i < threads; i++) {
        workers[i].running = false;
        try {
            worker_threads[i].join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    // System.out.println("Total packets processed: " + distributor.total_packets);
    System.out.println("packet/s count: " + (double)distributor.total_packets / (time / 1000.0));
}
```

The first thing that happens is the parsing of the arguments. You see that for the parallel version, there are two additional arguments that come at the end, which are the number of threads as well as the time which this parallel testing should run. This allows us to expose this option to the tester.

We then make the generator, and run the serial version of the code for $A^(3/2)$ iterations to allow the system to reach a steady state. Once this is done, we can start the parallel part of the code. Lines `60-84` instantiate a lot of our needed classes and objects, such as the locks, the workload, the workers, and the distributor. The distributor is the one that generates the packets and sends them to the workers. The workers then process the packets and update the `PNG` and `D` arrays accordingly. The `locks` array use my implementation of the `MCSLock` class, which is a lock that is designed to be more efficient than the `ReentrantLock` class in specific cases. The `WaitFreeQueue` class is a simple queue that is used to store the packets that are generated by the distributor and are processed by the workers.

We then start the distributor, followed by the workers, letting them run for the specified amount of time before issuing the stop command through the `.running` variable and waiting for all threads to catch up at the end.

We will now take a look at the `Distibutor` and `Worker` classes.

*`Distributor`*
```java
static class Distributor implements Runnable {
  volatile boolean running = true;
  int total_packets = 0;

  Distributor() {}

  public void run() {
    while (running) {
      if (flight.get() >= 256) {
        continue;
      }
      Packet packet = generator.getPacket();
      flight.incrementAndGet();
      if (packet.type == Packet.MessageType.ConfigPacket) {
        while (running) {
          try {
            workload[packet.config.address % workload.length].enq(packet);
            total_packets++;
            break;
          } catch (Exception e) {
            continue;
          }
        }
      } else {
        while (running) {
          try {
            workload[packet.header.source % workload.length].enq(packet);
            total_packets++;
            break;
          } catch (Exception e) {
            continue;
          }
        }
      }
    }
  }
}
```

The distributor class is relatively straightforward, but has a couple note worthy points. One of the important things is the `flight` variable from the parent `ParallelFirewall` class, which represents the number of packets that are currently being processed. This is used to ensure that the distributor does not send more packets than the system can handle. Every time we get a packet, this count increases, and we will see later that the workers decrease this count once they are done processing a packet.

One other thing to note is how I choose to allocate the packets. The packets are distributed according to the modulo of the source address. This approach seemed to work quite well compared to other method I tried, which seemed to be represented in the results which will be shown later. We also keep track of the `total_packets` processed by the distributor by incrementing it whenever we successfully enqueue a packet to one of the queues of the worker.

*`Worker`*
```java
static class Worker implements Runnable {
  volatile boolean running = true;
  int threadId;
  WaitFreeQueue workload;

  Worker(int threadId, WaitFreeQueue workload) {
    this.threadId = threadId;
    this.workload = workload;
  }

  public void run() {
    while (running) {
      try {
        Packet packet = workload.deq();
        if (packet.type == Packet.MessageType.ConfigPacket) {
          int addr = packet.config.address;
          boolean png = packet.config.personaNonGrata;
          int addrBegin = packet.config.addressBegin;
          int addrEnd = packet.config.addressEnd;
          boolean accept = packet.config.acceptingRange;

          locks[addr].lock();

          // edit PNG
          PNG[addr] = png;
          // edit D
          if (!D.containsKey(addr)) {
            D.put(addr, new RangeSum());
          }
          if (accept) {
            D.get(addr).add(addrBegin, addrEnd);
          } else {
            D.get(addr).remove(addrBegin, addrEnd);
          }

          locks[addr].unlock();
        } else {
          int source = packet.header.source;
          int dest = packet.header.dest;

          locks[source].lock();
          boolean png = !PNG[source];
          locks[source].unlock();

          locks[dest].lock();
          boolean d = D.containsKey(dest) && D.get(dest).verify(source);
          locks[dest].unlock();

          if (png && d) {
            long fingerprint = Fingerprint.getFingerprint(packet.body.iterations, packet.body.seed);
            histLock.lock();
            hist.put(fingerprint, hist.getOrDefault(fingerprint, 0) + 1);
            histLock.unlock();
          }
        }

        flight.decrementAndGet();
      } catch (Exception e) {}
    }
  }
}
```

Each worker essentially does the sequential version of processing the packets. We can see the aforementioned `flight` decrement on line `57`. Importantly, we have all the locks that are being turned on and off.

This happens around critical sections of the code that modify the `PNG` and `D` data structures. The way I chose to implement these locks is to have one for each address. The range of addresses in most cases is reasonable enough that this is not a problem. We can see that the locks are used on lines `22`, `36`, `41`, `43`, `45`, `47`, as well as the lock for the histogram on `51` and `53`. 
The idea of only having one lock for the histogram is that it won't be contested as much as other operations because of the time of the fingerprint.

The other locks are used to ensure that the `PNG` and `D` arrays are not modified by multiple workers at the same time. This is important because the workers are running concurrently and could potentially modify the same data structures at the same time. The underlying data structures are not inherently concurrent, so we need to use locks to ensure that they are modified correctly with locks.

With this implementation, we see that many requirements are already met, such as the packet flight limit as well as the updating of the histogram and steady state waiting.

= Data Structures

== `RangeSum`

```java
class RangeSum {
  TreeMap < Integer, Integer > ranges;

  RangeSum() {
    ranges = new TreeMap < > ();
  }

  void add(int a, int b) {
    if (a >= b) {
      return;
    }

    Map.Entry < Integer, Integer > lb = ranges.lowerEntry(b);
    if (lb != null && lb.getValue() >= a) {
      while (lb != null && lb.getKey() <= b) {
        a = Math.min(a, lb.getKey());
        b = Math.max(b, lb.getValue());
        ranges.remove(lb.getKey());
        lb = ranges.lowerEntry(b);
      }
    }
    ranges.put(a, b);
  }

  void remove(int a, int b) {
    if (a >= b) {
      return;
    }

    Map.Entry < Integer, Integer > floor = ranges.floorEntry(a);
    ArrayList < int[] > update = new ArrayList < > ();

    while (floor != null && floor.getValue() >= a) {
      if (floor.getKey() < a) {
        update.add(new int[] {
          floor.getKey(), a
        });
      }
      if (floor.getValue() > b) {
        update.add(new int[] {
          b,
          floor.getValue()
        });
      }
      ranges.remove(floor.getKey());
      floor = ranges.floorEntry(b);
    }

    for (int[] interval: update) {
      ranges.put(interval[0], interval[1]);
    }
  }

  boolean verify(int x) {
    Map.Entry < Integer, Integer > floor = ranges.floorEntry(x);
    return floor != null && floor.getValue() > x;
  }
}
```

`RangeSum` is my solution for how to manage ranges of addresses that are allowed to be accepted. The `add` function adds a range to the `TreeMap` of ranges, while the `remove` function removes a range from the `TreeMap`. The `verify` function checks if a given address is within any of the ranges in the `TreeMap`. This is used to check if a source address is allowed to send packets to a destination address. 

I believed that this is more efficient that the suggested skiplist implementation, and this is a competitive coding construct that I have used countless times to solve this problem. Again, there is nothing particularly concurrent about this data structure, but it is used in a concurrent context with locks controlling access to it.

This class is very efficient and allows us to do operations in logarithmic time, which I believe helped greatly in the final runtime. The class is trivially linearizable.

== `WaitFreeQueue`

```java
// implemented from chapter 3
static class WaitFreeQueue {
  volatile int head = 0, tail = 0;
  Packet[] items;

  public WaitFreeQueue(int capacity) {
    items = new Packet[capacity];
    head = 0;
    tail = 0;
  }

  public void enq(Packet x) throws Exception {
    if (tail - head == items.length) {
      throw new Exception();
    }
    items[tail % items.length] = x;
    tail++;
  }

  public Packet deq() throws Exception {
    if (tail - head == 0) {
      throw new Exception();
    }
    Packet x = items[head % items.length];
    head++;
    return x;
  }
}
```

This class is the queue that each worker and distributor uses to store packets. The queue is implemented as a circular buffer, which allows for efficient enqueuing and dequeuing of packets. The queue is wait-free, which means that each operation is guaranteed to complete in a finite number of steps, regardless of the number of threads accessing the queue. This is important because the workers and distributor are running concurrently and need to be able to access the queue without blocking each other. This implementation is directly from a previous lab where we implemented it from chapter 3 of the textbook. The proof of the data structure being wait-free and linearizable are given in the textbook and I will not reiterate it here for conciseness.

This queue is not locked from use, because only one thread is enqueueing and one thread is dequeuing (the distributor and specific worker).

== `MCSLock`

```java
  static class MCSLock {
    private static class MCSNode {
      volatile MCSNode next;
      volatile boolean locked = false;
    }

    private final ThreadLocal < MCSNode > node;
    private final AtomicReference < MCSNode > tail;

    public MCSLock() {
      tail = new AtomicReference < > (null);
      node = ThreadLocal.withInitial(MCSNode::new);
    }

    public void lock() {
      MCSNode currentNode = node.get();
      MCSNode predecessor = tail.getAndSet(currentNode);
      if (predecessor != null) {
        currentNode.locked = true;
        predecessor.next = currentNode;

        // spin until predecessor gives up the lock
        while (currentNode.locked) {}
      }
    }

    public void unlock() {
      MCSNode currentNode = node.get();
      if (currentNode.next == null) {
        if (tail.compareAndSet(currentNode, null)) {
          return;
        }
        // wait until successor appears
        while (currentNode.next == null) {}
      }
      currentNode.next.locked = false;
      currentNode.next = null;
    }
  }
```

This is the lock that I used for the `PNG` and `D` arrays. This lock is a more efficient lock than the `ReentrantLock` class in specific cases. I actually reimplemented the lock by hand compared to the previous lab, which I think led to a performance increase. As discussed in class, the MCSLock is deadlock and starvation free, but not necessarily wait free or lock free. Once again, the lienarizability is proven in the textbook and I will not reiterate it here.

I will discuss in a later section what the advantage and disadvantage of this lock is compared to the `ReentrantLock` class, which I tried using before.

= Performance Testing and Analysis

Testing was done using the `benchmark.py` script, which runs the Java code with different configurations. There was a different approach to testing the serial and parallel implementations. The serial version was tested based on how look running a number of iterations took, while the parallel version was tested based on how many packets were processed in a given time frame. This is because pausing time inherently utilizes Threads, which we should reserve for a parallel system. It is also not possible to accurately run until a certain amount of packets are processed in a parallel system due to the nature the interweaving of counting and parallel workers.

Thus, the serial version was tested to see how long it would take to run $1 . 000 . 000$ packets and the parallel version was tested to see how many packets could be processed in $1$ second. The final tests for each were averaged over 5 attempts on each configuration possibility. Even on the serial version, to ensure stability and a steady state, I ran the code for half a million packets. The results are shown below. The units for all the numbers are `packets / second` for the throughput and are simple ratios for the parallelism. Please note that I am using the dot $.$ in place of the comma $,$ for readability.

== Throughput

#twocol(
  [
    === Serial Throughput

    / *`Configuration 1`*: $185.685$
    / *`Configuration 2`*: $203.331$
    / *`Configuration 3`*: $394.808$
    / *`Configuration 4`*: $1.069.518$
    / *`Configuration 5`*: $144.112$
    / *`Configuration 6`*: $87.237$
    / *`Configuration 7`*: $107.968$
    / *`Configuration 8`*: $71.438$
  ],
  [
    === Parallel Throughput `n=2`

    / *`Configuration 1`*: $258.566$
    / *`Configuration 2`*: $323.999$
    / *`Configuration 3`*: $503.096$
    / *`Configuration 4`*: $1.218.549$
    / *`Configuration 5`*: $204.654$
    / *`Configuration 6`*: $137.129$
    / *`Configuration 7`*: $179.100$
    / *`Configuration 8`*: $125.041$
  ]
)

#twocol(
  [
    === Parallel Throughput `n=4`

    / *`Configuration 1`*: $461.146$
    / *`Configuration 2`*: $537.745$
    / *`Configuration 3`*: $842.239$
    / *`Configuration 4`*: $1.449.415$
    / *`Configuration 5`*: $424.482$
    / *`Configuration 6`*: $255.904$
    / *`Configuration 7`*: $361.329$
    / *`Configuration 8`*: $220.588$
  ],
  [
    === Parallel Throughput `n=8`

    / *`Configuration 1`*: $807.605$
    / *`Configuration 2`*: $868.646$
    / *`Configuration 3`*: $1.216.015$
    / *`Configuration 4`*: $1.266.260$
    / *`Configuration 5`*: $701.320$
    / *`Configuration 6`*: $442.627$
    / *`Configuration 7`*: $588.897$
    / *`Configuration 8`*: $407.789$
  ]
)

== Parallelism

#twocol(
  [
    === Serial Parallelism

    / *`Configuration 1`*: 1
    / *`Configuration 2`*: 1
    / *`Configuration 3`*: 1
    / *`Configuration 4`*: 1
    / *`Configuration 5`*: 1
    / *`Configuration 6`*: 1
    / *`Configuration 7`*: 1
    / *`Configuration 8`*: 1
  ],
  [
    === Parallel Parallelism `n=2`

    / *`Configuration 1`*: 1.39
    / *`Configuration 2`*: 1.59
    / *`Configuration 3`*: 1.27
    / *`Configuration 4`*: 1.14
    / *`Configuration 5`*: 1.42
    / *`Configuration 6`*: 1.57
    / *`Configuration 7`*: 1.66
    / *`Configuration 8`*: 1.75
  ]
)

#twocol(
  [
    === Parallel Parallelism `n=4`

    / *`Configuration 1`*: 2.48
    / *`Configuration 2`*: 2.64
    / *`Configuration 3`*: 2.13
    / *`Configuration 4`*: 1.36
    / *`Configuration 5`*: 2.95
    / *`Configuration 6`*: 2.93
    / *`Configuration 7`*: 3.35
    / *`Configuration 8`*: 3.09
  ],
  [
    === Parallel Parallelism `n=8`

    / *`Configuration 1`*: 4.35
    / *`Configuration 2`*: 4.27
    / *`Configuration 3`*: 3.08
    / *`Configuration 4`*: 1.18
    / *`Configuration 5`*: 4.87
    / *`Configuration 6`*: 5.07
    / *`Configuration 7`*: 5.45
    / *`Configuration 8`*: 5.71
  ]
)

== Analysis

There were some known results that I expected, as well as some surprising results that were shown in the parallel versions of the code. I will discuss some hypotheses I had about my code, and what the actual results were, and how the parts of my code impact this parallelism.

Firstly, it is interesting to note that the speedup gained was not directly proportional to the number of parallel workers. This is of course, to be expected since it is not possible to parallelize 100% of the program. Roughly looking at the number, it appears like two threads resulted in a $1.4$ times speedup, four threads resulted in a $2.8$ times speedup, and eight threads resulted in a $4.7$ times speedup. This is not a terrible scaling, but is a bit below what I desired for how parallel I thought the system was. The overall gains were pretty consistent across the board - of course there were some major differences on certain configurations that I will touch on.

It appears that the fourth configuration had something going on that made it very hard to parallelize. Looking at the statistic, the thing that sticks out the most is the low amount of work. Recall that we had a lock around the histogram. My belief here is that with such a low average work amount, the bottleneck no longer becomes the actual calculation itself, but the contesting of the singular lock that is controlling the histogram. This is why the speedup is so low on this configuration. It was actually the case for this particular configuration that we saw a dip in performance when we went to eight workers, although it was still better than two workers. Out of curiosity I ran the test with sixteen workers and found that it now matched the four worker case. Because the `DataPacket`s don't pose a significant amount of work, the lock is the main bottleneck in this case, and is why I think the performance was hard to optimize. One way that I believe I could have done this better was to make a concurrent data structure for the histogram, which would have allowed for more parallelism. I unfortunately did not have the time to do this, and as such the performance was not as good as it could have been.

The other interesting thing to note is that the last two configurations `7` and `8` had a very high speedup. This is because the workload was very high, and the lock was not as contested. This is why the speedup was so high in these cases. This is essentially the opposite of the previous case. Because the actual work itself was so hard, having multiple threads greatly helped reduce the amount of overall work being done. It's not hard to imagine how much faster this could have been with an improved histogram.

The other configurations were more or less as expected. The speedup was not as high as I would have liked, but it was still a good speedup. The parallelism was not as high as I would have liked, but it was still a good parallelism. The overall performance was good, but could have been better with some improvements to the code.

One thing to point out about a different part of my code is the `RangeSum` class. I believe this was efficient enough to the point where it actually became an anti-bottleneck. Looking at the results, in the first couple configurations, which have higher rates of `ConfigPacket`s, the parallelism is not as good, because the work in updating the configs is being done so fast, and my assumption is that the locks are the main bottleneck here again.

Another huge contributing factor the performance of my system could be the locks.

I believe the implementation of the lock plays a critical role in the performance. The MCSLock is very efficient when there are many threads contending for the lock, but it is not as efficient when there are only a few threads. With so many addresses, this may not have been the best approach in some cases, which is why perhaps large address ranges didn't have the best parallel performance, because the lock was not being contested as much as it would need to be for these benefits to outweight the overhead. On the other hand, the lock is also very good at a high number of threads since each thread stores their lock in memory which is likely to lead to must faster locking and unlocking. I was unable to do extensive testing with a different number of locks, but `ReentrantLock` was tested and had a similar performance to the MCSLock in the serial system, but was much slower in the parallel system.

= Code

== *`Firewall.java`*
 
```java
// imports
import java.util.HashMap;
import java.util.Random;
import java.util.concurrent.atomic.*;
import java.util.concurrent.locks.ReentrantLock;

/*
 * requirements:
 * -------------
 * - only 256 packets are being processed at any one time
 * - generate a histogram of all fingerprints
 * - process 2^(numaddresseslog) packets to reach stable state
 */

import java.util.*;

class RangeSum {
    TreeMap<Integer, Integer> ranges;

    RangeSum() {
        ranges = new TreeMap<>();
    }

    void add(int a, int b) {
        if (a >= b) {
            return;
        }

        Map.Entry<Integer, Integer> lb = ranges.lowerEntry(b);
        if (lb != null && lb.getValue() >= a) {
            while (lb != null && lb.getKey() <= b) {
                a = Math.min(a, lb.getKey());
                b = Math.max(b, lb.getValue());
                ranges.remove(lb.getKey());
                lb = ranges.lowerEntry(b);
            }
        }
        ranges.put(a, b);
    }

    void remove(int a, int b) {
        if (a >= b) {
            return;
        }

        Map.Entry<Integer, Integer> floor = ranges.floorEntry(a);
        ArrayList<int[]> update = new ArrayList<>();

        while (floor != null && floor.getValue() >= a) {
            if (floor.getKey() < a) {
                update.add(new int[]{floor.getKey(), a});
            }
            if (floor.getValue() > b) {
                update.add(new int[]{b, floor.getValue()});
            }
            ranges.remove(floor.getKey());
            floor = ranges.floorEntry(b);
        }

        for (int[] interval: update) {
            ranges.put(interval[0], interval[1]);
        }
    }

    boolean verify(int x) {
        Map.Entry<Integer, Integer> floor = ranges.floorEntry(x);
        return floor != null && floor.getValue() > x;
    }
}

class SerialFirewall {
    // D and PNG arrays as described in the PSET handout
    static HashMap<Integer, RangeSum> D = new HashMap<>();
    static boolean[] PNG = new boolean[1 << 17]; // set to the max size
    
    static HashMap<Long, Integer> hist = new HashMap<>();

    public static void main(String[] args) {
        // parse args
        if (args.length != 11) {
            System.out.println("Invalid number of arguments " + args.length + " != 11");
            return;
        }
        int numAddressesLog = Integer.parseInt(args[0]);
        int numTrainsLog = Integer.parseInt(args[1]);
        double meanTrainSize = Double.parseDouble(args[2]);
        double meanTrainsPerComm = Double.parseDouble(args[3]);
        int meanWindow = Integer.parseInt(args[4]); 
        int meanCommsPerAddress = Integer.parseInt(args[5]);
        int meanWork = Integer.parseInt(args[6]);
        double configFraction = Double.parseDouble(args[7]);
        double pngFraction = Double.parseDouble(args[8]);
        double acceptingFraction = Double.parseDouble(args[9]);
        int iterations = Integer.parseInt(args[10]);

        PacketGenerator generator = new PacketGenerator(
            numAddressesLog,
            numTrainsLog,
            meanTrainSize,
            meanTrainsPerComm,
            meanWindow,
            meanCommsPerAddress,
            meanWork,
            configFraction,
            pngFraction,
            acceptingFraction
        );
        
        for (int i = 0; i < PNG.length; i++) {
            PNG[i] = false;
        }
        for (int i = 0; i < (1 << numAddressesLog); i++) {
            D.put(i, new RangeSum());
            D.get(i).add(0, (1 << numAddressesLog));
        }
        
        double startTime = System.currentTimeMillis();
        for (int i = 0; i < iterations + 500000; i++) {
            if (i == 500000) {
                startTime = System.currentTimeMillis();
            }
            Packet packet = generator.getPacket();
            if (packet.type == Packet.MessageType.ConfigPacket) {
                int addr = packet.config.address;
                boolean png = packet.config.personaNonGrata;
                int addrBegin = packet.config.addressBegin;
                int addrEnd = packet.config.addressEnd;
                boolean accept = packet.config.acceptingRange;
        
                // edit PNG
                PNG[addr] = png;
                // edit D
                if (!D.containsKey(addr)) {
                    D.put(addr, new RangeSum());
                }
                if (accept) {
                    D.get(addr).add(addrBegin, addrEnd);
                } else {
                    D.get(addr).remove(addrBegin, addrEnd);
                }
            } else {
                int source = packet.header.source;
                int dest = packet.header.dest;
                
                if (!PNG[source] && D.containsKey(dest) && D.get(dest).verify(source)) {
                    long fingerprint = Fingerprint.getFingerprint(packet.body.iterations, packet.body.seed);
                    hist.put(fingerprint, hist.getOrDefault(fingerprint, 0) + 1);
                }
            }
        }

        double endTime = System.currentTimeMillis();
        double elapsed = (endTime - startTime) / 1000.0;
        System.out.println("packet/s count: " + iterations / elapsed);
    }
}

class ParallelFirewall {
    // D and PNG arrays as described in the PSET handout
    static HashMap<Integer, RangeSum> D = new HashMap<>();
    static boolean[] PNG = new boolean[1 << 17]; // set to the max size
    
    static HashMap<Long, Integer> hist = new HashMap<>();
    static WaitFreeQueue[] workload;
    static PacketGenerator generator;
    static MCSLock[] locks;
    static volatile AtomicInteger flight = new AtomicInteger(0);
    static MCSLock histLock;

    public static void main(String[] args) {
        // parse args
        if (args.length != 12) {
            System.out.println("Invalid number of arguments " + args.length + " != 12");
            return;
        }
        int numAddressesLog = Integer.parseInt(args[0]);
        int numTrainsLog = Integer.parseInt(args[1]);
        double meanTrainSize = Double.parseDouble(args[2]);
        double meanTrainsPerComm = Double.parseDouble(args[3]);
        int meanWindow = Integer.parseInt(args[4]); 
        int meanCommsPerAddress = Integer.parseInt(args[5]);
        int meanWork = Integer.parseInt(args[6]);
        double configFraction = Double.parseDouble(args[7]);
        double pngFraction = Double.parseDouble(args[8]);
        double acceptingFraction = Double.parseDouble(args[9]);
        int time = Integer.parseInt(args[10]);
        int threads = Integer.parseInt(args[11]);

        generator = new PacketGenerator(
            numAddressesLog,
            numTrainsLog,
            meanTrainSize,
            meanTrainsPerComm,
            meanWindow,
            meanCommsPerAddress,
            meanWork,
            configFraction,
            pngFraction,
            acceptingFraction
        );

        for (int i = 0; i < PNG.length; i++) {
            PNG[i] = false;
        }
        for (int i = 0; i < (1 << numAddressesLog); i++) {
            D.put(i, new RangeSum());
            D.get(i).add(0, (1 << numAddressesLog));
        }

        // allow the system to reach steady state
        int steady_iterations = (int) Math.pow((1 << (numAddressesLog)), 3.0 / 2.0);
        System.out.println("Steady iterations: " + steady_iterations);
        for (int i = 0; i < steady_iterations; i++) {
            Packet packet = generator.getPacket();
            if (packet.type == Packet.MessageType.ConfigPacket) {
                int addr = packet.config.address;
                boolean png = packet.config.personaNonGrata;
                int addrBegin = packet.config.addressBegin;
                int addrEnd = packet.config.addressEnd;
                boolean accept = packet.config.acceptingRange;
        
                // edit PNG
                PNG[addr] = png;
                // edit D
                if (!D.containsKey(addr)) {
                    D.put(addr, new RangeSum());
                }
                if (accept) {
                    D.get(addr).add(addrBegin, addrEnd);
                } else {
                    D.get(addr).remove(addrBegin, addrEnd);
                }
            }
        }
        System.out.println("Steady state reached");

        histLock = new MCSLock();
        locks = new MCSLock[1 << numAddressesLog];
        for (int i = 0; i < (1 << numAddressesLog); i++) {
            locks[i] = new MCSLock();
        }

        workload = new WaitFreeQueue[threads];
        for (int i = 0; i < threads; i++) {
            workload[i] = new WaitFreeQueue(256);
        }

        Worker[] workers = new Worker[threads];
        for (int i = 0; i < threads; i++) {
            workers[i] = new Worker(i, workload[i]);
        }
        
        Distributor distributor = new Distributor();
        Thread distributor_thread = new Thread(distributor);
        distributor_thread.start();

        Thread[] worker_threads = new Thread[threads];
        for (int i = 0; i < threads; i++) {
            worker_threads[i] = new Thread(workers[i]);
            worker_threads[i].start();
        }
        
        try {
            Thread.sleep(time);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //
        distributor.running = false;
        try {
            distributor_thread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        for (int i = 0; i < threads; i++) {
            workers[i].running = false;
            try {
                worker_threads[i].join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        // System.out.println("Total packets processed: " + distributor.total_packets);
        System.out.println("packet/s count: " + (double)distributor.total_packets / (time / 1000.0));
    }

    // implemented from chapter 3
    static class WaitFreeQueue {
        volatile int head = 0, tail = 0;
        Packet[] items;

        public WaitFreeQueue(int capacity) {
            items = new Packet[capacity];
            head = 0; tail = 0;
        }

        public void enq(Packet x) throws Exception {
            if (tail - head == items.length) {
                throw new Exception();
            }
            items[tail % items.length] = x;
            tail++;
        }

        public Packet deq() throws Exception {
            if (tail - head == 0) {
                throw new Exception();
            }
            Packet x = items[head % items.length];
            head++;
            return x;
        }
    }

    // make a distributor worker who takes in the generator and communicates with the labor workers, they will run as threads

    static class Distributor implements Runnable {
        volatile boolean running = true;
        int total_packets = 0;

        Distributor() {}
    
        public void run() {
            while (running) {
                if (flight.get() >= 256) {
                    continue;
                }
                Packet packet = generator.getPacket();
                flight.incrementAndGet();
                if (packet.type == Packet.MessageType.ConfigPacket) {
                    while(running) {
                        try {
                            workload[packet.config.address % workload.length].enq(packet);
                            total_packets++;
                            break;
                        } catch (Exception e) {
                            continue;
                        }
                    }
                } else {
                    while (running) {
                        try {
                            workload[packet.header.source % workload.length].enq(packet);
                            total_packets++;
                            break;
                        } catch (Exception e) {
                            continue;
                        }
                    }
                }
            }
        }
    }
    
    static class Worker implements Runnable {
        volatile boolean running = true;
        int threadId;
        WaitFreeQueue workload;

        Worker(int threadId, WaitFreeQueue workload) {
            this.threadId = threadId;
            this.workload = workload;
        }
    
        public void run() {
            while (running) {
                try {
                    Packet packet = workload.deq();
                    if (packet.type == Packet.MessageType.ConfigPacket) {
                        int addr = packet.config.address;
                        boolean png = packet.config.personaNonGrata;
                        int addrBegin = packet.config.addressBegin;
                        int addrEnd = packet.config.addressEnd;
                        boolean accept = packet.config.acceptingRange;

                        locks[addr].lock();
                
                        // edit PNG
                        PNG[addr] = png;
                        // edit D
                        if (!D.containsKey(addr)) {
                            D.put(addr, new RangeSum());
                        }
                        if (accept) {
                            D.get(addr).add(addrBegin, addrEnd);
                        } else {
                            D.get(addr).remove(addrBegin, addrEnd);
                        }

                        locks[addr].unlock();
                    } else {
                        int source = packet.header.source;
                        int dest = packet.header.dest;
                        
                        locks[source].lock();
                        boolean png = !PNG[source];
                        locks[source].unlock();

                        locks[dest].lock();
                        boolean d = D.containsKey(dest) && D.get(dest).verify(source);
                        locks[dest].unlock();

                        if (png && d) {
                            long fingerprint = Fingerprint.getFingerprint(packet.body.iterations, packet.body.seed);
                            histLock.lock();
                            hist.put(fingerprint, hist.getOrDefault(fingerprint, 0) + 1);
                            histLock.unlock();
                        }
                    }

                    flight.decrementAndGet();
                } catch (Exception e) {
                }
            }
        }
    }
    static class MCSLock {
        private static class MCSNode {
            volatile MCSNode next;
            volatile boolean locked = false;
        }

        private final ThreadLocal<MCSNode> node;
        private final AtomicReference<MCSNode> tail;

        public MCSLock() {
            tail = new AtomicReference<>(null);
            node = ThreadLocal.withInitial(MCSNode::new);
        }

        public void lock() {
            MCSNode currentNode = node.get();
            MCSNode predecessor = tail.getAndSet(currentNode);
            if (predecessor != null) {
                currentNode.locked = true;
                predecessor.next = currentNode;

                // spin until predecessor gives up the lock
                while (currentNode.locked) {
                }
            }
        }

        public void unlock() {
            MCSNode currentNode = node.get();
            if (currentNode.next == null) {
                if (tail.compareAndSet(currentNode, null)) {
                    return;
                }
                // wait until successor appears
                while (currentNode.next == null) {
                }
            }
            currentNode.next.locked = false;
            currentNode.next = null;
        }
    }
}
```

== *`benchmark.py`*

```python
import subprocess
import time
import sys

configs = [
    [11, 12, 5, 1, 3, 3, 3822, 0.24, 0.04, 0.96],
    [12, 10, 1, 3, 3, 1, 2644, 0.11, 0.01, 0.92],
    [12, 10, 4, 3, 6, 2, 1304, 0.10, 0.03, 0.90],
    [14, 10, 5, 5, 6, 2, 315, 0.08, 0.05, 0.90],
    [15, 14, 9, 16, 7, 10, 4007, 0.02, 0.10, 0.84],
    [15, 15, 9, 10, 9, 9, 7125, 0.01, 0.20, 0.77],
    [15, 15, 10, 13, 8, 10, 5328, 0.04, 0.18, 0.80],
    [16, 14, 15, 12, 9, 5, 8840, 0.04, 0.19, 0.76],
]

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 benchmark.py <number of runs> <\"Serial\" / \"Parallel\">")
        sys.exit(1)
    
    iterations = 1000000
    time_control = 1000
    threads = 8
    n = int(sys.argv[1])
    type = sys.argv[2]

    if type not in ["Serial", "Parallel"]:
        print("Invalid type. Please enter \"Serial\" or \"Parallel\"")
        sys.exit(1)


    for i, config in enumerate(configs):
        print(f"running with config: {i+1}")
        for i in range(n):
            start = time.time()
            # run the subprocess and output stdout
            if type == "Serial":
                res = subprocess.run(
                    ["java", "SerialFirewall"] +
                    [str(cfg) for cfg in config] +
                    [str(iterations)],
                    stdout=subprocess.PIPE
                )
            else:
                res = subprocess.run(
                    ["java", "ParallelFirewall"] +
                    [str(cfg) for cfg in config] +
                    [str(time_control), str(threads)],
                    stdout=subprocess.PIPE
                )
            print(res.stdout)

```
