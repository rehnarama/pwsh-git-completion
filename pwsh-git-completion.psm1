# Yes this will probably break in older/newer git versions than the one this is written for.
$githelpParseRegex = "(?<= {4})(-{1,2}(?:\w+)(?:(?:-\w+)+)?)(?:, )?(-{1,2}(?:\w+)(?:(?:-\w+)+)?)?"

function Register-GitCompletion {
  Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

      $ast = $commandAst.ToString()
      $words = $ast -split '\s+'
      $command = $words | Select-Object -Index 1

      $result = Invoke-Command -ScriptBlock {
        if ($ast -match "^git add") {
          $addableFiles = @(git ls-files --others --exclude-standard -m)
            $alreadyAddedFiles = @($words | Select-Object -Skip 2)
            $addableFiles | Where-Object { $_ -notIn $alreadyAddedFiles }
        } elseif ($ast -match "^git rm") {
          $removableFiles = git ls-files
            $removableFiles 
        } elseif ($ast -match "^git restore") {
          $restorableFiles = git ls-files -m
            $restorableFiles 
        } elseif ($ast -match "^git (checkout|rebase)") {
          $switchableBranches = git branch -a --format "%(refname:lstrip=2)"
            $switchableBranches 
        } elseif ($ast -match "^git switch") {
          $switchableBranches = `
            @(git branch --format "%(refname:lstrip=2)") `
            + @(git branch -r --format "%(refname:lstrip=3)")
            $switchableBranches 
        } else {
          $gitCommands = (git --list-cmds=main,others,alias,nohelpers)
            if (!$gitCommands.Contains($command)) {
              $gitCommands
            } else {
              ""
            }
        }
      }

    if ($wordToComplete -match "^-" -and $command) {
# omg, a monstrosity
# also 2>&1 since apparently some `git <command> -h` writes to stderr ¯\_(ツ)_/¯
      $flags = (git $command -h 2>&1 | Select-String -Pattern $githelpParseRegex).Matches | ForEach-Object { $_.Groups | Where-Object { $_.Success -and $_.Name -ne 0 } } | ForEach-Object { $_.Value }    
      $result = @($result) + @($flags)
    }


    $result = @($result)
      $result -like "*$wordToComplete*"
  }
}

Export-ModuleMember -Function Register-GitCompletion
