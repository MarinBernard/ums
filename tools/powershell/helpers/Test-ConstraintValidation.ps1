# Helper function which performs constraint validation on a UmsItem/UmsManagedItem instance.
function Test-ConstraintValidation
{
    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        # TODO: use the base class
        [UmsManagedItem] $Item,

        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [array] $Constraints
    )

    Process
    {
        try
        {
            foreach ($_constraint in $_constraints)
            {
                # No need to check the remaining constraints if we're already false
                if ($_isValid = $false) { continue }

                switch ($_constraint.Name)
                {
                    "ItemCardinality"
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
                            throw [IncompatibleCardinalityException]::New(
                                $Item, $_allowedCardinalities)
                        }
                    }

                    "bindingElementNamespace"
                    {
                        if ($Item.BindingNamespace -ne $_constraint.Value)
                        {
                            throw [IncompatibleBindingNamespace]::New(
                                $Item, $_constraint.Value)
                        }
                    }

                    "bindingElementName"
                    {
                        if ($Item.BindingElementName -ne $_constraint.Value)
                        {
                            throw [IncompatibleBindingElement]::New(
                                $Item, $_constraint.Value)
                        }
                    }
                }
            }
        }

        catch [UmsException]
        {
            Write-Error $_.Exception.MainMessage
            throw [ConstraintValidationFailure]::New($Item)
        }
    }
}