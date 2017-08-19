function Get-UmsMetadata
{
    <#
    .SYNOPSIS
    Reads and returns UMS metadata from a UMS item.
    
    .DESCRIPTION
    This command parses the XML document of a UMS item, and creates a hierarchy of UMS entities from its content.
    
    .PARAMETER Path
    Path to one or several UMS documents.

    .PARAMETER Uri
    Absolute URI to one or several UMS documents.

    .PARAMETER ManagedItem
    One or several UmsManagedFile instances as returned by the Get-UmsManagedFile command.

    .PARAMETER Source
    Allows to select the source to use to build metadata. This parameter is only available when input objects are UmsManagedFile instances, as returned by the Get-UmsManagedFile command. The default value of this parameter is "Cache", and will make the command return cached metadata, if available. If cached metadata are unavailable, the command will fallback to the static version of the UMS document, provided it is up-to-date. Finally, it will use raw metadata rendering if no other source is available. Unmanaged UMS items do not support static or cached versions and always use raw rendering.

    .PARAMETER Silent
    If specified, informational and warning message won't be displayed.
    
    .EXAMPLE
    Get-UmsMetadata -Path "D:\MyMusic\album.ums"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParameterSetName='FileInfoInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]  
        [ValidateNotNull()]
        [System.IO.FileInfo] $Path,

        [Parameter(ParameterSetName='UriInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]  
        [ValidateNotNull()]
        [System.Uri] $Uri,

        [Parameter(ParameterSetName='FileInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsFile] $File,

        [Parameter(ParameterSetName='FileInstance')]
        [ValidateSet("Cache", "Static", "Raw")]
        [string] $Source = "Cache",

        [switch] $Silent
    )

    Process
    {
        # If a path is supplied, we need to convert it to a URI
        # and force the use of the Raw source.
        if ($PSCmdlet.ParameterSetName -eq "FileInfoInstance")
        {
            $Source = "Raw"
            $_uri = [System.Uri]::New($Path.FullName)
            $_uid = $Path.Name
        }

        # If a URI is supplied, we need to force the use of the Raw source.
        if ($PSCmdlet.ParameterSetName -eq "UriInstance")
        {
            $Source = "Raw"
            $_uri = $Uri
            $_uid = $Uri.AbsoluteUri
        }

        # If a UMS item is supplied, we just map the properties
        if ($PSCmdlet.ParameterSetName -eq "FileInstance")
        {
            $_uid = $File.Name
            switch ($Source)
            {
                "Cache"     { $_uri = $File.CacheFileUri }
                "Static"    { $_uri = $File.StaticFileUri }
                "Raw"       { $_uri = $File.Uri }
            }
            [UmsDocument] $_document = $File.Document
        }

        # Now, let's render metadata.
        switch ($source)
        {
            # If the Raw source is specified, we bypass cached versions completely.
            "Raw"
            {
                return [EntityFactory]::ProcessDocument($_document, $_uid)
            }

            # If the cache source is specified, we need to make sure the cache
            # exists before proceeding.
            "Cache"
            {
                switch ($File.CachedVersion)
                {
                    "Current"
                    {
                        return Import-Clixml -Path $File.CacheFile.FullName
                    }

                    "Expired"
                    {
                        if (-not $Silent.IsPresent)
                        {
                            [EventLogger]::LogWarning(
                                $ModuleStrings.Common.ExpiredCachedVersion)
                        }

                        # We use cached metadata by design, even obsolete
                        return Import-Clixml -Path $File.CacheFile.FullName
                    }

                    # In any other case, cached version is declared unavailable.
                    # and we need to fallback to the raw version.
                    default
                    {
                        if (-not $Silent.IsPresent)
                        {
                            [EventLogger]::LogWarning(
                                $ModuleStrings.Common.MissingCachedVersion)
                        }

                        # Use raw version via recursive call.
                        return Get-UmsMetadata `
                            -Source Raw `
                            -Item $File `
                            -Silent:$Silent
                    }
                }
            }

            # If the static source is specified, we need to make sure a static
            # version exists before proceeding.
            "Static"
            {
                switch ($File.StaticVersion)
                {
                    "Current"
                    {
                        return [EntityFactory]::ProcessDocument($_uri, $_uid)
                    }

                    "Expired"
                    {
                        if (-not $Silent.IsPresent)
                        {
                            [EventLogger]::LogWarning(
                                $ModuleStrings.Common.ExpiredStaticVersion)
                        }

                        # We use static version by design, even obsolete
                        return [EntityFactory]::ProcessDocument($_uri, $_uid)
                    }

                    # In any other case, the static version is declared unavailable.
                    # and we need to fallback to raw rendering.
                    default
                    {
                        if (-not $Silent.IsPresent)
                        {
                            [EventLogger]::LogWarning(
                                $ModuleStrings.Common.MissingStaticVersion)
                        }

                        # Use static version via recursive call.
                        return Get-UmsMetadata `
                            -Source Raw `
                            -Item $File `
                            -Silent:$Silent
                    }
                }
            }
        }
    }
}