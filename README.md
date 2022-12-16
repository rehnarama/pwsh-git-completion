# pwsh-git-completion
Simple ad-hoc git completion that works for me

## Why not [posh-git](https://github.com/dahlbyk/posh-git)?

I couldn't figure out how to _only_ get the completion to work, without loading
the whole module, so I created my own that doesn't slow down your profile by
~0.5 seconds.

Also, this one tries to intelligently provide completions based on context, e.g.
`git add <tab>` will provide a list of unstaged/modified files, while `git
switch <tab>` provides a list of branches to switch to, etc. They are added as
needed.

## How to use?

Install it either manually, or from PowershellGallery with:
```pwsh
Install-Module pwsh-git-completion
```

Later, register the completions with the function `Register-GitCompletion`. Add
it to your profile to load the completion automatically.

## Support completions

This module does _not_ support all git commands, but the ones I use most often
myself. PRs are welcome to add support for more commands!

Currently, the module supports:
* `git <tab>` to complete commands `git add <tab>` to complete unstaged files
* `git rm <tab>` to complete removable files 
* `git restore <tab>` to complete modified, but non-staged, files 
* `git checkout <tab>` to complete potential refs to checkout 
* `git rebase <tab>` to complete potential refs to rebase upon
* `git switch <tab>` to complete branches to switch to 
* `git any-command -<tab>` to complete flags for any command (completed by 
  parsing `git help any-command`, some commands might be broken)

All completions also supports substring completions, e.g. `git add .psm1<tab>`
will complete
 any unstaged files that has `.psm1` in it's full path.

## Requirements

Probably the latest version of
[Powershell](https://github.com/PowerShell/PowerShell), or at least
[PSReadLine](https://github.com/PowerShell/PSReadLine) 2.1.0. 
