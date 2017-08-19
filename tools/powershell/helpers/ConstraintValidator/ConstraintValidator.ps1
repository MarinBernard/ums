###############################################################################
#   Concrete class ConstraintValidator
#==============================================================================
#
#   This class is a toolset which can be used to validate a set of UmsItem
#   instances against a list of constraints. It is mainly used to validate
#   items passed to converter/stylesheet-related PS commands.
#
###############################################################################

class ConstraintValidator
{

    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    # A set of constraints. PsCustomObject is used because the constraint lists
    # are read from the configuration file.
    [PSCustomObject[]] $Constraints

    ###########################################################################
    # Constructors
    ###########################################################################

    # Main constructor. A set of constraints is needed at construction time.
    # This method cannot throw any custom exception
    ConstraintValidator([object[]] $Constraints)
    {
        $this.Constraints = $Constraints
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Validate a single UmsItem instance against the collection of constraints.
    # This method returns nothing: if no exception is throw, it must be assumed
    # that the supplied instance is valid.
    # Throws:
    #   - [CVValidationFailureException] on validation failure.
    [void] Validate([UmsFile] $File)
    {
        foreach ($_constraint in $this.Constraints)
        {
            switch ($_constraint.Id)
            {
                "binding-element-namespace"
                {
                    if ($File.Document.BindingNamespace -ne $_constraint.Value)
                    {
                        throw [CVValidationFailureException]::New(
                            $File,
                            $_constraint,
                            $File.Document.BindingNamespace)
                    }
                }

                "binding-element-name"
                {
                    if ($File.Document.BindingLocalName -ne 
                        $_constraint.Value)
                    {
                        throw [CVValidationFailureException]::New(
                            $File,
                            $_constraint,
                            $File.Document.BindingLocalName)
                    }
                }

                "document-element-namespace"
                {
                    if ($File.Document.RootNamespace -ne $_constraint.Value)
                    {
                        throw [CVValidationFailureException]::New(
                            $File, $_constraint, $File.Document.RootNamespace)
                    }
                }

                "document-element-name"
                {
                    if ($File.Document.RootLocalName -ne $_constraint.Value)
                    {
                        throw [CVValidationFailureException]::New(
                            $File, $_constraint, $File.Document.RootLocalName)
                    }
                }

                "item-cardinality"
                {
                    # Build the list of allowed cardinalities
                    [FileCardinality[]] $_allowedCardinalities = @()

                    switch ($_constraint.Value)
                    {
                        "SidecarOrOrphan"
                        {
                            $_allowedCardinalities = @(
                            [FileCardinality]::Sidecar,
                            [FileCardinality]::Orphan)
                        }
                    }

                    # Check cardinality
                    if ($_allowedCardinalities -notcontains($File.Cardinality))
                    {
                        throw [CVValidationFailureException]::New(
                            $File, $_constraint, $File.Cardinality)
                    }
                }

                "item-static-version-status"
                {
                    # Build the list of allowed statuses
                    [FileVersionStatus[]] $_allowedVersionStatuses = @()
                    
                    switch ($_constraint.Value)
                    {
                        "CurrentOrExpired"
                        {
                            $_allowedVersionStatuses = @(
                            [FileVersionStatus]::Current,
                            [FileVersionStatus]::Expired)
                        }
                    }

                    # Check cardinality
                    if ($_allowedVersionStatuses -notcontains($File.StaticVersion))
                    {
                        throw [CVValidationFailureException]::New(
                            $File, $_constraint, $File.StaticVersion)
                    }
                }
            }
        }
    }
}