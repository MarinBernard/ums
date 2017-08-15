###############################################################################
#   Concrete class UmsCachedDocument
#==============================================================================
#
#   This class describes a cached UMS resource. A UMS resource in an in-memory
#   representation of a UMS document.
#
###############################################################################

class UmsCachedDocument
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
    [System.Xml.XmlDocument] $Document

    # Status of the cached document
    [UmsCachedDocumentStatus] $Status
    
    # The number of seconds left before the document is marked as expired
    [int] $TTL    

    ###########################################################################
    # Constructor
    ###########################################################################

    UmsCachedDocument([System.IO.FileInfo] $File, [int] $Lifetime)
    {
        $this.File = $File
        $this.Hash = $File.Name
        $this.CreationTime = $File.LastWriteTime

        # Update caching status
        $this.Lifetime = $Lifetime
        $this.UpdateLifetimeStatistics()

        # We only read the XML document if the caching status is still valid
        if ($this.Status -eq [UmsCachedDocumentStatus]::Current)
        {
            $this.Document = $this.ReadDocument()
        }
    }

    # Returns the cached UMS document
    [System.Xml.XmlDocument] GetDocument()
    {
        return $this.Document
    }

    # Creates a XmlDocument instance from the file content.
    [System.Xml.XmlDocument] ReadDocument()
    {
        # Instantiating an XML document from the file.
        try
        {
            return [System.Xml.XmlDocument] (
                Get-Content -Path $this.File -Encoding UTF8)
        }
        catch [System.Xml.XmlException]
        {
            Write-Error -Exception $_.Exception
            throw [InvalidUmsDocumentException]::New($this.File.FullName)
        }
    }

    [void] UpdateLifetimeStatistics()
    {
        # Update TTL
        $_secondsSpent = ((Get-Date) - $this.CreationTime).TotalSeconds
        $this.TTL = $this.Lifetime - $_secondsSpent

        # Update caching status
        if ($this.TTL -gt 0)
        {
            $this.Status = [UmsCachedDocumentStatus]::Current
        }
        else
        {
            $this.Status = [UmsCachedDocumentStatus]::Expired
        }
    }
}

Enum UmsCachedDocumentStatus
{
    Current
    Expired
}