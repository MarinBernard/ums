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


function ShowUmsException($Exception)
{
    if ($Exception.InnerException)
        { ShowUmsException $Exception.InnerException }

    if ($Exception.MainMessage)
    {
        [EventLogger]::LogException($_.Exception)
        $Exception.SubMessages | foreach { Write-Host $_ }
        return
    }
    else
    {
        [EventLogger]::LogException($_.Exception)
    }
}

try
{
    $_uri = [System.Uri]::New("file:///C:/Users/marin/Code/ums/tests/current/ums/album.ums")
    ([EntityFactory]::ParseDocument($_uri, "test")).Performances[0].Place.CountryDivision

}
catch
{
    [EventLogger]::LogException($_.Exception)
}

#[EntityFactory]::MeasureCache()