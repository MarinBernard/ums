###############################################################################
#   Exception class ItemManagerException
#==============================================================================
#
#   Parent class for all exceptions thrown by the [ItemManager] class.
#
###############################################################################

class ItemManagerException : UmsException
{
    ItemManagerException() : base()
    {}
}

###############################################################################
#   Exception class IMGetFolderFailureException
#==============================================================================
#
#   Thrown when the ItemManager cannot return the path of a management folder.
#
###############################################################################

class IMGetFolderFailureException : ItemManagerException
{
    IMGetFolderFailureException([string] $Path, [string] $FolderType) : base()
    {
        $this.MainMessage = ($(
            "Unable to build the path to the {0} management folder " + `
            "for the following location: {1}") -f $Path,$FolderType)
    }
}

###############################################################################
#   Exception class IMTestManagementFailureException
#==============================================================================
#
#   Thrown when the [ItemManger]::TestManagement() method cannot do its job.
#
###############################################################################

class IMTestManagementFailureException : ItemManagerException
{
    IMTestManagementFailureException([string] $Path) : base()
    {
        $this.MainMessage = ($(
            "Unable to check whether UMS management is enabled " + `
            "for the following location: {0}") -f $Path)
    }
}

###############################################################################
#   Exception class IMInconsistentStateException
#==============================================================================
#
#   Parent exception for all exceptions dealing with inconsistencies in the
#   management folder.
#
###############################################################################

class IMInconsistentStateException : ItemManagerException
{
    IMInconsistentStateException([string] $Path) : base()
    {
        $this.MainMessage = ($(
            "Inconsistencies were detected in the management folder " + `
            "linked to the following location: {0}") -f $Path)
    }
}

    ###########################################################################
    #   Exception class IMMissingCacheFolderException
    #==========================================================================
    #
    #   Thrown when the cache folder is missing from the management folder.
    #
    ###########################################################################

    class IMMissingCacheFolderException : IMInconsistentStateException
    {
        IMMissingCacheFolderException([string] $Path) : base($Path)
        {
            $this.MainMessage = ($(
                "An inconsistency was detected in the management folder " + `
                "linked to the following location, which lacks a cache " + `
                "folder: {0}") -f $Path)
        }
    }

    ###########################################################################
    #   Exception class IMMissingStaticFolderException
    #==========================================================================
    #
    #   Thrown when the static folder is missing from the management folder.
    #
    ###########################################################################

    class IMMissingStaticFolderException : IMInconsistentStateException
    {
        IMMissingStaticFolderException([string] $Path) : base($Path)
        {
            $this.MainMessage = ($(
                "An inconsistency was detected in the management folder " + `
                "linked to the following location, which lacks a static " + `
                "folder: {0}") -f $Path)
        }
    }

###############################################################################
#   Exception class IMDisableManagementFailureException
#==============================================================================
#
#   Thrown when the [ItemManagement]::DisableManagement() method fails to
#   disable UMS item management for a specific location.
#
###############################################################################

class IMDisableManagementFailureException : ItemManagerException
{
    IMDisableManagementFailureException([string] $Path) : base()
    {
        $this.MainMessage = ($(
            "Unable to disable UMS item management for " + `
            "the following location: {0}") -f $Path)
    }
}

###############################################################################
#   Exception class IMEnableManagementFailureException
#==============================================================================
#
#   Thrown when the [ItemManagement]::EnableManagement() method fails to
#   enable UMS item management for a specific location.
#
###############################################################################

class IMEnableManagementFailureException : ItemManagerException
{
    IMEnableManagementFailureException([string] $Path) : base()
    {
        $this.MainMessage = ($(
            "Unable to enable UMS item management for " + `
            "the following location: {0}") -f $Path)
    }
}

###############################################################################
#   Exception class IMHideManagementFolderFailureException
#==============================================================================
#
#   Thrown when the [ItemManagement]::HideManagementFolder() method fails to
#   hide the UMS item management folder for a specific location.
#
###############################################################################

class IMHideManagementFolderFailureException : ItemManagerException
{
    IMHideManagementFolderFailureException([string] $Path) : base()
    {
        $this.MainMessage = ($(
            "Unable to hide the UMS item management folder for " + `
            "the following location: {0}") -f $Path)
    }
}