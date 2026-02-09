---
name: git-user
description: Step-by-step guidance for maintaining a linear Git workflow using rebases, feature branches, and fast-forward merges.
---

# Git Workflow Guide

## When to use
Trigger this skill when:
- creating or updating branches
- rebasing work
- writing commits
- preparing a branch for review
- validating CI expectations related to Git history and PR integration

## Core principles
- Linear history is mandatory
- `main` is protected and immutable
- Rebasing is preferred over merging
- Human-reviewed pull requests gate integration into `main`

## Rules (non-negotiable)
- Never push or force-push on `main`
- Never merge `main` into a feature branch (no merge commits)
- Only fast-forward merges into `main` (performed manually by a human in GitHub)
- After rebasing a feature branch that is already pushed, always push with `--force-with-lease`

## Steps
0. Use the Git CLI
1. Create a branch from `main`
2. Rebase often on the remote `main`:
   - `git fetch && git rebase origin/main`
   - or `git pull --rebase origin main`
3. Resolve conflicts locally and run relevant checks/tests
4. Create one or several atomic commits
   - Group changes by technical area or business concern
   - Each commit represents a coherent unit of work
   - Commit history may be rewritten (reword, squash, reorder) **only** if prior commits no longer accurately describe the code due to AI-introduced changes
5. Push to remote **on demand**
   - First push: `git push -u origin <branch>`
   - After a rebase (or any rewritten history): `git push --force-with-lease`
   - Never push or force-push on `main`

## Branch naming
- `feature/<topic>` for a new feature
- `fix/<topic>` for a bug fix
- `chore/<topic>` for project cleanup, documentation, or general housekeeping

## Commit style
- Use imperative verbs (“add…”, “fix…”, “remove…”)
- Keep commits small and atomic
- Each commit represents a single technical or business unit of work
- Add a descriptive commit body for complex or non-obvious changes

## Pull requests and merging
- Feature branches are integrated into `main` via a manually created GitHub Pull Request
- The pull request is reviewed before integration
- The final merge is performed manually by a human
- Only fast-forward merges are allowed
- Merge commits and squash merges are forbidden

---

# Commit rewriting policy (for AI agents)

## Default behavior
Do NOT rewrite history by default.

Rewriting commit history is allowed **only** when the AI agent’s changes make the existing commit messages misleading or inaccurate.

## Checklist: when rewriting commits is allowed
Rewrite commits (reword, squash, reorder) ONLY if at least one of these is true:

1. Commit message no longer describes the code  
   Example: commit says “add endpoint X” but AI refactored it into endpoint Y or removed it.
2. A single logical change is split across commits due to AI edits  
   Example: implementation in one commit, tests in another unrelated commit, or partial refactor scattered.
3. Two or more commits now describe the same unit of work  
   Example: “fix typo” + “fix typo again” caused by iterative AI edits.
4. A commit introduces changes that were later reverted or undone by the AI  
   Example: feature added then partially removed.
5. Review clarity requires it  
   Example: noisy “wip / fix / retry” commits obscure intent.

## Checklist: when rewriting commits is NOT allowed
Do NOT rewrite commits if all of the following are true:
- Messages still accurately describe the code
- Commits are already clean and atomic
- The only motivation is “making history prettier”
- You would change `main` (forbidden)
- You cannot confidently preserve the intended meaning of each commit

---

# Explicit examples

## Example A: Good linear feature branch history

main:    A---B---C  
feature:         \---D---E---F  

- D: add domain model for billing
- E: add billing service and tests
- F: wire feature flag and documentation

This is ideal: atomic commits, linear history, easy review and bisect.

## Example B: Bad history (merge commit introduced)

main:    A---B---C---G  
feature:         \---D---E---F  
                 \---------M  

M is a merge commit from `main` into `feature`.

Not allowed: merge commits break linear history.

Fix:
- git fetch
- git rebase origin/main
- resolve conflicts
- git push --force-with-lease

## Example C: Bad history (noisy try/fix commits)

feature: D---E---F---G---H  

- E: wip
- F: fix ci
- G: fix ci again
- H: revert

This obscures the real change.

Fix:
- git rebase -i origin/main
- squash / reorder / reword
- git push --force-with-lease

## Example D: Allowed rewrite after AI refactor

Before:
- D: add endpoint /invoices
- E: add tests for /invoices

After AI changes:
- endpoint renamed to /billing/invoices
- tests expanded and moved

Allowed rewrite: reword and regroup commits so each commit accurately reflects final behavior.

---

# Common pitfalls
- Never push or force-push on `main`
- Never create merge commits
- Do not use squash merges in GitHub
- Always rebase before review or merge
- Do not rewrite history unless commit messages no longer match the code
