function Get-UmsSchemaFileName
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $URI
    )

    foreach( $_schemaName in $ModuleConfig.UMS.Schemas.Keys )
    {
        if ($ModuleConfig.UMS.Schemas.$_schemaName.URI -eq $URI)
        {
            return $ModuleConfig.UMS.Schemas.$_schemaName.Path
        }
    }

    return $false
}