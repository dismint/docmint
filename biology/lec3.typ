#import "template.typ": *
#show: template.with(
  title: "Lecture 3",
  subtitle: "7.016"
)

= Amino Acids

#define(
  title: "Amino Acid"
)[
  An amino acid is a protein that contains both the amino as well as carboxylic acid groups.
]

In the context of an amino acid, $R$ is the side chain, and is what distinguishes an amino acid. The middle Carbon is called an $alpha$-Carbon.

Two amino acids bind together in what is called a condensation reaction, where you lose a Hydrogen and Oxygen from one molecule, and another Hydrogen from the other, to make a water.

#define(
  title: "Peptide Bond"
)[
  A peptide bond is the resulting middle section that forms from a condensation reaction, and consists of:

  $ "H-N-C=O" $
]

= Amino Acid Groups (Side Chains)

The chart of 20 / 21 amino acids is completely based off of the $R$ group. They are encoded into the non-polar, polar, (+) charge, and (-) charge groups.

There are several ways to recognize each group

/ Non-polar: Loose ends of carbon, which is why it is non-polar.
/ Polar: Hanging groups, making it polar
/ (+) Charge: Has a (+) icon.
/ (-) Chage: Has a (-) icon.

= Levels of Protein Structures

There are four levels of protein structure: Primary, Secondary, Tertiary, and Quaternary.

#define(
  title: "Primary Structure"
)[
  A *sequence* of amino acids from a Nitrogen-terminus to a Carbon-terminus. It *must* be read from the N to C terminus. Peptide (covalent) bonds bold the primary structure.
]

#define(
  title: "Secondary Structure"
)[
  There are three primary types:

  - $alpha$-helix
  - $beta$-sheet
  - Loop / Turn

  Hydrogen bonds bold the structure together.
]

#define(
  title: "Tertiary Structure"
)[
  / Side Chain - Side Chain: Disulfide Bond, Ionic Bond, Hydrogen Bond, Hydrophobic Interaction.
  / Side Chain - Peptide Backbone: Hydrogen Bond.
  / Side Chain - Water: Hydrogen Bond.
]

#define(
  title: "Quaternary Structure"
)[
  Quaternary structures are a description of the number, type, and arrangement of polypeptide chains. 

  / Number: Monomer, Dimer, Trimer, Tetramer
  / Identity: Identical (Homo), (Different) (Hetero)

  For the number, if there are two similar types, it only counts as one. For example, two $alpha$ peptides and two *distinct* $beta$ peptides make a *Hetero Trimer*.

  The interactions are the same as the tertiary structures.
]
