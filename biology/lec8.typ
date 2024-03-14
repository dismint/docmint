#import "template.typ": *
#show: template.with(
  title: "Lecture 8",
  subtitle: "7.016"
)

= Repair Mechanisms

Deamination of 5-methylcytosine leads to a replication error because now it has the properties of thymine, meaning it will be incorrectly paired with guanine.  Thus when this bad half becomes a template for replication, it will result in an incorrect duplication of the original DNA.

DNA glycosylase works to automatically solve this problem by getting rid of the "thymine", after which the endonuclease severs the backbone allowing for the repair.

Sometimes thymine dimers can be formed when they covalently bond with each other (by UV light).

If both sides are damaged, you need to use the homologous chromosome in a homologous repair - this happens from intense procedures such as x-rays or other forms of radiation.

= RNA Polymerase

RNA polymerase synthesizes RNA from a DNA template. Notably, it does *not* require a primer.

General transcription factors load RNA polymerase near the transcription start site. These are loaded by the TATA box upstream of the starting location. There are also enhancers upstream that allow tissue-specific expression in a modular way.
