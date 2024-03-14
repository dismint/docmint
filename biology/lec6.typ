#import "template.typ": *
#show: template.with(
  title: "Lecture 6",
  subtitle: "7.016"
)

= Nucleotides

Nucleotides consists of three components - a sugar, a base, and a triphosphate. 

= DNA and RNA

== DNA

#define(
  title: "DNA vs RNA"
)[
  The difference between DNA from RNA is that it is missing the oxygen at the 2' position, and instead has a single hydrogen hanging off. 
]

The chain of DNA goes from 5' to 3', the direction does not particularly matter. The two strands in the double helix are antiparallel.

- A and T interact with 2 hydrogen bonds.
- G and C interact with 3 hydrogen bonds.

Thus we can also see a possible mechanism for which DNA can copy itself, since one half can accurately replicate the entire double helix

== RNA

/ Messenger (mRNA): Pairs with DNA to copy the message, T $->$ U
/ Transfer (tRNA): One end has an amino acid, the other has an adapter for mRNA.
/ Ribosomal (rRNA): An enzyme that allows for the building of proteins using mRNA and tRNA.

Information Transfer:

/ Transcription: Going from DNA to mRNA.
/ Translation: Using all the types of RNA to make proteins.
