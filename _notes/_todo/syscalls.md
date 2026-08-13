# Syscalls explained

finish this todo by explaining the whole journey of syscall from `glib` till the cpu instructions


## Highlights

### The mental model
system calls arent just functions with implementation, there are 7 layers each of them has responsibility and the implementation is the `thinner layer`.

### The layers on x86

| # | Layer | File | Responsibility |
|---|---|---|---|
| 0 | ABI contract | — | `nr` in `rax`; args in `rdi, rsi, rdx, r10, r8, r9` |
| 1 | glibc wrapper | `sysdeps/unix/sysv/linux/` | Translate C calling convention → syscall ABI; convert `-errno` → `-1` + `errno` |
| 2 | CPU transition | hardware | `syscall` instruction reads `MSR_LSTAR` |
| 3 | Entry asm | `arch/x86/entry/entry_64.S` | `swapgs`, CR3 switch (PTI), build `struct pt_regs` |
| 4 | Generic entry | `kernel/entry/common.c` + `arch/x86/entry/common.c` | seccomp / ptrace / audit / tracepoints; on exit: signals + resched |
| 5 | Dispatch | `arch/x86/entry/syscall_64.c` | `nr` → function |
| 6 | `SYSCALL_DEFINEn` wrapper | `include/linux/syscalls.h` | Unpack from `pt_regs`, sign-extension, metadata |
| 7 | Body | `fs/`, `mm/`, `kernel/`, … | The actual work — usually ~5 lines delegating to `ksys_*` / `vfs_*` |


## Resources
1. LKD syscalls chapter
2. The anatomy of syscall part 1 - lwn 
3. The anatomy of syscall part 2 - lwn 
4. syscall section in Linux insides book 
