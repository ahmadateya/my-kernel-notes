# kernel-notes

My annotations on the Linux kernel: inline comments written into kernel files,
plus standalone notes in `_notes/`. This repo holds **only my changes** — the
kernel comes from upstream.

## Idea: one tree, two repos

One copy of every file on disk. `fs/exec.c` is a single file containing
upstream code *and* my comments. Only the *history* is duplicated.

```
~/linux/                 the only directory with files
├── .git/                   CAMERA A — kernel history (~6 GB), read-only
├── fs/exec.c               upstream code + my comments, same file
├── _notes/  _scripts/  .vscode/
└── .gitignore

~/kernel-notes.git/      CAMERA B — my changes only (MBs) → GitHub (private)
```

Camera B's `.git` lives **outside** the tree; its files live **inside** it:
`--git-dir=$HOME/kernel-notes.git --work-tree=$HOME/linux`

**No merge step exists.** Merging needs two versions of a file; there's one.
Camera B just *remembers* the file's state, and `checkout` writes it back.

## Reading

| Question | Command |
|---|---|
| How old is this kernel line? | `git blame --date=short fs/exec.c` |
| How did this function evolve? | `git log -L :do_execve:fs/exec.c` |
| When did *I* write this note? | `nsync -- blame fs/exec.c` |
| What have I annotated? | `nsync -- ls-files` |

Camera A on an annotated file:

```
^34674c0 (Linus Torvalds    2005-04-16 1) static int do_execve(struct filename *filename)
00000000 (Not Committed Yet 2026-08-01 2) 	/* AHMAD: entry point */
^34674c0 (Linus Torvalds    2005-04-16 3) {
8a7e1dad (Al Viro           2012-10-20 4) 	return do_execveat_common(AT_FDCWD, filename, NULL);
```

Real line ages survive and my comment stands out — precisely because it is never
committed in camera A.

## Daily use

```bash
nsync                  # stage everything changed, commit, push
nsync "exec path"      # same, with a real commit message
```

Write a message when you finish a coherent piece. 300 commits named `sync`
can't be read later, which defeats half the point of keeping history.

## Setup (once)

```bash
git clone https://github.com/torvalds/linux.git ~/linux
cd ~/linux && git checkout v6.12        # pin here; line numbers must not shift

git --git-dir=$HOME/kernel-notes.git --work-tree=$HOME/linux init
G="git --git-dir=$HOME/kernel-notes.git --work-tree=$HOME/linux"
$G config status.showUntrackedFiles no  # else it lists 95k files
$G config user.name "Ahmad"
$G remote add origin git@github.com:<you>/kernel-notes.git

mkdir -p ~/linux/_scripts               # put nsync here, chmod +x
ln -s ~/linux/_scripts/nsync ~/bin/nsync
```

## Cloning onto a new machine

Order matters — kernel first, notes second.

```bash
git clone https://github.com/torvalds/linux.git ~/linux
cd ~/linux && git checkout v6.12

git clone --bare git@github.com:<you>/kernel-notes.git ~/kernel-notes.git
G="git --git-dir=$HOME/kernel-notes.git --work-tree=$HOME/linux"
$G checkout -f -- .
$G config status.showUntrackedFiles no

ln -s ~/linux/_scripts/nsync ~/bin/nsync
```

That `checkout` line is unavoidable: `nsync` lives inside the repo, so it
doesn't exist on disk until camera B is laid down.

## Pitfalls

**Never `nsync -- add -f .`** — `.` is the whole tree and `-f` defeats every
`.gitignore`: ~95k untouched files plus gigabytes of build output. Recover with
`nsync -- reset` before committing.

**Never run these in `~/linux`:** `git checkout .`, `git stash`,
`git clean -xfd`, `git reset --hard` — each wipes the inline comments off the
tree. Recoverable from camera B *if* pushed. So push often.

**Comments go on their own lines.** Appending to an existing line transfers that
line's blame to me and its real age is lost. `.git-blame-ignore-revs` does not
fix this.

**Don't move the tag.** Notes are pinned to line positions in v6.12. Read newer
code through camera A (`git log v6.17 -- fs/exec.c`) without moving the tree.

**Camera A always shows the tree as dirty.** By design. `git pull` there will
refuse while files are modified — run `nsync` first, re-checkout from camera B
after.

**Neither camera alone is a backup.** Deleting `~/kernel-notes.git` leaves the
comments on disk but loses their history; `git checkout .` in camera A destroys
the on-disk copy while camera B still has it.

**SQLite note DBs don't delta-compress.** Commit `sqlite3 notes.db .dump >
notes.sql` and exclude the binary via `.git/info/exclude`.