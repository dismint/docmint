#import "template.typ": *
#show: template.with(
  title: "Quiz 1",
  subtitle: "6.566"
)

= OS and VM Isolation

The motivation for this lecture is to solve the problem of isolation. We want to stop different containers from having access to each other to prevent malicious use cases.

== Linux Processes

Uses UIDs as well as per-file permissions, and is primarily used for fine-grained sharing between users rather than absolute isolation between two systems.

== Linux Containers

/ Abstraction: Packaging software with all dependencies, useful if different versions of dependencies are needed.
/ Isolation: Ensure that code runs securely on the same machine as other apps.

Namespaces enable control over what files, process, etc are visible, while cgroups control resource use to handle performance isolation and balance. The problem with using these two techniques is that there is still a shared kernel underneath, and with many ways to abuse the kernel.

seccomp-bpf attempts to somewhat solve this issue by preventing what kind of system calls can be made, could not be good as it limits the kind of syscalls that can be used to more common ones, which may break compatibility with some software.

VMs are a relatively foolproof solution, but have a high start-up cost and overhead.

== Firecracker

Uses KVM for virtual CPU and memory, have QEMU in Rust running, supporting a minimal set of devices. A block device is used instead of a disk. The Rust implementation should supposedly be memory safe and has a much smaller footprint than regular QEMU.

Firecracker utilizes several safety mechanisms including chroot, namespaces, UIDs, and seccomp-bpf to ensure that any potential attacks can not be exploded into something much larger. KVM bugs still continue to be a large problem for Firecracker.

== gVisor

Reimplement the syscall interface in a separate user-space process. The rewritten Go system calls are less likely to have bugs, and any bugs that do happen aren't directly in the kernel so it's harder to exploit it. seccomp-bpf can be used for further control as well. There is an overhead in redirecting every single system call to gVisor. Gofer refers to the part of gVisor that can access the files, Sentry is the reimplementation of all the system calls. 

A common pattern we see is that of the supervisor monitoring processes. Firecracker offers only about a tenth of the system calls, gVisor allows a little more.

= Software Fault Isolation

Software fault isolation does not rely on hardware or OS support like virtualization, and is therefore a very powerful technique. However developers need to be looped in, as an existing binary can't be run in isolation. A modern version of SFI is found in WebAssembly.

== WebAssembly

An adversary can run any of the functions in the Wasm module, but should not be able to access memory outside of what's assigned to the sandbox.
