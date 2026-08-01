## L203 <!-- linenote:unfiled/oK1skuKYr9BM3Vj9SWobAw -->
The miscellaneous binary format handler allows a more flexible and dynamic method of dealing with new formats.

- this handler is responsible for running things like java


### How its done?
by allowing run-time configuration (via a special filesystem mounted under /proc/sys/fs/binfmt_misc) to specify:

- How to recognize a supported format, based on filename extension or a magic value at a particular offset. (As with parsing script interpreters, this magic value has to fall within the first 128 bytes of the program file.)
- The interpreter program to invoke, which will get the program filename passed to it as argv[1] (as with script invocation).
