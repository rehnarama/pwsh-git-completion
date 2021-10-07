$gitFlags = @{
  commit = "--amend", "--no-edit"
  add = "-n", "--dry-run", "-p", "--patch", "-e", "--edit", "-f", "--force", "-u", "--update", "--renormalize", "-N", "--intent-to-add", "-A", "--all", "--ignore-removal", "--refresh", "--ignore-errors", "--ignore-missing", "--chmod", "--pathspec-from-file", "--pathspec-file-nul" 
}

# Yes this will probably break in older/newer git versions than the one this is written for.
$githelpParseRegex = "(?<= {4})(-{1,2}(?:\w+)(?:(?:-\w+)+)?)(?:, )?(-{1,2}(?:\w+)(?:(?:-\w+)+)?)?"

Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  
  $ast = $commandAst.ToString()
  $words = ($ast | Select-String "(\w+-?)+" -AllMatches).Matches | ForEach-Object { $_.Value } 
  $command = $words | Select-Object -Index 1

  $result = Invoke-Command -ScriptBlock {
    if ($ast -match "^git add") {
      $addableFiles = git ls-files --others --exclude-standard -m
      $addableFiles 
    } elseif ($ast -match "^git rm") {
      $removableFiles = git ls-files
      $removableFiles 
    } elseif ($ast -match "^git restore") {
      $restorableFiles = git ls-files -m
      $restorableFiles 
    } elseif ($ast -match "^git (checkout)") {
      $switchableBranches = git branch -a --format "%(refname:lstrip=2)"
      $switchableBranches 
    } elseif ($ast -match "^git (switch)") {
      $switchableBranches = git branch --format "%(refname:lstrip=2)"
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
  $result -like "$wordToComplete*"
}
