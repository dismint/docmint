#import "template.typ": *
#show: template.with(
  title: "BitLocker",
  subtitle: "6.566"
)

= Introduction

BitLocker is a feature of of Windows shipped in Vista onward which encrypts all the data on the system volume. The main motivation for BitLocker is to prevent any dangerous interactions when laptops are lost - an event that happens surprisingly frequently.

There are several common attacks that one can use to break into a laptop.

#example(
  title: "Ways to break into a laptop"
)[
  - Quite simply, you could just take the disk drive out of the laptop and plug it into another device. You can then use root privileges on the second device to access all the files.
  - You can run a script on the machine using a USB or other medium, allowing you to reset the Administrator password.
]

The easy solution to this problem is to use encryption on the disk, with a user passphrase / token. However this runs the annoyance that there will be extra work anytime the user attempts to use the machine.

BitLocker improves on this model by preventing the user from having to make extra actions during boot or hibernation. However, this can be defeated with hardware attacks. In general, *hardware* attacks are much more difficult than *software* based attacks, which are more easily distributable and general. The idea is that whatever allows the convenience of not taking actions on boot or hibernate is a physical piece on the laptop that can be recovered with a hardware attack. You can use a PIN or physical USB to prevent this, which BitLocker supports, but again, the average person will most likely refrain from having this extra step of security.

= Trusted Platform Module Chip (TPM)

To understand how BitLocker works, it is critical to understand how the TPM chip works.

The TPM contains several Platform Configuration Registers (PCR), which are special variables initialized to zero on startup, that can only be modified by the `extend` function, which takes a string and sets the PCR to the hash of its old value and the string. Therefore, you can think of the PCR as capturing a sequence of actions into one variable. The only way to get a value is to rewind and reapply the same `extend` calls that led to it.

Thus on boot, computers will track the software that is running with `extend` calls. The end value of this is seen, and then the key is *sealed* with the PCR value ahead of time. Anytime the computer boots, if the software is the same, then we expect to see the same PCR value, and thus we can use the *unseal* functionality of the TPM to decrypt the key. Of course, this means that if the boot code changes, then the PCRs must be recalculated, which leads to a very inflexible system.

BitLocker makes this easier by running as soon as possible on boot, after some relatively unchanged code, then using the PCRs at that point to run the rest of the boot software. This allows for modifications of the boot software without having to constantly redo the PCR hash of the encryption key. We assume that the BitLocker encrypted code for the latter half of the boot is hard to tamper with in a meaningful way.

= Inability for MACs

Although it is unlikely an attack on the ciphertext will lead to a meaningful attack, it is still a concerning vulnerability. We might ask why we can't encrypt sectors with a MAC.

There are two important requirements for BitLocker to consider:

+ Encryption is done in a per-sector basis.
+ The ciphertext cannot be larger than the plaintext.

#define(
  title: "Sectors"
)[
  Disks store information in fixed size sectors of bytes sizes that are some power of two. Usually this is 512 bytes, but this may grow to 4096 or even 8192 bytes.
]

The constraints both have solid engineering bases. If encryption was to be done on multiple sectors, then we could have a corruption in one sector while writing to a completely unrelated one. This is huge violation for many applications and database systems which rely on the fact that sectors will only corrupt themselves if at all.

Since there is no extra space, it is not possible to add a MAC for each sector, and doubling the sector size just to store a MAC would essentially mean losing half the available space on the disk.

It is also bad to designate a block specifically for MACs since an error in writing a MAC for one sector could corrupt another sectors MAC. Another reason this point wouldn't work is because we want BitLocker to be operable on an already existing disk.

= Poor-man's authentication

Since we can't use authentication our solution is to hope that changes to the ciphertext will not lead to any meaningful changes in the plaintext. We hope that the system or application would crash or stop rather than inflicting some kind of desired attack.

Again, it is possible that you can use an external hardware device that eliminates this weakness, although the disk cipher design is primarily aimed toward the TPM-only case.

= Performance

In order for customers to want to use BitLocker, it must result in no, or very insignificant slowdowns to the system.

It can be shown that this is possible and feasible.

= Attack Model

- The attacker has random ciphertext / plaintext pairs.
- The attacker has chosen ciphertext / plaintext pair. The plaintexts are chosen before the attacker gets access to the laptopl
- The attacker has a slow decryption function for some of the sectors.
- The attacker gets several ciphertexts of plaintexts for the same sector with a known difference.

An attack succeeds when they can modify the ciphertext to produce plaintext with a non-random property. 

