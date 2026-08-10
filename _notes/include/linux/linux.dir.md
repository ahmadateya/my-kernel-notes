# /include/linux = default bucket for whatever doesn't classify 


## Naming patterns inside `include/linux/`

| Pattern | Meaning | Example |
|---|---|---|
| `foo.h` | full subsystem API | `sched.h`, `fs.h`, `slab.h` |
| `foo_types.h` | structs only, no functions | `mm_types.h`, `tracepoint-defs.h` |
| `foo/*.h` (subdir) | header grew and got split | `sched/signal.h`, `sched/task.h` |
| `foo-provider.h` vs `foo.h` | who *implements* vs who *consumes* | `clk-provider.h` vs `clk.h` |
