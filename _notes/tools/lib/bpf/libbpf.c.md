## L10076 bpf section names


### Example
kprobe/<symbol>

- this symbol is important for `auto_attach`, but if you used `bpf_program__attach()` it will be ignored.