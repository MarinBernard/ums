function Wait-UserConfirmation
{
    $_answer = Read-Host $($ModuleStrings.Common.ConfirmPrompt + " (Y/N)")

    while ($_answer.ToLower() -notmatch "[y|n]")
    {
        $_answer = Read-Host $($ModuleStrings.Common.ConfirmPrompt + " (Y/N)")
    }
    
    return ($_answer -eq "y")
}