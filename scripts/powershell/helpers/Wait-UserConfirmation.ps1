function Wait-UserConfirmation
{
    while ($_answer.ToLower() -notmatch "[y|n]")
    {
        $_answer = Read-Host $($ModuleStrings.Common.ConfirmPrompt + " (Y/N)")
    }
    
    return ($_answer.ToLower() -eq "y")
}