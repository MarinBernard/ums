###############################################################################
#   Exception class CSGetConfigurationItemException
#==============================================================================
#
#   Thrown by the [ConfigurationStore]::GetConfigurationItem() method when a
#   configuration item cannot be retrieved because it has a bad type or name.
#
###############################################################################

class CSGetConfigurationItemException : UmsException
{
    CSGetConfigurationItemException([string] $Type, [string] $ShortName)
        : base()
    {
        $this.MainMessage = $((
            "A unknown configuration item was requested. " + `
            "Requested type: {0}. " + `
            "Requested short name: {1}.") -f $Type, $ShortName)
    }
}

###############################################################################
#   Exception class CSLoadConfigurationException
#==============================================================================
#
#   Thrown by the [ConfigurationStore]::LoadConfigurationFile() method when a
#   configuration file cannot be loaded or parsed.
#
###############################################################################

class CSLoadConfigurationException : UmsException
{
    CSLoadConfigurationException([System.IO.FileInfo] $ConfigFile)
        : base()
    {
        $this.MainMessage = (
            "Unable to load the config file at {0}" -f $ConfigFile.FullName)
    }
}

###############################################################################
#   Exception class CSParseConfigurationException
#==============================================================================
#
#   Thrown by the [ConfigurationStore]::LoadConfigurationFile() method when a
#   configuration file cannot be loaded or parsed.
#
###############################################################################

class CSParseConfigurationException : UmsException
{
    CSParseConfigurationException([System.Xml.XmlElement] $XmlElement)
        : base()
    {
        $this.MainMessage = $((
            "Unable to parse the configuration document. " + `
            "Invalid Xml element: {0}") -f $XmlElement.LocalName)
    }
}

###############################################################################
#   Exception class CSUninitializedStoreException
#==============================================================================
#
#   Thrown by various methods when a request cannot be fulfilled because the
#   configuration store is still uninitialized.
#
###############################################################################

class CSUninitializedStoreException : UmsException
{
    CSUninitializedStoreException() : base()
    {
        $this.MainMessage = "Configuration store is not initialized."
    }
}