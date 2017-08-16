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
    # This method throws a CVValidationFailureException on validation failure.
    [void] Validate([UmsItem] $Item)
    {
        foreach ($_constraint in $this.Constraints)
        {
            switch ($_constraint.Id)
            {
                "binding-element-namespace"
                {
                    if ($Item.BindingNamespace -ne $_constraint.Value)
                    {
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.BindingNamespace)
                    }
                }

                "binding-element-name"
                {
                    if ($Item.BindingElementName -ne $_constraint.Value)
                    {
                        # TODO: more generic exceptions
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.BindingElementName)
                    }
                }

                "document-element-namespace"
                {
                    if ($Item.XmlNamespace -ne $_constraint.Value)
                    {
                        # TODO: more generic exceptions
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.XmlNamespace)
                    }
                }

                "document-element-name"
                {
                    if ($Item.XmlElementName -ne $_constraint.Value)
                    {
                        # TODO: more generic exceptions
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.XmlElementName)
                    }
                }

                "item-cardinality"
                {
                    # Build the list of allowed cardinalities
                    [UICardinality[]] $_allowedCardinalities = @()

                    switch ($_constraint.Value)
                    {
                        "SidecarOrOrphan"
                        {
                            $_allowedCardinalities = @(
                            [UICardinality]::Sidecar,
                            [UICardinality]::Orphan)
                        }
                    }

                    # Check cardinality
                    if ($_allowedCardinalities -notcontains($Item.Cardinality))
                    {
                        # TODO: more generic exceptions
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.Cardinality)
                    }
                }

                "item-static-version-status"
                {
                    # Build the list of allowed statuses
                    [UIVersionStatus[]] $_allowedVersionStatuses = @()
                    
                    switch ($_constraint.Value)
                    {
                        "CurrentOrExpired"
                        {
                            $_allowedVersionStatuses = @(
                            [UIVersionStatus]::Current,
                            [UIVersionStatus]::Expired)
                        }
                    }

                    # Check cardinality
                    if ($_allowedVersionStatuses -notcontains($Item.StaticVersion))
                    {
                        # TODO: more generic exceptions
                        throw [CVValidationFailureException]::New(
                            $Item, $_constraint, $Item.StaticVersion)
                    }
                }
            }
        }
    }
}