###############################################################################
#   Concrete class CachedDocument
#==============================================================================
#
#   This class describes a cached UMS resource. A UMS resource in an in-memory
#   representation of a UMS document.
#
###############################################################################

class CachedDocument
{
    ###########################################################################
    # Visible properties
    ###########################################################################

    # The on-disk file from which the instance was created.
    [System.IO.FileInfo] $File

    # The MD5 hash of the absolute URI. This is used as a resource UID within
    # the cache database.
    [string] $Hash    

    # The date and time at which the source file was created
    [DateTime] $CreationTime

    # Cache lifetime, in seconds
    [int] $Lifetime

    # The main UMS document
    [UmsDocument] $Document

    # Status of the cached document
    [CachedDocumentStatus] $Status
    
    # The number of seconds left before the document is marked as expired
    [int] $TTL    

    ###########################################################################
    # Constructor
    ###########################################################################

    # Constructs a new instance from a path to a document file.
    # Throws [CDConstructionFailureException] on construction failure.
    CachedDocument([System.IO.FileInfo] $File, [int] $Lifetime)
    {
        $this.File = $File
        $this.Hash = $File.Name
        $this.CreationTime = $File.LastWriteTime

        # Update caching status
        $this.Lifetime = $Lifetime
        $this.UpdateLifetimeStatistics()

        # We only read the XML document if the caching status is still current
        if ($this.Status -eq [CachedDocumentStatus]::Current)
        {
            try
            {
                $this.Document = $this.ParseFile()
            }
            catch [CachedDocumentException]
            {
                Write-Host -Message $_.Exception.Message
                throw [CDConstructionFailureException]::New($File.FullName)
            }
        }
    }

    # Returns the cached UMS document
    [UmsDocument] GetDocument()
    {
        return $this.Document
    }

    # Parses the source file and returns a UmsDocument instance.
    # Throws:
    #   - [CDFileReadFailureException] if the file content cannot be parsed.
    #   - [CDFileParseFailureException] if the file contains an invalid document
    [UmsDocument] ParseFile()
    {
        # Try to read file content
        [string] $_fileContent = $null
        try
        {
            $_fileContent = [System.IO.File]::ReadAllText($this.File)
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [CDFileReadFailureException]::New($this.File.FullName)
        }

        # Try to create a new UmsDocument instance
        [UmsDocument] $_document = $null
        try
        {
            $_document = [UmsDocument]::New($_fileContent)
        }
        catch [UmsDocumentException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [CDFileParseFailureException]::New($this.File.FullName)
        }

        # Return the instance
        return $_document
    }

    [void] UpdateLifetimeStatistics()
    {
        # Update TTL
        $_secondsSpent = ((Get-Date) - $this.CreationTime).TotalSeconds
        $this.TTL = $this.Lifetime - $_secondsSpent

        # Update caching status
        if ($this.TTL -gt 0)
        {
            $this.Status = [CachedDocumentStatus]::Current
        }
        else
        {
            $this.Status = [CachedDocumentStatus]::Expired
        }
    }
}

Enum CachedDocumentStatus
{
    Current
    Expired
}