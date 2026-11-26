# my-kernel-notes

Notes I take while reading the Linux kernel source, pinned to **v7.2-rc1**.

This repo holds only my own changes. The kernel itself comes from upstream.

## What's here

- **Inline annotations**: comments written straight into kernel source files
  (`fs/exec.c`, `kernel/fork.c`, `mm/mmap.c`, `include/linux/sched.h`, …),
  each on its own line, so `git blame` on the upstream tree still shows the
  real age of every original line.
- **`_notes/`**: standalone write-ups that mirror the kernel's directory
  layout (`_notes/fs/exec.c.md` goes with `fs/exec.c`), plus:
  - `_concepts/`: topics that span many files (boot, the ELF loader, folios,
    namespaces)
  - `_todo/`: open questions and areas still to read
- **`_scripts/`**: small helpers for keeping the notes in sync.

## Reading the notes

Check out upstream Linux at `v7.2-rc1` and lay this repo over it. The
annotations depend on line positions, so they only line up on that tag. For
the full setup and daily workflow, see [`_notes/WORKFLOW.md`](_notes/WORKFLOW.md).

## Disclaimer

These are personal study notes and may contain mistakes. The kernel source
and its documentation are the authority. Kernel code is © its respective
authors under GPL-2.0.
