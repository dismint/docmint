#import "template.typ": *
#show: template.with(
  title: "Lecture 3",
  subtitle: "6.5081"
)

= Queues

== 2 Thread Lock-Based Queue

The idea is to have a circular queue (stored as a list) where the head and tail pointers dance around in a circle.

- To enqueue, we increase the tail counter and add the element
- To dequeue, we increase the head counter and remove the element

To ensure everything is atomic, all operations are locked.

== Wait-Free 2 Thread Lock-Based Queue

Assume that one thread will only *enqueue* and the other will only *dequeue*. It's very clear why the above implementation was correct - how do we show that this one is also correct?

Thus we need to find a way to specify a concurrent queue object, and also a way to prove that an algorithm that attempts to implement this specification is sound.

= Defining Concurrent Objects

We need to specify both the safety and liveness property:

+ When an implementation is *correct*.
+ The condition under which it guarantees progress.

== Sequential Specifications

Recall the definition of *preconditions* and *postconditions*.

#example(
  title: "Pre/Postconditions for Dequeue"
)[
  / Precondition: Queue is empty.
  / Postcondition: Returns and removes the first item in queue.
]

=== Benefits of Sequential Specifications

- Interactions among methods are captured by side effects on the object state.
- Documentation size scales linearly in the number of methods.
- Can add new methods without changing the specification of old methods.

== Concurrent Specifications

The main difference between concurrent and sequential methods is the fact that there is a notion of *time* in concurrent methods. Rather than being an *event*, a concurrent method is an *interval*.

/ Sequential: Objects only need meaningful states between method calls.
/ Concurrent: Because of overlapping method calls, "between" may never exist.

Thus as compared to sequential method specifications, we need to characterize *all* possible interactions, including the interleaving of different methods.

This means that when we add a concurrent method, we can't add documentation independently of other methods.

In a lock based approach, despite methods heavily overlapping, there is a way to get an ordering of events that don't overlap, where the critical operations occur. Thus to avoid all these problems mentioned above, we want to try and figure out a way to map concurrent method to sequential methods.

#define(
  title: "Linearizability"
)[
  Each method should "take effect" instantaneously between invocation and response events.

  An object is considered linearizable if all possible executions are linearizable.
]

Because the linearization point depends on execution, we need to describe the point in context of an execution. 

Let us split method calls into two events.

#define(
  title: "Invocation Notation"
)[
  #align(center)[`A q.enq(x)`]
]

#define(
  title: "Response Notation"
)[
  #align(center)[`A q: void`]
]

An invocation and response match if the thread and object names agree, and thus correspond to a method call.

We can view this history in terms of *projections*, such as an object or thread projection. We essentially filter the history for just these involved parties.

An invocation is pending if it has no matching response.

#define(
  title: "Sequential Histories"
)[
  A history is sequential if method calls of different threads to do not interleave.
]

#define(
  title: "Well-Formed Concurrent History"
)[
  If the thread projections are sequential, then it is concurrently well-formed. This can be seen as a weaker form of the above definition.
]

#define(
  title: "Equivalent Histories"
)[
  If the thread projections are the same for every thread, then the two executions are *equal*, even if the interleaving of the operations was different.
]

== Linearizability

How do we actually tell something is linearizable? History $bold(H)$ can be considered linearizable if it can be extended to another history $bold(G)$ by:

- Appending zero more more responses to pending invocations
- Discarding other pending invocations

#twocol(
  [
    The end result should be a legal sequential history where all orderings in $bold(G)$ fall under a subset of some legal sequential history $bold(S)$
  ],
  [temp]
  // bimg("img/subset.png")
)
