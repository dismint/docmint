#import "template.typ": *
#show: template.with(
  title: "Lecture 7",
  subtitle: "7.016"
)

= Introduction

In order to replicate the strands of DNA, we will need to separate the hydrogen bonds holding them together. This is done by a substance called *helicase*. Then we need to synthesize a new strand, which is done using *DNA polymerase*. In order to build these, we also need to have dNTP around.

= DNA Replication

DNA is synthesized from 5' to 3', thus the template is read 3' to 5'. DNA polymerase needs a 3' OH to start.

When the helicase is splitting DNA, one strand is the *leading* stand (if it is going in the same direction) and otherwise it is the *lagging* strand.

#define(
  title: "Topoisomerase"
)[
  Topoisomerase prevents supercoiling in DNA downstream of the replication fork.  
]

The location on a chromosome where DNA synthesis starts is called the *origin of replication*. There are signals for where this should be, as well as when it should start and finish.

#define(
  title: "Ligase"
)[
  Ligase is responsible for forming the covalent bonds where the 'nicked' strands previous were with the RNA.
]
