## L34 <!-- linenote:unfiled/eBpBMECmdBkzuzc2h4Qssf -->
Files that start with the character sequence #! (and have the execute bit set) are treated as scripts, handled by the `fs/binfmt_script.c` handler. 

### How it works
- After checking those first two bytes, this code parses the rest of the script-invocation line, splitting it into:
1. `the interpreter name`: everything after #! up to the first white space, and
2. `possible arguments`: everything else up to the end of the line, stripping external white space.

- **Example**:
```
#!./show_info -a -b -c
```