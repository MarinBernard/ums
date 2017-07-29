###############################################################################
#   Concrete class CachedEntity
#==============================================================================
#
#   This class describes an instance of a UMS entity class when stored in the
#   entity cache. It includes a reference to the instance, and several
#   properties of the UMS entity which act as a primary key in the cache DB.
#
###############################################################################

class CachedEntity
{
    ###########################################################################
    # Visible properties
    ###########################################################################

    # The XML namespace of the document element
    [string] $XmlNamespaceUri

    # The local name of the document element
    [string] $XmlElementName

    # The value of the 'uid' attribute.
    [string] $Uid

    # A reference to the entity instance
    [UmsAeEntity] $Instance

    ###########################################################################
    # Constructor
    ###########################################################################

    CachedEntity([string] $XmlNamespaceUri, [string] $XmlElementName,
        [string] $Uid, [UmsAeEntity] $Instance)
    {
        $this.XmlNamespaceUri = $XmlNamespaceUri
        $this.XmlElementName = $XmlElementName
        $this.Uid = $Uid
        $this.Instance = $Instance
    }
}