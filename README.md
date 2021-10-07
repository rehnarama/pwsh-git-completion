# pwsh-git-completion
Simple ad-hoc git completion that works for me

## Why not [posh-git](https://github.com/dahlbyk/posh-git)?

I couldn't figure out how to _only_ get the completion to work, without loading the whole module, so I created my own.

Also, this one tries to intelligently provide completions based on context, e.g. `git add <tab>` will provide a list of unstaged/modified files, while `git switch <tab>` provides a list of branches to switch to, etc. They are added as needed.

## How to use?

Just put the contents of `git-completion.ps1` in your powershell profile.
