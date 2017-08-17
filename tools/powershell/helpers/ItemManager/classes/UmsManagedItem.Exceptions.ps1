###############################################################################
#   Exception class UIGetManagementFolderFailureException
#==============================================================================
#
#   Inherits from the [UmsItemException], exception as [UmsManagedItem]
#   inherits from [UmsItem].
#
#   Thrown when the [UmsManagedItem] constructor fails at retrieving handles
#   to management-related folders.
#
###############################################################################

class UIGetManagementFolderFailureException : UmsItemException
{
    UIGetManagementFolderFailureException(
        [System.IO.FileInfo] $File,
        [string] $FolderType
    ) : base()
    {
        $this.MainMessage = ($(
            "Unable to get a the location of the {0} folder of the UMS item " + `
            "at the following location: {1}") -f $FolderType,$File.FullName)
    }
}