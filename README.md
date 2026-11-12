# dotfiles

My Mac setup. Mostly zsh, git, Cursor and Claude Code config, plus a Brewfile
so a new machine is ready in a few minutes.

Inspired by [Freek Van der Herten's dotfiles](https://github.com/freekmurze/dotfiles).

## What's inside

```
bin/install           bootstrap script
home/                 files symlinked into ~ (.zshrc, .zprofile, .gitconfig)
shell/                exports, aliases and functions, sourced by .zshrc
config/Brewfile       everything installed with Homebrew
config/git/ignore     global gitignore
config/cursor/        Cursor settings
config/claude/        Claude Code: global CLAUDE.md, settings, status line, skills
```

Everything is symlinked, not copied. Editing `~/.zshrc` edits the file in
this repo, so changes are versioned right away.

## Install

```sh
git clone https://github.com/parfienczyk/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bin/install --dry-run   # see what it would do first
bin/install
```

`bin/install` installs Homebrew and the Brewfile, oh-my-zsh with plugins,
and creates the symlinks. Files that already exist are moved to
`~/.dotfiles-backup/<date>/` first, so nothing gets lost. Running it again is
safe. `--links-only` skips Homebrew and oh-my-zsh.

## Private stuff

Work config, tokens and anything machine-specific lives in files that are
never committed:

- `~/.zshrc.local` - sourced at the end of `.zshrc`
- `~/.gitconfig.local` - included from `.gitconfig` (work email, credentials)
- `~/.npmrc` - not managed here at all

## Claude Code

I use Claude Code every day, so its config is part of the setup:

- `CLAUDE.md` - global rules for every project (in Polish, e.g. never commit
  or push without asking me first)
- `settings.json` - model and effort level, custom status line
- `statusline.sh` - shows folder, git branch, model and how much of the
  context window is used, color coded
- `skills/fe-sprawdz` - "check it once more": a final review pass after the
  agent says it's done. Typecheck, lint, tests, leftovers like `console.log`
  or `TODO`, and a review of the diff.

Two small helpers in `shell/functions.zsh`:

- `commit` - Claude writes a commit message from the staged diff and opens it
  in the editor, so I always read it before it goes in
- `uncommit` - undo the last commit, keep the changes staged

## Stack

zsh + oh-my-zsh + starship, nvm, pnpm, bun, Cursor, iTerm2, Raycast,
Claude Code.
