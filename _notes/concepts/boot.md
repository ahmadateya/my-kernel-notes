# This is the very early boot sequence in kernel


```ascii
Power on
  → BIOS / UEFI firmware
  → GRUB
  → arch/x86/boot/header.S      ← 16-bit real mode، MMU doesnt exist yet
       arch/x86/boot/main.c     ← C 16-bit, TODO: what is this?
       → go_to_protected_mode()
       → pmjump.S               ← 32-bit protected mode، segmentation without paging
  → arch/x86/boot/compressed/head_64.S
       startup_32:
         CR4.PAE = 1
         CR3 = trampoline page tables
         EFER.LME = 1
         CR0.PG = 1              ← paging start working
       → startup_64 → extract_kernel()   (misc.c)
  → arch/x86/kernel/head_64.S
       startup_64 → __startup_64 (head64.c)
       → x86_64_start_kernel()   ← first real C code
       → start_kernel()          ← init/main.c
```