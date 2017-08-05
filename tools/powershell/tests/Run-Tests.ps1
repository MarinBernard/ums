# Load module files
$ModuleBaseDirectory = "$PSScriptRoot\.."
. "$ModuleBaseDirectory\includes.ps1"

# Load test framework
. "$PSScriptRoot\TestFramework.ps1"

###########################################################################
# Retrieve test documents
###########################################################################

[System.Collections.Hashtable] $global:TestDocuments = @{}
foreach( $_file in (Get-ChildItem -File -Filter "*.ums" -Path "$PSScriptRoot\documents"))
    { $global:TestDocuments += @{ $_file.BaseName = [xml] (Get-Content -Path $_file.FullName -Encoding UTF8) } }

###########################################################################
# Run tests for common entities
###########################################################################

#. "$ModuleBaseDirectory\entities\UmsAeEntity.tests.ps1"

###########################################################################
# Run tests for base entities
###########################################################################

#. "$ModuleBaseDirectory\entities\base\UmsBaePerson.tests.ps1"


$_document = (Get-TestDocument "Audio_Binding_AlbumTrackBinding")
$_albumElement = $_document.binding.albumTrackBinding.album
$_performanceElement = $_albumElement.performances.performance

function ShowUmsException($Exception)
{
    if ($Exception.InnerException)
        { ShowUmsException $Exception.InnerException }

    if ($Exception.MainMessage)
    {
        Write-Error -Message $Exception.MainMessage
        $Exception.SubMessages | foreach { Write-Host $_ }
        return
    }
    else
        { Write-Error -Message $Exception.Message }
}

try
{
    ([EntityFactory]::GetEntity($_albumElement).performances[0].Work)

}
catch
{
    ShowUmsException $_.Exception
}

[EntityFactory]::GetStatistics()