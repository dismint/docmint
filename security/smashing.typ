#import "template.typ": *
#show: template.with(
  title: "Smashing the Stack in the 21st Century",
  subtitle: "6.566"
)

= Introduction

The stack stores the current state of the program as it runs, capturing things such as local variables, the return address, etc. Visualize the stack as exactly that, with the bottom being a high memory address where it starts, and additional frames moving upward toward lower addresses.

When a `main` calls a `function`, the following generally happens:

+ The return address is added to the stack.
+ Before setting the new `function` base pointer (`%rbp`), we store the old `main` base pointer on the stack.
+ Set the `function` base pointer to the new value.
+ Add all the local variables.

Note that the `%rsp` variable stores the current location of the stack (the topmost element).

= Smashing the Stack

Now consider the following short program of `C`

```C
#include <string.h>
#include <stdio.h>

void copy(char *str) {
  char buffer[16];
  strcpy(buffer, str);
  printf("%s\n", buffer);
}

int main (int argc, char **argv) {
  copy(argv[1]);
  return 0;
}
```

We can easily cause a *buffer overflow* by giving a `str` argument that has more than 16 bytes. This means that we can inject information into the rest of the stack, like other local variables, the stored `%rbp`, or perhaps even dangerously, the return address.

Thus it becomes possible for us to reach parts of the code that may be unreachable in a regular run of the software. Imagine there is a prototype function the developers have not connected in any way yet to the actual codebase. It's possible that we can make an attack such that the stack smash goes into the return pointer, setting it to elsewhere in the program, perhaps even that sensitive function.

However, stack smashing can be even more dangerous. We've been focusing primarily on the smashing of the return address, but there is an additional layer of risk. In particular, the first part of our stack smash can be some bytes that are actually a program the attacker has created, and then the subsequent return address smash can point back to the location of this code, meaning we can run completely foreign software with this type of attack.

#define(
  title: "Shell Code"
)[
  This injected code is often called *shell code*, because we usually want to open a shell where we can then run more commands.
]

This means we could potentially delete files, extract sensitive information, and in general gain complete control over the system the software is running on.

= Return to libc

What happens if the stack we're trying to smash is not executable? That is, it no longer becomes possible for us to inject our own code and run it on the stack? Well, then we have to borrow other prats of the existing code and patch it together for our use.

Suppose that we wish to `unlink` a file from the system. Without having an executable stack, this will require two steps.

+ Find the `unlink` system call somewhere in the existing codebase. It may come from the source code or an imported library. We will jump to this (return to libc) in order to perform the desired action.
+ In order to use the `unlink` we previously found, we need to load arguments into the correct registers. However, since we can't inject code, this is something that must also be scraped together from the existing codebase. The last part of this attack is to find a rop gadget (return-oriented programming) that somehow loads the correct argument registers from a place that we can smash with the stack.
