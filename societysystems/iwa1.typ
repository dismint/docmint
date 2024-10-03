#import "template.typ": *
#show: template.with(
  title: "IWA #1",
  subtitle: "6.1850",
  pset: true,
  toc: false,
)

#note(title: "Word Count")[1269]

= Introduction

BitTorrent is a communication protocol for distributing data across a network of peers in a decentralized manner. It spawned the widely used term "torrent", and is a popular method for sharing media. The protocol has reached a level of usage such that there are now additional concerns and complications about how the system is being utilized. Topics such as piracy have become intermingled with torrenting, and there are many complex interactions between stakeholders of BitTorrent.

== Technical Overview

BitTorrent hosts can serve their data through *seeds*. Seeds contain parts of the data that need to be distributed and resemble the more traditional single source downloading protocol. However, since it is a peer-to-peer system, the seeds must support distributed downloading. This is done by running a *tracker*, which will note peers that are attempting to download the file and will route and organize them accordingly to facilitate a peer-to-peer network.

A large piece of data is split into *pieces*, of which any can be downloaded at any given point in time. The idea is for peers to source all the pieces of the original file from peers and seeds, while also acting as as provider should any other peers want the pieces that they have. The final result is then verified against a checksum and completed.

The BitTorrent protocol specifies how peers should act by describing desired behaviors such as:

- How to balance uploading and downloading as a peer (*choking*)
- Which pieces to download first (_random_)
- Which pieces to prioritize (_rarest-first_)

= Impact Analysis

== Content Creators

As mentioned before, torrenting for many has become synonymous with pirating and the illegal distribution of intellectual property. This impacts many content creators, whether they create video content, music, games, or any other creative medium.

For the vast majority of cases, these stakeholders are impacted by the system acting on them. Many might not even know what torrenting is, only that it has been causing disallowed distribution and repurposing of their content as well as potential revenue losses. There are certainly content creators that use BitTorrent as a way to positively grow their content with decentralized distribution, with similar benefits to many other users of the system.

However the content creators who are the victims of BitTorrent highlight a very interesting demographic of stakeholders - those that feel completely detached from the system, yet profoundly feel the effects. This might be one of the more concerning classes of stakeholders. Imagine as a content creator, you wake up one day to see that your song has gone massively viral, only to find out that it was illegally distributed and you will not be seeing any of the revenue from its success. Without knowledge of the system, it could feel frightening and daunting to try to understand what happened and prevent it in the future.

It is an interesting question to consider whether it is the duty of more informed stakeholders, perhaps even the creator of the system themselves, to take it upon themselves to help stakeholders who are completely blind to the system yet are affected greatly by it.

== ISPs

Doing some research into the effects of BitTorrent ended up exposing some interesting stakeholders, one of which are Internet Service Providers (ISPs).

ISPs are similar to content creators in that they are mostly acted upon by BitTorrent. However, ISPs do act *on* BitTorrent since they are one of the core mechanisms with which peer-to-peer distribution happens. If an ISP decides that they will not allow any traffic that is originating from a BitTorrent protocol (which has happened in the past), then this would heavily impact the system. Unlike content creators however, ISPs are fully aware of what torrenting is and interact with the system as an informed stakeholder.

One particularly interesting way that BitTorrent acts upon ISPs is the tremendous increase in required bandwidth. ISPs' bandwidth is one of their core resources, so anything that causes that utilization to skyrocket would be incredibly concerning for them. Studies around 2015 showed that BitTorrent traffic accounted for an astounding 53% of all upstream traffic in North America. This type of usage is what has prompted ISPs to crack down on users who interact with BitTorrent, often punishing them for doing so.

As one of the core mechanisms of BitTorrent, it is possible that ISPs could also feel pressure from other stakeholders such as content creators to stop serving traffic that relates to torrenting.

== Corporations

Although there are certainly downsides to every stakeholder, I believe that corporations and BitTorrent are widely positive for each other. There are quite a few ways that corporations can interact with BitTorrent, but for this stakeholder analysis I will consider corporations that are *choosing* to use BitTorrent.

There are a large number of companies that use BitTorrent to enhance some part of their workflow. For example:

- Facebook and Twitter use BitTorrent to distribute updates so they can ensure high availability
- Blizzard and other game clients use BitTorrent for quick downloading large games as well as patching the game

These corporations have no reason not to use BitTorrent if they see it as a superior algorithm to previous systems. BitTorrent clearly states their mission goals on their website, and there is nothing that inhibits companies from using the BitTorrent protocol for their own use. Choosing to adopt a system would mean that it goes widely into use as well - if a large social media website relies on BitTorrent for updates, it is very likely that BitTorrent will become a core software that the entire system relies on. 

On the other side, although the use of BitTorrent might not directly benefit BitTorrent, it brings publicity and attention to the protocol, meaning that others are more likely to adopt or contribute to the project.

When big companies use BitTorrent, this impacts users indirectly as well. Very similar to how content creators often suffer unknowingly through the use of BitTorrent, customers of large social media platforms or games are often benefiting from the BitTorrent protocol without even realizing it. This illustrates a type of duality present in stakeholder analysis - it is important to consider all stakeholders and contexts to properly assess what secondary or tertiary impacts may arise from something as simple as a file distribution protocol.

= Design Impact

Many of the impacts that users feel either directly or indirectly from BitTorrent are a result of complex interactions between the protocol and stakeholders. However, there are also impacts that are a direct consequence of design decisions that were made by BitTorrent. In particular, let us take a look at the impact that a peer-to-peer model has on ISPs.

This design is of interest because it is a core part of the BitTorrent protocol, yet causes a number of negative effects. ISPs are forced to deal with increased strain, reduced bandwidth, and traffic congestion as a result of such protocols. The constant uploading and downloading present in BitTorrent's peer-to-peer design are a clear and direct cause for these pressures to ISPs.

However, there are likely reasons for why the developers took this path. On this flip side of congesting the network, having a system that is peer-to-peer will generally increase speed and resilience for users and downloading data. It also creates a fault tolerant and distributed system that allows decentralized distribution of information that doesn't rely on one server paying an extraordinary amount of money to host data at potentially slow rates (or paying the overhead of having multiple mirrors).
