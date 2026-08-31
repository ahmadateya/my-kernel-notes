## L832 


`load_elf_binary()` is the main function for elf support in the kernel.

- The kernel only really cares about 3 types of `program header table` entries.

> Notice Program Header Table not Section Header Table

### Program Header Table vs. Section Header Table
| | Section Header Table | Program Header Table |
|---|---|---|
| for | linker (linking time) | loader (loading time) |
| unit name | section | segment |
| examples | `.text` `.data` `.bss` `.rodata` | `PT_LOAD` `PT_INTERP` |
| kernel | ignores it | reads it (cares for 3 types only) |


## Resources
- https://lwn.net/Articles/631631/

