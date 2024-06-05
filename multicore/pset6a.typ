#import "template.typ": *
#show: template.with(
  title: "6.5081 PSET 6A",
  subtitle: "Justin Choi",
  pset: true
)

= Problem 1

== (a)

*Yes, a memory barrier would be required in this case*

Ideally, we would introduce a memory barrier in every single place we could have an ordering of operations or reads that could lead to a critical failure. This happens on lines `15` and `10`. 

One possible source for error that we cover is the potential for dequeueing an incorrect element if the expected enqueue is out of order, and the update of the array happens following that of the tail. In this case, without a memory barrier we would run into significant problems.

Another case that we protect against is the potential to read old values of head from memory if we have not updated it in the correct order. This could lead to a double dequeue operation, which would again cause significant issues later down the line.

We would like to ensure that the ordering of the updates for the array and then the head and tail are stable.

== (b)

*Yes, a volatile declaration would help*

This is because having an element as volatile would ensure that the value of the element is always read from memory, and not from a cache. This would ensure that the value of the element is always up to date and that we are not reading stale values. This would be particularly useful in the case of the head and tail variables, as we would like to ensure that the values are always up to date and that we are not reading stale values. Thus this could solve the potential issues we faced in *(a)*

= Problem 2

Below is my implementation of the first part of the problem:

```java
import java.util.concurrent.locks.*;
import java.util.concurrent.atomic.*;

public class Boxes {
    public interface Handler {
        void onEmpty();
    }

    volatile int boxIdx = -1;

    ReentrantLock lock = new ReentrantLock();
    Condition cond = lock.newCondition();
    AtomicInteger[] counts;
    Handler[] handlers;

    public Boxes(int m) {
        counts = new AtomicInteger[m];
        handlers = new Handler[m];

        for (int i = 0; i < m; i++) {
            counts[i] = new AtomicInteger(0);
        }
    }

    public void enter(int i) {
        lock.lock();

        while (boxIdx != -1 && boxIdx != i) {
            cond.await();
        }
        counts[i].incrementAndGet();
        boxIdx = i;

        lock.unlock();
    }

    public boolean exit() {
        lock.lock();

        int i = boxIdx;
        if (i == -1) {
            return false;
        }
        int cnt = cnt[i].decrementAndGet();
        if (cnt == 0) {
            if (handlers[i] != null) {
                handlers[i].onEmpty();
            } else {
                boxIdx = -1;
                cond.signalAll();
            }
        }
        return true;

        lock.unlock();
    }

    public void setExitHandler(int i, Handler h) {
        handlers[i] = h;
    }
}
```

Below is the fixed version of the code as well as the explanation:

```java
import java.util.concurrent.atomic.AtomicInteger;

public class Stack<T> {
    private AtomicInteger top;
    private T[] items;
    private final Boxes boxes; // new code

    public Stack(int capacity) {
        boxes = new Boxes(2); // new code

        top = new AtomicInteger();
        items = (T[]) new Object[capacity];
    }

    public void push(T x) throws FullException {
        boxes.enter(0); // enter the first box
        try {
            int i = top.getAndIncrement();
            if (i >= items.length) { // stack is full
                top.getAndDecrement(); // restore state
                throw new FullException();
            }
            items[i] = x;
        } finally {
            boxes.exit(); // enter the second box
        }
    }

    public T pop() throws EmptyException {
        boxes.enter(1); // enter the second box
        try {
            int i = top.getAndDecrement() - 1;
            if (i < 0) { // stack is empty
                top.getAndIncrement(); // restore state
                throw new EmptyException();
            }
            return items[i];
        } finally {
            boxes.exit(); // exit box
        }
    }
}
```

The previous implementation did not work, because parallel operations were not handled correctly. There could be multiple pushes and pops going on at the same time, which would cause major issues for the proper execution. Instead what we do is have two boxes, one for the pop and one for the push, that each function enters before executing the operation. This ensures that the operations are done in a serial manner apart from each other, and it is not the case the two functions are mixing in with each other.This prevents the case where increments and decrements on lines `18` and `32` cause some weird interleaving of actions that would cause the stack to be in an invalid state. It is okay to have multiple pushes or pops happening at the same time, but it is not okay to have a push and a pop happening at the same time. This is why we have the two boxes, to ensure that the operations are done in a serial manner.

= Problem 3

For the recurrences, we can use the master theorem to find the functional form. The parallelism is calculated as the result of the work divided by the critical path length.

== Work

$
W(n) &= 2 dot W(n \/ 2) + O(n)\
W(n) &= O(n dot log n)
$

== Critical Path Length

$
C(n) &= C(n \/ 2) + O(n)\
C(n) &= O(n)
$

== Parallelism

$
P(n) &= W(n) \/ C(n) = (2 dot P(n \/ 2) + O(n)) / (P(n \/ 2) + O(n))\
P(n) &= O(log n)
$

= Code

#note(
  title: "Analysis"
)[
  Because of the shifted due dates of the lab, I instead implemented the full parallel system instead of having a clear draft phase and then a refinement period. The code shown below is an accurate reflection of that. The serial version is still listed here as requested by 6A. I analyze and cover both extensively in 6B, so I will leave out the analysis here which I do not believe we need anyway. 
]

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
