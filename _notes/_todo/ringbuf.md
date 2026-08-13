# ring buffer explained


## Random notes
- its a circular buffer map
- there is no delete in ring buffer

### The main lifecycle
```
                    ┌──→ submit()  ──→ userspace read it
reserve() ──────────┤
                    └──→ discard() ──→ userspace drop it
```


### userspace API
```
struct ring_buffer *rb = ring_buffer__new(fd, handle_event, ctx, NULL);

ring_buffer__poll(rb, 100);   // epoll_wait ثم استهلاك — الشائع
ring_buffer__consume(rb);     // استهلاك فوري بدون انتظار
ring_buffer__add(rb, fd2, cb2, ctx2);   // كذا ringbuf في manager واحد
ring_buffer__epoll_fd(rb);    // للدمج في event loop بتاعك
ring_buffer__free(rb);
```

## Resources in order
1. **`Documentation/bpf/ringbuf.rst`** — the official document. 
    - Written as a design rationale, not a tutorial. 
    - Read the whole thing; it's short. https://docs.kernel.org/bpf/ringbuf.html
2. **Andrii Nakryiko — "BPF ring buffer" (Oct 26, 2020)** — 
    - the feature's author explaining *why* the API was designed this way, plus the comparison against perfbuf. 
    - https://nakryiko.com/posts/bpf-ringbuf/
3. **`anakryiko/bpf-ringbuf-examples`** — a set of examples demonstrating both the ringbuf and perfbuf APIs, written as a companion to the blog post. https://github.com/anakryiko/bpf-ringbuf-examples
4. **`kernel/bpf/ringbuf.c`** — the implementation itself. (VERY IMPORTANT TO ME) 
    - The original patch landed at `~490` lines and has grown since; still reasonably readable if you want to see the busy bit and the `spinlock` with your own eyes.
5. **`include/uapi/linux/bpf.h`** — the description of every helper and every flag. 
    - This is the canonical reference for any helper, not just the ringbuf ones.
