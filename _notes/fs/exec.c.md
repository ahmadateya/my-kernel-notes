## L1812 <!-- linenote:unfiled/vdCmjB8iHczaffo9t1N1Sq -->

the [loader](concepts/loader.md) story starts here,
1. `execve()` calls this func

## L1782 <!-- linenote:unfiled/3Hk9LgPGxzNN5yzw6bJ7b7 -->

- second step in `execve()`

## L1678 <!-- linenote:unfiled/wDXXuN3x6oSVpxCYQSe2tQ -->

- third and most important step in `execve()`: finding the binary handler from the registered list found in `__register_binfmt()` that is defined in `include/linux/binfmts.h` and implemented in `fs/binfmt_*.c` files. 


there are 4 main binary formats in Linux:
1. `fs/binfmt_elf.c` for ELF binaries (the most common format) and it uses `ld.so` to load shared libraries
2. `fs/binfmt_script.c` for script files (like shell scripts)
3. `fs/binfmt_flat.c` for flat binaries (used in embedded systems)
4. `fs/binfmt_misc.c` for miscellaneous binary formats (like Java class files, Python scripts, etc.)

TODO: go through them and understand what they do.

## L257 bprm_mm_init() 
This function is soo importatnt, it is the first step in creating a new process image.

- It creates a new `mm_struct` and 
- populates it with a temporary stack `vm_area_struct`. 

The `mm_struct` is the main data structure that represents the memory layout of a process, and it contains information about the process's virtual memory areas (VMAs), page tables, and other memory-related information.

## L257 <!-- linenote:unfiled/6pgGBJFmZ7Gqx2ZgBnrprc -->

## L1104

in this function the kernel (not revised):
- clears up state in the kernel that refers to the previous program.
- Any other threads of the old program are killed so the new program starts with a single thread
- and the signal-handling information for the process is unshared so that it can be safely altered later.
- Any pending POSIX timers for the old program are cleared, and the location of the executable file for the program (visible at /proc/pid/exe) is updated. 
- The virtual memory mappings for the old program are released, which also kills any pending asynchronous I/O operations and frees any uprobes. 
- Finally (this happens in `fs/binfmt_elf.c:1018`), the personality of the process is updated to remove any features that could affect security, as previously recorded in the per_clear field in linux_binprm. 



## Resources
- https://lwn.net/Articles/631631/