# /include = the kernel headers BUT not all the headers

This dir holds **declared contracts** -> what a subsystem offers to the rest of the kernel. 
Subsystem-private headers live *next to the source*:

- So if you search `include/` for a struct and don't find it, that's not a failed search — it's usually a deliberate design choice that it stays private. Go look in `<subsys>/*.h`.

linux/: General kernel headers.

asm-generic/: Generic architecture headers.

uapi/: User-space API headers.


## ازاي تدور في /include

Ask these in order:

**1. Does userspace see it?** → `include/uapi/`
Every struct crossing a syscall/ioctl, every flag (`O_RDONLY`, `PROT_EXEC`), `enum bpf_cmd`. This is frozen ABI.

**2. Is it arch-specific?** → not in `include/` at all, it's `arch/$(ARCH)/include/asm/foo.h`. 
- `include/asm-generic/` is the fallback an arch pulls in when it doesn't need its own version.

**3. Is it a large subsystem with its own culture?** → its own directory
`include/net/`, `crypto/`, `drm/`, `media/`, `sound/`, `scsi/`, `rdma/`, `trace/`, `dt-bindings/`

**4. Anything else generic and kernel-internal** → `include/linux/`

### `include/linux/` isn't a category — it's the **default bucket**. Whatever doesn't classify lands there.
- thats why it's bloated. 

---
 